#!/usr/bin/env bash
# Nightly encrypted logical backup, copied off the server. Run by turbo-backup.timer as root.
# Needs in /etc/turbo/backup.env:  AGE_RECIPIENT=age1...  (public key; keep the private key OFF this server)
#                                  RCLONE_REMOTE=b2:turbo-backups   (any rclone remote; the off-box copy is the point)
set -euo pipefail
. /etc/turbo/backup.env
DIR=/var/backups/turbo; mkdir -p "$DIR" /var/lib/turbo
. <(grep -E '^DATABASE_URL=' /etc/turbo/api.env)
OUT="$DIR/turbo-$(date +%F-%H%M).dump.age"
pg_dump -Fc "${DATABASE_URL/6432/5432}" | age -r "$AGE_RECIPIENT" > "$OUT"
[ -s "$OUT" ] || { echo "empty backup"; exit 1; }
# Identity photos live on disk, not in the database: back them up too, encrypted, or a lost server loses them for good.
FILES="$DIR/turbo-uploads-$(date +%F-%H%M).tar.age"
tar -C /var/lib/turbo -cf - uploads | age -r "$AGE_RECIPIENT" > "$FILES"
[ -s "$FILES" ] || { echo "empty uploads backup"; exit 1; }
rclone copy "$FILES" "$RCLONE_REMOTE/"
rclone copy "$OUT" "$RCLONE_REMOTE/"                       # off-box. If this fails the script fails and the alert fires.
find "$DIR" \( -name 'turbo-*.dump.age' -o -name 'turbo-uploads-*.tar.age' \) -mtime +7 -delete       # keep a week locally; the remote has its own lifecycle rule
touch /var/lib/turbo/last-backup
echo "backup ok: $OUT ($(du -h "$OUT" | cut -f1))"
