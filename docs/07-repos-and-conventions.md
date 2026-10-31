# 07. Repos and conventions

## Repositories

For now everything lives in this one `turbo/` folder. Split into these repos when coding starts, in this order.

| Repo | Contents | Owner |
| --- | --- | --- |
| `turbo-contract` | This folder's `api/` and `docs/`. The contract is the source of truth; other repos pull it | Kevin |
| `turbo-api` | Node.js + Express + TypeScript | Bethel (modules shared with Emmanuel) |
| `turbo-admin` | React + Vite dashboard | Bethel |
| `turbo-student-app` | Flutter (iOS, Android, web) | Kevin |
| `turbo-driver-app` | Flutter (iOS, Android) | Kevin |
| `turbo-landing` | Landing page and brand assets | Emmanuel |

How apps consume the contract: pin a released tag of `turbo-contract` (submodule or a CI download step). Never copy `openapi.yaml` by hand.

## Branching and commits

- Trunk-based. One `main`, protected, deployable.
- Branches are short-lived: open, review, merge, **delete**. Aim for a day or two. Stale branches get deleted.
- **One commit per issue.** Messages are short and plain, for example `add wallet top-up endpoint`.
- No co-author trailers in commit messages.
- Contract changes go in their own pull request, merged before the code that uses them.

## CI (every repo)

| Check | Tool |
| --- | --- |
| Contract lint | `redocly lint` |
| Breaking-change diff against `main` | `oasdiff breaking` |
| Generated clients up to date | Dart client for Flutter apps, TypeScript types for the dashboard |
| Tests and static analysis | `flutter analyze` and `flutter test`; `tsc`, ESLint and tests |
| Secret scan | gitleaks or similar |

## Conventions that apply everywhere

| Topic | Rule |
| --- | --- |
| Money | Integer pesewas. Never floats, never strings |
| Ids | UUIDs (v7 preferred) |
| Times | ISO 8601, UTC. Convert to Africa/Accra only in the UI |
| JSON keys | camelCase. Database columns snake_case |
| Pagination | Cursor based. No offset pagination |
| Errors | RFC 9457 `application/problem+json`, stable `code` |
| Deletes | Soft delete. Ledger, events, decisions, audit entries are append-only |
| Idempotency | Required header on money and SMS operations |
| Auth | JWT access, rotating refresh. httpOnly cookie on web, secure storage on mobile |
| Phone numbers | E.164, `+233XXXXXXXXX` |
| Secrets | Cloud secret manager and local `.env` files that are git-ignored. Never in a repo or in chat |
| Logging | JSON, with request id. Never log tokens, OTPs, document URLs, or full phone numbers |
| Cloud Run | No `setInterval` or background loops (CPU is only given during requests). Timers are Cloud Tasks; nightly jobs are Cloud Scheduler. Handlers are idempotent |

## Flutter specifics (student and driver apps)

State with Riverpod, navigation with GoRouter. A shared package for the generated API client, theme tokens and common widgets lets both apps stay consistent and halves the work.
Accessibility is part of done: dark mode, readable contrast, minimum tap targets, screen reader labels, reduced motion.

## Environments and keys

| Item | Staging | Production |
| --- | --- | --- |
| API | Cloud Run staging service | Cloud Run production service |
| Database | Separate Supabase project | Separate Supabase project |
| Payments | Provider sandbox | Provider live, keys held by whoever Turbo designates |
| Maps | Separate restricted key | Turbo's billing account, restricted key |
| Push | Separate Firebase project | Separate Firebase project |
