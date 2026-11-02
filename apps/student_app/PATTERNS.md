# Student app: patterns and images to work on

Owner: Bethel. Branch from `main`, one short branch per task, one plain commit per task, no attribution lines, never merge (Kevin merges). `flutter analyze && flutter test` must pass before each commit. Read `CLAUDE.md` and `apps/student_app/README.md` first.

Sources: the mobile-native patterns reference Kevin shared (sections 1 to 10), the design kit in `design/Turbo-component-kit`, and what is already in the repo. Where this file says "have", it is in `main` today.

## 1. What you start with

| Piece | Where | Notes |
| --- | --- | --- |
| Haptics | `TurboHaptics` (`selection`, `success`, `warning`, `error`) in `packages/turbo_ui/lib/src/haptics` | Used only by SOS and the ride screen today |
| Motion tokens | `TurboMotion` (fast 150, medium 250, slow 400 ms; `reduced(context)`) | Always go through `TurboMotion.duration` so Reduce Motion works |
| Components | `packages/turbo_ui`: buttons, chips, `TurboSegmented`, `TurboBanner`, `BentoTile`, `TripPin`, `TurboKeypad`, `SlideToContinue`, `PhotoCard`, `HeroIcon`, `SystemMessage`, `AuthLayout`, `TurboSheet`, `FloatingNavBar` | Do not add colour, size or text literals in screens; a test fails the build |
| 3D icons | `TurboArt` (28 PNGs, `HeroIcon(art:)`, `TurboArtImage`) | Licence note in `packages/turbo_ui/assets/icons3d/README.md` |
| Photos | `packages/turbo_ui/assets/photos` (8, credited in `CREDITS.md`) via `PhotoCard(asset:)` | Stock models, never presented as real people |
| Route line | `routePolyline` on quote and ride, drawn by the map views | Live on staging since contract 0.4.0 |
| Not in the project yet | swipe actions, number tweening, local notifications, biometrics, privacy screen, share sheet, home-screen widget | Listed below |

## 2. Patterns to build, in order

Effort: S under half a day, M about a day, L several days or needs native code. "Test" means a widget test in the same commit.

| # | Pattern | Where it applies | How | Effort |
| --- | --- | --- | --- | --- |
| 1 | **Haptic grammar** (ref 4) | Slide to continue and quote Book (medium), chip and segment taps (selection), top-up success (light), ride completed (heavy, once), PIN copy | Call `TurboHaptics` from the components, not from screens, so every screen gets it. Never on scroll, once per action | S |
| 2 | **Number tweening** (ref 3.3, 7.4) | Wallet balance, quote fare, "wallet after" line, activity totals | `TweenAnimationBuilder<double>` over pesewas, formatted with `formatPesewas`, in the mono style. Zero duration when Reduce Motion | S |
| 3 | **Swipe actions with undo** (ref 2.4) | Trusted contacts and saved places (Profile, Safety): swipe to remove | `Dismissible`, then an undo snackbar for 5 s; delete on the server only after the undo window. No confirm dialog | M |
| 4 | **Keyboard accessory** (ref 2.1, 2.2) | Top-up amount, phone, Ghana Card, student ID | Right `keyboardType` for each; quick amounts (`+GH₵10`, `+20`, `+50`) above the keyboard for top-up; Next/Done | M |
| 5 | **Privacy screen** (ref 6.3) | Whole app (wallet, trip, PIN) | Blur overlay on `AppLifecycleState.inactive`; `FLAG_SECURE` on Android when that is unparked | S |
| 6 | **Staggered list entrance** (ref 3.2) | Activity, transactions, support tickets | 30 ms offsets, fade and 12 px slide; skip when Reduce Motion | S |
| 7 | **Shared-element transition** (ref 3.1) | Activity row to ride detail; saved place chip to quote | `Hero` or `OpenContainer`; keep under 250 ms | M |
| 8 | **Skeletons** (ref 7.6) | Replace spinners that remain; `LoadingState` is already rows, check every screen has a content-shaped one | `skeletonizer` or the existing `TurboSkeleton` | S |
| 9 | **Pre-permission priming** (ref 9.4) | Location (home), camera (verification), notifications | Own sheet first ("We use your location to find the nearest pickup point"), system dialog only after Yes. Copy goes in the ARB | M |
| 10 | **Empty states that teach** (ref 7.5) | Activity, saved places, transactions, support | One line what it is for, one `HeroIcon(art:)`, one action | S |
| 11 | **Share sheet with an image card** (ref 5.5) | Share trip, receipt | `share_plus` with the server link as text plus a rendered card (`RepaintBoundary`) | M |
| 12 | **Local notifications with a number** (ref 5.2) | Low wallet before booking; verification result | Push already exists (Firebase). Add only if a server push cannot do it; copy must carry a number or a decision | M |
| 13 | **Biometric re-lock** (ref 6.1, 6.4) | Wallet and top-up after 60 s in background | `local_auth` with a device-passcode fallback; gate, not encryption | L |
| 14 | **Home-screen widget** (ref 5.1) | Wallet balance, active ride status | `home_widget` plus native WidgetKit code; needs a build per try | L |
| 15 | **Live Activity** (ref 5.3) | Ride in progress (driver ETA, PIN) | Native; only after the server can push updates | L |

