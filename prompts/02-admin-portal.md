# Prompt 02: Admin web portal

Owner: Bethel. Give the agent `00-shared-rules.md` and this file. React + Vite + TypeScript; typed client from `openapi-typescript`; a data-fetching library with cursor pagination support; a table component with server-side sorting and filtering; Google Maps JS for maps.

## Job

Let a small team run a campus transport service for a day without touching a database: approve students, manage drivers and shifts, watch rides live, handle money exceptions, answer support, react to SOS, and configure the service.

## Users and roles

Six staff roles, from the contract: `super_admin` (everything), `verifier`, `dispatcher`, `finance`, `support`, `hr`. Each operation lists its role in `x-roles`. **Hide what a role cannot use, and still expect the API to refuse.** Navigation is built from the role. A 403 shows "You do not have access to this" and never a blank page.

## Sign-in and security

- Email and password plus a mandatory MFA code (TOTP). Screens: sign in, MFA code, accept invite (`POST /auth/admin/invite/accept`) then scan the QR and confirm (`/auth/admin/mfa/confirm`), forgot and reset password, change password (`/admin/me/password`).
- Five failed attempts lock the account for 15 minutes: show the real message from the 429 `account_locked` response.
- Access token held in memory only; refresh through the httpOnly cookie (`clientType: web`). Idle sign-out after 15 minutes with a warning at 14.
- Identity documents appear only through signed URLs that expire; never cache or download them by default. Show a small "Viewed by you at 10:42, logged" note on the document viewer. Opening a document is audited by the API.
- Every destructive or money action is a confirm dialog that states the effect in plain words and, for the irreversible, requires typing the word.

## Navigation

Left rail: Overview, Verification, Students, Drivers, Vehicles, Live map, Rides, Finance (Top-ups, Adjustments, Reconciliation), Support, Incidents, Salary (Shifts, Attendance, Payments), Configuration, Staff, Audit log. Top bar: environment badge (STAGING in a loud colour), my name and role, sign out. Global search is out of scope for v1.

## Screens

Each block is a screen with purpose, primary action, content, states and endpoints.

**Overview.** Purpose: what needs attention now. Primary action: open the most urgent item. Content: counts of open SOS incidents (top, red if any), flagged rides, pending verifications with oldest age, flagged top-ups, pending adjustment approvals, expiring driver documents, drivers on duty, rides in progress. Endpoints: the list endpoints with `limit=1` and counts if the API returns them; otherwise compose from `GET /admin/incidents`, `/admin/rides?flag=`, `/admin/verifications`, `/admin/topups?flagged=true`, `/admin/wallet-adjustments?status=pending`, `/admin/driver-documents/expiring`. States: loading skeleton cards; each card has its own error so one failure does not blank the page. Empty: "Nothing needs attention."

**Verification queue.** Purpose: approve or reject students quickly and safely. Primary action: Claim and review the oldest. Content: table (name, student ID number, submitted time, age badge, claimed by) sorted oldest first. Filters: status. Endpoints: `GET /admin/verifications`, `POST /admin/verifications/{id}/claim` (15-minute lock; 409 `verification_claimed` shows who holds it). States: empty "No submissions waiting".

**Verification review.** Purpose: compare documents with the typed details and decide. Primary action: Approve. Content: left, the images (Ghana Card front and back, student ID, selfie holding the card) with zoom; right, typed full name, student ID number, Ghana Card number, history of earlier decisions, a checklist (name matches, photo matches selfie, card not expired, student ID current), buttons Approve, Needs attention, Reject. Reject and Needs attention require a reason code and a message to the student; an internal note is optional. Endpoints: `GET /admin/verifications/{id}`, `POST /admin/verifications/{id}/decision`. Error `duplicate_identity` surfaces as "This Ghana Card is already linked to another account" with a link to it.

**Students.** List and search by name and phone; detail with verification state, account status, wallet link (finance only), ride history, no-show count, tickets. Actions: suspend or reactivate (`PATCH /admin/students/{id}`), change phone number (`PUT /admin/students/{id}/phone`, requires a ticket id and a note, explain it signs the student out everywhere), sign out everywhere (`DELETE /admin/students/{id}/sessions`).

**Drivers and vehicles.** Driver list and detail; create driver (`POST /admin/drivers`), edit, activate or deactivate, assign vehicle, upload documents with expiry dates (licence, insurance, roadworthy). A prominent "Documents expiring" panel from `/admin/driver-documents/expiring` (default 30 days; red when expired, since an expired driver cannot go on duty and gets `document_expired`). Vehicles: list, create, edit, plate and model.

**Live map.** Purpose: see service right now. Primary action: click a ride to open it. Content: map with on-duty drivers (idle vs on a ride), active rides with pickup and drop-off, side list of active rides with status chips and flags (`driver_unreachable`, `overdue` in red). Poll `GET /admin/rides/live` every 5 seconds; show "Updated 3 s ago" and pause polling when the tab is hidden. States: empty "No drivers on duty" is a warning, since riders will be refused.

