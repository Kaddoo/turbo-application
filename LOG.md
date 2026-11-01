# Turbo log

Newest entry first. Template is in `docs/05-work-plan.md`. Add an entry at the end of every working session.

## 2026-11-01, Claude, code: live checks of critical dashboard endpoints

**Task:** Test the critical dashboard endpoints against `api.turbogh.app` and mark them Tested; prepare inconsistencies 5 to 11 and 17 for the backend.

**Files touched:** docs/api-tracker.md, docs/backend-feedback.md, LOG.md (plus, on 2026-10-31: apps/admin_dashboard/test/live/critical.live.ts, vitest.live.config.ts, `npm run test:live`).

**What changed:** The API was down on 2026-10-31 (empty Caddy 503) and up on 2026-11-01. `npm run test:live` passed 14/14; each of the six dev accounts signs in with the right role. Tested = Y for 8 endpoints (login, logout, me, verifications list and detail, live rides, incidents, service area); invite accept and MFA confirm stay N (only the bad-token path checked). Later, with staging confirmed and Kevin approving: `LIVE_WRITES=1` passed for boundary save, verification claim (and 409 for a second reviewer), vehicle create (and 409 for a duplicate plate) and edit, so Tested = Y for 4 more (12 in all); decision, create driver, assign vehicle and acknowledge incident skipped (they text real people, or nothing open). Feedback sent as https://github.com/KosherKev/turbo/issues/1. Feedback item 0 now asks whether the host is staging or production and flags that MFA is not enforced (every seed account has `mfaEnrolled: false`).

**Acceptance criteria:**
- [x] Only endpoints with a passing live check are marked Tested, each in the verification log
- [x] No tokens or passwords printed in output or files

**Deviations from plan or contract:** The full 0.2.2 `openapi.yaml` arrived (Downloads); not copied into `api/` (planning owns it). Versus 0.2.0 it only adds `text/csv` on `/uploads` and three `DriverRide` fields. Feedback not sent anywhere yet.

**Status:** done, awaiting review. Branch: api-tracker.

**Next step:** Planning places 0.2.2 in `api/`, then `npm run gen:api`, drop the CSV cast in `uploadContentType`, `npm run api-tracker`. Once the host is confirmed non-production, write the LIVE_WRITES checks. Send docs/backend-feedback.md where Kevin says.

## 2026-10-31, Claude, code: API endpoint tracker

**Task:** One tracking sheet for every documented endpoint: page, action, params, body, responses, auth, role, Integrated, Tested, notes; plus undocumented endpoints, backend inconsistencies and critical endpoints.

**Files touched:**
- docs/api-tracker.md (new), tool/api-tracker.cjs (new), package.json and package-lock.json (`npm run api-tracker`, js-yaml 3.15.2 pinned, already in node_modules via Prism)
- apps/admin_dashboard/src/pages/Finance.tsx (separate commit)

**What changed:** The table is generated from `api/openapi.yaml` (135 operations), the endpoint mentions per screen in `prompts/01` to `05`, and the dashboard code (which page really calls what). A rebuild keeps the Integrated and Tested cells already marked (checked by setting one, rebuilding, and seeing it kept). Hand-written sections: 17 undocumented endpoints, 20 inconsistencies, critical endpoints by journey, a verification log. While checking roles per page: the finance wallet tab called `GET /admin/settings` (super_admin only) for every finance user, got 403 every time and showed a made-up GH₵50 approval limit; it now fetches only for super_admin and leaves the number out otherwise.

**Acceptance criteria:**
- [x] Every operation in the contract has a row (135), every row has a page (dashboard, planned screen, or "None")
- [x] Integrated = Y only where dashboard code calls it (74); Flutter apps 0 (no screen calls the client)
- [x] Tested = N everywhere: nothing has been run against the real API yet
- [x] `npm run check` in the dashboard passes (75 tests)

**Deviations from plan or contract:** Built on contract 0.2.0 (the repo copy); the API runs 0.2.2 (inconsistency 1). Rerun `npm run api-tracker` when the full file lands. The landing page lives in another repo and is not tracked.

**Status:** done, awaiting review. Branch: api-tracker (cut from admin-api-integration).

**Next step:** Test the critical dashboard endpoints against the real API on :3000 and mark Tested with the verification log; send inconsistencies 5 to 11 and 17 to the backend.

