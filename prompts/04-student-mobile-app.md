# Prompt 04: Student mobile app (iOS and Android)

Owner: Kevin. Give the agent `00-shared-rules.md` and this file. Flutter, one codebase for iOS and Android (and the web build in prompt 03). Riverpod for state, GoRouter for navigation, a generated `dart-dio` client in a shared package (`turbo_api`) used by both rider and driver apps, `google_maps_flutter`, Firebase Messaging for push, secure storage for the refresh token.

## Job

A verified student books a ride in under a minute, pays from a wallet, and feels safe while waiting and riding.

## Navigation model

Signed-out stack: Welcome, Phone, Code, Terms, Verification. Signed-in: a **bottom bar with three destinations: Ride (home), Wallet, Activity**, with Profile and Safety reached from the home screen. Ride flow screens (quote, searching, assigned, in trip, done) are a full-screen stack above the bar and cannot be backed out of while a ride is active; the home screen always shows the active ride first. Android back and iOS edge-swipe behave normally elsewhere.

## Always-first checks

On start and resume: `GET /app-config` (update, maintenance, bookings paused), then session restore (`POST /auth/refresh`), then `GET /me`. Route by state: not signed in; terms not accepted; verification `not_submitted`, `pending`, `needs_attention` or `rejected`; `approved` goes home. Handle 403 `terms_not_accepted`.

## Screens

**Welcome.** Purpose: say what this is. Primary action: Continue. Content: wordmark, one line "Campus rides, paid from your wallet", "For Central University students at Miotso". States: offline message.

**Phone.** Purpose: sign in or sign up with a number. Primary action: Send code. Content: country code fixed to +233, number field (9 digits, strip a leading 0), helper "We'll text you a 6-digit code". Endpoint `POST /auth/otp/request` with `role: student`, `deviceId`. Errors: `otp_rate_limited` (show the wait time from `Retry-After`), `sms_budget_exceeded` ("We can't send codes right now. Try again soon."), 429.

**Code.** Purpose: prove the number. Primary action: Verify. Content: 6-box OTP with paste and SMS autofill, resend countdown (from `resendInSeconds`), "Wrong number?" link. Endpoint `POST /auth/otp/verify` (`clientType: mobile`, `acceptedTermsVersion` after the terms screen on first login). Errors: `otp_invalid`, `otp_expired`, `account_suspended`.

**Terms.** Purpose: informed consent. Primary action: I agree. Content: summary bullets, links to the full terms and privacy (`GET /legal`), a plain explanation of **why location and camera are needed**. Store accepted version.

**Verification (capture).** Purpose: prove they are a student, once. Primary action: Submit. Content: steps: full name as on the Ghana Card, Ghana Card number (format `GHA-123456789-0`, live validation), student ID number, then camera capture for Ghana Card front, back, student ID, and a selfie holding the card; each capture has a guide frame, a quality check (blur, glare, cut-off edges) with retake, and a clear note "Only our verification team sees these. They are deleted after review." Uploads via `POST /uploads` signed URLs, then `POST /me/verification`. States: upload progress per image with retry, resume if the app is killed. Errors: `duplicate_identity` ("This Ghana Card is already linked to another account. Contact support." with a button to open a ticket).

