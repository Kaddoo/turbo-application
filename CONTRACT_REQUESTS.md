# Contract requests

Things the apps need that the contract lacks or leaves unclear. Code sessions write here; planning applies them to `api/openapi.yaml`.

## 2026-10-31, student app

### CR-1. Does `POST /auth/otp/verify` use up the code when it answers 403 `terms_not_accepted`?

**What:** The contract says `acceptedTermsVersion` is "required on first login (terms_not_accepted if missing)". The build brief puts the Terms screen after the code screen, so the app first sends the code without the versions, gets 403, shows Terms, then sends the same code again with the versions.

**Why it matters:** If the first call consumes the code, the second call fails with `otp_invalid` and a new student has to request another SMS (cost, and a bad first impression). The app handles that case by returning to the phone screen, but that is the fallback, not the intent.

**Suggested:** State in the contract that a verify call refused with `terms_not_accepted` does not consume the code. Or add a lightweight way to learn it up front (for example `GET /auth/otp/status?phone=` is not wanted; simpler is to return the 403 before checking the code and leave the challenge intact).

### CR-2. Destination search needs a place-search source

**What:** The destination screen needs "Places autocomplete limited to the service area" (prompt 04). The contract has no search endpoint, so the app would call Google Places directly with a restricted client key.

**Why it matters:** That puts a Google key and billing in the client, and the contract's service area can only be enforced after the quote. A backend `GET /places/autocomplete?q=&sessionToken=` would keep the key on the server and let staff bias results to the boundary.

**Suggested shape:** `GET /places/autocomplete?q=string&sessionToken=uuid` returning `[{placeId, label, landmark?, point?}]`, and `GET /places/{placeId}` returning a `Location`.
