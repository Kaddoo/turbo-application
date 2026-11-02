# 11. Ops runbook: staging server, deploys, tests, TestFlight

How the code sessions actually run things. No secrets here. Secrets live in `/etc/turbo/api.env` on the server (never print it) and in the git-ignored files on the build Mac.

## The server

| What | Where |
| --- | --- |
| SSH | `ssh -i ~/.ssh/turbo_do root@203.161.62.244` (`server1.turbogh.app`, key already on the Mac, no passphrase prompt) |
| API code | `/opt/turbo/turbo-api` (plain JavaScript, ESM, Node 22), run as user `turbo` |
| Services | `turbo-api` (127.0.0.1:3000) and `turbo-worker`, systemd. `curl http://127.0.0.1:3000/health` |
| Settings | `/etc/turbo/api.env` (root:turbo, 640). Backups `api.env.bak*` beside it. **Check `STAFF_MFA=required` is still there after anyone edits it** (it silently disappeared once) |
| Caddy (HTTPS) | Docker, `/opt/turbo/deploy/Caddyfile` and `docker-compose.yml`; `cd /opt/turbo/deploy && docker compose up -d caddy`. Serves `api.turbogh.app` (proxy to 3000) and `admin.turbogh.app` (static files) |
| Dashboard files | `/opt/turbo/admin` (static build, served by Caddy; no restart needed) |
| Database | Postgres 16 on the host. Backups: pgBackRest stanza `main` to R2, cron 02:10 UTC. Manual: `runuser -u postgres -- pgbackrest --stanza=main --type=diff backup` |
| Monitoring | `/usr/local/bin/turbo-hostcheck` every 5 min (`/var/log/turbo-hostcheck.log`), `/root/LOGS.md` (how to read every log), `/etc/turbo/monitoring.env` (backup heartbeat URL), alerts to inlet and logs to LogPulse (see `docs/10-monitoring-plan.md`) |
| Old copies | before each deploy a copy goes to `/opt/turbo/src.pre-*`, `contract.pre-*`, `admin.pre-*` (undo = copy back and restart) |

Staging means: fixed phone sign-in code 123456, fake payments, push through Firebase, staff MFA required, email through the shared academicx Zoho account (often blocked: "unusual sending activity", so invite emails may not arrive; hand out links instead).

## Deploy the API (from a branch or main)

```bash
K=~/.ssh/turbo_do; cd api
# 1. nothing in flight? (rides searching/assigned/in progress, open SOS). TEST rides do not matter.
# 2. back up the old code on the server, then:
rsync -a --delete -e "ssh -i $K" src/ contract/ ... root@203.161.62.244:/opt/turbo/turbo-api/     # src, contract, migrations, scripts, test, package*.json
ssh -i $K root@203.161.62.244 'cd /opt/turbo/turbo-api && chown -R turbo:turbo src contract migrations scripts test package*.json \
  && runuser -u turbo -- npm ci --no-audit --no-fund \
  && runuser -u turbo -- node --env-file=/etc/turbo/api.env scripts/migrate.js \
  && systemctl restart turbo-worker turbo-api; sleep 7; systemctl is-active turbo-api turbo-worker; curl -s http://127.0.0.1:3000/health'
```

Before a migration that changes data or adds a unique index: take the pgBackRest diff backup first and list any collisions (migration 015 stops by itself if there are any).

## Deploy the dashboard

```bash
cd apps/admin_dashboard
VITE_API_BASE_URL=https://api.turbogh.app/v1 VITE_APP_ENV=staging npm run build
ssh -i $K root@203.161.62.244 'cp -a /opt/turbo/admin /opt/turbo/admin.pre-$(date +%Y%m%d-%H%M)'
rsync -a --delete -e "ssh -i $K" dist/ root@203.161.62.244:/opt/turbo/admin/
```

The dashboard and the API must go out together when a contract change makes a header or field required.

## Deploys from GitHub

Three workflows in `.github/workflows` publish to the staging server when the matching folder changes on `main`, and can be run by hand from the Actions tab: `deploy-api.yml` (`api/`), `deploy-admin.yml` (`apps/admin_dashboard/`) and `deploy-landing.yml` (`apps/landing_page/`). Each uses the `staging` environment (Settings, Environments: add yourself as a required reviewer if you want to approve each deploy). They do the same steps as the manual commands above: keep a copy of what runs, copy the new files, and check the result. The API one also checks the contract, takes a pgBackRest backup when the push changed `api/migrations`, runs the migrations, restarts both services, refuses to continue if `STAFF_MFA=required` is missing, and calls `/health`.

**One-time setup**

1. Make a key just for deploys (no passphrase): `ssh-keygen -t ed25519 -f ~/.ssh/turbo_deploy -C github-deploy -N ""`. Put `turbo_deploy.pub` in `/root/.ssh/authorized_keys` on the server.
2. Get the server's host key so the runner can check it: `ssh-keyscan -t ed25519 203.161.62.244`.
3. In GitHub, Settings, Secrets and variables, Actions, add four secrets: `DEPLOY_HOST` (`203.161.62.244`), `DEPLOY_USER` (`root`), `DEPLOY_SSH_KEY` (the whole private key file), `DEPLOY_KNOWN_HOSTS` (the `ssh-keyscan` line). A fifth secret, `VITE_GOOGLE_MAPS_API_KEY`, is the Google Maps browser key that `deploy-admin` builds into the dashboard.
4. Landing site: add DNS A records for `turbogh.app` and `www.turbogh.app` to the server IP, then add this to `/opt/turbo/deploy/Caddyfile` and run `cd /opt/turbo/deploy && docker compose up -d caddy`. The Caddy container must also be able to read `/opt/turbo/landing` (mount it the same way `/opt/turbo/admin` is mounted).