## 2026-10-31, Claude, code: admin dashboard follows the API integration guide

**Task:** Store the backend's integration guide (contract 0.2.2) and bring the dashboard in line with it before trying the real API.

**Files touched:**
- docs/api-integration.md (new: the guide, verbatim, with a note on the contract version)
- apps/admin_dashboard: src/api/client.ts, src/lib/problems.ts, src/main.tsx, src/app/Layout.tsx, src/pages/Finance.tsx, src/pages/People.tsx, src/pages/SignIn.tsx, src/demo/server.ts, vite.config.ts, .env.example, README.md, test/api-client.test.ts (new), test/routes.smoke.test.tsx

**What changed:**
- Uploads go through one `uploadFile` helper: declares the type (`.csv` always as `text/csv`), PUTs with exactly that `Content-Type` and no auth header, and fails unless storage answers 2xx. Before, a failed PUT was ignored and the screen carried on with a useless `uploadId`.
- Reconciliation takes the Payaza CSV statement (0.2.2); the "upload a PDF instead" banner is gone.
- 429/503: the wait comes from `retryAfterSeconds` or `Retry-After`; queries retry after that delay and messages say how long to wait.
- 426 `upgrade_required` shows a reload banner.
- Dev proxy target is configurable (`API_PROXY_TARGET`, Prism :4010 by default, real API :3000); refresh-cookie path and domain are rewritten in dev so the cookie comes back.
- Demo logins match the API's dev accounts (`dispatch@`, `finance2@`); the demo storage accepts uploads; the demo no longer JSON-parses file bodies.

**Acceptance criteria:**
- [x] `npm run check` (75 tests) and `npm run build` pass
- [x] Proxy checked against Prism: `/api/health` and `/api/service-area` return 200 through the dev server
- [ ] Signed in against the real API on :3000 (not running on this machine)

**Deviations from plan or contract:**
- `api/openapi.yaml` is still 0.2.0. The 0.2.2 file was pasted incomplete (stops at `addDriverDocument`), so it was not stored and types were not regenerated. Until it lands, `text/csv` is sent through the existing content-type cast. 0.2.1 only touches `DriverRide` (driver app).
- `GET /admin/stats` exists in the API but not in the contract, so Overview does not use it (contract wins). Needs a contract entry to be used.
- CONTRACT_REQUESTS A1 (CSV for reconciliation) is resolved by 0.2.2; that file lives on branch admin-contract-requests and was not edited here.

**Status:** done, awaiting review. Branch: admin-api-integration (cut from admin-dashboard-screens).

**Next step:** Drop the full 0.2.2 `openapi.yaml` into `api/` and run `npm run gen:api`; then `API_PROXY_TARGET=http://localhost:3000 npm run dev`, sign in as each dev staff account, and click through.

## 2026-10-31, Claude, code: admin dashboard screens

**Task:** Build the dashboard screens on the scaffold: sign-in through to every `x-roles` area.

**Files touched:**
- apps/admin_dashboard/src: app (App routes, Layout, env, strings), auth (roles, session), components (ui, MapView), lib (format, problems, queries), pages (SignIn, Overview, Verification, People, Rides, Finance, Care, Workforce, Admin), demo (data, server), api/client.ts, main.tsx
- apps/admin_dashboard: package.json (react-query, react-router, leaflet, qrcode), vite.config.ts (dev proxy `/api` → :4010), test/hardcoded-style.test.ts (allow `demo/`), test/routes.smoke.test.tsx (new), README.md

**What changed:** Staff sign-in with MFA step, forgot and reset password, invite acceptance with authenticator QR, idle sign-out at 15 min. Role-guarded areas exactly per `x-roles`: overview; verification queue and review (claim, decision); students, drivers (documents, salary profile), vehicles; live map, rides (cancel, complete, reassign, refund), announcements; top-ups, wallet adjustments (request and second-person approval), reconciliation; support tickets, incidents; shifts, attendance corrections, salary payments; configuration (settings, fare bands, service area, pickup points), staff, audit log; own account. All 71 admin operations in the contract are used. Errors switch on problem `code`; money stays in pesewas. Demo mode (`VITE_APP_ENV=demo`) serves contract-shaped sample data in the browser for presentations; it is now kept out of real builds.

