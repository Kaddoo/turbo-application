# Admin dashboard

Staff web portal for Turbo operations. React + Vite + TypeScript. Spec: `prompts/02-admin-portal.md`; contract: `api/openapi.yaml`.

```bash
npm install
cp .env.example .env.local          # API base URL, environment name, version
npm run dev                         # http://localhost:5173 (mock API on :4010, see the root README)
npm run gen:api                     # regenerate src/api/schema.d.ts from the contract (never hand-edit)
npm run check                       # schema up to date, typecheck, tests: must pass before every commit
```

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

## API client

`src/api/client.ts` uses `openapi-fetch` with the generated types. The access token is kept in memory only; the refresh token is the httpOnly cookie, so requests send credentials. A 401 triggers one refresh and a retry for requests without a body; writes are not replayed. Every request sends `X-App-Version: web/<version>`.