Rejected for now, with the reason, so nobody redoes the discussion: streak and milestone mechanics (ref 10, the product is calm and transactional), Siri shortcuts (low value until there is a stable "book again" route).

Every pattern must pass four checks (ref Method C): serves a named job, survives Reduce Motion / largest text / screen reader, fits the brand, one developer can keep it working. Record the result in `docs/PATTERNS.md` style entries (section 5 here) in your PR description.

## 3. Screen by screen

State: **built** means the redesign is in `main`; **partial** means some parts need assets or data. Images: **have** = in the repo, **kit** = in `design/Turbo-component-kit` but not yet bundled, **need** = not available yet.

### Start and sign-in

| Screen | File | Patterns | Images and slots |
| --- | --- | --- | --- |
| S01 Start, S02-S05 system | `gate/gate_screens.dart`, `turbo_ui` `SystemMessage` | 1 (success haptic on retry that works), 10 | 3D icons have: warning, phone, wrench, padlock. No more needed |
| S06 Welcome | `auth/welcome_screen.dart` | 1 (slide), 8 | **need:** the lime card shows a drawn car icon; the board has a side-on car render. Kit has `images/car-side.png` and `car-side-r.png` (transparent, 3:2). Bundle one into `turbo_ui/assets/photos` and use it in the card; keep the "Fixed fares" tag |
| S07 Phone | `auth/phone_screen.dart` | 4 (phone keyboard, "+233" shown always, not only on focus) | 3D phone have |
| S08 Code | `auth/code_screen.dart` | 1 (success on verify), 4 (one-time-code autofill, 6 boxes in mono) | 3D key have |
| S09 Terms | `auth/terms_screen.dart` | 9 (explain location and camera before the system asks) | **need:** the board has a padlock with a shield and a tick; today one shield. Optional: combine two `TurboArt` images side by side |

### Verification (once per student)

| Screen | File | Patterns | Images |
| --- | --- | --- | --- |
| S10 Checklist, details, upload tiles | `verification/verification_capture_screen.dart` | 4 (Ghana Card format `GHA-123456789-0`, student ID), 9, 8 | **need:** tile art for Details, Ghana Card, Student ID, Selfie. 3D have: identification card, graduation cap, camera, busts in silhouette. Map them to the four rows |
| S11 Camera and review | `verification/photo_capturer.dart` | 1 (shutter), 9 (camera priming) | **kit:** `images/facemesh.svg` (selfie guide overlay). **need:** a card frame guide (draw in code, no image). Sample "looks clear" and "too dark and blurry" photos are mock only; do not ship real faces |
| S12 Status (pending, needs attention, rejected, approved) | `verification/verification_status_screen.dart` | 1 (light on approved), 6 (timeline rows) | 3D have: hourglass, warning, ID card, tick. Approved uses `PhotoCard(student-campus.jpg)`; the board's hero is a portrait with a "Verified" tag over it. Pexels `welcome-accra.jpg` is a candidate; confirm with Kevin |

### Home, booking and the ride

| Screen | File | Patterns | Images |
| --- | --- | --- | --- |
| S13 Home | `home/home_screen.dart` | 2 (wallet tile), 5, 9 (location), 10, 6 | 3D have: money bag, shield. **need:** "Last ride" tile (taxi render, kit `car-side.png`), "Ride hours" tile (3D alarm clock have), "Nearest point" tile (round pushpin have). Aerial `campus-aerial.jpg` could head the screen; decide with Kevin. The booking panel tabs "Nearest point / Choose point" and the swap button are not built |
| S14 Destination | `home/destination_screen.dart` | 4, 6, 8, 10 | 3D motorway (no results) have. **need:** map behind the pickup-point list (needs the dark map style JSON from the designer) and "Results / Saved / Recent" tabs |
| S15 Quote | `home/quote_screen.dart` | 2 (fare and shortfall roll), 1 (book), 5 | **need:** map with the route line behind the sheet (`routePolyline` is ready), taxi 3D (have: oncoming taxi), money bag and warning for the Wallet / Short-by tiles |
| S16 Searching | `ride/ride_screen.dart` (`_Searching`) | 2 (timer is mono), 1 | **need:** pulsing ring on the map; no image |
| S16 No driver found | same, cancelled branch | 10 | 3D taxi have |
| S17 Assigned, arrived, cancel reasons | `_Assigned`, `_confirmCancel` | 1 (arrived: success), 3-style undo is not wanted here, 7 | PIN is `TripPin` have. Driver avatar: **need** real `photoUrl` from the API (works) and a fallback avatar (initial, have) |
| S18 Trip status | `_InTrip` | 2 (fare locked), 1 | Photo card have (`trip-status-trotro.jpg`). Alternative `trip-status-intersection.jpg` |
| S19 Done and rating | `_Done` | 1 (heavy once), 2 | **need:** green tick 3D (have: check mark button) in place of the icon; stars stay as icons |
| S20 Cancelled, no longer available | `_Cancelled` | 10 | 3D taxi have |

