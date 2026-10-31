# Turbo log

Newest entry first. Template is in `docs/05-work-plan.md`. Add an entry at the end of every working session.

## 2026-10-31, Kevin with Claude, code: push and the driver app

**Task:** Push notifications for both apps, then the driver app (prompt 05).

**Files touched:**
- apps/student_app, apps/driver_app: features/push (register, tap routing, in-app notes), ios Runner.entitlements (not yet switched on) and `remote-notification` background mode
- apps/driver_app: whole app. core (session, gate, profile, flow, problem messages), auth (phone, code, terms), duty (readiness, location sharing, connectivity), home (off duty, on duty), ride (offer with 45 s countdown, to pickup, at pickup with PIN keypad and no-show, trip with offline-safe completion, end screens), me (devices, shifts, attendance, salary, trips), support, safety (SOS), shell
- packages/turbo_api/test/live_backend_test.dart (decodes the real backend's answers; skipped when none runs)
- CONTRACT_REQUESTS.md (CR-5, CR-6)

**What changed:**
- Push: each app registers the phone with the server after sign-in and removes it first on sign-out; a tapped push opens the right screen (ride, wallet, support, safety); a message while the app is open shows a note and refreshes the data; a push that starts the app waits for sign-in. Tested with a fake push platform.
- Driver app: sign in as a driver (unknown number gets "This number isn't registered as a driver"); readiness checklist (location Always, battery or charging, internet, notifications); Go on duty starts location sharing at once and off duty stops it; a stalled position, an offline phone and an unreachable server each show a red or amber banner in words; a ride takes over the screen until it ends; accept or decline with a reason; navigate to pickup (Google Maps or Waze); "I've arrived" asks first when far from the pickup; four-digit PIN keypad with lock message; "Student not here" after the wait; complete with confirm and retry until the server answers; calm end screens; SOS by 3-second hold; trips, shifts, attendance, salary history, help tickets.

**Checked on the real backend:** the generated client decodes the real answers for every driver and student call used (including "no current ride"), via the live test. The ride lifecycle was driven by script earlier in the day.

**Acceptance criteria:**
- [x] `flutter analyze` clean; student app 124 tests, driver app 53, turbo_ui 48
- [ ] **Push on a real phone: blocked.** Xcode refuses the Push Notifications capability: "PLA Update available: agree to the latest Program License Agreement". Accept it at developer.apple.com, then set `CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements` for both apps (the file exists) and upload an APNs key to the Firebase project `turbo-dev-5f54ed`. Until then the apps work by polling.
- [ ] Driver app used on the phone: installed, not used
- [ ] 30-minute locked-screen location test: still open (R7)
- [ ] Driver sign-in to ride loop against the real backend on a phone: not done

**Deviations from plan or contract:**
- Drivers' documents and time on duty are not shown (CR-5). The driver "Me" has no documents list.
- Supervisor and security numbers are missing (CR-6); "Call your supervisor" has no button.
- The driver app has no photo attachments on tickets and no student web build yet.
- Completion retries live in memory; if the app is killed while waiting for signal the driver must tap Complete again (the server still holds the ride in progress).
- Firebase's newer `register()` API returns an installation id, not the classic FCM token the backend's sender expects, so the apps use `getToken` (marked deprecated).
- The shared sign-in, gate and session code was copied from the student app into the driver app, not moved into a shared package. Worth extracting before the redesign branch settles.

**Status:** built and tested; not seen on a phone. **Next step:** accept the Apple agreement, switch on push, run the locked-screen test, then the student web build and offline notes.

## 2026-10-31, Kevin with Claude, code: student app phase 2, part 2 (ride, safety, support, profile)

**Task:** Finish the student app's functions before the UI redesign is handed over.

**Files touched:**
- apps/student_app: features/ride (booking, searching, driver assigned with PIN, arrived, in trip, done with rating and receipt, cancelled variants, cancel), features/safety (SOS hold, safety screen, trusted contacts, share trip), features/support (list, new ticket with photos, conversation), features/profile (email, saved places, devices, terms, sign out, delete), home (active ride card, safety button), shell (Ride, Activity, Wallet, Profile), router, ARB
- tools/drive-ride.sh (plays the driver on the local backend), CONTRACT_REQUESTS.md (CR-3, CR-4)

**What changed:** A student can now book a quoted ride (one idempotency key per quote, reused on retry; `active_ride_exists` opens the running ride; a short wallet or an expired price re-reads the quote), watch it by polling (4 s, with a haptic on arrival), message the driver with quick messages, see the start PIN digit by digit, cancel with a reason before the trip, trigger SOS by holding for 3 seconds (falls back to dialling 112 if it cannot send), share the trip with trusted contacts, rate the driver, see the receipt, and read what happened to the money on a cancelled ride. Support tickets with up to 5 photos, a profile with devices and account deletion, and a bottom bar matching the design (Home, Activity, Wallet, Profile).

**Checked on the real backend:** a full ride with a test student: quote, book, assigned, driver acknowledges, arrives, student sees the PIN, driver starts with it, completes, GH₵50 charged and the wallet debited. The driver side was played by `tools/drive-ride.sh`.

**Acceptance criteria:**
- [x] `flutter analyze` clean; student app 116 tests, turbo_ui 48 (including the hard-coded style scan, which caught a product name in a string and now passes)
- [x] Whole ride lifecycle against the running backend
- [ ] Used on the phone: installed, not used
- [ ] Push notifications (Firebase): not built
- [ ] Trip-share public page and the student web build: not built
- [ ] Offline "last updated" notes on wallet and history: not built
- [ ] Ghana Card photo capture against the real backend: parked
- [ ] Android pre-permission screens: not built (Android paused)
- [ ] Driver app: only the location spike exists

**Deviations from plan or contract:**
- Bottom bar is Home, Activity, Wallet, Profile (the design), not Ride, Wallet, Activity (prompt 04). Safety is a shield button on home, in a ride, and in Profile.
- No campus security number, announcements or notification toggles: contract has none (CR-3).
- Place search is off; official points serve as drop-offs (CR-4).
- Map tiles need billing on the Maps project; markers and the layout are built and tested with a stand-in map.

**Status:** done for the ride flow. Branch: student-ride. **Next step:** push notifications, then the driver app (prompt 05), then the student web build.

## 2026-10-31, Kevin with Claude, code: student app phase 2, part 1 (wallet and top-up)

**Task:** Move on without place search: drop-offs from official points, then the wallet, top-up and activity screens, behind the bottom bar.

**Files touched:**
- apps/student_app: features/wallet (wallet, top-up, waiting, transactions), features/activity, features/shell (bottom bar), destination screen, quote screen, router, flow, ARB
- tools/complete-topup.sh (dev: sends the signed webhook Payaza would), tools/seed-dev-places.sh (dev: demo pickup points)

**What changed:**
- Drop-off: official pickup points are offered as drop-offs ("Campus and popular places"); place search stays off until it has a key or a backend endpoint (CR-2). The "not available in this version" message is gone.
- Bottom bar (Ride, Wallet, Activity) with the ride and money flows full screen above it.
- Wallet: available in large type, held, owed (icon and words), recent entries; See all with filters and paging. Holds and releases read "Held" and "Released".
- Top-up: chips and a typed amount parsed to integer pesewas, range checked before sending, one idempotency key per intention (same amount retried reuses it, a new amount does not), waiting screen with polling, check-now, resume check, and a timeout that says "still waiting, don't pay again" and never calls a payment failed. Quote's "Top up" pre-fills the shortfall and the quote renews when money lands.
- Activity: list of my rides with status chips (empty and error states).

**Checked on the real backend (curl):** top-up created, webhook helper credited it, wallet and transaction list updated.

**Acceptance criteria:**
- [x] `flutter analyze` clean; student app 86 tests, turbo_ui 48
- [x] Top-up path against the running backend
- [ ] Seen on the phone: installed, not yet used
- [ ] Booking, ride tracking, PIN, completion, cancel, receipt, rating: next (phase 2 part 2)

**Deviations from plan or contract:**
- Top-up limits (GH₵5 to GH₵500) are constants from decision D20; the server decides. The contract has no field for them.
- The contract has no network chooser or phone field on a top-up (the backend uses the account number), so none is shown.
- Demo pickup points on the local backend are approximate and not approved by Turbo (D1).

**Status:** done, part 1. Branch: student-wallet. **Next step:** booking (`POST /rides` with an idempotency key), searching, driver assigned with the PIN, in trip, done, cancel.

## 2026-10-31, Kevin with Claude, code: run the real backend locally

**Task:** Make `api/contract/openapi.yaml` the source of truth and run the backend from `origin/main` for the phone apps.

**Files touched:**
- tools/backend-local.sh (setup, start, stop), tools/review-student.sh (approve, reject or send back a student as the demo verifier)
- tools/make-mock-spec.mjs, packages/turbo_api/tool/generate.sh (read `api/contract/openapi.yaml`), packages/turbo_api/generated (regenerated from 0.2.2)
- api/contract/openapi.yaml (copied from origin/main so tooling works before the merge), packages/turbo_ui scanner test (only our own lib folders)
- CONTRACT_REQUESTS.md (CR-1 confirmed live), .gitignore (`.backend/`)

**What changed:** The client is generated from contract 0.2.2. The backend runs from `.backend/` (git-ignored): a private Postgres 16 on port 5433, the API on port 3000 bound to the local network with signed upload links built from this Mac's address, and the worker. Development settings: sign-in code 123456, fake payments, push logged, estimated routes.

**Checked against the running backend (curl):** app-config, legal, sign-up with the terms refusal then the same code accepted, profile, verification status, service area (demo boundary and one pickup point, "Central Gate"), wallet (GH₵0.00), four photo uploads (204) and a submit (pending), a reviewer decision (needs attention) with the student seeing the message.

**Acceptance criteria:**
- [x] Client regenerated; `flutter analyze` clean; tests pass in all four packages
- [x] Backend migrates, seeds and answers the phase 1 calls
- [ ] Student app on the phone against the real backend: built and installed, not yet used
- [ ] Backend's own 69 tests not run here

**Deviations from plan or contract:**
- `api/openapi.yaml` (0.2.0, planning's copy) is now superseded by `api/contract/openapi.yaml` (0.2.2) in our tooling, as Kevin decided. The old file is left in place; planning should remove it and update `CLAUDE.md`, which still names `api/openapi.yaml`.
- The wallet starts at GH₵0.00, so quotes show "Top up" until top-ups exist (phase 2); the dev backend has a fake payment provider for that.

**Status:** done. Branch: backend-local. **Next step:** use the student app against the real backend on the phone; then phase 2 (wallet, top-up, booking).

## 2026-10-31, Kevin with Claude, code: mock, design brief, backend review

**Task:** Make the mock behave on a phone, write the screen-by-screen design brief, and read the backend that landed on `origin/main`.

**Files touched:**
- tools/make-mock-spec.mjs, tools/mock-server.mjs, package.json (mock gives realistic answers, accepts photo uploads, remembers verification status; `/mock/state/<status>` sets it)
- design/SCREENS.md (new: components and states per screen, student and driver)
- CONTRACT_REQUESTS.md (CR-1 answered from the backend source)

**What changed:** First on-device test of the student app against the mock found three mock problems (maintenance on by default, upload URL pointing nowhere, no memory of a submit); none were app bugs. Backend review: see below.

**Backend (read, not run):** `api/` on `origin/main` (Bethel, one commit): Node 22, Express 5, PostgreSQL, 133 of 135 operations implemented against contract 0.2.2 (the two left are v1.1), migrations 001 to 014, a worker for assignment, timeouts, reconciliation and push, 69 tests, deploy files. Its contract copy differs from ours only by the driver-ride fare and ETA fields and a CSV upload type. Without a Google key it estimates routes (straight line times 1.3), so quotes need no Maps billing in development. In development the sign-in code is fixed at 123456.
- It sits beside our `api/openapi.yaml` (it uses `api/contract/openapi.yaml`); the two copies need a rule for which is the source.
- Photo uploads go to `PUT /uploads/{id}/content` on the API itself, signed, with exact size and content-type checks and a file-type sniff.
- To use it from a phone it needs `HOST=0.0.0.0` and `PUBLIC_URL=http://<this Mac>:3000` (signed upload links are built from it), a local Postgres, `npm run migrate`, `npm run seed`.

**Acceptance criteria:**
- [x] Statuses shown correctly on the phone: pending, plus approved, needs attention and rejected set through the mock
- [ ] Photo capture and upload against the real backend: parked, not tested
- [ ] Backend not run here

**Status:** done (mock and docs). **Next step:** run the backend locally and point the apps at it.

## 2026-10-31, Kevin with Claude, code: group 4 (student app phase 1)

**Task:** Student app phase 1: shell and app-config gate, phone and code, terms, verification capture and status, map home, destination, quote.

**Files touched:**
- apps/student_app: lib/src/core (session, gate, me, flow, auth draft, problem messages, semver), features/auth, gate, verification, home; l10n ARB; router; iOS and Android permissions; Maps key plumbing; tests
- packages/turbo_api: 401 refresh interceptor; mock contract test for every phase 1 call
- CONTRACT_REQUESTS.md (CR-1, CR-2), .gitignore (Secrets.xcconfig)

**What changed:** App starts on the app-config gate (update, maintenance, 426) then restores the session (refresh rotation, secure storage), then reads the profile and routes: signed out, terms, verification, home. Sign-in is phone then 6-box code; a first sign-in that needs terms shows them and re-sends the held code with the versions. Verification: details with live Ghana Card format, camera capture with guide frame and a blur/glare/dark check, uploads with progress and retry, draft saved across restarts, status screen (pending, needs attention with Send again, rejected, approved then Continue). Home: map with official pickup points, wallet chip (amber and "low" when under the cheapest fare), Where to bar, saved-place chips, paused-bookings and location-denied states. Destination: nearest pickup point by default, pickup list, saved places, optional place search. Quote: fixed fare in large type, wallet line, shortfall, every ineligibility reason from the server, quiet re-quote on expiry, 429 wait.

**Acceptance criteria:**
- [x] `flutter analyze` clean; student app 70 tests, turbo_ui 48 (including the hard-coded style scan over the student app), turbo_api tests
- [x] Every phase 1 call is answered by the Prism mock and decoded by the generated client
- [x] Four states on every screen built here (loading, empty, error, full), copy from ARB
- [x] iOS debug build compiles with maps and camera
- [ ] Not run on a device or simulator: nothing in this group has been seen on screen except through widget tests. The camera screen and the real map are untested.
- [ ] Place search is untested against live Google (no billing on the project, no Places key). Off unless `--dart-define=PLACES_API_KEY` is set. See CR-2.

**Deviations from plan or contract:**
- Wallet chip is not tappable and the Book and Top up buttons are present but off: wallet and booking are phase 2.
- Not built yet from prompt 04: active-ride card, announcements banner (no contract field found), Safety button, "add saved place" chip, cut-off edge detection in the photo check (blur, glare and darkness only), "Contact support" button on a duplicate Ghana Card (support is phase 3), Android pre-permission screen (Android paused).
- A needs-attention decision shows the reviewer's message first; "Send again" opens the form. The brief's flow listed capture first, but the message has to be seen.
- First-sign-in terms depend on the server not consuming the code on 403 (CR-1). If it does, the app falls back to asking for a new code.
- Prism returns `resendInSeconds: 0` because the schema has no example. Add one (planning).

**Status:** built and tested against the mock; not seen on a device. Branches: student-phase1, student-verification, student-home-quote.

**Next step:** Look at it on a real screen (install on the phone), then group 5 (driver app phase 1) or phase 2 for the student app.

## 2026-10-31, Kevin with Claude, code: group 3 (driver location spike)

**Task:** Background-location spike for the driver app (risk R7), before anything else in the driver app.

**Files touched:**
- apps/driver_app/lib/src/location/ (buffer, reporter, permission and stream, API sender, spike screen), lib/main.dart, test/location_test.dart
- apps/driver_app: Info.plist (location strings, `UIBackgroundModes: location`, local networking), AndroidManifest.xml (location, foreground service, notification permissions), pubspec (geolocator, turbo_api)
- package.json (`mock:lan` serves the mock to a phone on the same network), .gitignore

**What changed:** One point per 5 s from a background-enabled stream goes to `PUT /driver/location` through the generated client. Failures are buffered, retried every 5 s, sent oldest first in requests of at most 20 points, and points older than 10 minutes are dropped. The reporter detects its own stall (no GPS fix, or no server acceptance, for 30 s) and the screen shows a red banner. iOS asks for "while using" and then "Always"; the screen shows what was granted and a button to open Settings.

**Acceptance criteria:**
- [x] Pipeline unit tests: 5 s throttle, buffer and flush in order, 20-point batches, 10-minute drop, stall detection, stop
- [x] `flutter analyze` clean, all tests pass; iOS debug build compiles (unsigned)
- [ ] 30 minutes with the screen locked on a real iPhone: NOT DONE, no device has run it
- [ ] Android foreground service: not tested (Android paused)

**Deviations from plan or contract:** Android "Allow all the time" needs `permission_handler` (geolocator cannot request it on Android 11+), plus battery-optimisation guidance; not added yet. iOS strings do not name the product so a rebrand does not touch them. The mock accepts any bearer token, so the spike sends a placeholder.

**Status:** built, not verified on a device. **Launch gate R7 stays open.**

**Next step:** Install on the phone (wireless), run 30 minutes locked, count `PUT /driver/location` in the mock log against the on-screen sent count.

## 2026-10-31, Kevin with Claude, code: group 2 (turbo_ui)

**Task:** `turbo_ui` brand layer, theme, safeguards, base components, shared states, gallery.

**Files touched:**
- packages/turbo_ui: brand/, theme/, components/, states/, motion/, haptics/, format/, gallery/, l10n (ARB), tests, goldens, BRANDING.md
- apps/student_app, apps/driver_app: main.dart now runs the component gallery on the Turbo theme; smoke tests

**What changed:** Three layers: `brand_tokens.dart` (only raw values), a `TurboTheme` extension with semantic roles for light and dark, then components. Components: button (3 variants), text field, OTP field, money text, status chip, card, list row, sheet, toast, confirm dialog (with type-to-confirm), skeleton, map container (placeholder until the maps key exists), timeline, wordmark; loading, empty and error states. `formatPesewas` shows `GH₵35.00` with integer maths only.

**Acceptance criteria:**
- [x] Hard-coded style test passes and is proven to catch each violation kind
- [x] Second brand fixture restyles components with no widget change
- [x] Contrast test passes for both brands, light and dark
- [x] Goldens for controls, content and states, light and dark
- [x] Gallery lays out at 200% text scale with no overflow
- [x] `flutter analyze` clean, all tests pass
- [ ] Gallery seen on a device (no simulator; waiting for the phone on a cable). Goldens use the test font, so they show blocks for text.

**Deviations from plan or contract:**
- Added role `controlBorder` (input and secondary button edges). The listed `border` is about 1.4:1 on black, which fails the 3:1 rule for control edges; `border` stays for dividers and cards.
- Light `success` is `#117A59` (was `#12805C`) and light `danger` is `#CF2A1E` (was `#D92D20`). The listed values fall just under 4.5:1 on the light surface `#F4F4F2` (4.47 and 4.39). Dark values unchanged.
- Added role `accentBorder` (black in light, none in dark) for the 1.5 px edge the rules ask for on light.
- The gallery has English hard-coded (developer-only). Everything shipped uses ARB.
- Support email and phone in `turboBrand` are null until Turbo supplies them.
- Native display names live in Info.plist and AndroidManifest, listed in BRANDING.md step 3.
- Bug caught by the semantics test and fixed: wrapping the button in `excludeSemantics` hid its tap action from screen readers.

**Status:** done, awaiting review. Branch: turbo-ui-theme (cut from mock-and-generator).

**Next step:** Group 3, the driver background-location spike on a real device.

## 2026-10-31, Kevin with Claude, code: group 1 (workspace, mock, client)

**Task:** Workspace, tooling, `turbo_api` generation, mock running.

**Files touched:**
- pubspec.yaml (pub workspace), package.json (Prism and generator, dev only), .gitignore
- apps/student_app (ios, android, web; `gh.turbo.student`, "Turbo"), apps/driver_app (ios, android; `gh.turbo.driver`, "Turbo Driver")
- packages/turbo_api (generated/ via tool/generate.sh, wrapper, tests), packages/turbo_ui (empty scaffold)

**What changed:** Git initialised here. Client generated with dart-dio and json_serializable; regeneration gives no diff. Wrapper adds X-App-Version, bearer token, GET-only retry, typed `ApiProblem`, `IdempotencyKey`.

**Acceptance criteria:**
- [x] `flutter analyze` clean, `flutter test` passes
- [x] `getAppConfig` through the generated client against Prism returns 200
- [x] Regeneration produces no diff
- [ ] Apps launched on a device (no simulator; waiting for the phone on a cable)

**Deviations from plan or contract:** The generated package sits outside the workspace (its dev dependencies conflict with the Flutter SDK pins) and generate.sh raises its SDK constraint, since the generator emits syntax newer than its own constraint. No contract problems found. Android is built but not tested for now.

**Status:** done, awaiting review. Branches: workspace-and-apps, mock-and-generator.

**Next step:** Group 2, `turbo_ui` brand layer and theme.

## 2026-10-31 06:10, Kevin with Claude, planning

**Task:** Write build prompts for each surface so work can start before the brand guide.

**Files touched:**
- prompts/00 to 05 (new), README.md
- api/openapi.yaml (VerificationDetail gets ghanaCardNumber; removed a stray provider_statement from verification document purposes), api/README.md

**What changed:** Five function-first prompts with a placeholder theme in one swappable file. Contract still 0.2.0.

**Acceptance criteria:**
- [ ] Each owner reads their prompt and the shared rules, and raises changes
- [ ] Open items below answered

**Deviations from plan or contract:** none. Open items: student web covers no identity capture (confirm with Turbo); fare-band and boundary fallback on the landing page until D1.

**Status:** done (docs).

**Next step:** Emmanuel starts the landing page; Kevin starts the shared Flutter package and theme.

## 2026-10-30 22:00, Kevin with Claude, contract

**Task:** Apply the audit's v1 items to the contract (0.2.0).

**Files touched:**
- api/openapi.yaml (0.1.1 to 0.2.0, 107 to 135 operations), api/README.md
- docs/01 (D22 to D27), docs/03, docs/04, docs/06, docs/09, README.md

**What changed:** See the 0.2.0 line in api/README.md. Lint clean; Prism mock serves the new endpoints and rejects a bad body with 422. New schemas return placeholder examples on the mock.

**Acceptance criteria:**
- [x] `redocly lint` clean
- [x] Mock answers `/app-config`, `/legal`, force-complete, adjustment list
- [ ] Bethel reviews the stuck-ride, reconciliation and adjustment-approval design
- [ ] Emmanuel and Kevin read 0.2.0 and raise changes
- [ ] D22 to D27 sent to Turbo

**Deviations from plan or contract:** Breaking change to `POST /me/verification` (new required fields), acceptable while nothing is built. Audit correction: MFA field existed on login; the gap was enrolment, invite and reset.

**Status:** done (contract).

**Next step:** Bethel review, then add realistic examples to the new schemas.

## 2026-10-30 21:10, Kevin with Claude, planning

**Task:** Run the feature-completeness audit on the plan and contract.

**Files touched:**
- docs/09-feature-audit.md (new), README.md (index)

**What changed:** 26 findings: 3 S0 (stuck rides, staff accounts without MFA/reset, no Payaza reconciliation queue), 10 S1, 11 S2, 2 S3. Six new decisions D22 to D27 proposed with defaults. Contract not changed yet.

**Acceptance criteria:**
- [ ] Bethel and Kevin agree which findings go into contract 0.2.0 (F-01 to F-03 first)
- [ ] D22 to D27 sent to Turbo and moved into 01-open-decisions.md
- [ ] F-07, F-13, F-16, F-18 priced as change requests

**Deviations from plan or contract:** none yet.

**Status:** done (docs). Awaiting decision on 0.2.0.

**Next step:** Apply S0 and S1 `v1` items to openapi.yaml as 0.2.0.

## 2026-10-30 15:40, Kevin with Claude, planning

**Task:** Cut running costs: no always-on instance, no Redis, Supabase Pro only in production and paid by Turbo Mobility.

**Files touched:**
- docs/02-architecture.md (assignment loop on Cloud Tasks, no Redis, new Cost shape section), docs/03, docs/06 (R17), docs/07

**What changed:** Baseline falls from about US$82-108 to about US$30-63 a month once live. Assignment is task-driven instead of a worker loop. Free Supabase plan is for dev and staging only.

**Acceptance criteria:**
- [ ] Assignment loop proven on a cold instance (two rides, one driver; no tick lost)
- [ ] Flip to always-on billing documented in the runbook

**Deviations from plan or contract:** none to the contract. Presence moves from Redis to an UNLOGGED Postgres table.

**Status:** done (docs).

**Next step:** Bethel reviews the task-driven assignment design.

## 2026-10-30 15:10, Kevin with Claude, planning

**Task:** Switch the wallet provider to Payaza and answer the shareholders' infrastructure questions.

**Files touched:**
- docs/08-payaza-integration.md (new)
- docs/01-open-decisions.md (D2 changed, D21 added), docs/02-architecture.md, docs/06-risks.md (R16 added), README.md
- api/openapi.yaml (webhook provider enum now payaza, paystack, moolre), api/README.md

**What changed:** Payaza facts taken from its public docs. Ghana collections need approval and business verification in Turbo Mobility's name; fees, limits and webhook retries are not published.

**Acceptance criteria:**
- [x] Contract lints clean after the change
- [ ] Turbo Mobility has emailed Payaza for Ghana collections access
- [ ] Payaza questions in docs/08 answered

**Deviations from plan or contract:** `channel: card` kept in the contract but not committed for v1 (Ghana cards unconfirmed).

**Status:** done (docs). Waiting on Payaza approval.

**Next step:** Turbo Mobility emails Payaza; Bethel builds the adapter against a fake provider.

## 2026-10-30 01:55, Kevin with Claude, planning

**Task:** Turn Turbo's requirements PDF into a planning pack and an API contract.

**Files touched:**
- README.md, LOG.md
- docs/00 to docs/07
- docs/source/Student_Ride_Hailing_Requirements.pdf (copy of the original)
- api/openapi.yaml, api/README.md, api/redocly.yaml

**What changed:** Created the folder from scratch. Contract has 107 operations, lints clean with Redocly, and a Prism mock was run and answered correctly for `/service-area`, `/rides/quote` and `/rides` (with and without an Idempotency-Key).

**Acceptance criteria:**
- [x] Contract lints with no errors or warnings
- [x] Every schema reference resolves; every operationId is unique
- [x] Mock server serves examples
- [ ] Bethel and Emmanuel have read the contract and raised changes
- [ ] Defaults in `01-open-decisions.md` sent to Turbo

**Deviations from plan or contract:** none. Design additions needing Turbo's approval are flagged in the docs: driver acknowledgement step, start PIN lockout, in-app deletion request in v1.

**Status:** done (planning). Awaiting review.

**Next step:** Fix invoice line 6 to include the student web app, send the invoice, then send Turbo the open-decisions list.
