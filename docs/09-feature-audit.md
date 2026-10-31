# 09. Feature-completeness audit

Method: the Feature-Completeness Auditor (Part 0 protocol, 14 lenses, archetype maps), run on 30 October 2026 against `docs/00` to `docs/08` and `api/openapi.yaml` 0.1.1.
Scope of this pass: the plan and the contract. No code exists yet, so this finds **missing design**, not missing implementation.
Confidence tags: **Certain** = checked in the contract or docs (absence confirmed by search). **Likely** = strong inference. **Guess** = depends on facts we do not have.

## 1. Frame

- **System:** campus ride-hailing for verified students, a wallet funded by mobile money (Payaza), salaried drivers, auto-assignment, staff back office.
- **Archetypes stacked:** on-demand transport + fintech wallet + multi-role back office + SMS-login mobile apps.
- **Must never go wrong:** (1) money reconciles and nothing moves twice; (2) a driver is never double-assigned; (3) a student is never charged for a service failure; (4) identity documents never leak; (5) an SOS never goes unanswered; (6) only verified students ride.
- **Bar:** pilot with real students. Anything protecting the six invariants is non-negotiable; the rest scales.

## 2. What exists (inventory, 107 operations)

Auth (OTP, admin login, refresh, devices) · verification (submit, review, decide) · quote, book, track, cancel, receipt, rating · trip share, SOS, trusted contacts · support tickets · wallet (balance, history, top-up) · driver duty, location, ack/decline/arrive/start/complete, shifts, attendance, salary history · admin (verifications, students, drivers, vehicles, rides, reassign, cancel, config, finance, support, incidents, salary, staff, audit log).

Strong already: money in integers, idempotency keys, append-only ledger, hold/charge/release, partial unique index for drivers, signed webhooks, soft delete, audit log, SOS responder gate (R11), Payaza approval gate (R16).

## 3. Findings

Severity: S0 blocker, S1 serious, S2 should-have, S3 polish. **Plan:** `v1` = hardening inside the quoted scope, no price change; `ask` = Turbo should approve as extra scope; `v1.1` = later.

