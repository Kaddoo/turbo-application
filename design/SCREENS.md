# Turbo apps: what goes on each screen

For the designer. One entry per screen: what it is for, the single main action, what must be on it, what data it shows, and the states to design. Content and copy come from `prompts/04-student-mobile-app.md` and `prompts/05-driver-app.md`; this is the same material arranged for design.

**Status** says what exists in the app today: **built** (working against the mock, current look is a plain first pass), **next** (planned, not built), or **later**.

## Rules that apply to every screen

- **Brand (interim):** black and neon. Dark mode is the main design; light follows the phone setting. Neon `#C6FF00` is the only accent. It is only ever a fill with black text on it, or text and icons on dark. On white, a neon button gets a 1.5 px black edge and neon is never used as text. **One neon element per screen**: the main action.
- **Everything is swappable.** Colours, type, radius, logo, product name all come from one brand file. Do not design with fixed values that only make sense for black and neon; design with the roles: background, surface, surfaceRaised, border, controlBorder, textPrimary, textSecondary, accent, onAccent, accentText, focusRing, success, warning, danger.
- **Four states per screen:** loading (skeleton, not a spinner), empty (says what goes here, offers one action), error (what happened, how to retry), and the full state. Design all four.
- **Accessibility:** text scales to 200% without clipping, tap targets at least 44 pt (56 pt for driver primary actions), 4.5:1 contrast for text and 3:1 for control edges, status is never colour alone (always icon plus word), respects reduced motion.
- **Copy:** plain English, short, no exclamation marks, no emoji. Amounts are cedis, shown `GH₵35.00`. Phone numbers `+233 24 123 4567`. Times in Ghana time.
- **Poor network:** light screens, no auto-play media, last known data shown with a "last updated" note.
- **Not allowed to invent:** a logo (we use the word "Turbo" as a placeholder), new icon sets (one outline set), emoji.

## Parts that already exist (reuse these)

| Part | Use |
| --- | --- |
| Primary, secondary, destructive button | One primary per screen. Large (56 pt) variant for glanceable screens |
| Text field | Label above, helper text and inline error below |
| Code field | Six boxes, paste and auto-advance |
| Money text | Always integer pesewas formatted at display |
| Status chip | Icon + word, tones: neutral, success, warning, danger |
| Card | Surface with a border, no shadow; can be tappable |
| List row | Title, optional subtitle, leading icon, trailing item |
| Bottom sheet, toast (with Undo), confirm dialog (with type-to-confirm for the irreversible) | |
| Skeleton, empty state, error state | |
| Map frame | Rounded frame holding the map, optional overlay card |
| Timeline | Vertical steps: done, current, upcoming |
| Wordmark | The text "Turbo" for now |

---

# Student app

## Before sign-in and system screens

### S01 Loading (start-up)
- **Status:** built. **Purpose:** shown while the app checks the server and restores the session. **Main action:** none.
- Wordmark centred, skeleton lines. Under 1 second normally.

### S02 Update required
- **Status:** built. **Purpose:** block an app version that is too old. **Main action:** go to the store (to be added when store links exist).
- Icon, title "Please update the app", one sentence naming the product, the store button. Cannot be dismissed.

### S03 Maintenance
- **Status:** built. **Main action:** Check again.
- Icon, title, the message the server sends (or a default), Check again button.

### S04 Couldn't start (offline on start)
- **Status:** built. **Main action:** Try again.
- Error state: what happened in one sentence, retry.

### S05 Account suspended
- **Status:** built (bare). **Main action:** Contact support (to add with Support).
- Title, one sentence, support contact.

## Sign-in

### S06 Welcome
- **Status:** built. **Main action:** Continue.
- Wordmark, tagline "Campus rides, paid from your wallet", "For Central University students at Miotso". The only screen where the brand can breathe: room for an illustration or photo later.
- States: offline message strip.

