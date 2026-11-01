# Turbo log

Newest entry first. Template is in `docs/05-work-plan.md`. Add an entry at the end of every working session.

## 2026-11-01, Claude, code: data-changing checks on staging for 0.3.1

**Task:** Re-run the data-changing checks against staging and say what still mismatches (backend request; Kevin approved data changes, with the dev-seed accounts).

**Files touched:** `docs/api-tracker.md` (verification log). Probe script kept out of the repo (scratchpad `writes-probe.mjs`).

**What changed:** 48 checks, 39 passed. Of the 9 failures:
- 3 are API mismatches: approving your own adjustment gives 403 where the contract says 409; `ticket_state_invalid` is missing from the contract's ticket update; a plate without its hyphen is accepted as a new vehicle.
- The other 6 could not run: staging has no rides, top-ups, incidents or tickets; the minimum web version is 0.0.0; and the probe used a wrong path for the boundary (`GET /service-area`).
- Also, the dev-seed staff accounts do sign in on staging, though the backend said they could not.

**Dashboard mismatches (branch `dashboard-ui-match`, still built on 0.2.0):**
- Add driver, Resolve top-up and Run reconciliation send no Idempotency-Key, so staging answers 422 to all three.
- None of the new 409 codes, `service_busy`, `link_invalid` or `link_expired` are handled; invite and reset still look for `invalid_token`.
- The approval threshold is read from settings (super admin only), not `/admin/me`.
- Support cannot open a student and finance cannot open a ride in the dashboard yet.

**Status:** Report done. No dashboard code changed.

**Next step:** Rebase the dashboard restructure onto `main`, regenerate from 0.3.1, then fix the four dashboard mismatches above.

## 2026-11-01, Claude, code: staff onboarding, and one contract

**Task:** Build the approved first-run onboarding for each staff role. Then consolidate on one contract (`api/contract/openapi.yaml`), add the staging note, and make CI catch drift.

**Files touched:**
- `dashboard-ui-match` (`0480dea`): `src/utils/onboarding.ts`, `src/features/onboarding/` (new), `pages/OverviewPage.tsx`, `demo/server.ts` (`?demo=fresh`, `demo-<role>` invite tokens), `features/auth/SignIn.tsx` (keep-this-page-open warning on invite step 2), `Configuration.tsx` (`?tab=`), empty-state text in Drivers, Vehicles and Workforce, `utils/problems.ts`, `test/onboarding.test.tsx`.
- `admin-contract-requests` (`4361d1a`): A32 in `CONTRACT_REQUESTS.md`.
- `contract-one-source`, cut from `main` (`ccd3fc1`): `docs/api-integration.md` (staging/production note at the top, changelog to 0.3.1), contract pointers in `CONTRACT_REQUESTS.md`, `docs/02`, `docs/05`, `docs/07`; `.github/workflows/contract.yml` (new `dart-client` and `mock` jobs).
- GitHub issue #2 for the backend.

**What changed:**
- Onboarding:
  - Super admin gets a six-step pilot checklist; HR gets a four-step driver checklist, with salary marked "can wait".
  - Ticks come from live data, so progress resumes anywhere. "Hide for now" folds it into a bar.
  - Verifier, dispatcher, finance and support get one card naming their job.
  - Once put away it does not return in that browser (localStorage until A32).
- One contract: `main` already had most of it from the backend: `api/openapi.yaml` was deleted, `tools/check-contract.mjs` was in place, and both generated clients were stamped from 0.3.1. On top of that:
  - Here I regenerated the dashboard schema and built the mock spec from 0.3.1. Both were unchanged.
  - New CI jobs rebuild the Dart client and the mock spec, and fail on any difference.

**Acceptance:** `npm run check` passes (321 tests) and `node tools/check-contract.mjs` passes.

**Deviations:**
- The user said 0.2.2, but the repo contract is 0.3.1; the docs say 0.3.1.
- The Dart client was not regenerated on this Mac (no Dart, Flutter or Java), so the new `dart-client` CI job is unproven until its first run.
- `api/README.md` and `api/README copy.md` are stale, but they are backend files; this is raised in issue #2.

