# Admin dashboard

Staff web portal for Turbo operations. React + Vite + TypeScript. Spec: `prompts/02-admin-portal.md`; contract: `api/contract/openapi.yaml`.

```bash
npm install
cp .env.example .env.local          # API base URL, environment name, version
npm run dev                         # http://localhost:5173 (mock API on :4010, see the root README)
npm run gen:api                     # regenerate src/types/schema.d.ts from the contract (never hand-edit)
npm run lint                        # ESLint, including the import rules below
npm run format                      # Prettier (format:check only checks)
npm run check                       # schema up to date, typecheck, lint, format, tests: must pass before every commit
npm run build                       # production build in dist/
```

## Against the real API

How the API behaves is in `docs/api-integration.md`. Locally the API runs on `http://localhost:3000` (`npm run migrate && npm run seed && npm start`, plus `npm run worker`, in the API repo).

```bash
API_PROXY_TARGET=http://localhost:3000 npm run dev
```

Calls go to `/api` on the dev server, which proxies them, so the `SameSite=Strict` refresh cookie works with no CORS setup. Dev staff accounts: `admin@`, `finance@`, `finance2@`, `verifier@`, `dispatch@`, `hr@`, `support@` at `turbo.test`, password `Turbo-demo-1`. A local API may skip MFA; staging (`api.turbogh.app`) requires it since 2026-11-01. A deployed dashboard sets `VITE_API_BASE_URL` to the API's `/v1` URL on the same site (for example `admin.turbo.com` and `api.turbo.com`), and its origin must be in the API's `CORS_ORIGINS`.

## Demo mode

```bash
VITE_APP_ENV=demo npm run dev       # no API needed: sample data served in the browser from src/demo
```

Any email, a 10-character password and any 6-digit code sign in. Start the email with a role (`verifier@`, `dispatcher@`, `finance@`, `support@`, `hr@`) to see that role's menu; anything else is super admin. Actions change the in-memory data until the page reloads. Real builds leave `src/demo` out of the bundle. `test/routes.smoke.test.tsx` signs in through the demo server and renders every screen.

## Brand

Three layers, as in the Flutter apps:

1. `src/brand/brand.ts`: the only file with raw values (colours, fonts, type sizes, radii, product name). Taken from the landing page: ink, paper, `#D4FF3A` neon, Geist Sans and Geist Mono.
2. `src/theme/theme.ts`: turns the brand into CSS variables (`--color-*`, `--text-*`, `--radius-*`, `--font-*`). Dark is the default; light follows the system or `data-theme="light"`.
3. Components and screens read those variables only. `test/hardcoded-style.test.ts` fails on any colour literal, font size, radius, font family or product name outside layers 1 and 2. `test/contrast.test.ts` checks every text and control pair.

## Structure

```
src/
  app/          bootstrap pieces: router (App.tsx), route table and menu (routes.tsx), Layout, env, strings
  pages/        one thin file per route; renders a feature screen, holds no API calls
  features/     one folder per area (auth, overview, verification, students, drivers, vehicles, rides,
                finance, support, incidents, workforce, configuration, announcements, staff, audit):
                its screens, plus queries.ts with its React Query hooks and query keys
  components/   shared UI, one file per component; import from @/components.
                MapView is imported from @/components/MapView so Leaflet stays out of the main bundle
  services/     http.ts (the only HTTP client) and one module per API resource
  hooks/        shared hooks: useCursorList, useAction, useIdleTimer, and queries several features read
  state/        client state: the session (signed-in user, sign in and out)
  utils/        pure helpers: money and time formatting, problem messages, roles
  types/        generated schema.d.ts and named re-exports; every request and response shape comes from here
  theme/ brand/ the three brand layers (below)
  demo/         sample data and an in-browser API, loaded only when VITE_APP_ENV=demo
```

How a screen gets data: the page renders a feature screen; the screen calls a hook from its `queries.ts`; the hook calls a service; the service calls `api` in `services/http.ts`. Server state lives in React Query only. Client state is the session context plus local component state; there is no global store.

Routes and the left-hand menu come from one table, `src/app/routes.tsx`. Each route names its role area (from the contract's `x-roles`, see `utils/roles.ts`); the menu hides what a role cannot use and the route shows "You do not have access to this". The API still refuses with 403 on its own. Pages behind sign-in load on first visit; sign-in screens ship with the shell.

Import rules (ESLint enforces them):

- pages use features, components and hooks
- features use services, components, hooks, state, utils and types, never another feature
- services use types and utils only, never React
- only `services/http.ts` imports `openapi-fetch`
- use the `@/` alias (`@/services/rides`), not `../` paths

Naming: components and their files in PascalCase (`VerificationQueue.tsx`), hooks start with `use`, service modules are the camelCase resource (`walletAdjustments.ts`), constants in `UPPER_SNAKE`, types use the contract's own names.

## API layer

`src/services/http.ts` wraps `openapi-fetch` with the generated types:

- **Base URL**: `VITE_API_BASE_URL`; unset in development, where calls go to `/api` and the dev server proxies them to `API_PROXY_TARGET`.
- **Auth**: the access token is kept in memory only; the refresh token is the httpOnly cookie, so requests send credentials. A 401 triggers one shared refresh and a retry for requests without a body; writes are not replayed.
- **Headers**: every request sends `X-App-Version: web/<version>`; a 426 shows a reload banner.
- **Errors**: everything a service throws is an `ApiError` with `status`, `code` and `retryAfterSeconds`. Problem codes come from the API; `network` (no connection), `timeout` and `unexpected` (an error with no problem body, such as a proxy page) are added here. Screens switch on `code`; `problemMessage()` gives the plain-language sentence.
- **Timeouts**: 15 seconds per call, 2 minutes for file uploads to storage.

Each `services/<resource>.ts` is a set of plain functions such as `verifications.claim(id)`. Parameter and body types come from the contract through `Query<path, method>` and `Body<path, method>` in `src/types`; return types are inferred from the generated client.

## Environment variables

See `.env.example`. `VITE_API_BASE_URL` (deployed builds), `VITE_APP_ENV` (`local`, `staging`, `production` or `demo`), `VITE_APP_VERSION` (sent as `X-App-Version`), and `API_PROXY_TARGET` (development only, never bundled). No secrets: the dashboard holds none.
