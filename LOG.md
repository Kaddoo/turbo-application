# Turbo log

Newest entry first. Template is in `docs/05-work-plan.md`. Add an entry at the end of every working session.

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
