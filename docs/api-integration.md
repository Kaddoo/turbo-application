# Integrating with the Turbo API

> Received from the backend on 2026-10-31, for contract **0.2.2**. `api/openapi.yaml` in this repo is still **0.2.0**:
> the 0.2.2 file was not supplied in full (the copy pasted into the code session stopped at `addDriverDocument`), so it
> was not stored. Planning drops the full 0.2.2 file into `api/`; then every client regenerates. Section 10 lists what
> 0.2.1 and 0.2.2 change.

For the frontend engineers (student app, driver app, admin dashboard, landing page). The contract is `openapi.yaml` (v0.2.2). The API enforces it:
every request body is checked against it and, in staging, every response is too. **If your generated client matches the contract, it works.**

## 1. Connect

| | |
| --- | --- |
| Base URL | `https://<api-host>/v1` (the contract's server URL). The bare path (`https://<api-host>/rides`) works too, so the mock and the real API are interchangeable |
| Local | `http://localhost:3000` (run `npm run migrate && npm run seed && npm start`, plus `npm run worker` for ride assignment) |
| Format | JSON, camelCase, money in integer pesewas, times ISO 8601 UTC |
| Health | `GET /health` → `{ status, version, time }` |

Send on **every** request: `Authorization: Bearer <accessToken>` (except public endpoints) and `X-App-Version: ios/1.2.0` (or `android/`, `web/`).
An app older than the minimum in `GET /app-config` gets `426 upgrade_required`: show the update screen.

## 2. Signing in

| Client | How |
| --- | --- |
| **Student / driver app (mobile)** | `POST /auth/otp/request {phone, role}` → `202`. Then `POST /auth/otp/verify {phone, code, role, clientType:"mobile", acceptedTermsVersion, acceptedPrivacyVersion}` → `{accessToken, refreshToken, expiresInSeconds, user}`. Keep `refreshToken` in secure storage |
| **Student web** | Same, with `clientType:"web"`. The refresh token is **not in the body**: it arrives as an httpOnly cookie. Call `fetch(..., {credentials:"include"})` everywhere |
| **Admin dashboard** | `POST /auth/admin/login {email, password, totpCode}`. Same cookie behaviour as web. All staff must use MFA |
| **Refresh** | `POST /auth/refresh` with `{refreshToken}` (mobile) or an empty body + cookie (web). Tokens **rotate**: always store the new one. Replaying an old one ends the whole session |
| **Logout** | `POST /auth/logout`, then `DELETE /devices/{deviceId}` |

Access tokens last 15 minutes: refresh on a `401 invalid_token`, then retry once.
Drivers cannot register themselves: HR creates them, and an unknown driver number gets `403`.
**Terms:** the first login must send `acceptedTermsVersion`/`acceptedPrivacyVersion` from `GET /legal`. If Turbo publishes new versions, protected calls return `403 terms_not_accepted` until you call `POST /me/terms-acceptance`.
**Web origins:** a browser app only works if its origin is listed in the API's `CORS_ORIGINS`. Tell the backend your exact origin (including `https://`). The refresh cookie is `SameSite=Strict`, so the web apps and the API must share a site, e.g. `app.turbo.com` and `api.turbo.com` (decide the domains early); a different domain will never receive the cookie.

## 3. Errors

Every failure is `application/problem+json`: `{ type, title, status, code, detail?, errors?[{field,message}], retryAfterSeconds? }`.
**Switch on `code`, never on the text.** Validation errors name the field in `errors[]`, so highlight that input.

| Status | Codes you will meet | What the app does |
| --- | --- | --- |
| 400 | `validation_failed` (malformed JSON, bad cursor), `invalid_pin` | Show the message. `invalid_pin`: retry |
| 401 | `unauthenticated`, `invalid_token`, `otp_invalid`, `otp_expired`, `invalid_credentials`, `mfa_required` | Refresh the token once; otherwise sign in again |
| 403 | `forbidden`, `verification_required`, `terms_not_accepted`, `account_suspended`, `driver_not_assigned`, `approval_by_requester_forbidden` | Route to the matching screen |
| 404 | `not_found` | Also returned for someone else's resource |
| 409 | `insufficient_balance`, `quote_expired`, `active_ride_exists`, `ride_not_cancellable`, `invalid_ride_state`, `pin_locked`, `no_show_too_early`, `document_expired`, `driver_has_active_ride`, `shift_overlap`, `refund_exceeds_charge`, `idempotency_key_reused`, `verification_claimed`, `verification_not_resubmittable`, `duplicate_identity`, `conflict` | See the README table for app behaviour |
| 422 | `validation_failed`, `topup_amount_out_of_range`, `upload_expired` | Fix the named fields |
| 426 | `upgrade_required` | Update screen |
| 429 | `rate_limited`, `otp_rate_limited`, `account_locked` | Wait `Retry-After` seconds (also in `retryAfterSeconds`) |
| 503 | `sms_budget_exceeded`, `conflict` ("Busy") | Retry after `Retry-After` |

A `quote` that cannot be booked is **not an error**: it is `200` with `eligible:false` and `reasons[]`.

## 4. Things the API is strict about

- **Unknown fields are rejected** (`422`), because the contract says `additionalProperties:false`. Don't send extras; generated clients won't.
- **Omitted vs `null`:** optional, non-nullable fields are *left out* of responses. Nullable ones come as `null`. Generated models handle this; hand-written ones must not assume presence.
- **Locations** are `{ point: {lat, lng}, label? }`, not flat `{lat, lng}`.
- **Idempotency-Key** (8 to 128 characters, a fresh UUID per user action, **reused on retry**) is required on `POST /rides`, `POST /wallet/topups`, and the finance and salary POSTs. Same key + same body replays the first answer; same key + different body is `409 idempotency_key_reused`.
- **Pagination:** `?limit=` (1 to 100) and `?cursor=`; responses are `{ data, page: { nextCursor, hasMore } }` (a few lists use `items`, exactly as the contract says). Cursors are opaque: don't parse them.
- **Rate limits** are per account (300 requests a minute), not per IP, so a campus Wi-Fi is not punished for one noisy client.

## 5. Uploading photos (verification, driver documents, support)

1. `POST /uploads {purpose, contentType, sizeBytes}` → `{uploadId, uploadUrl, headers, expiresAt}`
2. `PUT` the raw bytes to `uploadUrl` with the **exact** `Content-Type` you declared and exactly `sizeBytes` bytes (JPEG/PNG/PDF up to 10 MB). No auth header: the signed URL is the credential and expires in 10 minutes. `204` means stored
3. Pass `uploadId` to the endpoint that needs it (e.g. `POST /me/verification`). An id works once. File contents must really be the type you declared

## 6. Rides

Polling is the design (no sockets): student `GET /rides/{id}/tracking` every 5 s while active; driver `PUT /driver/location` every 5 s (up to 20 buffered points in one batch after a dropped connection) and `GET /driver/rides/current` as the fallback for a missed push.
`searching → assigned → driver_arrived → in_progress → completed | cancelled`. The start PIN is only in the student's ride (status `assigned`/`driver_arrived`); the driver types what the student reads out.
A driver's offer carries `farePesewas`, `pickupDistanceMeters`, `pickupEtaSeconds` and the countdown to acknowledge (in `GET /driver/rides/current`, and pushed as `ride_offer`); the engine reassigns if it isn't acknowledged in time.

## 7. Push notifications (FCM)

Push is **live in the API** (Firebase Cloud Messaging, HTTP v1). It speeds things up; it is not the source of truth, so keep the polling above as the safety net: pushes can be delayed, dropped or turned off by the user.

**What the app must do**
1. After sign-in and notification permission, call `POST /devices {deviceId, fcmToken, platform, appVersion}`. `deviceId` is a stable id you generate once per install.
2. Call it again whenever FCM gives you a new token (`onTokenRefresh`) and on every app start.
3. On logout call `DELETE /devices/{deviceId}`. A phone that signs in as someone else automatically stops receiving the previous person's pushes.
4. **Android:** create two notification channels, or Android 8+ drops the messages: `turbo_urgent` (high importance, sound) and `turbo_default`. **iOS:** upload the APNs key in the Firebase console. **Web:** needs a service worker and a VAPID key.

**What arrives.** `notification.title/body` are ready to display. `data` is all strings: `type` plus ids. Use `type` to decide where to navigate, then fetch the details from the API (nothing sensitive is ever in a push: no PIN, no phone number, no ID details).

| `data.type` | Goes to | Extra data | When |
| --- | --- | --- | --- |
| `ride_offer` | driver | `rideId` | A ride was offered to you: open the accept screen (the countdown is `ackDeadline`) |
| `ride_assigned`, `ride_reassigned` | student | `rideId` | A driver was assigned (or changed) |
| `ride_arrived` | student | `rideId` | Driver is at the pickup: show the PIN |
| `ride_completed` | student | `rideId` | Trip done: show receipt and rating |
| `ride_cancelled` | student | `rideId` | Driver, staff or the system cancelled; you were not charged |
| `ride_cancelled_driver` | driver | `rideId` | The rider (or staff) cancelled |
| `quick_message` | the other party | `rideId`, `code` | A preset message (`im_here`, `at_the_gate`...): the text is already in the body |
| `verification` | student | `status` | ID approved / needs attention / rejected |
| `topup_succeeded`, `refund` | student | `topupId` / `rideId` | Wallet changed: refresh `GET /wallet` |
| `support_reply` | student/driver | `ticketId` | Staff replied (internal notes never notify) |
| `incident_ack` | reporter | `incidentId` | Staff acknowledged your SOS |
| `announcement` | all or one group | `announcementId` | A broadcast from staff |
| `sos`, `ride_stuck`, `document_expiring` | staff (dashboard) | `incidentId` / `rideId` / `documentId` | SOS to support and super admin; flagged rides to dispatch; expiring papers to HR |

Behaviour worth knowing: time-sensitive pushes expire (a ride offer after 60 s, "driver arrived" after 5 min), so a phone that was offline never shows a stale one. A push for something the user did themselves is not sent (you do not hear about your own cancel). Delivery is retried with back-off if Google is unavailable, and uninstalled apps are removed automatically.

## 8. Dev and staging accounts

| | |
| --- | --- |
| Students | any `+233XXXXXXXXX`; code `123456` while `OTP_MODE=fixed` |
| Drivers | `+233200000001`, `…02`, `…03` (code `123456`) |
| Staff | `admin@`, `finance@`, `finance2@`, `verifier@`, `dispatch@`, `hr@`, `support@` `turbo.test`, password `Turbo-demo-1` (no MFA in dev) |
| Push in dev | A device token starting `gone-` behaves like an uninstalled app and `retry-` like a Google outage, so you can see how the server reacts |
| Payments | `PAYMENT_PROVIDER=fake`: a top-up stays `pending` until the signed webhook is posted (see `scripts/demo.js`) |

## 9. Not live yet (plan around these)

| Gap | Effect on your screens |
| --- | --- |
| **Push in development** | Needs Turbo's Firebase project: until `FCM_SERVICE_ACCOUNT` is set the server prints pushes to its log instead of sending them. Everything above is built and tested, so the app side can be finished and verified the day the key exists. Announcements have no in-app read endpoint (push only) |
| **SMS, email, Payaza, Google routing** run as stubs until Turbo's keys exist | OTP codes are fixed in dev; distances are straight-line × 1.3; top-ups never complete on their own |
| **Card top-ups** | `channel:"card"` answers `422` for now; use `mobile_money`. The network (MTN, Telecel, AirtelTigo) is inferred from the phone number |
| **Destination change** (`/rides/{id}/destination-change`) | `v1.1`, deliberately not built; the endpoints return `404` |
| **Boundary** | A demo rectangle, not Turbo's approved polygon |

## 10. What changed in the contract (since 0.2.0)

- **0.2.1** `DriverRide` gained `farePesewas`, `pickupDistanceMeters`, `pickupEtaSeconds`, `routeDurationSeconds` (all optional).
- **0.2.2** `UploadRequest.contentType` also accepts `text/csv`, only for `provider_statement` (finance reconciliation).
- Not in the contract, by design: the signed `uploadUrl`/document `url` targets, and `GET /admin/stats` (dashboard home numbers).

Regenerate your clients from `openapi.yaml` 0.2.2. Problems with the contract itself go in a pull request against that file, not a workaround in the app.
