# 00. Scope and release plan

Source: Turbo's *Student Ride-Hailing System Requirements* (`docs/source/`). Section numbers below refer to that PDF.

## The product in one paragraph

Verified Central University students book a ride from Miotso toward Ashaiman China Mall, pay from an in-app wallet, and watch their
driver arrive. Salaried drivers are assigned automatically. Staff run everything from an admin dashboard, including identity review,
fares, the map boundary, refunds, salaries and attendance.

## Decisions already made by Turbo (§2)

| Area | Decision |
| --- | --- |
| Users | Central University students at Miotso, Prampram |
| Verification | Ghana Card and Central University student ID |
| Service area | Miotso toward Ashaiman China Mall; exact boundary not drawn yet |
| Trip limit | 18 km by road; longer trips cannot be booked |
| Payment | Cashless, from the student wallet |
| Drivers | Salaried, no commission |
| Assignment | Automatic to an available on-duty driver; drivers do not compete |
| Cancellation | Free for students, no no-show fee |
| Operations | Salary and attendance live in the admin dashboard |

## Release 1 (the first release Turbo itself defined, §14)

1. Student registration and identity verification
2. Configurable service area and trip limit
3. Fares and wallet payments
4. Booking and automatic driver assignment
5. Driver trip handling, start PIN and live tracking
6. Free cancellations and the refunds that go with them
7. Admin management of drivers, trips, salary and attendance
8. Essential safety and support

Also in v1 because they are cheap and Apple/Google expect them: account deletion request, ratings, trip sharing.
**If time runs short, ratings and trip sharing are cut first. Nothing else is.**

## Not in Release 1

| Item | Why it waits | Contract status |
| --- | --- | --- |
| Shared rides (§7) | Turbo's own list of unresolved questions: matching, base fare with different drop-offs, capacity, cancellations, revised fares | Formula documented in `04-business-rules.md`; no endpoints |
| Destination change mid-trip (§9) | Marked "proposed, to confirm" by Turbo | Specified, tagged `x-release: v1.1` |
| Automatic top-ups, balance withdrawal (§8) | Still to agree; adds regulatory weight | Not specified |
| Scheduled rides | Not requested | Not specified |
| Payroll payouts from the system | We record salary payments; Turbo pays them outside the system (decision D12) | Record only |

## Where the invoice and the requirements disagree

The invoice lists nine deliverables. Set against the PDF:

| Invoice line | Covers | Gap |
| --- | --- | --- |
| 1 Discovery and architecture | This planning pack | none |
| 2 Brand guidelines | §13, §15 | Product name and style not chosen yet |
| 3 Marketing landing page | not in the PDF | Assumed wanted; confirm |
| 4 Admin dashboard | §12 | Salary, attendance, verification review and incident handling are inside this line |
| 5 Driver app | §10 | none |
| 6 Customer app (iOS and Android) | §5, §13 | **The PDF also asks for a student web app. The invoice does not list it** |
| 7 Backend, dispatch, payments | §4, §8, §9, §11 | Identity-document handling and support/SOS are inside this line |
| 8 Testing and handover | | none |
| 9 Hosting, 12 months | | Maps, SMS and payment fees are billed at cost per the invoice terms |

**Recommended fix before the invoice is sent:** reword line 6 to "Customer app (iOS, Android and web)".
The web app is a Flutter web build of the same codebase, limited to account, booking, wallet and history (§13). Cost is small,
but if it is not written down it becomes an unpaid line item later.

## Change control

Release 1 is frozen at the list above once Turbo signs off this document. Anything else is a written change request with its own price.
Every open decision in `01-open-decisions.md` has a default we build against; if Turbo later chooses differently, that is a change request too,
unless it was decided before its "needed by" gate.
