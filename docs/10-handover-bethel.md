# Handover to Bethel: apps and what is open

From Kevin and Claude, 2026-11-01. Kevin and Claude are moving to devops, the API, the admin dashboard and the landing page. The two mobile apps are yours from here, plus the student web build if you choose to take it on. Everything below is a starting point; the order is your call.

## Where things stand

`main` now holds everything:

| Part | Where | State |
| --- | --- | --- |
| Contract | `api/contract/openapi.yaml` (and `api/openapi.yaml`) | Planning owns it. Read only. Gaps go in `CONTRACT_REQUESTS.md` |
| Shared UI | `packages/turbo_ui` | Brand tokens, theme, floating bar, auth layout, badge, cards. Redesigned to the boards in `design/` |
| Generated client | `packages/turbo_api` | Never hand-edit. Regenerate from the contract |
| Student app | `apps/student_app` | iOS and Android working; redesigned except the screens listed below |
| Driver app | `apps/driver_app` | iOS and Android working; redesigned except the screens listed below |
| Student web | `apps/student_app/web` | Folder exists, **nothing built for it yet** (see the last section) |
| Admin dashboard | `apps/admin_dashboard` | Kevin and Claude are on it, not yours |
| Landing page | not in the repo yet | Kevin and Claude are on it, not yours |

Tests at handover: turbo_ui 49, student app 129, driver app 61. `flutter analyze` is clean. **None of the redesign has been looked at on a phone yet.** Do that first.

## Rules that already apply (from `CLAUDE.md`)

- The contract wins. Never invent an endpoint or field. Missing something: append to `CONTRACT_REQUESTS.md`.
- Money is integer pesewas, formatted only at the edge.
- Switch on the problem `code`, never the message.
- No colour literal, font size, radius or product name in screens or components. `packages/turbo_ui/test/hardcoded_style_test.dart` enforces it.
- Every screen: loading, empty, error and full states; dark mode; 44 pt targets; labels; text to 200%. Most screens have a dark-mode 200% test; copy the pattern (`platformBrightnessTestValue`, `textScaleFactorTestValue`, then `tester.takeException()`).
- Never log tokens, OTPs, document URLs or full phone numbers. No keys or `.env` files in git.
- One branch per task, one short plain commit per issue, no attribution trailers. Run `flutter analyze && flutter test` before each commit.
- Do not run `dart format` on a whole old file; it rewrites unrelated lines.

## Get running

```bash
flutter pub get                      # from the repo root (it is a pub workspace)
cd apps/student_app && flutter run --dart-define=API_BASE_URL=https://api.turbogh.app
cd apps/driver_app  && flutter run --dart-define=API_BASE_URL=https://api.turbogh.app
```

`https://api.turbogh.app` is the staging API. Sign in with any seeded number and the code **123456**. Seed drivers: +233200000001 to +233200000003. This is staging only: the code and the fake payments are open on a public address, so use test data. Kevin and Claude are moving it to production settings (real SMS, real payments); see `LOG.md`.

For the local mock instead: `npm run mock` at the repo root, then `--dart-define=API_BASE_URL=http://localhost:4010` (iOS simulator) or `http://10.0.2.2:4010` (Android emulator).

Keys you need locally (ask Kevin, never commit):
- `GoogleService-Info.plist` and `google-services.json` for push (Firebase project `turbo-dev-5f54ed`)
- The Google Maps key (`apps/*/ios/Flutter/Secrets.xcconfig`, see the `.example` file next to it)

## What is open, in the order I would do it

1. **Look at it on a phone.** Walk both apps in light and dark. Fix what looks wrong against the boards in `design/` (boards 01 to 15; `design/SCREENS.md` lists the screens).
2. **Screens not redone yet.**
   - Student: destination and pickup-point screens (board 14), cancel-reasons sheet and rating card (board 13), ride detail map and timeline, support new-ticket form (board 7), profile rows and switches.
   - Driver: Me screen with photo and document chips, trip detail, trip-complete card (distance, time, "paid from the student's wallet").