```
turbogh.app {
	root * /srv/landing
	encode zstd gzip
	try_files {path} {path}/index.html
	file_server
}
www.turbogh.app {
	redir https://turbogh.app{uri} permanent
}
```

Notes: a contract change that makes a header or field required must reach the API and the dashboard in the same merge, so run both. The API's own tests need a Postgres and have two known failures (see below), so they are not a gate here; the contract guard is. Roll back by copying the newest `*.pre-*` folder back and restarting. Do not put the private key anywhere in the repo.

## Staff accounts (no seed accounts on staging, ever)

- Never run `scripts/seed.js` on a shared host (it now refuses). The old `@turbo.test` staff are deactivated.
- Invite someone: `runuser -u turbo -- node --env-file=/etc/turbo/api.env scripts/create-admin.js <email> <role> "<Name>"` prints a one-time link (valid 72 hours) of the form `https://admin.turbogh.app/accept-invite?token=...`. Roles: `super_admin finance verifier dispatcher hr support`. The person sets a password and scans an authenticator QR code. Run it again for the same email to get a fresh link.
- Test data for staff to click through: `runuser -u turbo -- node --env-file=/etc/turbo/api.env scripts/seed-test-data.js` (everything is marked TEST; `--cleanup` removes it; never in production).
- Invited test accounts in use: `devspaceshared+<tag>@gmail.com` for admin, finance, finance2, verifier, dispatch, hr, support (Emmanuel's dashboard checks).

## Run the API tests on the Mac

```bash
export PATH=/usr/local/opt/postgresql@16/bin:$PATH LC_ALL=en_US.UTF-8
initdb -D "$TMPDIR/pgtest" -U postgres --auth=trust --locale=en_US.UTF-8
mkdir -p /tmp/pgsock54329   # the unix socket path must be short
pg_ctl -D "$TMPDIR/pgtest" -o "-p 54329 -c listen_addresses=127.0.0.1 -k /tmp/pgsock54329" -l "$TMPDIR/pg.log" start
createdb -h 127.0.0.1 -p 54329 -U postgres turbo_test
cd api && export DATABASE_URL=postgres://postgres@127.0.0.1:54329/turbo_test NODE_ENV=development PORT=3999 BASE_URL=http://localhost:3999 \
  UPLOAD_DIR=/tmp/turbo-test-uploads ADMIN_LOGIN_PER_10MIN=100000 RATE_LIMIT_IP_PER_MIN=100000 RATE_LIMIT_PER_MIN=100000 OTP_PER_IP_HOUR=100000 COOKIE_SECURE=true
npm run migrate && npm run seed          # seed is allowed on localhost only
node src/server.js & node src/worker.js &
npm test                                  # stop the postgres and delete the temp dirs afterwards
```

Two tests fail on a clean checkout and are not regressions: the per-account rate-limit test (fails because the limits are raised for the suite) and the document-purge test.

Dashboard tests need Node 22.23 or newer (the Mac has 22.12, where the workers crash): `cd apps/admin_dashboard && npx -y node@22.23.4 node_modules/vitest/vitest.mjs run`. Also `npm run typecheck`, `npm run lint`, `npx prettier --check .`.

Flutter: `flutter analyze && flutter test` in `packages/turbo_ui`, `apps/student_app`, `apps/driver_app` (turbo_api's own mock tests need the mock on :4010 and fail without it).

## The contract

One file: `api/contract/openapi.yaml` (currently 0.3.2). `node tools/check-contract.mjs` (and CI) fails if a second copy exists or a generated client was built from another version. After any change: `cd apps/admin_dashboard && npm run gen:api`, `cd packages/turbo_api && bash tool/generate.sh` (needs Java), then the check. Lint: `cd api && npx @redocly/cli lint contract/openapi.yaml`.

## TestFlight

`tools/testflight/ship.sh` builds and uploads both apps to App Store Connect (about 15 minutes, run it in the background). Bump `version: 1.0.0+N` in both `pubspec.yaml` files first. It uses the Apple account signed in to Xcode (team M7TM8A4V9S); "missing Xcode-Token" means sign in to Xcode again. Last upload: build 4. Apple needs a few minutes to process before it shows in TestFlight.

## Habits that bit us

- macOS: `sed -i ''` (empty string), no `timeout` command, zsh does not expand `--include=*.ts` in grep (use `git grep`).
- Do not run `dart format` on a whole old Dart file; it rewrites unrelated lines.
- A fixed seed SOS or a searching ride older than 3 minutes pages people through inlet. TEST fixtures avoid both.
- Never commit anything under `design/` that is not yours; the working tree there is edited by hand.
- Git rules from `CLAUDE.md`: short branches, one plain commit per issue, no attribution trailers, merge only when Kevin says so.
