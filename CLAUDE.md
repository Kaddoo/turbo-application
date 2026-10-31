# Turbo: working rules for code sessions

Cashless campus ride-hailing for Central University students at Miotso (Ghana). Client: Turbo. Builder: Bevin Business Solutions.
**Planning happens in a separate planning session. Code sessions build.** Do not re-plan; build what the docs and contract say, and send questions back.

## Read first, every session

1. `LOG.md` (newest entry first): where the last session stopped.
2. `prompts/00-shared-rules.md` and the prompt for the surface you are building (`04` student app, `05` driver app, `03` student web).
3. `api/openapi.yaml` for any endpoint you touch; `docs/04-business-rules.md` and `docs/03-domain-and-state-machines.md` for behaviour.
4. `prompts/06-app-build-brief.md` for structure, the theme architecture and the work order.

## Layout

```
api/                 the contract (planning owns this; read only here)
docs/ prompts/       planning docs (read only here, except LOG.md)
apps/student_app/    Flutter: iOS, Android, web build
apps/driver_app/     Flutter: iOS, Android
packages/turbo_api/  generated Dart client from api/openapi.yaml (never hand-edit)
packages/turbo_ui/   brand layer, theme, shared components, motion and haptics
CONTRACT_REQUESTS.md things the apps need that the contract lacks (you write, planning applies)
```

## Hard rules

- **The contract wins.** Never invent an endpoint or field, never hand-type a request or response shape, never edit `api/`. Missing something? Append to `CONTRACT_REQUESTS.md` (what, why, suggested shape) and carry on with the mock or a stub.
- **Money is integer pesewas**, formatted only at the edge (`GH₵35.00`). No floating point for money.
- **Errors**: switch on the problem `code`, never the message. Plain-language text for people.
- **Idempotency**: one key per user intention, reused on retry.
- **Brand is swappable.** Three layers: brand tokens (raw values, one file) → semantic theme → components. **No colour literal, font size, radius or product-name string in screens or components.** A test enforces it.
- **Every screen has loading, empty, error and full states** plus accessibility basics (dark mode, 44 pt targets, labels, text scaling to 200%).
- **Never** log or print tokens, OTPs, document URLs or full phone numbers. Tokens live in secure storage only. No keys, `google-services.json` or `.env` files in git.
- Stack: Flutter, Riverpod, GoRouter, generated dart-dio client, `flutter_secure_storage`, `intl` ARB strings for all text.

## Git rules (Kevin's standing preferences)

- Short branches, one task each. **One succinct commit per issue.** Commit messages are short and plain, for example `add otp login screen`.
- **No `Co-Authored-By` or other attribution trailers in commit messages**, even if a tool suggests them.
- **Never merge branches.** Tell Kevin the branch is ready; he merges and deletes it.
- Do not install global tools or change system settings without asking.

## Commands

```bash
cd api && npx @stoplight/prism-cli mock openapi.yaml        # mock API, http://localhost:4010
# Android emulator reaches the host at http://10.0.2.2:4010; iOS simulator at http://localhost:4010
flutter run --dart-define=API_BASE_URL=http://localhost:4010
flutter analyze && flutter test                              # must pass before every commit
```

## End of every session

Add a `LOG.md` entry (template in `docs/05-work-plan.md`): files touched, what changed, acceptance criteria, deviations, status, next step. Say plainly what you did not finish.
