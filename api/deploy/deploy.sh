#!/usr/bin/env bash
# Ship a new version. Run from your laptop:  bash deploy/deploy.sh user@server
# Migrations run BEFORE the restart, so every migration must be backward compatible with the running version.
set -euo pipefail
HOST="${1:?user@server}"
cd "$(dirname "$0")/.."
rsync -az --delete --exclude node_modules --exclude .env --exclude .git ./ "$HOST:/opt/turbo/turbo-api/"
ssh "$HOST" 'set -e
  cd /opt/turbo/turbo-api
  sudo chown -R turbo:turbo /opt/turbo
  sudo -u turbo npm ci --omit=dev
  # migrations connect straight to Postgres (not PgBouncer) so DDL is not pooled
  sudo -u turbo bash -c "set -a; . /etc/turbo/api.env; set +a; DATABASE_URL=\${DATABASE_URL/6432/5432} node scripts/migrate.js"
  sudo systemctl enable turbo-api turbo-worker
  sudo systemctl restart turbo-worker
  # API: restart is a few hundred ms; nginx retries the next attempt. For zero-downtime, run two instances on 3000/3001.
  sudo systemctl restart turbo-api
  sleep 2; curl -fsS http://127.0.0.1:3000/health && echo " <- healthy"'