**Acceptance criteria:**
- [x] `npm run check` (schema regenerates with no diff, typecheck, 67 tests) and `npm run build` pass
- [x] Every screen renders signed in through the demo server with no error state (smoke test; shown to fail when a demo route is missing)
- [ ] Seen in a real browser, against Prism or the demo (no browser in this session)
- [ ] Map seen with tiles (Leaflet is mocked in the smoke test)

**Deviations from plan or contract:**
- Interim map is Leaflet on OpenStreetMap tiles until Turbo's Google Maps key exists; `MapView` props stay the same when it is swapped.
- `demo/` is exempt from the hard-coded style test (it holds SVG document placeholders, not UI styling).
- The main bundle is 664 kB (200 kB gzip); Vite warns above 500 kB. Route-level code splitting not done.
- Screens that need contract gaps (A1 to A28 in `CONTRACT_REQUESTS.md` on branch admin-contract-requests) use what the contract has today, e.g. finance looks students up by id.

**Status:** done, awaiting review. Branch: admin-dashboard-screens (cut from admin-dashboard-scaffold, so merge that first).

**Next step:** Click through in a browser (`VITE_APP_ENV=demo npm run dev`, then against Prism) and fix what shows up; rebuild affected screens when the updated contract lands; move `turbo_ui` tokens to the landing-page brand on a machine with Flutter.

## 2026-10-31, Claude, code: admin dashboard discovery and scaffold

**Task:** Review the docs and contract for the admin dashboard, record contract gaps, scaffold `apps/admin_dashboard`.

**Files touched:**
- CONTRACT_REQUESTS.md (new; branch admin-contract-requests)
- apps/admin_dashboard: package.json, vite and ts config, src/brand/brand.ts, src/theme (theme.ts, base.css), src/api (client.ts, generated schema.d.ts), src/app shell, test/contrast.test.ts, test/hardcoded-style.test.ts, README.md (branch admin-dashboard-scaffold)

**What changed:** Discovery review agreed with the dashboard builder: the dashboard lives in `apps/admin_dashboard` in this repo, screens follow `x-roles` exactly, staff login follows the contract as written, one vehicle has at most one driver, the environment badge is set at build time. Contract gaps written as A1 to A28 in `CONTRACT_REQUESTS.md` (blockers: CSV upload for reconciliation, staff names, SOS visible to all staff, finance student lookup). Scaffold: React 19 + Vite 8 + TS 5.9, `openapi-typescript` types and `openapi-fetch` client (memory access token, cookie refresh, one retry for body-less requests, `X-App-Version`). Brand taken from the landing page (https://turbo-lake.vercel.app/): ink `#0B0C0A`, paper `#F3F1EA`, neon `#D4FF3A`, Geist Sans and Mono, radius 16/12/full.

**Acceptance criteria:**
- [x] `npm run typecheck`, `npm test` (23 tests: contrast both schemes, hard-coded style guard and its self-checks), `npm run build` pass
- [x] Regenerating `schema.d.ts` from the contract gives no diff
- [ ] Seen in a browser against the Prism mock (not run this session)

**Deviations from plan or contract:**
- `docs/07` puts the dashboard in a separate `turbo-admin` repo and `README.md` names Bethel as owner; decided otherwise (see above). `CLAUDE.md` layout does not list `apps/admin_dashboard` yet: planning to update.
- Landing-page brand replaces the interim `#C6FF00` / system-font theme for the dashboard. Light-mode status colours darkened for the paper background (success `#0F6E50`, warning `#A3400A`, danger `#B42318`).
- The Flutter apps were also meant to move to the landing-page brand, but this machine has no Flutter SDK, so `flutter analyze`/`flutter test` and the goldens could not run. Not started.
- `npm audit` reports 3 moderate issues in `openapi-typescript`'s dev-only dependency chain (minimatch via @redocly/openapi-core). Build-time only; the suggested fix downgrades the generator, so left as is.

**Status:** done, awaiting review. Branches: admin-contract-requests, admin-dashboard-scaffold (both cut from main).

**Next step:** Dashboard sign-in, MFA and invite screens against the mock; separately, move `turbo_ui` brand tokens to the landing-page values on a machine with Flutter.

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
