#!/usr/bin/env bash
# Plays the driver for a ride on the local backend, until the driver app exists.
# Uses the seeded driver +233200000001 (sign-in code 123456).
#   tools/drive-ride.sh duty            go on duty, near the Central Gate
#   tools/drive-ride.sh status          what the driver sees now
#   tools/drive-ride.sh ack             accept the assignment
#   tools/drive-ride.sh arrive          "I've arrived"
#   tools/drive-ride.sh start 4827      start the trip with the PIN shown to the student
#   tools/drive-ride.sh complete        finish the trip
#   tools/drive-ride.sh off             go off duty
set -euo pipefail
b="${API:-http://127.0.0.1:3000}"; j='Content-Type: application/json'
phone="${DRIVER_PHONE:-+233200000001}"
cache="$(dirname "$0")/../.backend/driver.token"
login() {
  curl -s -o /dev/null -X POST -H "$j" -d "{\"phone\":\"$phone\",\"role\":\"driver\",\"deviceId\":\"drive-script\"}" "$b/auth/otp/request"
  curl -s -X POST -H "$j" -d "{\"phone\":\"$phone\",\"code\":\"123456\",\"role\":\"driver\",\"clientType\":\"mobile\",\"acceptedTermsVersion\":\"1.0\",\"acceptedPrivacyVersion\":\"1.0\"}" "$b/auth/otp/verify" | python3 -c "import sys,json;print(json.load(sys.stdin)['accessToken'])"
}
# Codes are limited to one per 30 seconds, so the token is kept between calls.
tok=$(cat "$cache" 2>/dev/null || true)
if [ -z "$tok" ] || [ "$(curl -s -o /dev/null -w '%{http_code}' -H "Authorization: Bearer $tok" "$b/driver/profile")" != 200 ]; then
  tok=$(login); mkdir -p "$(dirname "$cache")"; printf '%s' "$tok" >"$cache"
fi
h="Authorization: Bearer $tok"
now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
ping() { curl -s -o /dev/null -w "location: %{http_code}\n" -X PUT -H "$h" -H "$j" -d "{\"points\":[{\"point\":{\"lat\":${1:-5.7205},\"lng\":${2:-0.0757}},\"recordedAt\":\"$now\"}]}" "$b/driver/location"; }
current() { curl -s -H "$h" "$b/driver/rides/current"; }
ride() { current | python3 -c "import sys,json;t=sys.stdin.read();print(json.loads(t).get('id','') if t.strip() else '')"; }
case "${1:-status}" in
  duty)   curl -s -o /dev/null -w "duty on: %{http_code}\n" -X PUT -H "$h" -H "$j" -d '{"onDuty":true}' "$b/driver/duty"; ping ;;
  off)    curl -s -o /dev/null -w "duty off: %{http_code}\n" -X PUT -H "$h" -H "$j" -d '{"onDuty":false}' "$b/driver/duty" ;;
  status) current | python3 -c "import sys,json;t=sys.stdin.read();d=json.loads(t) if t.strip() else {};print({k:d.get(k) for k in ('id','status','noShowAvailableAt')} if 'id' in d else 'no ride')" ;;
  ack)    ping; curl -s -o /dev/null -w "ack: %{http_code}\n" -X POST -H "$h" "$b/driver/rides/$(ride)/ack" ;;
  arrive) ping 5.7203 0.0757; curl -s -o /dev/null -w "arrived: %{http_code}\n" -X POST -H "$h" "$b/driver/rides/$(ride)/arrived" ;;
  start)  curl -s -o /dev/null -w "start: %{http_code}\n" -X POST -H "$h" -H "$j" -d "{\"pin\":\"${2:?pin}\"}" "$b/driver/rides/$(ride)/start" ;;
  complete) ping 5.6942 -0.0335; curl -s -w "\ncomplete: %{http_code}\n" -X POST -H "$h" -H "$j" -d '{"location":{"lat":5.6942,"lng":-0.0335}}' "$b/driver/rides/$(ride)/complete" | tail -1 ;;
  *) echo "usage: $0 duty|status|ack|arrive|start <pin>|complete|off"; exit 1 ;;
esac
