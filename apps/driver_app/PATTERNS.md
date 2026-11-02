# Driver app: patterns and images to work on

Owner: Kevin. Same working rules as the student app: branch from `main`, one short branch per task, one plain commit per task, no attribution lines, `flutter analyze && flutter test` before every commit. Read `CLAUDE.md` and `prompts/05-driver-app.md` first.

Drivers use the app one-handed in a phone mount, in sun, sometimes in traffic. That changes what a good pattern is: bigger targets (80 pt buttons are in), fewer decisions per screen, sound and haptics for events, no text that needs reading while moving. Patterns from the reference (sections 1 to 10) are filtered with that in mind.

## 1. What you start with

| Piece | Where | Notes |
| --- | --- | --- |
| Big action | `TurboButton(driver: true)` is 80 pt | Used on duty, arrived, start, complete, accept, decline |
| PIN entry | `TripPin` plus `TurboKeypad` on the start screen | Wrong PIN clears and shakes nothing yet (pattern 3) |
| New assignment | Countdown ring, mono seconds, sound and haptic once (`TurboHaptics.warning`, `SystemSound.alert`) | `ride/ride_screen.dart`, `_Offer` |
| Records | `TurboSegmented` (Trips, Shifts, Hours, Salary) | `me/records_tabs.dart` |
| Navigation hand-off | Google Maps or Waze via `launchUrl` | In-app turn by turn is out of scope |
| Route line | `routePolyline` on the driver ride, drawn on the trip map | Approach leg (driver to pickup) is not provided by the API yet |
| Components, haptics, motion, 3D icons, photos | Same as the student file | `driver-welcome.jpg` is used on the welcome screen |
| Not in the project yet | swipe actions, tweening, keep-awake, local notifications, Live Activity, biometrics, privacy screen, widgets | Listed below |

## 2. Patterns to build, in order

| # | Pattern | Where | How | Effort |
| --- | --- | --- | --- | --- |
| 1 | **Haptic grammar for events** (ref 4) | Accept (medium), arrived (light), PIN correct (success), trip complete (heavy once), PIN wrong (error), offline (warning) | Put it in the screens that own the event; one haptic per action; check the system setting | S |
| 2 | **Sound plan** | New assignment (exists), assignment about to expire (10 s), PIN accepted | `SystemSound` or a short bundled sound; respect silent mode; never loop | S |
| 3 | **PIN feedback** | PIN entry | Shake the boxes on a wrong PIN (spring, 200 ms, none with Reduce Motion), clear, keep the keypad focus; a locked state with who to call | S |
| 4 | **Keep the screen awake** | Go to pickup, at pickup, trip | `wakelock_plus` while a ride is active and the app is in front; release on done | S |
| 5 | **Pre-permission priming for "Always" location** (ref 9.4) | Home off duty, readiness | Explain why "Always" is needed in a sheet with the three-step guide before opening Settings; the readiness list already tracks the result | M |
| 6 | **Foreground service and ongoing notification** (ref 5.3, Android) | On duty | Shows "On duty, sharing your location" with a Stop action; needed on Android for reliable GPS; iOS uses the location indicator. Android is parked, so design now, build later | L |
| 7 | **Readiness as bento with status tags** (ref 7.2) | Home off duty | Documents, Battery, Location, Notifications, Internet as tiles with one tag each; one headline "Ready to go" or the single blocker | M |
| 8 | **Skeletons and empty states that teach** (ref 7.5, 7.6) | Trips, Shifts, Hours, Salary, Help | One sentence what the screen is, one image, no table of nulls | S |
| 9 | **Sticky headers** (ref 7.3) | Hours (week total), Salary (year) | Aggregate stays pinned while the list scrolls | S |
| 10 | **Swipe actions** (ref 2.4) | Not for ride actions (never swipe to complete a trip). Only for support tickets and devices on Me | `Dismissible` with undo; skip if no real need | S |
| 11 | **Staggered entrance** (ref 3.2) | Records lists | 30 ms offsets, none with Reduce Motion | S |
| 12 | **Local notifications for reminders** (ref 5.2) | "Shift starts in 30 minutes", "Insurance expires in 14 days" | Needs the shift and document dates from the API (CR-5); until then server push only | M |
| 13 | **Biometric lock** (ref 6.1) | Optional on app open | `local_auth` with passcode fallback; low priority because drivers share phones rarely | L |
| 14 | **Privacy screen** (ref 6.3) | Not needed: the driver app shows first names only | Skip | - |
| 15 | **Widgets and Live Activity** (ref 5.1, 5.3) | On-duty state, current ride ETA | Native code; only after patterns 1 to 7 are in a build | L |

Rejected: streaks and score mechanics (drivers are salaried, no earnings pressure is a product rule), confetti, swipe to confirm an irreversible ride step.

## 3. Screen by screen