**Status:** Branches `dashboard-ui-match`, `admin-contract-requests` and `contract-one-source` are ready for Kevin. Not done:
- Dashboard work for 0.3.1: new problem codes, required Idempotency-Key on the three operations, item-17 reduced views and the threshold. The dashboard restructure branches are not on `main`, and `main`'s item-17 edits use the old file layout, so this needs the restructure rebased onto `main` first.
- The data-changing re-run on staging, which needs a real invited account.

**Next step:** Rebase the dashboard restructure onto `main`, regenerate from 0.3.1 and handle the new codes. Then re-run the write checks on staging with an invited account.

## 2026-11-01, Claude, code: browser run of sign-in on staging

**Task:** Run the whole sign-in flow in a real browser against staging.

**Files touched:** `apps/admin_dashboard/src/app/App.tsx` (deliberate sign-out starts fresh), `vite.config.ts` (`strictPort` on 5173), `test/auth-routes.test.tsx`, `docs/api-tracker.md`. The browser script stays outside the repo (it needs playwright-core, which the dashboard does not depend on).

**What changed:** 24 checks in Chrome against staging, passed on two full runs (details in the tracker's verification log). Fixed: after a deliberate sign-out the sign-in link kept the last page, so the next person landed there. Found: staging only sets the refresh cookie for `localhost:5173` and `admin.turbogh.app`; the dev server on 5174 lost the session on every reload, so the port is now strict.

**Acceptance criteria:**
- [x] `npm run check` passes
- [x] Browser run 24/24 on staging (twice)

**Deviations from plan or contract:** One run passed 23/24 without naming the failing step; the next two were clean. The last run stopped on staging's sign-in rate limit (3 minutes), shown correctly on the sign-in page.

**Status:** done. Branch: dashboard-ui-match.

**Next step:** Kevin stops the old dev server holding port 5173 (started 31 Oct, its proxy returns 404 on sign-in) so `npm run dev` can start. Backend: `Secure` on the cookie; add every dashboard address to the cookie allowlist.

## 2026-11-01, Claude, code: live auth and role checks on staging

**Task:** Staging MFA removed; run the checks that were waiting for accounts.

**Files touched:** `apps/admin_dashboard/test/live/roles.live.ts` (super admin is allowed everything), `apps/admin_dashboard/.gitignore` (role results file), `docs/api-tracker.md`.

**What changed:** Ran the critical checks (14 passed, 10 write checks skipped) and the per-role sweep with the six dev-seed accounts: 114/114 checks as the contract says, so the API itself refuses every role outside its x-roles on all admin list reads. Probed the refresh cookie (attributes only, no values): rotation, reuse revocation, Origin check and logout clearing work. Tracker: Tested 12 → 28.

**Acceptance criteria:**
- [x] Every non-admin role gets 403 on each admin list read the contract denies it
- [x] Refresh, reuse detection, Origin check and logout verified on staging

**Deviations from plan or contract:** none. Single-record reads and writes were not swept by role.

**Status:** done. Branch: dashboard-ui-match.

**Next step:** Backend: add `Secure` to the `turbo_rt` cookie (tracker inconsistency 22).

## 2026-11-01, Claude, code: dashboard sign-in, sessions and role access

**Task:** Kevin's auth brief: login and logout, token storage, refresh with many failing calls, session persistence, expired-session handling, protected routes, role and permission based UI, blocking direct URLs, password reset, profile. Plan approved; built on `dashboard-ui-match` as asked.

**Files touched:** apps/admin_dashboard: `services/http.ts` (refresh on its own typed client, cross-tab refresh lock, replay of a request with its body after a refresh, session-expired signal); `state/session.tsx` (localStorage marker, expiry, sign-in and sign-out shared between tabs, query cache cleared on sign-out); `hooks/useIdleTimer.ts` (activity shared between tabs); new `hooks/usePermissions.ts`, `utils/permissions.ts` (action → role from x-roles), `utils/returnPath.ts`; `utils/roles.ts` (area reads and labels); `app/App.tsx` (return to the page asked for); `app/Layout.tsx` (access-denied screen); `features/auth/SignIn.tsx` (notices, link token removed from the address bar), `Account.tsx`; `features/students`, `rides`, `finance/Adjustments` (action checks); `components/Icon.tsx` (lock); `eslint.config.js` (no-console); `index.html` (referrer policy); tests `test/auth.test.ts`, `test/auth-routes.test.tsx`, `test/contract-roles.test.ts`, `test/live/roles.live.ts`. Repo: `tool/api-tracker.cjs` (follows the new services → hooks → pages layout), `docs/api-tracker.md`.

**What changed:** Access token in memory, refresh token in the API's httpOnly cookie, nothing secret in browser storage. Calls that fail together share one refresh, and tabs take turns (Web Locks) because refresh tokens rotate. A POST is replayed with the same body and idempotency key. A refused refresh signs the tab out, clears cached data and sends the user to sign-in with the page kept (`?next=`, same-app paths only) and "Your session ended. Sign in again to carry on." Signing out in one tab signs out all; signing in picks up in others. Typing a URL the role cannot use shows "You don't have access to …" and the page's data is never requested. Actions are checked against a table built from the contract's x-roles; a test fails if the table drifts from `api/openapi.yaml`. Reset and invite tokens are taken out of the address bar as soon as they are read.

**Acceptance criteria:**
- [x] `npm run check` passes: 306 tests
- [x] One refresh for three failing calls; POST replayed with body and key; refused refresh ends the session once; network failure does not
- [x] Signed-out direct URL goes to sign-in and back after it; verifier at `/staff` sees the access screen and `GET /admin/staff` is never called
- [x] Tokens never in errors (test), no console output (lint rule)

**Deviations from plan or contract:** Profile edit is read-only: no `PATCH /admin/me` (A31). Not tested against staging: no MFA-enrolled account, so `/auth/refresh` is Integrated Y, Tested N.

**Status:** done, awaiting review. Branch: dashboard-ui-match. A31 on admin-contract-requests.

**Next step:** Backend: one MFA-enrolled staging account per role (and its setup key) so `test/live/roles.live.ts` can prove each role is refused; confirm cookie flags, Origin check and logout clearing the cookie (tracker inconsistencies 21 to 24).

## 2026-11-01, Claude, code: dashboard matched to the inspiration, live map on phones

**Task:** Kevin: "the ui is not what i asked for look at the inspo i gave, i want the same design but turbo colors and data so fix it", then "this live map on mobile view is not ok fix the design".

**Files touched:** apps/admin_dashboard: `brand/brand.ts` (type scale, radii, layout sizes); `components/ui.module.css` (lighter weights, gradient cards, soft badges, thin ticked slider); `components/Field.tsx` (Slider `labelHidden`, tick marks); `components/charts/` (smooth glowing Sparkline with average line, peak and latest markers; new RangeLines); `components/dashboard/` (rewritten: IconTile, SectionHeader, ChangePill, MetricCard, HeroCard, Panel, DetailCard, BigNumber, ControlCard, StatTile, SortHeaderRow); `components/MapView.tsx` (optional `className`, redraws on resize); `app/shell/` and `app/Layout.tsx`, `app/routes.tsx` (sidebar, top bar and search laid out as in the inspiration; primary action has an icon); `features/overview/` (rebuilt to the inspiration's layout); `features/rides/Rides.tsx` and new `rides.module.css` (live map layout); `utils/series.ts` (`smoothForDisplay`, `expiryCurve`).

**What changed:** Overview follows the reference section by section: header with caption, count chip and filter chips; three queue cards (icon tile, caption and title, big number, change pill, glowing line chart running to the card edge; the Documents card draws expiries as a line, red when any have expired); promo-style hero card with the most urgent item; "Live operations" panel with a dotted inner card, big active-rides number, a refresh-rate slider card, sortable header row and four stat tiles. Chart curves are smoothed for display only; totals and screen-reader summaries use the raw counts. Live map: the map and ride list were forced into two columns by an inline style, so on phones the map was a narrow strip. Now side by side at equal height on desktop, stacked (map first, full width) on tablets and phones; rides are a divided list with status, flags, names, distance, fare and time.

**Acceptance criteria:**
- [x] `npm run check` passes: 224 tests, including hardcoded-style and contrast
- [x] No horizontal scroll at 390, 900 and 1440 px, dark and light (Overview and Live map, checked in Chrome against the demo server)

**Deviations from plan or contract:** none new. Overview series still come from one page of each list (A30).

**Status:** done, awaiting review. Branch: dashboard-ui-match (cut from dashboard-ui-shell).

**Next step:** Kevin reviews Overview and Live map at phone and desktop sizes. Other screens still use the older page layout; bring them to this style next.

## 2026-11-01, Claude, code: dashboard shell and component library

**Task:** Rebuild the dashboard shell and shared components to match the dark dashboard inspiration Kevin attached, using Turbo's colours (neon lime) and Turbo data, and fix the phone layout. Approved list: shell (sidebar, top bar, bottom nav), overview blocks, component library with every variant and state; a search contract request; phone tab bar.

**Files touched:** apps/admin_dashboard: `brand/brand.ts` and `theme/theme.ts` (new tokens: spacing, layout sizes, motion, hero/micro type, panel/small radii, hero gradient, scrim, shadow); `components/` (rewritten: Button, Chip, Field with Checkbox/Switch/Slider, Toast, Banner, Skeleton, EmptyState, ErrorState, Dialog with Drawer, DataTable, Card, PageHeader, ui.module.css; new: Icon, IconButton, Badge, Avatar, SegmentedControl, Menu/FilterChip, usePopover, SearchInput, Pagination/LoadMore, Tooltip, `charts/` and `dashboard/`); `app/Layout.tsx`, `app/routes.tsx`, new `app/shell/` (Sidebar, GlobalSearch, Notifications, UserMenu, BottomNav, shell.module.css), removed `app/layout.module.css`; `features/overview/` (rebuilt); `features/uikit/` and `pages/UiKitPage.tsx` (dev and demo only); `hooks/` (useSort, useFilters, useMediaQuery, nav-count queries); `utils/series.ts`; tests (`test/components.test.tsx`, smoke test names the main navigation). docs/api-tracker.md (U18, U19). On branch `admin-contract-requests`: CONTRACT_REQUESTS.md A29 (search) and A30 (overview series).

**What changed:** Sidebar with brand, Operations/Back office toggle, icons, count badges (verification, support, incidents), open SOS or active rides list, environment card; collapses to icons on desktop and always on tablets. Top bar with user menu and role badge, the role's main action, notification bell, page search ("/" focuses it), Settings. Phones: menu drawer, search sheet, bottom tab bar (4 tabs by role plus More), tables become cards, dialogs become bottom sheets. Overview: header with period, area and order filters; metric cards with sparkline or bars and change pill; hero card picking the most pressing item; live operations panel with a refresh slider, sortable stat tiles and an active rides table. No colour, size or radius literal outside brand and theme.

**Acceptance criteria:**
- [x] `npm run check` passes: 223 tests, including hardcoded-style and contrast
- [x] No horizontal scroll at 390, 900 and 1440 px (checked in Chrome against the demo server), light and dark
- [x] Production build excludes the gallery and the demo server
- [x] Every shared component shown in each state at `/ui-kit` (dev/demo)

**Deviations from plan or contract:** Overview charts use timestamps from one page of each list, so busy queues are undercounted (A30). Search finds pages only (A29). Metric cards for roles with no queues: the page shows an empty state; the live panel shows only for roles with the live map.

**Status:** done, awaiting review. Branch: dashboard-ui-shell (cut from dashboard-foundation); A29/A30 committed on admin-contract-requests.

**Next step:** Kevin reviews `/ui-kit` and the Overview (run with `VITE_APP_ENV=demo`), then merges dashboard-foundation and dashboard-ui-shell. Other screens still use the older page layout inside the new shell; give them the section header and filter chips next.

## 2026-11-01, Claude, code: admin dashboard foundation restructure

**Task:** Phase 2 of the approved foundation plan: folders, service layer, routing from one table, HTTP timeouts and error codes, ESLint and Prettier, README. No new product features; nothing in `api/` touched.

**Files touched:** apps/admin_dashboard only. Moved: `api/client.ts` to `services/http.ts`, `api/schema.d.ts` to `types/`, `lib/*` and `auth/roles.ts` to `utils/` and `hooks/`, `auth/session.tsx` to `state/`. Split: `components/ui.tsx` into one file per component; the 9 multi-screen page files into `features/<area>/` (screens plus `queries.ts`) and 30 one-line route files in `pages/`. New: 25 `services/<resource>.ts`, `hooks/sharedQueries.ts`, `app/routes.tsx`, `types/index.ts`, `eslint.config.js`, `.prettierrc.json`, `.prettierignore`. README and `.env.example` updated.

**What changed:** Screens call feature hooks, hooks call services, only `services/http.ts` talks HTTP (ESLint enforces the layers). Query keys are unchanged, so refreshes after a change behave as before. New in the HTTP layer: a 15 s timeout (2 min for uploads), and `network`, `timeout` and `unexpected` codes so every failure is an `ApiError`; requests with no response are retried by React Query as before. Routes and the left rail come from one table; pages behind sign-in load on first visit (main bundle 666 KB to 363 KB).

**Acceptance criteria:**
- [x] `npm run check` passes: schema, typecheck, lint, format, 184 tests (style test now scans each component file)
- [x] Smoke test signs in on the demo server and renders all 25 routes, and now proves each lazy page really rendered
- [x] Production build excludes the demo server; demo build works; running dev server serves the new modules
- [x] New tests for network, timeout and non-problem errors

**Deviations from plan or contract:** The geist font import stays a `node_modules` path: the package does not export its font files, so the planned package import fails (ESLint exempts that one file). Sign-in, forgot, reset and invite screens call the `auth` service directly instead of React Query hooks: they are one-off form submits with local busy state. Announcements got its own feature folder (not in the plan list). Live checks: staging now refuses password-only sign-in (403 `mfa_enrollment_required`, confirmed with a plain request), so the 9 signed-in live checks fail until a staff account with MFA is set up; the 5 that need no sign-in pass.

**Status:** done, awaiting review. Branch: dashboard-foundation (cut from api-tracker).

**Next step:** Kevin merges api-tracker, then dashboard-foundation. To run the live checks again, staging needs an MFA-enrolled test account (the suite would then need a TOTP code).

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

## 2026-11-01, Kevin with Claude, code: log shipping to LogPulse

**Task:** Send the API's failures and warnings to LogPulse (central-logging-service) with `@bevingh/telemetry` 0.2.2. Branch `logpulse-shipping` (stacked on `monitoring-alerts`, not merged, not pushed).

**What changed:** `api/src/lib/logpulse.js` ships 5xx as error, 401/403/429 and requests slower than 3 s as warn, and every pino warn/error line, with scalar fields only; headers, bodies, query strings, IPs and positions never leave, and text is masked for numbers, emails, URLs and JWTs. Off unless `TELEMETRY_COLLECTOR_URL` and `TELEMETRY_API_KEY` are set; failures are silent and never reach the caller. Health ping is opt-in (`TELEMETRY_HEALTH_PING=true`): the key refused it with "not authorized for this appId", so the key's app id must be found first.

**Server (not in git):** three `TELEMETRY_*` lines appended to `/etc/turbo/api.env` (previous copy `api.env.bak3`); code backup `/opt/turbo/src.pre-logpulse-20261101-1719`; both services restarted, "log shipping enabled" in both logs.

**Checked:** 6 new tests pass. The collector stored a direct test log (201) and a client report from the server finished with no errors. Not checked: reading the logs back (the collector's read side is still the open blocker in the monitoring plan).

## 2026-11-01, Kevin with Claude, code: monitoring and alerts

**Task:** Brief "monitoring and alerts" (docs/10-monitoring-plan.md): server housekeeping, host checks, and API alerts to inlet. Branch `monitoring-alerts` (not merged, not pushed).

**Server (not in git), each reversible:** `/etc/systemd/journald.conf.d/turbo.conf` (delete, restart journald); `/etc/docker/daemon.json` (delete, restart docker, recreate Caddy); `lnav` installed; `/root/LOGS.md`; `/etc/cron.d/pgbackrest` (original saved as `pgbackrest.orig.txt` beside it) now chains `/usr/local/bin/turbo-heartbeat` after a successful backup, reading `BACKUP_HEARTBEAT_URL` from `/etc/turbo/monitoring.env` (empty, postgres-owned, 600); `/usr/local/bin/turbo-alert`, `/usr/local/bin/turbo-hostcheck`, `/etc/cron.d/turbo-hostcheck` (every 5 minutes), `/var/lib/turbo-hostcheck/`, `/etc/logrotate.d/turbo-hostcheck`, log `/var/log/turbo-hostcheck.log`. API code backed up at `/opt/turbo/src.pre-alerts-20261101-1524` (plus package files) before deploy.

**API:** `@bevingh/sdk-node` 0.2.1; `src/lib/alerts.js` (`alert()`, off without `INLET_SECRET_KEY` and `INLET_PRODUCT_ID`, 3 s timeout, one retry, no throw, payload scrubbed); `src/domain/alert_jobs.js` (stuck ride, SOS, ledger, worker error); wired in `src/worker.js`, `src/routes/wallet.js` (Payaza), `src/app.js` and `src/server.js` (5xx rate), `src/config.js`, `deploy/api.env.example`.

**Acceptance:** [x] alerts.test.js 12 tests pass against a scratch Postgres (8 without a database). [x] Full suite on that scratch DB: 79 of 81; the 2 failures are the rate-limit test (I raised the limits to run the suite) and the document-purge test, which also fails with these changes stashed. [x] On the server: one "alerts disabled" line per process, no errors, `/health` 200. [x] Worker stopped 2 minutes: host check logged the problem; alert skipped (no key). [x] journald cap and Caddy log options confirmed. [x] `verify.sh` all pass.

**Still open:** Kevin creates the inlet product and key, then adds `INLET_SECRET_KEY`, `INLET_PRODUCT_ID`, `SOS_ONCALL_PHONE` to `/etc/turbo/api.env` and `BACKUP_HEARTBEAT_URL` to `/etc/turbo/monitoring.env`, then `systemctl restart turbo-api turbo-worker`. All alerts use inlet type `custom_alert` (the payload shapes for `error_spike` and `health_check_failed` are not in the SDK). Not done: the external uptime monitor (Kevin's step).

## 2026-11-01, Kevin with Claude, code: redesign from the design boards

**Task:** Redo both apps' screens from the boards in `design/` (light and dark), on branch `redesign-foundation` (stacked on `driver-app-foundation`, nothing merged).

**Files touched:**
- packages/turbo_ui: brand tokens (lime accent, new palettes, rounding), new `AuthLayout`, `DarkScope`, `SplashView`, `BigWordmark`, `FloatingNavBar`, `BadgeIcon`; `TurboCard` takes a colour. Goldens regenerated.
- apps/student_app: splash, welcome slides, phone, code, terms; floating bar; home (greeting card, booking sheet); price; trip screens; activity (This week, Earlier); SOS block and result sheet; share trip; wallet card, top-up amount grid, waiting screen, transactions by day; profile header and counts.
- apps/driver_app: floating bar (Home, Records, Help, Me); Records as one control (Trips, Shifts, Hours, Salary); new Help tab; home off duty and on duty; offer, to pickup, at pickup, PIN, trip, end screens.
- Both apps: build 3 (`1.0.0+3`), `ITSAppUsesNonExemptEncryption=false`.

**What changed:** Sign-in screens are always dark; everything else follows the phone's light or dark setting. New screens use theme roles only, so the hard-coded style test still passes.

**Acceptance criteria:**
- [x] `flutter analyze` clean; student app 129 tests, driver app 61, turbo_ui 49
- [x] New dark mode plus 200% text tests for student home, trip, wallet, top-up, waiting, share; driver records, home (both states) and four ride states (these caught three overflows, fixed)
- [x] Student and driver build 3 uploaded to TestFlight (processed by Apple, not yet installed or checked). **Build 3 has no driver changes after "redo driver records, help tab and bottom bar"** (home and ride screens came after it).
- [ ] **Nothing here has been looked at on a phone or a simulator.**

**Deviations from the boards:**
- No campus map art or welcome photos (not provided); slides use text and dots.
- Driver Me has no photo or document chips (CR-5); no supervisor or campus security call buttons (CR-6).
- Help topics open the ticket form without preselecting a category.
- Profile has no News and offers or Tips switches (no contract fields seen); Sign out and Delete are full-width buttons.
- Wallet card has no separate Balance and Held columns (would repeat amounts).
- Driver offer lists existing sentences, not label and value rows; no shift time on the vehicle card; no battery percentage; trip-complete card and "paid from wallet" note are missing.
- Not redone: destination and pickup-point screens, cancel-reasons sheet, rating card, student ride detail map and timeline, support new-ticket form, driver Me and trip detail.

**Next:** look at it on a phone; TestFlight build 4 with the driver changes (needs an Xcode sign-in or an App Store Connect key); remaining screens above; production setup for the API (Texify, Payaza, Google server key, terms and privacy URLs, rotate the shared SMTP password).

## 2026-11-01, Kevin with Claude, code: staging API on the server

**Task:** Run the planning repo's API on the VPS so the apps and the admin developer can use it.

**What changed (server only, nothing in the repo):** API code from `origin/main` `api/` at `/opt/turbo/turbo-api`, Node 22, `turbo` service user, systemd units `turbo-api` and `turbo-worker` on 127.0.0.1:3000 behind the existing Caddy. Settings in `/etc/turbo/api.env` (not in git): staging mode, fixed sign-in code 123456, fake payments, push through Firebase, SMTP through Academicx's Zoho sender for now, estimated routes (no Google key yet). Migrations 001 to 014 applied and the dev seed run. `https://api.turbogh.app/health` returns 200. `main` on GitHub now includes the admin dashboard and api-tracker branches.

**Risks, plainly:** anyone can sign in with code 123456, and the seeded staff accounts use a published demo password. Staging only. Before real users: real Texify, Payaza, SMTP sender and terms/privacy URLs, NODE_ENV=production, rotate the shared SMTP password.

## 2026-11-01, Kevin with Claude, code: push switched on

**Task:** Make push work on the real phone.

**Files touched:** apps/student_app and apps/driver_app `ios/Runner.xcodeproj` (push entitlement; `GoogleService-Info.plist` added to the Runner resources).

**What changed:** The apps never asked for notification permission because the Firebase config file was not in the app bundle, so Firebase did not start. It is now bundled (the file itself stays git-ignored). The push entitlement is on in both apps. The local backend runs with `FCM_PROVIDER=fcm` and the service-account file in `.secrets/`.

**Checked on the phone:** the student app registered the phone with the server. Driver quick messages and a test announcement were sent by Firebase without error; Kevin confirmed the driver messages arrived. Not yet checked: tapping a push to open its screen, the driver app's own registration, a push while the app is closed.

**Next:** student web build, public trip-share page, offline "last updated" notes, the 30-minute locked-screen location test.

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
