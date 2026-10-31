#!/usr/bin/env bash
# One-time bootstrap for a fresh Ubuntu 24.04 VPS. Run as root:  bash setup-vps.sh api.example.com you@example.com
set -euo pipefail
DOMAIN="${1:?domain}"; EMAIL="${2:?email}"
export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get -y upgrade
apt-get -y install nginx postgresql pgbouncer ufw fail2ban certbot python3-certbot-nginx curl git unattended-upgrades age rclone postgresql-client

# Node 22 LTS
curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt-get -y install nodejs

# Firewall: only SSH + web. Postgres and PgBouncer stay on localhost.
ufw default deny incoming && ufw allow OpenSSH && ufw allow 'Nginx Full' && ufw --force enable
systemctl enable --now fail2ban

# App user and folders
id turbo &>/dev/null || useradd --system --create-home --shell /usr/sbin/nologin turbo
mkdir -p /opt/turbo /etc/turbo && chown turbo:turbo /opt/turbo

# Kernel + file limits
install -m 644 "$(dirname "$0")/sysctl-turbo.conf" /etc/sysctl.d/99-turbo.conf && sysctl --system >/dev/null
echo 'turbo soft nofile 100000' >> /etc/security/limits.d/turbo.conf; echo 'turbo hard nofile 100000' >> /etc/security/limits.d/turbo.conf

# Postgres: tuning + database + role (password printed once; put it in /etc/turbo/api.env)
PGVER=$(ls /etc/postgresql | head -1)
install -d /etc/postgresql/$PGVER/main/conf.d
install -m 644 "$(dirname "$0")/postgresql-tuning.conf" /etc/postgresql/$PGVER/main/conf.d/turbo.conf
systemctl restart postgresql
DBPASS=$(openssl rand -hex 24)
sudo -u postgres psql -c "CREATE ROLE turbo LOGIN PASSWORD '$DBPASS'" -c "CREATE DATABASE turbo OWNER turbo"
install -m 640 -o postgres -g postgres "$(dirname "$0")/pgbouncer.ini" /etc/pgbouncer/pgbouncer.ini
# PgBouncer userlist needs the SCRAM verifier of the role
sudo -u postgres psql -Atc "SELECT '\"turbo\" \"' || rolpassword || '\"' FROM pg_authid WHERE rolname='turbo'" > /etc/pgbouncer/userlist.txt
chown postgres:postgres /etc/pgbouncer/userlist.txt && chmod 640 /etc/pgbouncer/userlist.txt
systemctl enable --now pgbouncer && systemctl restart pgbouncer

# TLS first (standalone, nginx stopped), then the full nginx site that references the cert
systemctl stop nginx
certbot certonly --standalone -d "$DOMAIN" -m "$EMAIL" --agree-tos -n \
  || { echo "certbot failed: point the DNS A record at this server first, then rerun this script"; exit 1; }
sed "s/api.example.com/$DOMAIN/g" "$(dirname "$0")/nginx.conf" > /etc/nginx/sites-available/turbo-api
ln -sf /etc/nginx/sites-available/turbo-api /etc/nginx/sites-enabled/turbo-api && rm -f /etc/nginx/sites-enabled/default
sed -i 's/^worker_processes.*/worker_processes auto;\nworker_rlimit_nofile 100000;/' /etc/nginx/nginx.conf
sed -i 's/worker_connections.*/worker_connections 20000;/' /etc/nginx/nginx.conf
nginx -t && systemctl enable --now nginx && systemctl reload nginx
echo '0 3 * * * root certbot renew -q --deploy-hook "systemctl reload nginx"' > /etc/cron.d/certbot-turbo

# systemd units
install -m 644 "$(dirname "$0")/turbo-api.service" /etc/systemd/system/turbo-api.service
install -m 644 "$(dirname "$0")/turbo-worker.service" /etc/systemd/system/turbo-worker.service
for u in turbo-backup turbo-alerts; do
  install -m 644 "$(dirname "$0")/$u.service" /etc/systemd/system/$u.service
  install -m 644 "$(dirname "$0")/$u.timer" /etc/systemd/system/$u.timer
done
mkdir -p /var/lib/turbo /var/backups/turbo /var/lib/turbo/uploads
chown turbo:turbo /var/lib/turbo/uploads && chmod 700 /var/lib/turbo/uploads      # identity documents: only the API user can read them
systemctl daemon-reload
# Timers start after you create /etc/turbo/backup.env (see backup.env.example) and /etc/turbo/api.env:
#   systemctl enable --now turbo-backup.timer turbo-alerts.timer

cat <<MSG

Done. Next:
 1. Create /etc/turbo/api.env (chmod 600, owner turbo) from .env.example with:
      DATABASE_URL=postgres://turbo:$DBPASS@127.0.0.1:6432/turbo
      the production template: deploy/api.env.example (every REQUIRED line must be filled or the API will not start)
 2. Create /etc/turbo/backup.env from deploy/backup.env.example, run 'rclone config' for the off-box remote,
    generate an age key ON YOUR LAPTOP (age-keygen) and put only the PUBLIC key in backup.env.
 3. Run deploy.sh to ship the code, then create the first super admin (spec/04 section 4).
 4. systemctl enable --now turbo-backup.timer turbo-alerts.timer
MSG
