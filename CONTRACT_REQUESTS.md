# Contract requests

Things the apps need that the contract lacks or leaves unclear. Code sessions write here; planning applies them to `api/openapi.yaml`.

## 2026-10-31, student app

### CR-1. Does `POST /auth/otp/verify` use up the code when it answers 403 `terms_not_accepted`?

**Answered 2026-10-31 by reading the backend on `origin/main`** (not yet run): no. The code is marked used inside a transaction that is rolled back when the 403 is thrown (`api/src/routes/auth.js`, `tx` in `api/src/db.js`), so the same code can be sent again with the versions. Please state it in the contract so it stays true. Confirmed against the running backend: a new number's code was refused with 403 `terms_not_accepted`, and the same code then signed in with the versions.

**What:** The contract says `acceptedTermsVersion` is "required on first login (terms_not_accepted if missing)". The build brief puts the Terms screen after the code screen, so the app first sends the code without the versions, gets 403, shows Terms, then sends the same code again with the versions.

**Why it matters:** If the first call consumes the code, the second call fails with `otp_invalid` and a new student has to request another SMS (cost, and a bad first impression). The app handles that case by returning to the phone screen, but that is the fallback, not the intent.

**Suggested:** State in the contract that a verify call refused with `terms_not_accepted` does not consume the code. Or add a lightweight way to learn it up front (for example `GET /auth/otp/status?phone=` is not wanted; simpler is to return the 403 before checking the code and leave the challenge intact).

### CR-2. Destination search needs a place-search source

**What:** The destination screen needs "Places autocomplete limited to the service area" (prompt 04). The contract has no search endpoint, so the app would call Google Places directly with a restricted client key.

**Why it matters:** That puts a Google key and billing in the client, and the contract's service area can only be enforced after the quote. A backend `GET /places/autocomplete?q=&sessionToken=` would keep the key on the server and let staff bias results to the boundary.

**Suggested shape:** `GET /places/autocomplete?q=string&sessionToken=uuid` returning `[{placeId, label, landmark?, point?}]`, and `GET /places/{placeId}` returning a `Location`.

### CR-3. Campus security number, announcements and notification settings have no home in the contract

**What:** Three things the student screens call for and the contract cannot supply.
1. **Campus security phone number** (Safety screen "Call for help", and what SOS tells staff). The app shows the national emergency number 112 only. Suggested: add `campusSecurityPhone` and `supportPhone` to `GET /app-config` (or `GET /service-area`).
2. **Announcements banner** on the home screen (prompt 04). Nothing in the contract returns one. Suggested: `announcement: { id, message, severity } | null` in `GET /app-config`.
3. **Notification preferences** (profile toggles "News and offers", "Tips" in the design). There is no endpoint to read or write them. Suggested: `GET/PUT /me/notification-settings` with a small map of booleans. Until then the toggles are not built.

**Why:** these are visible in the design and in prompts 04 and 05.

### CR-4. Place search (CR-2) still open

The destination screen offers official pickup points as drop-offs. A real "search for a place" needs the endpoint in CR-2 or a restricted Google key with billing.

### CR-5. The driver app cannot show document expiry or time on duty

**What:** The driver screens call for (1) a documents list with expiry dates (valid, expiring in under 30 days, expired) on "Me" and in the readiness checklist, (2) which document blocked going on duty and when it expired, and (3) how long the driver has been on duty. `GET /driver/profile` has none of these, and `document_expired` carries only a sentence.
**Suggested:** add `documents: [{type, expiresOn}]` and `dutySince` to `DriverProfile`, and put `documentType` and `expiredOn` extension fields on the `document_expired` problem. Until then the checklist says documents are checked when going on duty, and time on duty counts from when the app started sharing.

### CR-6. Supervisor and campus security phone numbers (drivers and students)

**What:** "Too many tries. Call your supervisor." (PIN locked), the Safety screens and the help screens need real phone numbers. The apps show 112 only.
**Suggested:** `supervisorPhone` and `campusSecurityPhone` in `GET /app-config` (see CR-3).

## 2026-11-02, landing page

### CR-7. `GET /legal` has no publication date

**What:** The privacy and terms pages must show "Version 1.0, updated <date>" (prompt 01, and the app stores ask for it). `LegalVersions` carries versions and URLs only, so the landing page keeps the date in its own config and shows it only while that config describes the same version. A new version published through the API shows without a date.
**Suggested:** `termsUpdatedAt` and `privacyUpdatedAt` (`format: date`) in `LegalVersions`.

### CR-8. Admins need to set the terms and privacy documents

**What:** Turbo has not supplied the terms and privacy yet; an admin will publish them from the dashboard. The contract only has `GET /legal`: no admin operation sets `termsUrl`, `privacyUrl` or the versions, so the dashboard cannot build that screen. Until an admin sets them, staging returns `https://turbo.example/...`, so the landing page footer links to a dead site.
**Suggested:** `PUT /admin/legal` (`admin:super_admin`, audited) taking `LegalVersions` plus the dates from CR-7. Until the first one is set, `GET /legal` returns the landing page's own hosted drafts (`<PUBLIC_SITE_URL>/terms/` and `/privacy/`), not placeholders. Note: a new terms version makes every student accept again (`acceptedTermsVersion`), so the screen must say so before saving.

