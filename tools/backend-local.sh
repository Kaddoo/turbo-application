#!/usr/bin/env bash
# Runs the backend from origin/main on this Mac for the phone apps.
#   tools/backend-local.sh setup   first time: private Postgres, packages, migrate, seed
#   tools/backend-local.sh start   Postgres, API (port 3000) and worker, reachable on the local network
#   tools/backend-local.sh stop
# Everything lives in .backend/ (git-ignored). Development settings only: the
# sign-in code is fixed at 123456, payments are fake, push is logged.
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
b="$root/.backend"
export PATH=/usr/local/opt/postgresql@16/bin:$PATH LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ip="${LAN_IP:-$(ipconfig getifaddr en0)}"

pg_up() {
  pg_isready -h 127.0.0.1 -p 5433 -q || pg_ctl -D "$b/pgdata" -o "-p 5433 -c listen_addresses=127.0.0.1 -c unix_socket_directories=/tmp" -l "$b/pg.log" start >/dev/null
}

env_for_api() {
  export NODE_ENV=development DATABASE_URL=postgres://turbo@127.0.0.1:5433/turbo_dev
  export HOST=0.0.0.0 PORT=3000 PUBLIC_URL="http://$ip:3000" UPLOAD_DIR="$b/data/uploads"
}

case "${1:-}" in
  setup)
    mkdir -p "$b"
    [ -d "$b/pgdata" ] || initdb -D "$b/pgdata" -U turbo --auth=trust -E UTF8 --locale=en_US.UTF-8 >/dev/null
    pg_up; sleep 2
    createdb -h 127.0.0.1 -p 5433 -U turbo turbo_dev 2>/dev/null || true
    rm -rf "$b/api" "$b/_x"; mkdir -p "$b/_x"
    git -C "$root" fetch -q origin
    git -C "$root" archive origin/main api | tar -x -C "$b/_x"
    mv "$b/_x/api" "$b/api"; rmdir "$b/_x"
    (cd "$b/api" && npm ci --silent && env_for_api && npm run migrate && npm run seed)
    ;;
  start)
    pg_up
    env_for_api
    cd "$b/api"
    nohup node src/server.js >"$b/server.log" 2>&1 & echo $! >"$b/server.pid"
    nohup node src/worker.js >"$b/worker.log" 2>&1 & echo $! >"$b/worker.pid"
    sleep 4
    echo "API on http://$ip:3000  (health: $(curl -s -m 3 -o /dev/null -w '%{http_code}' "http://$ip:3000/health"))"
    ;;
  stop)
    for f in server worker; do [ -f "$b/$f.pid" ] && kill "$(cat "$b/$f.pid")" 2>/dev/null || true; rm -f "$b/$f.pid"; done
    pg_ctl -D "$b/pgdata" stop >/dev/null 2>&1 || true
    ;;
  *) echo "usage: $0 setup|start|stop"; exit 1 ;;
esac