**Verification status.** Purpose: tell them where they stand. Content by state: Pending ("We're checking your documents. This usually takes a day. We'll text you."), Needs attention (reviewer's message and a Resubmit button that keeps the details they already gave), Rejected (reason and Contact support), Approved (celebration is a quiet check mark, then Continue). Poll `GET /me/verification` on open and listen for push.

**Home (Ride).** Purpose: start a ride. Primary action: "Where to?" bar. Content: map centred on the student with official pickup points shown, "Where to?" bar, saved places chips (Home, Hostel, plus add), wallet balance chip (taps to Wallet, amber if below one typical fare), Safety button, an **announcements banner** when one exists, a persistent **active-ride card** at the top when a ride is active. Bookings paused: the bar is disabled and shows the pause message. States: location permission denied (explain, offer manual pickup point list), no signal (last map, "You're offline").

**Destination and pickup.** Purpose: choose both points. Primary action: Continue. Content: pickup (default current location snapped to the nearest pickup point; list of official points with landmark text such as "by the main gate"), destination search (Places autocomplete limited to the service area), saved places. Outside-area locations are rejected on the quote, show the reason in plain words.

**Quote and confirm.** Purpose: show the price before commitment. Primary action: Book for GH₵X. Content: route summary (distance, minutes, pickup ETA), the **fare in large type**, "Fixed. It won't change." wallet line (balance, after this ride), terms of cancellation: "Cancel for free until you're in the car." If wallet is short, a single action "Top up GH₵Y" (the shortfall) that returns here. Ineligible quote: show every `reasons` message and a button to change a location. Codes: `outside_service_area`, `route_too_long` ("This trip is over 18 km, which is the longest we do."), `no_drivers_on_duty` ("No drivers are available right now. Try again soon." with Retry), `verification_required`, `bookings_paused`, `account_owes` (shows what is owed and a Top up button), `quote_expired` (silently re-quote and re-ask). Endpoint `POST /rides/quote` then `POST /rides` with an `Idempotency-Key`, `active_ride_exists` opens that ride.

**Searching.** Purpose: reassure while a driver is found. Primary action: Cancel ride. Content: animated map pulse (static if reduced motion), "Finding your driver", elapsed time, fare held note. After the no-driver timeout the API cancels with a reason: show "We couldn't find a driver. You haven't been charged." and Try again. Poll `GET /rides/{id}` every 3 to 5 seconds and react to push.

**Driver assigned.** Purpose: help them meet the driver. Primary action: none (information); Cancel is secondary. Content: **start PIN in very large type** with "Tell this to your driver when you're in the car. Never share it earlier", driver first name and photo, vehicle model, colour and **plate in large type**, pickup point name and landmark, live driver position and ETA on the map, quick messages row (I'm here, Running late, At the gate, Please come out, `POST /rides/{id}/messages`), Share trip, Safety. When the driver has arrived the screen says so clearly and plays one haptic. Cancel reasons list. If the driver goes quiet (no tracking update), show "Your driver's location is delayed" without alarm.

**In trip.** Purpose: calm and safe. Primary action: Safety. Content: route with live position, ETA, driver and plate, Share trip, SOS (long-press to trigger with a 3-second countdown and cancel), fare locked reminder. No cancel (the API refuses with `ride_not_cancellable`; explain "Contact support from Safety").

**Trip done.** Purpose: close the loop. Primary action: Done. Content: fare charged, distance, time, receipt link, 1 to 5 rating of the driver with optional comment (skippable), "Report a problem with this ride" opening a ticket linked to it. Endpoints `POST /rides/{id}/rating`, `GET /rides/{id}/receipt`.

**Cancelled.** Purpose: explain what happened and what money did. Content by reason: you cancelled, driver unavailable (reassigned or not), no driver found, service issue, student no-show. Always say "You haven't been charged" or the exact refund.

**Wallet.** Purpose: know your money and top up. Primary action: Top up. Content: **available** large, with balance and reserved beneath ("GH₵6.00 held for your ride"), owed amount in red if any, recent transactions, "See all". Endpoints `GET /wallet`, `/wallet/transactions`.

**Top-up.** Purpose: add money fast. Primary action: Pay. Content: amount chips (GH₵10, 20, 50, 100, custom within min and max from settings), mobile money number (defaults to the account phone), network is auto-detected or chosen. After Pay: a **waiting screen** "Approve the payment on your phone" with a countdown, steps (dial prompt, enter PIN), Check status, and a way out. Results: succeeded (new balance), failed (reason, Try again), still pending after the wait ("We'll add the money when it arrives. You don't need to pay again", and a link to Activity). Poll `GET /wallet/topups/{id}`; on app resume refresh. Never double-charge: reuse the same idempotency key on retry and warn before starting a second top-up while one is pending.

**Transactions.** Filterable list (top-ups, rides, refunds, adjustments) with plain descriptions; holds and releases shown as "Held" and "Released", not as spend. Empty state: "No transactions yet."

**Activity (history).** List of past rides with date, route, fare, status; detail with map, timeline, receipt, rating given, and Report a problem. Empty: "Your rides will appear here."

**Safety.** Purpose: put help one tap away. Primary action: SOS. Content: SOS, Share my trip, trusted contacts (add up to 3 with name and phone, `POST /me/trusted-contacts`), campus security and emergency numbers (from config, tap to call), "How SOS works" in two sentences, Report a safety concern. SOS sends location and ride, shows "Help has been alerted" and who is watching, never a silent failure: if the call fails, offer to dial the emergency number immediately.

**Trip share.** Purpose: let a trusted person follow the ride. Content: choose contacts, preview, send; the link works without an account and expires when the ride ends. Endpoint `POST /rides/{id}/share`.

**Support.** New ticket (category, ride link, message, up to 5 attachments), my tickets, conversation view. Categories from the contract.

**Profile.** Name, phone, email optional, saved places, notification toggles for non-critical items only, **signed-in devices** (`GET /me/sessions`, sign out a device or "sign out everywhere else"), terms and privacy links, app version, sign out, **Delete my account** (explains: balance is handled by staff, ride records are anonymised, `POST /me/deletion-request`). Change phone number is a support request, not self-service.

## Push notifications

Register `POST /devices` with the FCM token on sign-in; remove on sign-out. Handle: verification decided, driver assigned, driver arrived, ride cancelled, quote or top-up result, quick message from driver, announcement, low-balance. Tapping opens the right screen. Critical ones (driver arrived, SOS acknowledgement) must also work from a cold start.

## Offline and failure behaviour

Wallet and history show cached data with "Last updated". Booking and top-up require a connection and say so before the person fills anything in. A request in flight that loses connection resolves to a definite answer: poll the ride or top-up by id before telling the person it failed. Never show a payment as failed unless the API says so.

## Platform notes

iOS: camera and location (When In Use) usage strings that state exactly why; Sign in needs no Apple login (phone only). Android: runtime permissions with a pre-permission explanation screen; predictive back. Both: dark mode, dynamic text up to 200%, haptic on driver arrival and on SOS arm, screen reader order on the PIN screen reads the digits individually.

## Screens to generate in a design tool (one state each)

Welcome · Phone · Code · Terms · Capture (Ghana Card front) · Verification pending · Home (no ride) · Home (active ride card) · Quote full · Quote short on funds · Quote ineligible (no drivers) · Searching · Driver assigned with PIN · Driver arrived · In trip · Trip done with rating · Cancelled (no driver found) · Wallet · Top-up waiting for approval · Top-up pending after timeout · Safety · SOS armed · Profile with devices.

## Done when

A test student can sign up, verify, top up, book, meet the driver with the PIN, complete a ride, rate it and see the receipt, entirely against the mock then staging; cancel at every stage and see correct money text; every screen has its four states; and the app handles update-required, maintenance and bookings-paused.
