#!/usr/bin/env bash
# Pretends the payment network approved the newest pending top-up on the local
# backend, by sending the signed webhook Payaza would send. Dev only.
#   tools/complete-topup.sh            succeed
#   tools/complete-topup.sh failed     fail
set -euo pipefail
export PATH=/usr/local/opt/postgresql@16/bin:$PATH
outcome="${1:-success}"
db="${DATABASE_URL:-postgres://turbo@127.0.0.1:5433/turbo_dev}"
row=$(psql "$db" -At -F'|' -c "select reference, amount_pesewas from topups where status='pending' order by created_at desc limit 1")
[ -n "$row" ] || { echo "no pending top-up"; exit 1; }
ref="${row%%|*}"; pesewas="${row##*|}"
amount=$(python3 -c "p=$pesewas; print(f'{p//100}.{p%100:02d}')")
if [ "$outcome" = failed ]; then status="Transaction Failed"; else status="Funds Received"; fi
body=$(printf '{"transaction_reference":"%s","transaction_status":"%s","amount_received":"%s"}' "$ref" "$status" "$amount")
sig=$(printf '%s' "$body" | openssl dgst -sha512 -hmac "${PAYAZA_WEBHOOK_SECRET:-dev-payaza-secret}" -binary | base64 | tr -d '\n')
curl -s -w "\nwebhook: %{http_code}\n" -X POST -H "Content-Type: application/json" -H "x-payaza-signature: $sig" -d "$body" "${API:-http://127.0.0.1:3000}/webhooks/payaza"
