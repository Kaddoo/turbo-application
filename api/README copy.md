# turbo-api

The Turbo backend: Node 22+, Express 5, PostgreSQL. It implements `contract/openapi.yaml` (a copy of `../Docs/api/openapi.yaml`, currently **0.2.2**): 133 of 135 operations; the other two are `v1.1` and deliberately not built.
Frontend engineers: start with `../Docs/api/INTEGRATION.md`.

```bash
npm install
npm run migrate        # apply SQL migrations (needs DATABASE_URL, see .env.example)
npm run seed           # demo staff, drivers, boundary, fares   (refuses to run in production)
npm start              # the API on :3000 (HOST=127.0.0.1; put nginx in front)
npm run worker         # assignment engine, timeouts, reconciliation, retention (run exactly one or more; it is safe to run several)
```

| Command | What it does |
| --- | --- |
| `npm test` | 69 tests against a running API + worker. Response validation is on, so any drift from the contract fails the test |
| `npm run demo` | A whole ride, narrated: sign-up, verification, top-up, booking, assignment, PIN, charge |
| `npm run loadtest` | 5,000 students + 500 drivers polling every 5 s. Pass: no errors, p99 under 500 ms |
| `npm run pushload` | Times a broadcast to every load-test student's device (run the worker with `PUSH_SIMULATED_LATENCY_MS=100`) |
| `npm run contract:gap` | Contract operations the code does not implement |
| `npm run contract:sync` | Copy `../Docs/api/openapi.yaml` into `contract/` (do this whenever the contract changes) |
| `node scripts/contract-coverage.mjs <server.log>` | Which operations a test run actually exercised |

## How the contract is enforced

`src/lib/contract.js` loads the OpenAPI file at startup.
- **Requests:** the body is validated against the operation's schema *after* authentication and the role check (so strangers cannot probe schemas and a forbidden caller gets 403, not 422). Failures are `422` with `errors[{field,message}]`.
- **Responses:** in development and test every response is validated too, and a mismatch becomes a `500 CONTRACT VIOLATION ...` that names the field. Production runs with `CONTRACT_RESPONSES=off` (tested in CI, not paid for per request).
- A route that forgets to validate its body fails the same check, so the guard cannot be skipped by accident.

Push: `domain/notify.js` writes notifications into the `notifications` outbox in the same transaction as the event; `worker.js` (`sendPushes`) delivers them through `lib/push.js` (FCM HTTP v1, no SDK). `FCM_PROVIDER=console` prints instead of sending in development.

Layout: `routes/` (HTTP only), `views.js` (database row → contract object), `domain/` (money, rides, attendance), `lib/` (auth, sessions, contract, sanitizing, paging, rate limits, storage), `worker.js`, `migrations/`, `deploy/` (nginx, systemd, backups, alerts).
Security notes are in `../spec/06-security.md`; deployment in `../spec/04-vps-deployment.md`.
