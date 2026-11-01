#!/usr/bin/env bash
# Adds a few DEMO pickup points to the local backend so there is somewhere to
# go. The coordinates are approximate and not approved by Turbo (decision D1).
set -euo pipefail
b="${API:-http://127.0.0.1:3000}"; j='Content-Type: application/json'
tok=$(curl -s -X POST -H "$j" -d '{"email":"admin@turbo.test","password":"Turbo-demo-1"}' "$b/auth/admin/login" | python3 -c "import sys,json;print(json.load(sys.stdin)['accessToken'])")
existing=$(curl -s "$b/service-area")
add() {
  case "$existing" in *"\"$1\""*) echo "have: $1"; return;; esac
  curl -s -o /dev/null -w "$1: %{http_code}\n" -X POST -H "Authorization: Bearer $tok" -H "$j" \
    -d "{\"name\":\"$1\",\"point\":{\"lat\":$2,\"lng\":$3}}" "$b/admin/pickup-points"
}
add "Ashaiman China Mall" 5.6942 -0.0335
add "Miotso Hostels" 5.7228 0.0731
add "Prampram Junction" 5.7090 0.1050
