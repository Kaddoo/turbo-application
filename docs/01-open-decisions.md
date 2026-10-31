# 01. Open decisions

Turbo's PDF leaves these open (§15 and the "still to agree" notes). For each, we state **the default we build against**, so work never
stops. The default is a proposal from us, not something Turbo has approved. Get each one confirmed in writing (WhatsApp or email is fine).

Gates: **P1** = before Phase 1 ends, **P2** = before Phase 2 ends, **Pilot** = before real students use it.

| # | Decision | Default we build against | Decider | Needed by |
| --- | --- | --- | --- | --- |
| D1 | Exact map boundary; road distances checked against 18 km | Boundary is configurable and ships empty (`null`). Dashboard has a polygon editor. Pilot is blocked until Turbo approves a drawn boundary | Turbo | Pilot |
| D2 | Payment provider and top-up methods | **Payaza** (chosen by Turbo's shareholders), behind an adapter interface. Mobile money first; card not committed until Payaza confirms Ghana cards. Turbo Mobility must apply for Ghana collections and pass business verification: start now (`08-payaza-integration.md`) | Turbo | P2 |
| D3 | Withdrawal of unused wallet balance | Not in v1. Staff can debit via a wallet adjustment and pay out manually | Turbo | Pilot |
| D4 | Student login method | Phone number plus SMS code | Turbo | P1 |
| D5 | Identity data collected and retention | Ghana Card front and back, student ID, name, student ID number. Documents purged 30 days after a final decision; the decision record stays. Retention job is configurable | Turbo (data controller) | P1 |
| D6 | Who reviews identity documents | Staff role `verifier`; Turbo names the people | Turbo | Pilot |
| D7 | Map and routing provider | Google Maps Platform: Routes API for road distance, Maps SDK in the apps. Turbo owns the billing account and API keys | Turbo | P1 |
| D8 | Assignment rules | Nearest idle on-duty driver by straight-line distance among drivers seen in the last 60 s. Driver must acknowledge within 45 s or the ride is reassigned. Search for up to 5 min, then cancel with no charge | Turbo | P2 |
| D9 | Shared rides | Deferred to v1.1. Needs Turbo's answers on matching, fares, capacity, cancellations | Turbo | v1.1 |
| D10 | Operating hours and driver capacity | No fixed hours. Quote refuses with `no_drivers_on_duty` when nobody is on duty. Optional operating windows are configurable | Turbo | P2 |
| D11 | How hours are calculated and corrected | Hours = duty-on to duty-off inside a scheduled shift. Staff corrections need a reason and are audit-logged | Turbo | P2 |
| D12 | How salaries are paid | System records payments made outside it. No payouts initiated from the API | Turbo | P2 |
| D13 | Partial trips and breakdowns | Staff judgement: cancel the ride and refund any amount via the refund endpoint | Turbo | Pilot |
| D14 | Destination change during a trip | v1.1 | Turbo | v1.1 |
| D15 | Support and emergency procedure | In-app SOS creates a high-priority incident, pushes to staff, shows campus security and emergency numbers (Turbo supplies them). A named human must watch incidents during operating hours | Turbo | Pilot |
| D16 | Product name, branding, visual style | Working name "Turbo". Emmanuel delivers colours, type and radius first so Kevin can theme the apps | Turbo + Emmanuel | P1 |
| D17 | Student and driver contact | No phone numbers shown in v1. Students see driver first name, vehicle and plate. Drivers see student first name | Turbo | P2 |
| D18 | Who legally holds wallet money | Funds sit with a licensed payment provider, not with Turbo or Bevin, until a lawyer says otherwise | Turbo + their lawyer | P2 |
| D19 | Data deletion process | In-app request creates a ticket; staff complete it within a stated period; ledger entries are anonymised, not deleted | Turbo | Pilot |
| D20 | Top-up limits and low-balance behaviour | Min GH₵5, max GH₵500 per top-up. Booking is blocked with a clear message and a top-up shortcut when available balance is below the fare | Turbo | P2 |
| D21 | Who bears Payaza's fee on top-ups | Fee schedule not published. Default: Turbo absorbs it. Alternative: add the fee to the top-up amount shown to the student | Turbo | P2 |
| D22 | Wallet balance when an account is deleted or the student graduates | Staff pay the balance out manually after a ticket; recorded as an adjustment | Turbo + their lawyer | Pilot |
| D23 | How long a verification lasts | One academic year, re-verified each September (not built in v1; `verifiedUntil` is a change request) | Turbo | P2 |
| D24 | Location history retention | Full tracks 90 days (`locationRetentionDays`), then ride summary only | Turbo | Pilot |
| D25 | Wallet adjustment approval | Up to GH₵50 alone; above that a second finance or super_admin approves | Turbo | P2 |
| D26 | Rider no-show | Driver waits 5 minutes (`noShowWaitSeconds`), then cancels; no fee; repeats flagged to staff | Turbo | P2 |
| D27 | Ghana Card number stored | Yes, encrypted and unique, with a selfie holding the card. Lawyer confirms | Turbo + their lawyer | P2 |

## How to close a decision

1. Send Turbo the one-line question and our default.
2. Record their answer here: date, who answered, what they chose.
3. If it differs from the default, update the affected doc and the contract in the same commit.

| # | Answer | Date | From |
| --- | --- | --- | --- |
| | *(empty)* | | |
