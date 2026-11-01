# Contract and API questions for the backend

From the admin dashboard team, 2026-10-31. Found while building `docs/api-tracker.md` against `api/openapi.yaml` and `docs/api-integration.md` (0.2.2). Numbers match the tracker's "Backend inconsistencies" table. Each item says what we found, why it matters to the apps, and what we suggest.

## 0. `api.turbogh.app` is down

Every path, including `/health` and `/v1/health`, returns an empty `503` from Caddy (checked repeatedly on 2026-10-31 from 19:51 to after 20:00 UTC). The proxy is up, so the API process behind it is not. Is this host staging or production, and when will it be up? We need it to test the dashboard.

Please also send the **full 0.2.2 `openapi.yaml`**: the copy we got stops at `addDriverDocument`, so we are still generating from 0.2.0.

## 5. 426 `upgrade_required` is listed on 5 operations only

The guide says any request from an old app gets 426. The contract lists 426 only on `POST /auth/otp/verify`, `POST /rides/quote`, `POST /rides`, `POST /wallet/topups` and `PUT /driver/duty`.
**Ask:** document 426 as a response every operation can give (a shared response, like 429), or say which operations really check the version.

## 6. 403 is missing on 8 authenticated operations

The guide says protected calls return `403 terms_not_accepted` (and `account_suspended`), but these list no 403: `POST /auth/logout`, `POST /devices`, `DELETE /devices/{deviceId}`, `POST /uploads`, `POST /me/terms-acceptance`, `GET /me/sessions`, `DELETE /me/sessions`, `DELETE /me/sessions/{id}`.
**Ask:** say which of these can return 403. `POST /me/terms-acceptance` and `POST /auth/logout` presumably must be exempt from the terms check, or a user with old terms could never accept the new ones or sign out.

## 7. 409 with no problem code on 17 operations

These list 409 but the description names no `code`, so apps cannot show a specific message: `POST /rides/{id}/rating`, `POST /driver/rides/{id}/ack`, `/decline`, `/arrived`, `/complete`, `POST /admin/verifications/{id}/decision`, `POST /admin/drivers`, `PATCH /admin/drivers/{id}`, `POST /admin/vehicles`, `POST /admin/rides/{id}/reassign`, `/cancel`, `/complete`, `POST /admin/shifts`, `POST /admin/staff`, `POST /admin/topups/{id}/resolve`, `POST /rides/{id}/messages`, `PUT /admin/students/{id}/phone`.
**Ask:** name the code(s) per operation, e.g. `invalid_ride_state`, `shift_overlap`, `duplicate_identity`, or a new `duplicate_phone` / `duplicate_email` / `duplicate_plate` instead of a bare `conflict`.

## 8. Idempotency-Key gaps

The guide says finance and salary POSTs require `Idempotency-Key`, but `POST /admin/topups/{id}/resolve` and `POST /admin/reconciliation/reports` take none. The contract's own rule ("every endpoint that moves money or sends SMS") would also cover `POST /auth/otp/request` and `POST /admin/drivers` (SMS invite), which take none.
**Ask:** add the header to those four, or document why a double submit is safe.

## 9. `conflict` means two different things

`conflict` is the 409 "someone else changed this" code and also the 503 "Busy" code.
**Ask:** give the 503 its own code (e.g. `service_busy`), so apps know whether to refresh or wait and retry.

## 10. 503 is documented on one operation only

Only `POST /auth/otp/request` lists 503, but the guide says any call can answer 503 with `Retry-After`.
**Ask:** add 503 (with `Retry-After` / `retryAfterSeconds`) as a shared response on every operation.

## 11. `invalid_token` covers two different situations

It means "your access token expired, refresh it" and also "this invite / reset / enrolment link is expired or used". Apps must guess from the endpoint which one it is.
**Ask:** keep `invalid_token` for access tokens and add `link_expired` (or `invalid_link`) for the single-use staff links.

## 17. Roles that cannot reach their own actions

| Action (role allowed) | Read it depends on (role allowed) | Effect |
| --- | --- | --- |
| `DELETE /admin/students/{id}/sessions` (support) | `GET /admin/students/{id}` (verifier) | Support cannot open the student, so cannot use it |
| `POST /admin/rides/{id}/refund` (finance) | `GET /admin/rides/{id}` (dispatcher) | Finance cannot open the ride, so cannot refund it |
| Wallet adjustments (finance) need the approval limit | `GET /admin/settings` (super_admin) | Finance cannot see when an adjustment needs a second approver |

Today only super_admin can actually do these.
**Ask:** widen the reads (e.g. `admin:support` on `GET /admin/students/{id}`, `admin:finance` on `GET /admin/rides/{id}`), and expose `adjustmentApprovalThresholdPesewas` to finance (on `GET /admin/me`, `/app-config`, or a finance-readable settings view).
