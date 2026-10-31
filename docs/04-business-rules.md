# 04. Business rules

All money in **pesewas**. GH₵1 = 100 pesewas.

## Fare bands (configurable by `super_admin`)

| Road-route distance | Base fare | Pesewas |
| --- | --- | --- |
| Up to 3 km | GH₵18 | 1800 |
| Over 3 km to 6 km | GH₵25 | 2500 |
| Over 6 km to 12 km | GH₵35 | 3500 |
| Over 12 km to 18 km | GH₵50 | 5000 |
| Over 18 km | Booking unavailable | |

Rules:

- Bounds are **inclusive on the upper side**: exactly 3000 m is GH₵18; 3001 m is GH₵25.
- Distance is the **road route** returned by the Routes API for that trip, in metres, not straight-line distance.
- The fare is shown before confirmation and **locked** when the quote is created. It does not change if the band table is edited afterwards.
- Band fares must be whole cedis (multiples of 100 pesewas). The API rejects anything else. This keeps shared-ride maths exact.

### Worked examples

| Route distance | Band | Fare |
| --- | --- | --- |
| 2.4 km (2400 m) | up to 3 km | 1800 |
| 3.0 km (3000 m) | up to 3 km | 1800 |
| 3.001 km (3001 m) | to 6 km | 2500 |
| 9.4 km (9400 m) | to 12 km | 3500 |
| 18.0 km (18000 m) | to 18 km | 5000 |
| 18.001 km (18001 m) | none | blocked: `route_too_long` |

## Eligibility (checked in this order, all reasons returned)

1. Student is verified (`approved`) and the account is active. Otherwise `verification_required`.
2. Student has no active ride. Otherwise `active_ride_exists`.
3. Pickup inside the boundary, then drop-off inside the boundary. Otherwise `outside_service_area`.
4. Route found. Otherwise `route_unavailable`.
5. Road distance at or under the limit (default 18000 m). Otherwise `route_too_long`.
6. At least one driver is on duty and the time is inside operating windows if any are set. Otherwise `no_drivers_on_duty`.
7. Wallet check is **reported but does not make the quote ineligible**: the quote returns `wallet.sufficient` and `shortfallPesewas`, and the app shows a top-up prompt. Creating the ride re-checks and returns 409 `insufficient_balance`.

Ineligible quotes are a normal `200` with `eligible:false`, plain-language messages, and no `quoteId`, so the app can explain and let the student change locations.

## Booking and payment

1. `POST /rides` with a valid `quoteId` and an `Idempotency-Key`.
2. In one transaction: re-check eligibility and balance, lock the wallet, create a hold for the fare, create the ride as `searching`.
3. At completion: convert the hold to a `ride_charge` for the same amount.
4. A quote expires after 5 minutes (configurable). Expired quote gives 409 `quote_expired`.

## Start PIN

- 4 digits, random per ride, shown only in the student app while the ride is `assigned` or `driver_arrived`.
- The driver types what the student reads out. Five wrong attempts lock the start; staff must intervene. (Design addition, confirm with Turbo.)

## Cancellations and refunds (all free for students)

| Stage | Student cancels | Driver or service cancels | Staff cancels |
| --- | --- | --- | --- |
| searching | Hold released | Not applicable. No driver in time: system cancels, hold released | Hold released |
| assigned | Hold released | Driver declines: reassigned. No replacement: system cancels, hold released | Hold released |
| driver_arrived | Hold released. **No no-show fee** | Same as above | Hold released |
| in_progress | **Not allowed** (409) | Breakdown: staff cancel and refund as needed (D13) | Charge or release, then refund |
| completed | Not applicable | Not applicable | Refund for wrong or duplicate charge via the refund endpoint |

- A student is never charged for a driver or service cancellation.
- A refund is a positive `refund` ledger entry linked to the ride. The sum of refunds can never exceed the amount charged (`refund_exceeds_charge`).
- Cancellation and refund both appear in the student's history with a plain-language description.

## Pickup and no-show (D26)

- Students see the pickup point and its landmark. Driver and student exchange preset quick messages ("I'm at the gate"); no phone numbers (D17).
- After arriving, the driver waits `noShowWaitSeconds` (default 300). Then "student not here" cancels the ride with reason `rider_no_show`, releases the hold and charges nothing. The count appears on the student record for staff.

## Wallet

- Top-up limits: min GH₵5, max GH₵500 (defaults, configurable, D20).
- Balance, reserved and available are shown separately: `available = balance - reserved`.
- A failed or abandoned top-up never changes the balance.
- Only a verified provider webhook credits a top-up. Duplicate webhooks are ignored.
- Staff adjustments need a reason code and a note, are idempotent, and cannot take a balance below zero. Up to `adjustmentApprovalThresholdPesewas` (default GH₵50) they apply at once; above it a different finance or super_admin user must approve (D25). Nobody can adjust a wallet tied to their own phone number.
- Every top-up records the amount the provider says it received. Anything other than an exact match is flagged for finance, who work the exceptions queue and run a statement reconciliation (`docs/08`).
- Quotes are limited per student (`quoteLimitPerMinute`, default 10) because each one can cost a Routes API call.

## Shared rides (v1.1, not built, formula for later)

| Riders | Each pays | Total collected |
| --- | --- | --- |
| 1 | 100% of fare | 100% |
| 2 | 50% of fare | 100% |
| 3 | 35% of fare **plus** GH₵5 (500 pesewas) | 105% of fare + GH₵15 |

Example with a GH₵35 fare (3500): two riders pay 1750 each (GH₵17.50); three riders pay 1225 + 500 = 1725 each (GH₵17.25), total 5175 (GH₵51.75). This matches the PDF.

Because band fares are whole cedis, 35% is always a whole number of pesewas (35% of 100n = 35n), so no rounding rule is needed.
Still undecided by Turbo: matching and route compatibility, base fare when drop-offs differ, capacity, cancellations and no-shows, how remaining riders accept a revised fare.

## Salary and attendance

- Each driver has a monthly salary and a pay period (weekly, biweekly, monthly).
- Staff schedule shifts. Duty on and off events inside a shift produce attendance and minutes worked.
- Staff can correct attendance with a mandatory reason; the original values stay in the audit log.
- Salary payments are **recorded** by staff after Turbo pays them outside the system (D12). Drivers see their own history read-only.