**Rides list and ride detail.** List with filters: status, date, driver, student, `flag`. Detail: summary, map of the route and driver track, **timeline** of every ride event with actor and time, payment panel (held, charged, refunded), flags. Actions by role and state: reassign (`POST /admin/rides/{id}/reassign`), cancel (`/cancel`, choose whether to release or charge), **force-complete a stuck ride** (`POST /admin/rides/{id}/complete`, only when in progress, reason code and note required, explains the fare will be charged), refund (finance, `POST /admin/rides/{id}/refund`, cannot exceed the charge).

**Finance: Top-ups and exceptions.** Table of top-ups with status and a **Flagged** filter (`GET /admin/topups?flagged=true`): shows requested amount, amount received, validation (exact, underpayment, overpayment), reason. Resolve action (`POST /admin/topups/{id}/resolve`) with resolution and note. Any wallet change goes through Adjustments, and the screen says so.

**Finance: Adjustments.** Student wallet lookup, ledger view (`GET /admin/students/{id}/wallet/transactions`), new adjustment (amount, reason code, note). At or below the threshold it applies at once; above it the API returns 202 and the UI says "Sent for approval." Approvals tab for another finance user (`GET /admin/wallet-adjustments`, approve and reject); you cannot approve your own, show the 409 `approval_by_requester_forbidden` message plainly. `self_adjustment_forbidden` gets its own sentence.

**Finance: Reconciliation.** Upload the Payaza collections CSV (upload purpose `provider_statement`), pick the period, run (`POST /admin/reconciliation/reports`), see the report: matched count, totals from both sides, an exceptions table (missing here, missing at provider, amount mismatch, status mismatch) each linking to the top-up. History of reports.

**Support.** Ticket list (status, category, age, assignee), ticket detail as a conversation with ride context and a link to the ride, reply, change status. Categories include `phone_change` and `data_request` (explain the process in a helper line). Endpoints under `/admin/support/tickets`.

**Incidents.** Purpose: nobody misses an SOS. A sticky red banner on every page whenever an incident is `open`, with a sound the user can mute. Incident detail shows ride, last known location on a map, student and driver names, contact path, Acknowledge and Resolve (with note). **An unacknowledged incident turns more urgent after 2 minutes.** Endpoints: `/admin/incidents`.

**Salary and attendance.** Shifts calendar (create, delete, overlap error `shift_overlap`), attendance table with minutes worked, correct attendance (reason mandatory, original kept in audit), salary profile per driver, record a salary payment made outside the system (the screen says plainly it does not send money). Endpoints under `/admin/shifts`, `/attendance`, `/salary-payments`, `/drivers/{id}/salary-profile`.

**Configuration (super_admin).** Boundary editor: polygon drawn on a map, version shown, save with a confirmation listing how many pickup points would fall outside; **ships empty, and the portal shows a warning banner that the pilot is blocked until a boundary is approved.** Pickup points (create, rename with landmark, deactivate). Fare bands table (whole-cedi validation, upper bounds ascending, clear message that changes only affect new quotes). Settings form (all fields in `Settings`, including driver silence seconds, no-show wait, quote limit, SMS daily limit, adjustment threshold, location retention). **Pause bookings**: one switch with a message, red while on. **Announcements**: compose and send to students, drivers or all, preview before sending.

**Staff (super_admin).** List, invite (`POST /admin/staff`), resend invite, change role, deactivate, **sign out everywhere**. Show invite pending, MFA enrolled, last login, locked until.

**Audit log (super_admin).** Searchable, filterable table (actor, action, entity, date), read-only, exportable view for the current filter.

## Cross-cutting UI rules

Tables: server pagination with cursors, sticky header, loading skeleton rows, an empty message, an error with retry, keyboard navigation. Forms: validate inline from the contract's rules, disable submit while sending, show the API's `code` mapped to a sentence. Destructive: confirm. Dates: show relative and exact on hover. Money: right-aligned, tabular figures. Desktop first (1280 wide) but usable at 1024 and on a tablet; not designed for phones. Dark mode supported.

## Screens to generate in a design tool (one state each)

Sign in · MFA · Overview (with 3 alerts) · Verification queue · Verification review · Live map · Ride detail with timeline and a `driver_unreachable` flag · Force-complete dialog · Flagged top-ups · Adjustment approval · Reconciliation report · Incident banner and detail · Boundary editor (empty) · Fare bands · Audit log.

## Done when

Every operation in the `Admin*` tags the role can use is reachable; the mock drives every screen; roles hide and refuse correctly; the idle sign-out works; and a full day can be run: onboard a driver, schedule a shift, approve a student, handle a ticket, acknowledge an SOS, close a flagged top-up.
