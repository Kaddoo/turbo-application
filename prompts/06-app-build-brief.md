# Prompt 06: Student and driver apps, build brief

For the code session in `/Users/kevinafenyo/Documents/GitHub/turbo`. Read with `CLAUDE.md`, `prompts/00-shared-rules.md`, and `04` (student) and `05` (driver). This brief adds the structure, the swappable theme, and the order of work.

## 1. Check the machine before building

Run and report: `git status`, `git log --oneline -5`, `flutter --version`, `flutter doctor -v`, `dart --version`, `node --version`. Report gaps (Xcode, Android SDK, CocoaPods, emulator or device). Do not install system tooling without asking. Confirm the mock works: start Prism and `curl localhost:4010/app-config`.

## 2. Ask these before native setup (do not guess)

1. **Bundle ids / application ids and app display names** for the student and driver apps. They cannot be changed cheaply once chosen (risk R13). Suggest `gh.turbo.student` and `gh.turbo.driver` as defaults and wait for approval.
2. **The exact neon hex.** Use `#C6FF00` as an assumption until told.
3. Real devices available (iPhone model and iOS version, Android model) for the background-location test.
4. Whether Apple Developer and Google Play accounts exist (needed for TestFlight and internal testing, not for local runs).
5. Google Maps API keys (iOS, Android, web) and the Firebase project: where the files will be provided. **Never commit them.**

## 3. Structure

Create a Dart pub workspace at the repo root (or Melos if the workspace feature is not available on the installed Dart; say which):

```
apps/student_app    flutter create --platforms=ios,android,web
apps/driver_app     flutter create --platforms=ios,android
packages/turbo_api  generated client, plus a thin wrapper (auth interceptor, App-Version header, problem-details parsing, idempotency helper, retry rules)
packages/turbo_ui   brand layer, theme, components, motion, haptics, shared states
```

- Generate the client with `openapi-generator-cli` (`dart-dio`) from `../../api/openapi.yaml` through a script `packages/turbo_api/tool/generate.sh`. Commit the generated code; CI must be able to regenerate it with no diff. If the generator mishandles `oneOf`, nullable or the problem-details responses, do not hand-edit: record it in `CONTRACT_REQUESTS.md` with the exact error.
- The wrapper turns problem responses into a typed `ApiProblem(code, title, detail, retryAfter)`. Screens switch on `code`.
- Config: `--dart-define=API_BASE_URL`, `APP_ENV`. No secrets in Dart.

## 4. The swappable theme (build this first, inside `packages/turbo_ui`)

Three layers as defined in `00-shared-rules.md`:

```
lib/src/brand/brand_tokens.dart   THE ONLY FILE WITH RAW VALUES
lib/src/theme/                    semantic roles (a ThemeExtension) built from brand tokens; light and dark ThemeData
lib/src/components/               buttons, fields, OTP field, money text, status chip, list row, card, sheet, toast,
                                  skeleton, empty state, error state, confirm dialog, map container, timeline
lib/src/states/                   shared loading / empty / error widgets
lib/src/motion/                   duration and curve tokens, reduced-motion aware
lib/src/haptics/                  semantic wrapper (selection, success, warning, error) so call sites say what happened
```

`brand_tokens.dart` holds: app name, wordmark text, logo and icon asset paths, the two brand colours (black, neon), the font family, the radius scale, support strings. Everything user-visible that names the product comes from here or from ARB strings with an `{appName}` placeholder.

Required safeguards (these are what make a future rebrand cheap):

1. **A test that fails on hard-coded styling.** It scans `apps/**/lib` and `packages/turbo_ui/lib/src/components` for `Color(0x`, `Colors.`, `TextStyle(` with a literal size, `BorderRadius.circular(` with a literal, `fontFamily:` and the string "Turbo" outside the brand and theme files. Make it part of `flutter test`.
2. **A second brand fixture** in the test folder (different colours, radius, name, font) and a test that builds the theme and a few components with it, proving the apps restyle with no widget code change.
3. **Golden tests** for the core components in light and dark, so a rebrand shows its visual diff.
4. **`packages/turbo_ui/BRANDING.md`**: five steps to apply a new brand guide (edit `brand_tokens.dart`; replace logo and icon assets; regenerate launcher icons and splash with `flutter_launcher_icons` and `flutter_native_splash`; set the font in `pubspec`; run the golden tests and review diffs), plus a list of what a rebrand cannot absorb (layout, navigation, icon style, motion language).
5. **Contrast check in the theme tests**: assert each text/background and onAccent/accent pair meets 4.5:1 (3:1 for large text and control edges). Neon is only a fill with black text on it, or text on dark surfaces; on light backgrounds a neon button gets a 1.5 px black border and `accentText` is black.

Dark mode is the primary design; light follows the system. Use the role table in `00-shared-rules.md` exactly.

## 5. Shared app infrastructure (build once in `turbo_ui` or `turbo_api`)

App-config gate (update required, maintenance, bookings paused, 426 handling) · auth/session with secure storage and refresh rotation · `X-App-Version` header · idempotency key helper · rate-limit (429) back-off · money formatter (pesewas to `GH₵35.00`) · Africa/Accra time formatters · problem-code-to-message mapper (one place) · connectivity banner · push registration (`POST /devices`) · terms-acceptance gate · skeleton, empty and error widgets · back-gesture handling (iOS edge swipe, Android predictive back).

## 6. Order of work

Small tasks, each its own short-lived branch and one commit. Stop after each group for review.

1. **Workspace, tooling, `turbo_api` generation, mock running.** Gate: a test calls `getAppConfig` against the mock through the generated client.
2. **`turbo_ui` brand layer, theme, safeguards, base components, shared states.** Gate: the hard-coded-style test and the second-brand test pass; a component gallery screen shows everything in light and dark.
3. **Driver app: the background-location spike, before anything else in the driver app.** Android foreground service and iOS Always permission, pinging `PUT /driver/location` against the mock. Real-device test with the screen locked for 30 minutes. This is the biggest technical risk (R7); report honestly if it fails.
4. **Student app Phase 1** (prompt 04): shell and app-config gate, phone and code, terms, verification capture and status, map home, destination, quote against the mock.
5. **Driver app Phase 1** (prompt 05): login, readiness checklist, duty toggle, new assignment, go to pickup.
6. **Phase 2** for both apps in the order set by `docs/05-work-plan.md`: wallet and top-up, booking and tracking, PIN, completion, cancel, history, receipt; driver trip flow including no-show.
7. **Phase 3**: safety, SOS, trusted contacts, trip share, support, ratings, shifts, attendance, salary history, sessions, deletion request.
8. **Student web build** (prompt 03) once the student app screens are stable.

## 7. Definition of done for any task

Matches the contract against the mock; the four states exist; error codes map to plain sentences; accessibility basics hold; `flutter analyze` and `flutter test` pass (including the hard-coded-style test); no secrets in git; `LOG.md` updated; contract gaps written to `CONTRACT_REQUESTS.md`.

## 8. Your first reply (do not start coding yet)

Send: (a) what you understood the job to be, in ten lines or fewer; (b) results of the machine check; (c) the questions in section 2; (d) the task list for group 1 and 2 with how you will verify each. Wait for approval before creating anything.