| ID | Feature | Gap | Sev | Conf. | Plan | Smallest fix |
| --- | --- | --- | --- | --- | --- | --- |
| F-01 | Ride lifecycle | A ride can sit in `in_progress` (or `assigned`) forever if the driver's phone dies or the app is killed. The student is then blocked by `active_ride_exists`, the hold never settles, and the driver is blocked by the one-active-ride index. Nothing detects a silent driver, and staff can only **cancel** an in-progress ride, not complete it | S0 | Certain | v1 | Cloud Task per active ride: no ping for 3 min raises a `driver_unreachable` alert to dispatch; ride past 2x expected duration is flagged. Add `POST /admin/rides/{id}/complete` (reason required, charges the locked fare) |
| F-02 | Staff accounts | Login accepted a `totpCode`, but there was no way to enrol in MFA, no invite or set-password, no reset, no change password, no lockout, no session control. (The first draft of this audit wrongly said MFA was absent; the field existed, the path to it did not.) These accounts can open Ghana Card images and move wallet money | S0 | Certain | v1 | Invite email then set-password; MFA enrolment before first login, mandatory for every staff user; lockout after 5 failures; reset by email; super_admin can revoke a staff session |
| F-03 | Provider reconciliation | Docs promise to "flag non-EXACT `amount_validation` for finance", but the contract has no field or list for it. The nightly job only checks our own ledger. Nothing compares our credits with what Payaza says it collected and settled | S0 | Certain | v1 | Store `amountReceived`, `validation`, `flagged` on top-ups; `GET /admin/topups?flagged=true`; nightly report of succeeded top-ups vs a Payaza statement (CSV import is enough for v1); exceptions queue worked by `finance` |
| F-04 | OTP login | Rate limit is per phone number only. An attacker rotates numbers and burns SMS credit (SMS pumping), or locks real students out | S1 | Likely | v1 | Allow only `+233` numbers; per-IP and per-device limits; daily SMS spend ceiling that alerts and trips a switch; captcha or app-attestation on the web app |
| F-05 | Wallet adjustments | `finance` can credit any wallet by any amount with a reason code. No cap, no second approver, no block on adjusting a wallet tied to the staff member's own phone | S1 | Certain | v1 | Cap per adjustment (default GH₵50); above the cap needs a second approver; refuse self-adjustment; daily adjustment digest to `super_admin` |
| F-06 | Pickup and no-show | D17 hides phone numbers. The driver has no way to reach the student, no wait timer, and no "student not here" action (the driver endpoints stop at decline, arrived, start, complete). The commonest ride-hailing failure has no path | S1 | Certain | v1 | Show pickup point name and landmark; quick messages ("I'm at the gate") or masked call; after 5 min waiting the driver can tap "student not here" and the system cancels with reason `rider_no_show`, hold released (still free, per Turbo). Count no-shows on the student record for staff |
| F-07 | Account deletion | A student with a balance can request deletion, but withdrawals are out of v1 (D3). The money is stranded, or silently forfeited. Same at graduation | S1 | Certain | ask | Deletion ticket must settle the wallet first: staff pay out manually and record a ledger adjustment; terms say so. Needs a decision (D22) |
| F-08 | Consent and notice | No terms, privacy or location consent anywhere in the contract (searched). The Data Protection Act 2012 expects notice and consent for personal data and location | S1 | Likely | v1 | Store accepted terms and privacy version and time on first login; block the app until accepted; log the version on every ride request |
| F-09 | Identity checks | Submission captures a name and student ID number, but **not the Ghana Card number** and no selfie. Nothing stops one card opening many accounts, and a borrowed card passes a photo check | S1 | Certain | v1 | Capture the Ghana Card number (unique, stored encrypted); reject duplicates with `duplicate_identity`; add a selfie holding the card; verifier checklist. Lawyer to confirm storing the number |
| F-10 | Forced update | No minimum app version or maintenance flag. Store apps cannot be recalled, so the first breaking contract change strands old installs | S1 | Certain | v1 | `X-App-Version` header; `GET /app-config` returning `minVersion` and `maintenance`; `426 upgrade_required` problem code |
| F-11 | Driver documents | `expiresOn` is stored but nothing acts on it. A driver with an expired licence or insurance can keep taking rides | S1 | Certain | v1 | Daily job: warn staff 30 days out; block going on duty when licence, insurance or roadworthy is expired (`document_expired`) |
| F-12 | Phone change | Identity is the phone number and there is no change-number flow. Lost phone, new SIM, or a recycled number hands the account and wallet to someone else | S1 | Likely | v1 | Change number via support ticket with staff re-verifying the Ghana Card; notify the old number; step-up OTP on the new one |
| F-13 | Reporting | The dashboard has lists but no summary or export. Turbo and its shareholders will ask for rides per day, revenue, wait time, cancellations by reason, driver utilisation, cost per ride | S1 | Certain | ask | `GET /admin/reports/summary?from&to` plus CSV export for rides, ledger, top-ups and attendance |
| F-14 | Concurrency tests | The launch gate tests double booking, double assignment, duplicate webhook only | S2 | Certain | v1 | Add cancel vs start, cancel vs complete, admin cancel vs driver complete, double complete, top-up webhook arriving during a booking |
| F-15 | Trip completion | The driver can complete anywhere, at any time. The fare is locked, so the student pays in full for a trip that never happened | S2 | Likely | v1 | Store completion location and duration; flag completions over 500 m from the destination or under 1 minute for staff review. Flag only; do not block |
| F-16 | Notifications | Push and SMS only. No in-app inbox, so a missed push means lost information. No preferences | S2 | Certain | ask | `GET /me/notifications` with read state; preferences for non-critical categories only |
| F-17 | Data access | Deletion exists; a request for a copy of one's data does not | S2 | Likely | v1 | Handle as a support ticket category with a stated period; no endpoint needed yet |
| F-18 | Re-verification | `approved` lasts forever. Students graduate and leave but keep access (and a wallet) | S2 | Certain | ask | `verifiedUntil` per academic year; prompt to re-verify; staff bulk-expire after graduation. Needs the university's calendar (D23) |
| F-19 | Verification queue | Two verifiers can open and decide the same submission. No claim, no ageing | S2 | Likely | v1 | Claim with a 15-minute lock; oldest first; ageing badge |
| F-20 | Pause and broadcast | Only operating windows exist. No one-tap "pause new bookings" with a message, and no announcement to students or drivers for rain, an incident or a protest | S2 | Certain | v1 | Setting `bookingsPaused` plus message; `POST /admin/announcements` (push to a segment) |
| F-21 | Sessions | No list or revoke of sessions for students and drivers. A lost phone keeps a live wallet session | S2 | Certain | v1 | `GET /me/sessions`, `DELETE /me/sessions/{id}`, "log out everywhere"; staff can revoke a user's sessions |
| F-22 | Location retention | Documents have a purge rule (D5). Driver and ride location history has none | S2 | Certain | v1 | Keep full tracks 90 days, then keep only the ride summary (D24) |
| F-23 | Mobile-money reversal | Wallet cannot go negative (check constraint). If a network reverses a top-up after the student spent it, there is no entry type or recovery path | S2 | Guess | v1 | `provider_reversal` ledger type that may take the wallet negative; flag the account `owes`; block booking until topped up. Depends on Payaza's answer to question 7 in doc 08 |
| F-24 | API rate limits | Only the auth endpoints define 429. Quote spam costs real money (Routes API, R8) | S2 | Certain | v1 | Per-student limit on quotes (for example 10 a minute) and on every write endpoint |
| F-25 | Wallet comfort | No top-up receipts, statement export or low-balance alert | S3 | Certain | v1.1 | Receipt on top-up success; low-balance push below one fare |
| F-26 | Support tooling | No impersonation. Probably right for privacy; staff reproduce issues from ride timelines instead | S3 | Guess | confirm | Leave out; revisit if support cannot resolve tickets |

