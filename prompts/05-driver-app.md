# Prompt 05: Driver app (iOS and Android)

Owner: Kevin. Give the agent `00-shared-rules.md` and this file. Flutter, same shared `turbo_api` package and theme as the student app. Riverpod, GoRouter, `geolocator` plus a background location plugin, Firebase Messaging, `google_maps_flutter`, secure storage.

## Job

A salaried driver goes on duty, gets a ride assigned automatically, finds the student, checks the PIN, drives, completes, and sees their own shifts and pay record. Everything must work one-handed, in sunlight, with a phone on a mount and a poor signal.

## Principles specific to drivers

- **Glanceable**: one primary button per screen, very large type for the next action, nothing that needs reading while driving. High contrast, large tap targets (at least 56 pt for primary actions).
- **No student phone number** is shown (decision D17). Drivers see the student's first name only. Coordination goes through pickup point name, landmark and quick messages.
- **The phone is a tool the driver depends on**: show battery, GPS and connection warnings early, never hide failures.
- **Drivers do not compete or choose**: assignments arrive; they can acknowledge or decline.
- Plain, respectful language. No gamification, no earnings pressure (drivers are salaried).

## Navigation model

Signed-out stack: Welcome, Phone, Code. Signed-in: **bottom bar with Home, Trips, Me** (Me holds shifts, attendance, salary, help). While a ride is active, the ride flow takes over the whole screen and cannot be dismissed. Duty status and the current ride are restored from `GET /driver/profile` and `GET /driver/rides/current` on every start and resume.

## Always-first checks

`GET /app-config` (update, maintenance), session restore, `GET /driver/profile`. If the account is suspended, show a blocking message with the support contact.

## Screens

**Welcome, Phone, Code.** As the student app, with `role: driver`. Driver accounts are created by staff, so an unknown number gets "This number isn't registered as a driver. Contact your supervisor."

**Home (off duty).** Purpose: start the shift. Primary action: Go on duty (huge, bottom). Content: greeting with first name, vehicle assigned (model, plate), today's scheduled shift, **readiness checklist** (location permission "Always", battery above 20% or on charger, internet, notifications on, documents valid) with failures in red and a fix button. Going on duty can return 409 `document_expired`: show which document ("Your insurance expired on 12 Oct. Contact your supervisor.") and disable the button. Endpoint `PUT /driver/duty`.

**Home (on duty, idle).** Purpose: wait for work calmly. Primary action: Go off duty (secondary, behind a confirm). Content: map with own position, status "On duty. Waiting for a ride", shift time so far, connection and GPS indicators. Location pings run in the background at the interval configured (default every 5 seconds) with `PUT /driver/location`. A driver cannot go off duty during a ride (409): explain.

**New assignment.** Purpose: accept in time. Primary action: Accept. Content: full-screen takeover with sound and vibration (works from the lock screen via push), a **45-second countdown ring** (from settings), pickup point name and landmark, distance and ETA to pickup, student first name, trip distance, Decline (secondary, with reason: car problem, too far, unwell, other). Missing the countdown reassigns the ride; show "Ride passed to another driver" without blame. Endpoints `POST /driver/rides/{id}/ack` and `/decline`.

**Go to pickup.** Purpose: get there. Primary action: I've arrived. Content: map, route line, big "Navigate" button opening Google Maps or Waze with the pickup coordinates, pickup point name and landmark, student first name, quick messages (Running late, I'm here, At the gate, I can't find you, `POST /rides/{id}/messages`), SOS. "I've arrived" is enabled only within a reasonable distance of the pickup (soft check; if far, ask to confirm). Endpoint `POST /driver/rides/{id}/arrived`.

**At pickup (waiting).** Purpose: find the student. Primary action: Start trip (enter PIN). Content: waiting timer, student first name, plate and landmark reminder, quick messages. **After the no-show wait (default 5 minutes, `noShowAvailableAt`) a "Student not here" button appears**; it confirms, then cancels with reason `rider_no_show` (`POST /driver/rides/{id}/no-show`), explains the student isn't charged and no fee applies. Before the time: 409 `no_show_too_early` shows when it will be available.

