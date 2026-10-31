# 05. Work plan

Sequence and gates, not dates. Nobody has given us hours per week, so any calendar would be invented. Once each person states their weekly hours, convert the phases below into dates.

## Who builds what

| Person | Owns | Blocked by |
| --- | --- | --- |
| **Kevin** | Student app (Flutter: iOS, Android, plus the web build) and driver app (Flutter) | Brand tokens from Emmanuel (colours, type, radius); contract for anything not yet mocked |
| **Emmanuel** | Brand guide, then landing page | Decision D16 (product name and style) |
| **Bethel** | Admin dashboard (React) and API modules marked "B" below | Contract and the staging database |

### API modules (proposal: Bethel decides the final split)

The API is the critical path, and Bethel is also building the dashboard. Putting the whole API on him is the single biggest schedule risk, so this proposes a split by risk.
Emmanuel already knows Node and Express from the FYP; PostgreSQL is the new part. Money and concurrency stay with Bethel.

| Module | Contract tags | Owner | Phase |
| --- | --- | --- | --- |
| Auth, OTP, devices, uploads, student profile | Auth, Uploads, Student | B | 1 |
| Verification (student and admin) | Verification, Admin: Verification, Admin: Students | B | 1 |
| Config: service area, pickup points, fares, settings | Service area, Admin: Config | E | 1 |
| Notifications infrastructure (FCM, SMS) | n/a (internal) | E | 1 |
| Quote (boundary check, routing, fare) | Rides (`/rides/quote`) | B | 1 to 2 |
| Wallet, top-ups, webhooks, ledger | Wallet, Webhooks, Admin: Finance | B | 2 |
| Rides, assignment engine, driver trip actions | Rides, Driver, Admin: Rides | B | 2 |
| Support, incidents, SOS, trip share, ratings, receipts | Support, Safety, Admin: Support | E | 3 |
| Salary, shifts, attendance, staff, audit log | Admin: Salary, Admin: Staff | E | 3 |

## Phases and gates

### Phase 0: Lock (before anyone codes)

- All three read the contract and the docs, and raise changes as pull requests.
- Defaults in `01-open-decisions.md` sent to Turbo for confirmation.
- Repos created (see `07-repos-and-conventions.md`), mock server running, CI lints the contract.
- Emmanuel hands Kevin the brand tokens (even rough ones).

**Gate:** contract tagged `v0.2.0`, all three have run the mock locally.

### Phase 1: Identity and configuration

| Who | Delivers |
| --- | --- |
| Bethel (API) | Auth, uploads, verification, student profile, device registration, Service area, fares, settings, pickup points, notifications |
| Bethel (dashboard) | Staff login, verification queue, config screens (boundary editor, fares, pickup points, settings) |
| Kevin (student) | Onboarding, OTP login, verification flow with camera capture, status screens, map home, quote screen against the mock |
| Kevin (driver) | Login, duty toggle, background location spike (see risks) |
| Emmanuel (web) | Brand guide v1, landing page |

**Gate:** a test student can register, upload documents, and be approved from the dashboard on staging.

### Phase 2: Money and rides (the critical phase)

| Who | Delivers |
| --- | --- |
| Bethel (API) | Wallet, top-ups with the chosen provider, webhooks, booking, assignment engine, driver trip actions, cancellation and refunds |
| Bethel (dashboard) | Live rides map, ride detail and timeline, reassign, wallet and refund screens |
| Kevin (student) | Wallet and top-up, booking, tracking, PIN, cancel, history, receipt |
| Kevin (driver) | Assignment screen, acknowledge and decline, navigate to pickup, arrived, PIN entry, complete, trip history |

**Gate:** end to end on staging with a sandbox payment provider: top up, book, assign, start with PIN, complete, charge, receipt. Plus: cancel at every stage and see the right refund.

### Phase 3: Operations and safety

| Who | Delivers |
| --- | --- |
| Emmanuel (API) | Support, incidents, SOS, trip share, ratings, salary, shifts, attendance, staff, audit log |
| Bethel (dashboard) | Drivers and vehicles, salary and attendance, support and incidents, audit log, staff |
| Kevin (both apps) | Safety button and SOS, trusted contacts, trip sharing, support tickets, ratings, driver shifts, attendance and salary history, deletion request |

**Gate:** staff can run a full day from the dashboard: onboard a driver, schedule a shift, handle a ticket, acknowledge an SOS.

### Phase 4: Hardening and pilot

- Concurrency tests on assignment and wallet (two rides, one driver; double-submitted booking; duplicate webhooks).
- Security pass on identity documents and staff permissions.
- App Store and Play submissions (privacy policy, data safety, account deletion path, location and camera justifications).
- Verify the real road distances against the 18 km limit and get Turbo's boundary approved (D1).
- Named safety responder in place (D15). Training for staff.
- Pilot with a small number of drivers and students.

**Gate:** all launch gates in `06-risks.md` are green.

## Screens (so estimates are honest)

**Student app:** onboarding, phone and code, verification (capture, status, resubmit), home ("Where to?", saved places, pickup points, wallet, Safety), destination search, quote and confirm, searching, driver assigned (PIN, vehicle, live map), in trip, trip done (receipt, rating), history, ride detail, wallet (balance, top-up, transactions), safety (SOS, trusted contacts, share), support, profile and settings, delete account.
**Student web:** account, booking, wallet, history. No camera-heavy verification flow in v1 web; direct web users to the app for verification (confirm with Turbo).

**Driver app:** login, home (duty toggle), assignment, navigate to pickup, arrived, PIN, trip in progress, complete, trips, shifts, attendance, salary history, report issue, support, SOS.

**Admin dashboard:** login and MFA, verification queue and review, students, drivers and vehicles, live map, rides and ride detail, wallets and refunds, top-up reconciliation, support, incidents, salary and attendance, shifts, fares and settings, boundary editor, staff, audit log.

**Landing page:** hero, how it works, safety, fares (read from `GET /service-area`), campus coverage, download links, contact, privacy policy and terms.

## Contract-first hand-off

1. Need a new field or endpoint? Open a pull request on `api/openapi.yaml` only. Tag the other two.
2. Merged contract means the mock serves it immediately. Kevin and Bethel build against the mock.
3. Real implementation replaces the mock behind the same URL. No app change needed if the contract was right.
4. Breaking change (rename, remove, retype, tighten): version bump and all three must approve.
5. CI runs `redocly lint` and a breaking-change diff; generated clients are rebuilt from the contract.

## Definition of done (every task)

- Behaviour matches the contract, verified against the mock and the real API.
- Money paths have tests for retries, duplicates and concurrency.
- Errors surface the contract's `code` and show a plain-language message.
- Dark mode, large tap targets and screen reader labels on every app screen.
- A `LOG.md` entry exists.

## LOG.md entry template

Copy into `LOG.md` at the end of every working session so anyone (or any tool) can resume cleanly.

```markdown
## YYYY-MM-DD HH:MM, <name>, <component>

**Task:** <one line>

**Files touched:**
- path/to/file

**What changed:** <plain description>

**Acceptance criteria:**
- [ ] <criterion from the contract or this plan>

**Deviations from plan or contract:** <none, or what and why>

**Status:** done | in progress | blocked (by what)

**Next step:** <the single next action>
```
