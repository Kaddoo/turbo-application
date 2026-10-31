# 06. Risks and launch gates

## Risk register

Likelihood and impact are our judgement: **H**igh, **M**edium, **L**ow.

| # | Risk | L | I | What we do |
| --- | --- | --- | --- | --- |
| R1 | **Holding student money in a wallet may need a Bank of Ghana licence** (stored value is regulated; Payment Systems and Services Act, 2019, Act 987, as far as we know). Turbo's PDF itself says to confirm with a provider and adviser | M | H | Keep funds with a licensed payment provider, not in a Bevin or Turbo bank account. Turbo's lawyer confirms the structure (D18) before Pilot. Our contract with Turbo says Turbo operates the wallet and Bevin builds the software |
| R2 | **Identity documents are high-risk data.** Ghana Card images fall under the Data Protection Act, 2012 (Act 843). A leak is a legal and reputational disaster | M | H | Private storage, signed URLs, role-limited access, audit log, retention purge (D5). Turbo, as data controller, registers with the Data Protection Commission and signs a data-processing agreement with Bevin. Lawyer confirms |
| R3 | **Scope exceeds price.** The PDF asks for more than the invoice lists (student web app, verification workflow, salary and attendance, safety) | H | H | Freeze Release 1 (`00-scope`), fix invoice line 6, price everything else as change requests, record decisions in writing |
| R4 | **API is the critical path and one person also builds the dashboard** | H | H | Split API modules (`05-work-plan`), mock server so nobody waits, small contract-first increments |
| R5 | **Open decisions drift into the build** | H | M | Defaults for all 27 (`01-open-decisions`), each with a gate. Unanswered by its gate means the default stands |
| R6 | **Double assignment or double charge** from concurrency and retries | M | H | Partial unique index per driver, `FOR UPDATE` on wallets, idempotency keys, webhook de-duplication, dedicated concurrency tests |
| R7 | **Background location on phones is fiddly.** iOS and Android restrict background location; the driver app and live tracking depend on it | H | H | Spike in Phase 1, not Phase 2: Android foreground service with a persistent notification, iOS "Always" permission and background modes. Test on real devices with the screen locked |
| R8 | **Maps costs and quotas.** Every quote calls the Routes API | M | M | Cache by rounded coordinates, precompute from fixed pickup points, never call for points outside the boundary. Turbo owns the billing account (invoice already bills it at cost) |
| R9 | **Store review.** Apple requires in-app account deletion for apps that create accounts (guideline 5.1.1(v)); Google Play has a similar requirement. Location, camera and payments need clear justifications | M | M | Deletion request is in v1 (not v1.1). Privacy policy and data-safety forms prepared in Phase 3 |
| R10 | **SMS codes are the front door.** Delivery failures or cost spikes lock students and drivers out | M | M | Two SMS providers behind one interface, rate limits per number, resend timer, alert on delivery failure rate |
| R11 | **SOS with no responder is worse than no SOS.** A button that alerts nobody gives a false sense of safety | M | H | A named human watches incidents during operating hours (D15) before Pilot. Unacknowledged incident alerts at 2 minutes. Show real emergency numbers in the app |
| R12 | **The 18 km limit and boundary are unverified.** Turbo has not checked real road distances | M | M | Boundary ships empty. Pilot blocked until Turbo approves a drawn boundary and distances are checked (D1) |
| R13 | **Brand and name undecided** blocks app names, bundle ids and store listings | M | M | Working name "Turbo". Bundle ids chosen early and kept (changing them later is painful). Emmanuel's brand tokens come first |
| R14 | **Salary rules are vague** (hours, corrections, how paid) | M | L | System records and reports; it does not pay. Defaults in D11 and D12 |
| R16 | **Payaza approval is not automatic.** Ghana mobile money collections are "available on request only" and production needs business verification in Turbo Mobility's name | H | H | Turbo Mobility applies now. Build against a fake provider and Payaza test mode meanwhile. Ask Payaza the questions in `08-payaza-integration.md` |
| R17 | **Scale-to-zero pitfalls.** Cloud Run only gives CPU during requests, so background timers silently stop; the first request after idle is slower | M | M | All timers are Cloud Tasks, handlers idempotent, a test that runs the assignment loop on a cold instance. Driver pings keep it warm in duty hours. Switch to always-on billing at Growth size (`02-architecture.md`, Cost shape) |
| R15 | **Branch and repo sprawl across three people** | M | L | Short-lived branches merged and deleted quickly, one contract repo, CI lint (`07-repos-and-conventions`) |

## Launch gates (all must be green before real students use it)

| Gate | Owner |
| --- | --- |
| Boundary drawn, approved, and road distances checked against 18 km (D1) | Turbo |
| Wallet structure confirmed by Turbo's lawyer; Payaza approved for Ghana collections and fee schedule received; sandbox and live keys separated (D2, D18, D21) | Turbo |
| Data Protection Commission registration and data-processing agreement in place (R2) | Turbo |
| Verifier reviewers named and trained (D6) | Turbo |
| Named safety responder and emergency numbers configured (D15) | Turbo |
| Concurrency tests passed: double booking, double assignment, duplicate webhook, cancel vs start, cancel vs complete, admin cancel vs driver complete, double complete, top-up webhook during a booking | Bethel |
| Staff accounts: invite, MFA and reset working; no shared logins | Bethel |
| Stuck-ride drill: kill a driver app mid-trip, staff force-complete, student can book again | Bethel + Kevin |
| First reconciliation against a real Payaza statement matches to the pesewa | Turbo finance + Bethel |
| Minimum-version check live in all three apps before first store release | Kevin |
| Driver app tested with screen locked on real iOS and Android devices | Kevin |
| Privacy policy, terms, data-safety forms, in-app deletion working | Emmanuel + Kevin |
| Apps approved on both stores, or TestFlight and internal track distribution agreed for the pilot | Kevin |
| Backups and restore tested; alerts wired (R-observability list in `02-architecture`) | Bethel |
| Written sign-off from Turbo on Release 1 scope and decisions | Kevin |
