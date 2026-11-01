#!/usr/bin/env bash
# Decide a student's verification on the local backend, as the demo verifier.
#   tools/review-student.sh +233241110001 approved
#   tools/review-student.sh +233241110001 needs_attention "The back of your card is blurry."
#   tools/review-student.sh +233241110001 rejected "The names did not match."
set -euo pipefail
phone="${1:?phone like +233241110001}"; decision="${2:?approved|rejected|needs_attention}"; message="${3:-}"
b="${API:-http://127.0.0.1:3000}"; j='Content-Type: application/json'
tok=$(curl -s -X POST -H "$j" -d '{"email":"verifier@turbo.test","password":"Turbo-demo-1"}' "$b/auth/admin/login" | python3 -c "import sys,json;print(json.load(sys.stdin)['accessToken'])")
h="Authorization: Bearer $tok"
id=$(curl -s -H "$h" "$b/admin/verifications?status=pending" | python3 -c "
import sys,json
d=json.load(sys.stdin)
rows=d.get('data',d if isinstance(d,list) else [])
phone='$phone'
hit=[r for r in rows if phone in json.dumps(r)]
print((hit or rows)[0]['id'] if (hit or rows) else '')")
[ -n "$id" ] || { echo "no pending verification found"; exit 1; }
curl -s -o /dev/null -X POST -H "$h" "$b/admin/verifications/$id/claim" || true
body=$(python3 -c "import json;print(json.dumps({k:v for k,v in {'decision':'$decision','studentMessage':'$message' or None,'reasonCode':'other' if '$decision'!='approved' else None}.items() if v}))")
# The response carries signed links to the documents, so only the result is shown.
curl -s -X POST -H "$h" -H "$j" -d "$body" "$b/admin/verifications/$id/decision" \
  | python3 -c "import sys,json;d=json.load(sys.stdin);print('student is now:', d.get('status', d.get('title')))"