## 3a. Status after contract 0.2.0

| Applied to the contract | Findings |
| --- | --- |
| Endpoints, fields, codes and settings | F-01, F-02, F-03, F-04, F-05, F-06, F-08, F-09, F-10, F-11, F-12, F-19, F-20, F-21, F-24, and the contract side of F-15, F-17, F-22, F-23 |
| Docs and launch gates only | F-14 (tests), F-15 (flag rules), F-22 (retention job) |
| **Not applied: needs Turbo** | F-07 (D22), F-13 reports, F-16 inbox, F-18 re-verification |
| Not applied: later or left out | F-25 (v1.1), F-26 (left out) |

Behaviour that lives in code, not the contract, is written in `03` and `04` and must be built: the stuck-ride Cloud Task, the SMS spend ceiling, the document-expiry duty check, the completion-sanity flags, the retention purge.

## 4. Absent features the archetype expects

Already counted above: reporting (F-13), pause/broadcast (F-20), notification inbox (F-16), session control (F-21), forced update (F-10), reconciliation queue (F-03). Not found anywhere and not listed: **driver-side safety checks** such as a periodic "are you OK" prompt on long trips (S3, ask), and **fare dispute from the ride screen** (a "report a problem with this ride" button that opens a ticket pre-linked to the ride; the ticket categories exist, so this is a UI link only, S3).

## 5. Top 10 to do next

1. F-01 stuck-ride handling and force-complete
2. F-02 staff accounts with MFA, invite and reset
3. F-03 Payaza reconciliation and flagged top-ups queue
4. F-04 OTP abuse controls and SMS spend ceiling
5. F-05 adjustment cap and second approver
6. F-06 pickup contact and rider no-show
7. F-09 Ghana Card number, selfie and duplicate rejection
8. F-08 consent capture
9. F-10 minimum app version and 426
10. F-07 wallet settlement on deletion (needs Turbo's answer)

F-01 to F-03 should land in contract 0.2.0 before Bethel builds the ride and wallet modules, because they change tables and endpoints he owns.

## 6. Confirm intent (looks missing, may be deliberate)

Tipping (cashless, so likely out) · driver rating of students · scheduled rides (already out of v1) · withdrawals (D3) · promo codes and referrals · multiple stops · impersonation (F-26) · alumni access (F-18).

## 7. Decisions this audit adds

Defaults we build against, same rules as `01-open-decisions.md`. Move into that file once Turbo has seen them.

| # | Decision | Default | Decider | Needed by |
| --- | --- | --- | --- | --- |
| D22 | Wallet balance when an account is deleted or the student graduates | Staff pay the balance out manually after a ticket; recorded as an adjustment | Turbo + lawyer | Pilot |
| D23 | How long a verification lasts | One academic year, re-verified each September | Turbo | P2 |
| D24 | Location history retention | 90 days of full tracks, then ride summary only | Turbo | Pilot |
| D25 | Adjustment cap and approver | GH₵50 alone; above that a second `finance` or `super_admin` approves | Turbo | P2 |
| D26 | Rider no-show handling | Wait 5 minutes, then cancel, no fee; repeated no-shows flagged to staff | Turbo | P2 |
| D27 | Ghana Card number stored | Yes, encrypted and unique; lawyer to confirm | Turbo + lawyer | P2 |

## 8. Scope warning

The invoice is GHS 15,000 and R3 already says scope exceeds price. Of the 26 findings, the **S0 and S1 items marked `v1` are hardening of what we already promised** (a ride system that cannot get stuck, safe staff logins, money that reconciles). Treat them as in scope. F-07, F-13, F-16 and F-18 are **extra product** and should go to Turbo as priced change requests before anyone builds them.

## 9. Limits of this audit

Read the docs and the operation list in full, and spot-checked schemas by search. A gap marked Certain means the term is absent from the contract; a field could exist under a name we did not search. Nothing here has been run against code. Re-run after contract 0.2.0 and again when the first screens exist, when the state lens (empty, loading, error) can be checked per screen.