**Enter PIN.** Purpose: confirm the right passenger. Primary action: Start. Content: 4-digit keypad with large keys, "Ask the student for their PIN. Never accept it by message." Wrong PIN shows remaining attempts; five wrong attempts lock the start (`pin_locked`) and the screen says "Too many tries. Call your supervisor." with a call button. The PIN is never shown to the driver app. Endpoint `POST /driver/rides/{id}/start`.

**Trip in progress.** Purpose: drive safely. Primary action: none until the end; "Complete trip" is shown but requires a confirm at the destination area. Content: map and route to the drop-off, big Navigate button, drop-off label, elapsed time, SOS (always visible), Report a problem. Completion sends current location. Endpoint `POST /driver/rides/{id}/complete`. If the phone loses signal at the end, store the completion locally and retry with the same intent until the API answers; show "Waiting for signal to finish your trip" so the driver is not stuck.

**Trip complete.** Purpose: close and return to work. Primary action: Back to waiting. Content: "Trip complete", distance and time, fare is not emphasised (drivers are salaried). Ratings given by students are not shown to the driver in v1.

**Cancelled by student or staff.** Purpose: clear instructions. Primary action: Back to waiting. Content: who cancelled and what to do ("Return to your waiting position").

**Trips.** Past trips with date, route, status; detail with map and timeline. Empty: "No trips yet." Endpoint `GET /driver/rides`.

**Shifts.** Upcoming and past shifts with times (`GET /driver/shifts`). Empty: "No shifts scheduled. Your supervisor sets these."

**Attendance.** Per shift: scheduled, clocked in and out, minutes worked, and a note if staff corrected it (`GET /driver/attendance`). Read-only, with "Think something is wrong?" opening a ticket.

**Salary history.** List of salary payments recorded by staff (date, period, amount, reference) (`GET /driver/salary-payments`). Read-only. Plain note: "This is a record. Payment is made by your employer outside the app."

**Help and support.** Report an issue (vehicle, student behaviour, app problem, safety, other), my tickets, conversation. Supervisor and campus security numbers (tap to call). Endpoints under `/support/tickets`.

**Safety (SOS).** Always one tap away on the ride screens and in Me. Long-press with 3-second countdown and cancel; sends location and ride (`POST /safety/sos`). Confirmation "Help has been alerted." If the request fails, offer to call the emergency number immediately; never a silent failure.

**Me.** Profile (name, vehicle), documents with expiry dates (valid, expiring in under 30 days in amber, expired in red), signed-in devices (`GET /me/sessions`), terms and privacy, version, sign out. Drivers cannot delete their account in-app (staff handle it); do not show a delete option.

## Background location (the hard part, spike first)

- **Android**: foreground service with a persistent notification ("Turbo is sharing your location while you are on duty"), location permission "Allow all the time", battery optimisation exemption guidance, handle the OS killing the service.
- **iOS**: "Always" permission with background location mode, a clear purpose string, handle "While Using" by showing an in-app prompt to upgrade it, and blue-bar behaviour.
- Pings only while on duty. Stop immediately when off duty. If the phone is offline, batch and send on reconnect, oldest dropped after 10 minutes.
- Test on real devices with the screen locked for at least 30 minutes; this is a launch gate (`docs/06-risks.md`).
- If pings stop for the silence limit, the system flags the ride `driver_unreachable` and staff are alerted, so the app should detect its own stall and show a red banner "Your location isn't being shared. Open the app."

## Push notifications

New assignment (high priority, wakes the screen), ride cancelled, student message, shift reminders, document expiring in 30 days, announcement. Tap opens the right screen. Register `POST /devices`.

## Offline and failure behaviour

Assignment requires connectivity; if offline while on duty show a persistent red banner. Actions in flight (arrived, start, complete) are retried with the same idempotency key and show clear pending states. Never leave the driver unsure whether an action worked.

## Screens to generate in a design tool (one state each)

Phone · Home off duty with readiness checklist · Home off duty with expired document · Home on duty idle · New assignment with countdown · Go to pickup · At pickup waiting · Student not here (available) · Enter PIN · PIN locked · Trip in progress · Waiting for signal to finish · Trip complete · Shifts · Attendance · Salary history · Me with documents · SOS armed.

## Done when

A test driver can go on duty, receive, accept, reach, verify the PIN, complete a trip and see it in Trips, against the mock then staging; the screen-locked 30-minute location test passes on real iOS and Android devices; no-show, decline, timeout and cancellation paths all behave; and every screen has its four states.