### S07 Phone number
- **Status:** built. **Main action:** Send code.
- Title, phone field with fixed `+233` prefix, helper "We'll text you a 6-digit code", Send code.
- States: inline error (short number, rate limited with the wait time, "We can't send codes right now").

### S08 Enter code
- **Status:** built. **Main action:** Verify.
- Title, "We sent a 6-digit code to +233 24 123 4567", six-box code field, Verify, resend button with countdown ("Send a new code in 24 s"), "Wrong number?" link.
- States: wrong code (boxes clear, message), expired, locked, loading on Verify.

### S09 Terms
- **Status:** built. **Main action:** I agree (pinned to the bottom).
- Title "Before you start", two short bullets (what Turbo is, what is kept), two cards: **why we need your location**, **why we need your camera**, links to full terms and privacy.
- States: loading, could not load (retry), agreeing.

## Verification (once per student)

### S10 Verification form
- **Status:** built (photo capture is parked, see the note below). **Main action:** Submit (pinned).
- Title "Confirm you're a student", intro, privacy note card ("Only our verification team sees these. They are deleted after review."), fields: full name as on the Ghana Card, Ghana Card number (shown as `GHA-123456789-0`, formats as you type), student ID number, "We keep what you've typed if you close the app", then four photo tiles: Ghana Card front, Ghana Card back, Student ID, Selfie holding the Ghana Card.
- Photo tile: thumbnail, name, a status chip (Not taken yet, Sending 40%, Sent, Didn't send), one button (Take photo, Retake, Try sending again), a progress bar while sending.
- States: each tile has four of its own; Submit is off until everything is sent; duplicate Ghana Card message.

### S11 Camera capture
- **Status:** built. **Main action:** Take photo, then Use this photo.
- Full-screen camera, a guide window (card-shaped; oval for the selfie) with the rest dimmed, one-line instruction under it, shutter button, close button.
- After the shot: the photo large, a quality note (looks clear, or blurry/glare/too dark with a plain fix), Retake and Use this photo (the order swaps when there is a problem).
- States: camera permission denied (explain, Open Settings), camera failed to start, starting.

### S12 Verification status
- **Status:** built. Four versions of one screen. Pull down to check again.
  - **Pending:** big icon, "We're checking your documents", "This usually takes a day. We'll text you."
  - **Needs attention:** warning icon, "We need a little more", the reviewer's message, button **Send again** (opens the form with the typed details kept).
  - **Rejected:** icon, "We couldn't confirm you", the reason, "Contact support if you think this is a mistake."
  - **Approved:** a quiet check mark, "You're verified", button **Continue**. No celebration.

## Ride

### S13 Home
- **Status:** built (first pass). **Main action:** the "Where to?" bar.
- Map filling the screen with official pickup points and the student's position; top: wordmark and a wallet chip (neutral, or warning with the word "low" when the wallet cannot cover the cheapest fare); bottom panel: location notice if needed, paused-bookings message if needed, the Where to? bar, chips for saved places (Home, Hostel).
- **Next on this screen:** active-ride card at the top when a ride is active (driver, plate, status, tap to open), announcements banner, Safety button, "add a place" chip.
- States: loading (skeleton), error (retry), offline strip ("You're offline. The map and prices may be out of date."), location off (explain, Allow location / Open Settings, or choose a pickup point from the list), bookings paused (bar disabled, message), no pickup points yet.

### S14 Destination and pickup
- **Status:** built. **Main action:** Continue (pinned).
- Pickup card (defaults to the nearest official point with its landmark, tap to expand the list of points), drop-off: search field (when search is available) with results, or the chosen place; Saved places list.
- States: searching, no results, search failed, no saved places yet.

### S15 Quote
- **Status:** built. **Main action:** Book for GH₵35.00 (off until booking is built).
- Route line ("9.4 km · about 13 min"), pickup ETA, **the fare in very large type**, "Fixed. It won't change.", a card with wallet balance and balance after the ride, "Cancel for free until you're in the car."
- **Short on funds:** a warning line with the exact shortfall and one button **Top up GH₵15.00** replacing Book.
- **Not available:** title "We can't book this trip", every reason as a card, button **Change location**.
- States: getting your price (skeleton), error with retry and the wait time on rate limits, a quiet note when the price was renewed.

### S16 Searching for a driver
- **Status:** next. **Main action:** Cancel ride.
- Map with a gentle pulse (still when reduced motion), "Finding your driver", time elapsed, "Your fare is held."
- End state: "We couldn't find a driver. You haven't been charged." with Try again.

### S17 Driver assigned
- **Status:** next. **Main action:** none (Cancel is secondary).
- **Start PIN in very large type** with "Tell this to your driver when you're in the car. Never share it earlier.", driver first name and photo, car model and colour, **plate in large type**, pickup point name and landmark, the driver moving on the map with ETA, a row of quick messages (I'm here, Running late, At the gate, Please come out), Share trip, Safety.
- Variants: **driver has arrived** (clear message, one haptic), **driver location delayed** (calm note), cancel reasons sheet.

### S18 In trip
- **Status:** next. **Main action:** Safety.
- Route and live position, ETA, driver and plate, Share trip, SOS (hold to trigger), "fare locked" reminder. No cancel; explain "Contact support from Safety".

### S19 Trip done
- **Status:** next. **Main action:** Done.
- Fare charged, distance, time, receipt link, 1 to 5 star rating of the driver with optional comment (skippable), "Report a problem with this ride".

### S20 Cancelled
- **Status:** next. One screen, five wordings: you cancelled, driver unavailable, no driver found, service issue, you weren't there. Always says "You haven't been charged" or the exact refund.

## Money

### S21 Wallet
- **Status:** next. **Main action:** Top up.
- **Available** in large type, balance and "held for your ride" beneath, the amount owed in danger colour if any, recent transactions, See all.
- States: loading, empty ("No transactions yet."), error, owing.

### S22 Top up
- **Status:** next. **Main action:** Pay.
- Amount chips (GH₵10, 20, 50, 100, custom within limits), mobile money number (defaults to the account phone), network chooser if not detected, warning before starting a second top-up while one is pending.

### S23 Waiting for approval
- **Status:** next. **Main action:** Check status.
- "Approve the payment on your phone", a countdown, the steps (dial prompt, enter PIN), a way out.
- Results: success (new balance), failed (reason, Try again), still pending ("We'll add the money when it arrives. You don't need to pay again").

### S24 Transactions
- **Status:** next. Filterable list (top-ups, rides, refunds, adjustments); holds and releases read "Held" and "Released", not spend. Empty: "No transactions yet."

## History, safety, support, profile

### S25 Activity (ride history) and ride detail
- **Status:** next. List: date, route, fare, status. Detail: map, timeline, receipt, rating given, Report a problem. Empty: "Your rides will appear here."

### S26 Safety
- **Status:** next. **Main action:** SOS.
- SOS, Share my trip, trusted contacts (up to 3, name and phone), campus security and emergency numbers (tap to call), "How SOS works" in two sentences, Report a safety concern.

### S27 SOS armed
- **Status:** next. Hold-to-trigger with a 3-second countdown and cancel; after sending "Help has been alerted" and who is watching; if sending fails, offer to dial the emergency number at once.

### S28 Share trip
- **Status:** next. Choose contacts, preview, send. The link works without an account and ends with the ride.

### S29 Support
- **Status:** next. New ticket (category, ride link, message, up to 5 attachments), my tickets, conversation view.

### S30 Profile
- **Status:** next. Name, phone, optional email, saved places, notification toggles (non-critical only), signed-in devices with "sign out everywhere else", terms and privacy links, app version, sign out, **Delete my account** (explains what happens first).

---

# Driver app

Everything must work one-handed, in sunlight, on a phone in a mount. One primary button per screen, very large type for the next action, 56 pt tap targets, nothing to read while driving. No student phone numbers anywhere. No earnings pressure (drivers are salaried). Plain, respectful language.

### D01 Welcome, phone, code
- **Status:** next. As the student screens, with the extra message "This number isn't registered as a driver. Contact your supervisor."

### D02 Home, off duty
- **Status:** next (a developer test screen exists). **Main action:** Go on duty (huge, at the bottom).
- Greeting, assigned vehicle (model, plate), today's shift, a **readiness checklist** (location "Always", battery above 20% or charging, internet, notifications on, documents valid) with failures in danger colour plus an icon and a fix button.
- Variant: **expired document** ("Your insurance expired on 12 Oct. Contact your supervisor.") with the button off.

### D03 Home, on duty and waiting
- **Status:** next. **Main action:** Go off duty (secondary, behind a confirm).
- Map with own position, "On duty. Waiting for a ride", time on shift, connection and GPS indicators, a red banner "Your location isn't being shared. Open the app." when sharing stalls, a red banner when offline.

### D04 New assignment
- **Status:** next. **Main action:** Accept.
- Full-screen takeover with sound and vibration, a **45-second countdown ring**, pickup name and landmark, distance and ETA to pickup, the fare the student pays, student first name, trip distance, Decline (secondary, with a reason: car problem, too far, unwell, other). If time runs out: "Ride passed to another driver" with no blame.

### D05 Go to pickup
- **Status:** next. **Main action:** I've arrived.
- Map and route, a big **Navigate** button (opens Google Maps or Waze), pickup name and landmark, student first name, quick messages (Running late, I'm here, At the gate, I can't find you), SOS. If far from the pickup, asks to confirm.

### D06 At pickup, waiting
- **Status:** next. **Main action:** Start trip (enter PIN).
- Waiting timer, student first name, plate and landmark reminder, quick messages. After the wait, a **Student not here** button appears; it confirms, then explains the student isn't charged and no fee applies.

### D07 Enter PIN
- **Status:** next. **Main action:** Start.
- Four-digit keypad with large keys, "Ask the student for their PIN. Never accept it by message." Wrong PIN shows attempts left.
- Variant **locked:** "Too many tries. Call your supervisor." with a call button.

### D08 Trip in progress
- **Status:** next. **Main action:** none until the end; Complete trip is shown and asks for confirmation at the destination.
- Map and route, big Navigate button, drop-off label, elapsed time, SOS always visible, Report a problem.
- Variant **waiting for signal:** "Waiting for signal to finish your trip" so the driver is never stuck.

### D09 Trip complete / Cancelled
- **Status:** next. **Main action:** Back to waiting.
- Complete: "Trip complete", distance and time, fare not emphasised. Cancelled: who cancelled and what to do ("Return to your waiting position").

### D10 Trips, Shifts, Attendance, Salary history
- **Status:** next. Read-only lists. Trips: date, route, status, detail with map and timeline. Shifts: upcoming and past (empty: "No shifts scheduled. Your supervisor sets these."). Attendance: scheduled, clocked in and out, minutes worked, a note if staff corrected it, "Think something is wrong?". Salary: date, period, amount, reference, with "This is a record. Payment is made by your employer outside the app."

### D11 Help and SOS
- **Status:** next. Report an issue (vehicle, student behaviour, app problem, safety, other), my tickets, supervisor and campus security numbers (tap to call). SOS as the student app, always one tap away on ride screens.

### D12 Me
- **Status:** next. Profile (name, vehicle), documents with expiry (valid, expiring within 30 days in warning, expired in danger, each with an icon and a word), signed-in devices, terms and privacy, version, sign out. No delete option for drivers.

---

## Note on the Ghana Card photos

The photo capture screens (S10, S11) are working but parked. They will be revisited against the real backend, which stores the files and controls how they are sent. Design them as specified above; the behaviour may change, the layout should not.