### Wallet

| Screen | File | Patterns | Images |
| --- | --- | --- | --- |
| S21 Wallet (and owing) | `wallet/wallet_screen.dart` | 2, 6, 8, 13 later | Lime card is code only. **need:** Balance and Held bento tiles on the card; 3D money bag and padlock (have) |
| S22 Top-up, network chooser | `wallet/topup_screen.dart` | 4 (quick amounts), 1, 9 | **need:** the "Pay with" sheet with network logos (MTN MoMo, Telecel Cash, AT Money). Logos are trademarks: get Kevin's OK and the brand files; do not use Pexels. 3D phone have |
| S23 Waiting, success, failed, still pending | `wallet/topup_waiting_screen.dart` | 1 (success), 2 (new balance) | 3D have: phone, tick, warning, hourglass; board success uses credit card plus tick (combine two `TurboArt`) |
| S24 Transactions | `wallet/transactions_screen.dart` | 6, 8, 10 | **need:** filter chips (All, Top-ups, Rides, Refunds); no image. Row icons are Material; optional 3D coin and credit card at 24 px |

### Activity, safety, support, profile

| Screen | File | Patterns | Images |
| --- | --- | --- | --- |
| S25 Activity | `activity/activity_screen.dart` | 6, 7, 10 | Filter chips built. **need:** car thumbnail on each row (kit `car-side.png`, small) |
| S25 Ride detail and receipt | `ride/ride_screen.dart` (`ReceiptScreen`) | 7, 11 | **need:** photo card of the trip (kit `trip-busstop.jpg` is Nigerian; use Pexels `bus-stop.jpg` or `busy-street-accra.jpg`) and map thumbnail with the route |
| S26 Safety | `safety/safety_screen.dart` | 1, 3, 10 | 3D shield, speech balloon, telephone receiver (have) for tiles. Trusted contacts tile has avatars (initials, have) |
| S27 SOS armed and sent | `safety/sos.dart` | 1 (heavy on send), 5 | **need:** countdown ring (draw in code), shield 3D (have) for "Help has been alerted". SOS always uses the separate red |
| S28 Share trip | `safety/share_screen.dart` | 11 | **need:** preview card using `PhotoCard` with the route text, contacts as avatar chips |
| Support list, new ticket, thread | `support/support_screens.dart` | 4, 6, 10 | 3D speech balloon, telephone receiver (have). New-ticket form restyle not done |
| Profile | `profile/profile_screen.dart` | 3 (saved places and devices), 5, 13 later | Avatar from initials; **need:** real photo is not collected, keep initials. Notification toggles wait for CR-3 |

## 4. Assets still missing, in one list

1. Side-on car render (`car-side.png` in the kit) bundled for the Welcome card and the "last ride" tile.
2. Dark map style JSON from the designer (also needed for S14, S15, S16-S18 and for the route line to look right at night).
3. Network logos for the Pay-with sheet (Kevin to supply or approve).
4. A signed-off licence source for the 3D icons (see the README in `assets/icons3d`).
5. Campus isometric map art (decision with Kevin: draw it, buy it, or leave the real map).
6. A decision on whether the welcome screen uses a photo (Pexels `welcome-accra.jpg`) instead of the car.

Image specs when you add one: PNG with transparency for 3D and renders, JPG for photos, 1200 px wide, under 400 KB, dark and light safe (no baked-in white). Put the file in `packages/turbo_ui/assets/photos`, add its credit to `CREDITS.md`, and reference it only through a component.

## 5. Pattern registry (copy into your PR descriptions)

```
P-01 Haptic grammar
Job:       confirm actions without looking
Mechanism: TurboHaptics from components; selection, light, medium, heavy once
A11y:      honours system haptic setting; always paired with a visual change
Status:    Trialling (SOS and ride only)

P-02 Number tweening
Job:       show that money changed
Mechanism: TweenAnimationBuilder over pesewas, mono figures
A11y:      zero duration with Reduce Motion; Semantics label holds the final value
Status:    To do

P-13 Biometric re-lock
Status:    Parked: needs a decision on the lock timeout and a passcode fallback
```

## 6. Dependencies to ask Kevin about

- CR-3 (campus security number, announcements, notification settings) blocks the notification toggles and the home announcement banner.
- CR-5, CR-6 are driver-side but share the support numbers.
- Android is parked; do not spend time on Android-only patterns yet.
- TestFlight builds take about 15 minutes and 3 GB of disk each: batch several patterns per build.
