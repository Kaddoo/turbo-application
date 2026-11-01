# 10. Log and server monitoring plan

Server: one VPS (`server1`), API and worker as systemd units (`turbo-api`, `turbo-worker`), Caddy for HTTPS, Postgres on the host, pgBackRest backups to R2. Primary log platform: **LogPulse** (via `@bevingh/telemetry`). This plan adds the pieces LogPulse cannot cover: looking at the box itself, and being told when the box or LogPulse is down.

## 1. Where every log lives today

| Source | How to read it | Notes |
| --- | --- | --- |
| API and worker | `journalctl -u turbo-api -f` and `-u turbo-worker` | JSON lines with a request id. Never contains tokens, OTPs, document URLs or full phone numbers |
| Caddy (access and errors) | `docker logs -f turbo-caddy-1` (or `journalctl -u caddy` if it moves to systemd) | JSON. Every scanner request shows here |
| Postgres | `/var/log/postgresql/postgresql-16-main.log` | Slow queries, errors, restarts |
| Backups | `/var/log/pgbackrest/*.log` and `pgbackrest info` | The only proof a backup ran |
| Logins and attacks | `/var/log/auth.log`, `fail2ban-client status sshd` | Look for `Accepted` lines from unknown IPs |
| System | `journalctl -p warning -b`, `dmesg`, `df -h`, `free -h` | Disk and memory first |

## 2. Looking at logs by hand (no extra software on the public internet)

1. **SSH + journalctl** is the baseline. Learn four commands: `journalctl -u turbo-api -f`, `--since "1 hour ago"`, `-p err`, and `| grep requestId`.
2. **lnav** (`apt install lnav`): a terminal log viewer that merges files, filters, and understands JSON. Best first tool to add.
3. **Cockpit** (`apt install cockpit`): a web dashboard with a log viewer, services and graphs. **Do not open its port (9090) in the firewall.** Reach it through an SSH tunnel: `ssh -L 9090:127.0.0.1:9090 server` and open `https://localhost:9090`.
4. Do not install anything that listens on a public port to show logs. Every such tool is one more thing to patch and attack.

## 3. Central logs (LogPulse first)

- The API sends structured events straight to LogPulse with `@bevingh/telemetry` (batching and retry already shipped). This is the main stream.
- Ship **server-level** logs too (Caddy errors, Postgres errors, auth failures) with a small forwarder such as Vector or Fluent Bit reading journald, sending only `warning` and above plus Caddy 5xx.
- **Scrub before sending.** No tokens, OTPs, signed document URLs, full phone numbers or exact driver coordinates. Do not ship every location ping.
- Open question: LogPulse's read API (`GET /api/v1/metrics`) is still a blocker, so dashboards may lag the write path. If LogPulse runs on this same server, an outage takes the logs down with it, so section 4 is mandatory.
- Backup option if LogPulse is not ready for launch: a hosted free tier such as Grafana Cloud (Loki) or Better Stack. Check current free limits and the vendor's data-location terms before sending identity-adjacent data.

## 4. Alerts: tell a person, from outside the server

Anything that lives only on the server cannot tell you the server is dead.

| Check | Tool | Alerts |
| --- | --- | --- |
| `https://api.turbogh.app/health` every 1 minute | External uptime monitor (UptimeRobot, Better Stack or similar free tier) | SMS or WhatsApp to a named person; second contact after 10 minutes |
| TLS certificate expiry | Same monitor | 14 days before expiry |
| Backup ran (heartbeat) | healthchecks.io style "dead man's switch": the backup cron pings a URL on success | No ping in 26 hours |
| Disk over 80%, memory over 90%, load | Netdata or a 20-line cron script | Email or SMS |
| Postgres not accepting connections, replication/WAL archive failing | `pgbackrest check` in cron, `pg_isready` | Heartbeat or LogPulse alert |
| Failed SSH logins spike, new `Accepted` IP | fail2ban email or LogPulse rule | Email |

## 4a. Inlet as the alert hub

Inlet's `alert` module receives every alert from sections 4 and 5, then pages by severity (`critical` pages immediately, `info` never does) and can escalate. It does **not** probe anything itself (no uptime checks), so something else must watch and report to it.

How events get in (publish the secret key only on the server, `sk_live_...`):

| Source | Route into inlet | Event type |
| --- | --- | --- |
| Rides stuck in `searching`, reconciliation difference, SOS unacknowledged, Payaza webhook failures | Turbo API / worker calls the Node SDK `inlet.sendEvent` | `custom_alert` with `title`, `severity`, `dedupeKey` |
| 5xx or error spike | Same, from the API's error handler or a worker check | `error_spike` |
| `/health` down | The external uptime monitor's outbound webhook to `POST /v1/webhooks/:productId/:sourceSlug` (signed HMAC-SHA256) | falls back to `custom_alert`, default `critical` |
| Backup heartbeat missed, disk or memory | Healthchecks-style tool or the host script, by webhook or `curl` to `/v1/events` | `custom_alert` |

Rules:
- Always set a `dedupeKey` (for example `turbo-health`, `sos-<rideId>`). Alerts dedupe for 60 minutes, so a flapping check becomes one event with a count.
- Severities: SOS and `/health` down are `critical`; stuck rides and reconciliation are `critical` or `high`; spend and disk warnings are `normal`.
- **Two independent paths.** The external uptime monitor keeps its own direct SMS or WhatsApp to a named person, in addition to the inlet webhook. SOS also gets a direct fallback (an SMS to the on-call number sent by the API itself) so one inlet failure cannot swallow it.
- Inlet must run somewhere that survives this VPS failing. If it shares the VPS, the direct path above is the only alert when the server dies.
- Test monthly: stop `turbo-worker` for two minutes and confirm inlet pages the named person and escalates if unacknowledged.
- Never put tokens, OTPs, document URLs or full phone numbers in alert payloads.

## 5. App alerts from the planning docs (wire these in LogPulse)

- Payaza webhook failures or signature rejections.
- Rides stuck in `searching` over 3 minutes.
- Wallet reconciliation difference not zero.
- SOS incident unacknowledged for 2 minutes (page a human, not email).
- 5xx rate over 2% for 5 minutes; 429 spikes; login failures per number.
- Maps spend: Google budget alerts at US$10, 25, 50 and a daily Routes quota cap.

## 6. Housekeeping

- Cap journald: `SystemMaxUse=500M`, `MaxRetentionSec=30day` in `/etc/systemd/journald.conf`.
- Docker log rotation (Caddy): `{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}` in `/etc/docker/daemon.json`.
- Keep security-relevant logs (auth, admin actions) 90 days; routine request logs 14 to 30 days. Decide with Turbo's lawyer for personal data (Act 843).
- Test the alert path once a month: stop `turbo-worker` for two minutes and confirm a human is told.

## 7. Build order

1. lnav and the four journalctl commands (10 minutes).
2. External uptime monitor on `/health` and the backup heartbeat (30 minutes). **Do this first; it is the cheapest protection.**
3. journald and Docker log caps.
4. API to LogPulse via `@bevingh/telemetry`, then the server forwarder.
5. Netdata or the disk script.
6. The app alerts in section 5.
7. Cockpit through a tunnel, only if you want a browser view.