| Screen | File | Patterns | Images and slots |
| --- | --- | --- | --- |
| D01 Welcome | `auth/welcome_screen.dart` | 1 | Photo have: `driver-welcome.jpg` (taxi driver). Board also has a "Turbo Driver" badge over the photo |
| D01 Phone, code, terms | `auth/phone_screen.dart`, `code_screen.dart`, `terms_screen.dart` | 1, 5 | 3D phone, key have. Error banner for "number not registered" with a Call supervisor button: number comes from CR-6 |
| System screens | `gate/gate_screens.dart` | - | 3D warning, phone, wrench, padlock have |
| D02 Home, off duty, ready or blocked | `home/home_screen.dart` | 5, 7 | 3D have: automobile (vehicle tile), calendar (shift), bell (notifications), round pushpin (location), identification card (documents), battery needs a Material icon. Plate in mono (have). Vehicle photo comes from the API when the vehicle has one: **need** `photoUrl` on `Vehicle` or use `car-side.png` from the kit |
| D03 Home, on duty and waiting | same | 1, 2, 6 | **need:** the map with the driver dot and a status sheet ("Online", "GPS stalled"); the map needs the dark style JSON |
| D04 New assignment | `ride/ride_screen.dart` `_Offer` | 1, 2 | Ring and mono seconds have. Details as 4 tiles (To pickup, Trip, Student, Student pays) are still one card: rebuild with `BentoTile`. 3D for decline reasons (wrench car problem, hourglass unwell...) have |
| D04 Decline reasons | `_decline` sheet | 1 | 2x2 tiles with 3D icons: Car problem (wrench), Too far (motorway), I'm unwell (hourglass), Other (speech balloon) |
| D05 Go to pickup | `_ToPickup` | 4, 1 | Map with the driver and the pickup; approach road is **not available** (needs `driverToPickupPolyline` in the contract). Navigate button has |
| D06 At pickup, waiting | `_AtPickup` | 1, 2, 4 | Quick-message chips have; "Student not here" timer ring |
| D07 Enter PIN | `_AtPickup` PIN branch | 3, 1 | `TripPin` and `TurboKeypad` have |
| D08 Trip in progress | `_Trip` | 1, 4 | Route line has; navigate button has |
| D09 Trip complete, cancelled, passed to another | `_End` | 1 (heavy once) | 3D tick, taxi, hourglass have. Board uses an hourglass for "Ride passed to another driver" |
| D10 Trips, trip detail | `me/trips_screen.dart` | 6, 8, 11 | Row thumbnails: **need** (kit `car-side.png` small). Trip detail: map with the route (have the line), timeline of events (Accepted, Arrived, PIN accepted, Completed) as rows with ticks |
| D10 Shifts, Hours | `me/record_screens.dart` | 8, 9 | Today's shift as a lime card with a 3D calendar (have). Hours shows scheduled against clocked-in; "Corrected by staff" tag |
| D10 Salary | same | 8, 9 | Records only, no earnings pressure; 3D money bag (have) in the info banner. Amounts in mono |
| D11 Help and SOS | `support/help_screen.dart`, `safety/sos.dart` | 1, 2 | SOS red tile with shield have (uses the separate SOS red); Call supervisor and Campus security tiles with 3D telephone receiver and school (have); report topic chips (Vehicle, Student, App) |
| D12 Me | `me/me_screen.dart` | 8, 10 | Documents tiles (Driving licence, Roadworthy, Insurance) with a status tag: **blocked** until the profile returns documents and expiry (CR-5). 3D identification card (have) |

## 4. Assets still missing, in one list

1. Vehicle image: the API has none; use the kit's side-on car for now.
2. Dark map style JSON (D03, D05, D08 and trip detail).
3. `driverToPickupPolyline` or an equivalent so D05 can draw the approach road (contract change, ask Kevin; the route-line request CR-9 notes it).
4. Supervisor and campus security numbers (CR-6) for the "Call supervisor" buttons.
5. Documents and expiry on the driver profile (CR-5) for D02 readiness and D12.
6. A sound file for the assignment alert if the system alert is not loud enough in the mount; short, under 2 s.
7. Optionally a second driver photo for variety (Pexels, same process: shortlist first, no downloads until approved).

Image specs are the same as for the student app: transparent PNG for 3D or renders, JPG photos, 1200 px wide, under 400 KB, credit in `packages/turbo_ui/assets/photos/CREDITS.md`.

## 5. Pattern registry (copy into your PR descriptions)

```
P-D1 Event haptics
Job:       confirm a driver action without looking away from the road
Mechanism: TurboHaptics per event, once per action
A11y:      honours system haptic setting
Status:    Partly built (assignment only)

P-D3 PIN shake
Job:       say "wrong PIN" without reading
Mechanism: spring shake on the boxes, error haptic, boxes clear
A11y:      error text stays; no shake with Reduce Motion
Status:    To do

P-D6 Foreground service
Status:    Parked with Android
```

## 6. Dependencies

- CR-5 (document expiry, time on duty), CR-6 (supervisor and security numbers), and a new request for `driverToPickupPolyline` block D02, D05 and D12 completeness.
- Android is parked, so the foreground service (pattern 6) is design only for now.
- Test patterns 4 and 6 on a real phone in a car mount; the simulator cannot show GPS or screen-awake behaviour.
- TestFlight builds take about 15 minutes and 3 GB of disk each: batch several patterns per build.
