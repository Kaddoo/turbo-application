#!/usr/bin/env bash
# Business and liveness alerts (spec/04 section 7). Run every 2 minutes by turbo-alerts.timer.
# Prints one line per problem. If ALERT_WEBHOOK_URL is set (Slack/Discord/Better Stack incoming webhook), posts them.
# Exit code 1 when anything is wrong, so the unit shows as failed in `systemctl --failed`.
set -uo pipefail
set -a; . /etc/turbo/api.env; set +a
DB="${DATABASE_URL/6432/5432}"
sql() { psql "$DB" -Atqc "$1"; }
problems=()
add() { problems+=("$1"); }

[ "$(sql "SELECT count(*) FROM worker_heartbeat WHERE beat_at > now() - interval '60 seconds'")" = 1 ] || add "WORKER DOWN: no heartbeat for 60s (rides will not be assigned)"
n=$(sql "SELECT count(*) FROM rides WHERE status='searching' AND requested_at < now() - interval '3 minutes'"); [ "$n" = 0 ] || add "$n ride(s) searching for over 3 minutes"
n=$(sql "SELECT count(*) FROM rides WHERE flags && ARRAY['driver_unreachable','overdue'] AND status IN ('assigned','driver_arrived','in_progress')"); [ "$n" = 0 ] || add "$n active ride(s) flagged stuck (driver_unreachable/overdue): staff must act"
n=$(sql "SELECT count(*) FROM topups WHERE flagged AND resolved_at IS NULL AND completed_at > now() - interval '1 day'"); [ "$n" = 0 ] || add "$n flagged top-up(s) in the last day (finance review)"
n=$(sql "SELECT count(*) FROM incidents WHERE type='sos' AND status='open' AND created_at < now() - interval '2 minutes'"); [ "$n" = 0 ] || add "SOS: $n incident(s) unacknowledged for over 2 minutes. SOMEONE MUST ANSWER NOW"
n=$(sql "SELECT count(*) FROM topups WHERE status='pending' AND created_at < now() - interval '30 minutes'"); [ "$n" -lt 20 ] || add "$n top-ups pending over 30 min: webhook or provider problem?"
n=$(sql "SELECT count(*) FROM (SELECT w.student_id FROM wallets w LEFT JOIN (SELECT student_id, sum(amount_pesewas) b, sum(reserved_delta) r FROM ledger_entries GROUP BY 1) l USING (student_id) WHERE w.balance_pesewas <> COALESCE(l.b,0) OR w.reserved_pesewas <> COALESCE(l.r,0)) x"); [ "$n" = 0 ] || add "LEDGER MISMATCH on $n wallet(s): stop and investigate"
[ "$(df --output=pcent / | tail -1 | tr -dc 0-9)" -lt 80 ] || add "disk over 80%"
curl -fsS -m 5 http://127.0.0.1:3000/health >/dev/null || add "API /health failed"
f=/var/lib/turbo/last-backup; [ -f "$f" ] && [ "$(( $(date +%s) - $(stat -c %Y "$f") ))" -lt 93600 ] || add "no successful backup in the last 26 hours"

[ ${#problems[@]} = 0 ] && exit 0
msg="Turbo alert ($(hostname)):"
for p in "${problems[@]}"; do msg+=$'\n'"- $p"; done
echo "$msg"
[ -n "${ALERT_WEBHOOK_URL:-}" ] && curl -fsS -m 10 -H 'content-type: application/json' \
  -d "$(printf '%s' "$msg" | python3 -c 'import json,sys;print(json.dumps({"text":sys.stdin.read()}))')" "$ALERT_WEBHOOK_URL" >/dev/null || true
exit 1