3. **Waiting on art.** The isometric campus map and the three welcome photos were not supplied. The code uses text and dots until they arrive.
4. **Waiting on the contract.** Document dates (CR-5) and supervisor and security phone numbers (CR-6) in `CONTRACT_REQUESTS.md`. Profile switches (News and offers, Tips) need fields I have not seen; raise them there if you want them.
5. **Real-world checks still open.** The 30-minute locked-screen location test for the driver (R7); push while the app is closed on the driver app; the driver sign-in to ride loop on a phone; the placeholder app icon.
6. **Help topics** in the driver Help tab open the ticket form without preselecting a category. Small fix when the form accepts one.

## Getting a build to testers (iOS)

Both apps are on TestFlight (builds 1 to 3 uploaded; build 3 has no driver home or ride changes yet). The flow that worked:

```bash
cd apps/student_app   # or driver_app
flutter build ipa --release --dart-define=API_BASE_URL=https://api.turbogh.app \
  --export-options-plist=<your export plist>
xcodebuild -exportArchive -archivePath build/ios/archive/Runner.xcarchive \
  -exportOptionsPlist <your upload plist> -exportPath <dir> -allowProvisioningUpdates
```

- Bump `version:` in the app's `pubspec.yaml` (the number after `+`) every upload.
- The upload uses the Apple account signed in to Xcode (team `M7TM8A4V9S`). If it says `missing Xcode-Token`, sign in again in Xcode, then retry. An App Store Connect API key would remove this; Kevin has not made one yet.
- Bundle ids and app records already exist in App Store Connect. Push needs the entitlement and `GoogleService-Info.plist` in the Runner resources (already done).
- Android has not been uploaded anywhere yet.

## Student web: not started, your discretion

`prompts/03-student-web-app.md` is the full brief; read it with `prompts/04-student-mobile-app.md`. In short: it is a Flutter web build of the **same** student app code, limited to sign-in, terms, verification status, booking, wallet, history, profile, support and safety. It is a convenience, not the main product, so only take it on when the mobile apps are in good shape. If you do, the points that need care:

- **Sign in as `clientType: web`.** The refresh token comes as an httpOnly cookie, so never store it. Keep the access token in memory. Every request needs `credentials: include`. On page reload, call `POST /auth/refresh` first and show a skeleton, not a login flash.
- **OTP request needs a `captchaToken`** (invisible challenge) and a `deviceId` kept in local storage.
- **Camera capture does not belong on web.** For verification, show the status and send the student to the app.
- **No push on web.** Poll every 3 to 5 seconds on an active ride and refresh on focus.
- **Layout:** phone-width first (360 to 430), then two columns on wide screens (panel left, map right, max width 1100).
- **URLs:** path URLs not hash (`/ride`, `/wallet`, `/activity`, `/profile`, `/safety`), refresh keeps your place, and the host must fall back to the app for unknown routes.
- **Accessibility is the weak point of Flutter web.** Turn semantics on, check focus order and focus rings, test with a screen reader and keyboard only, and report gaps.
- **Maps:** Google Maps JS through the plugin, plus a text list of pickup points.
- **Security:** strict content security policy, no tokens in URLs or storage, 30-minute idle timeout, sign-out revokes the session.
- **Hosting:** the web build is static files; Kevin and Claude will serve it from the server once it exists. Tell us the build command and the output folder.

How I would start: add a `kIsWeb` branch in the session code for the cookie flow, get sign-in, refresh-on-reload and the wallet working first, then booking and the live ride, then the desktop two-column layout. Keep it one codebase; do not fork the student app.

## Who to ask

- API, server, admin dashboard, landing page, production settings: Kevin (with Claude on devops).
- Contract changes and design decisions: planning. Put the request in `CONTRACT_REQUESTS.md` and tell Kevin.
