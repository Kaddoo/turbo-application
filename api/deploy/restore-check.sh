#!/usr/bin/env bash
# Prove a backup restores. Run on a scratch machine (or this one) with the PRIVATE age key:
#   AGE_KEY=~/age.key bash restore-check.sh turbo-2026-11-01-0230.dump.age
# Restores into a throwaway database and runs the ledger check. "A backup never restored is a hope."
set -euo pipefail
FILE="${1:?backup file}"; KEY="${AGE_KEY:?path to age private key}"
DB="turbo_restore_check"
dropdb --if-exists "$DB"; createdb "$DB"
age -d -i "$KEY" "$FILE" | pg_restore --no-owner -d "$DB"
rows=$(psql "$DB" -Atq -f "$(dirname "$0")/../scripts/ledger-check.sql" | wc -l)
echo "wallets: $(psql "$DB" -Atqc 'select count(*) from wallets'), rides: $(psql "$DB" -Atqc 'select count(*) from rides'), ledger mismatches: $rows"
dropdb "$DB"
[ "$rows" = 0 ] && echo "RESTORE OK" || { echo "RESTORE RESTORED BUT LEDGER DOES NOT ADD UP"; exit 1; }
