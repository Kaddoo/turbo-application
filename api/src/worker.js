// Background worker. On a VPS this is a normal always-on process (the Cloud Run "no timers" rule does not apply).
// Every step is idempotent and uses FOR UPDATE SKIP LOCKED, so running 2 workers is safe.
import { q, tx, pool } from './db.js';
import { log } from './app.js';
import { getSettings } from './lib/settings.js';
import { cancelRide, event } from './domain/rides.js';
import { rideAssigned, notifyStaff } from './domain/notify.js';
import { pushProvider } from './lib/push.js';
import { config } from './config.js';
import * as storage from './lib/storage.js';
import { purgeDocuments } from './domain/retention.js';
import { provider } from './lib/payments.js';
import { applyOutcome, receivedPesewas } from './domain/topups.js';
import { announceAlerts } from './lib/alerts.js';
import { announceLogpulse, startHealthPing } from './lib/logpulse.js';
import { alertStuckSearching, alertUnackedSos, alertWalletDrift, alertWorkerError } from './domain/alert_jobs.js';

async function assign(cfg) {
  const rides = (await q(`SELECT id FROM rides WHERE status='searching' ORDER BY requested_at LIMIT 50`)).rows;
  for (const { id } of rides) {
    await tx(async (c) => {
      const { rows: [ride] } = await c.query(`SELECT * FROM rides WHERE id=$1 AND status='searching' FOR UPDATE SKIP LOCKED`, [id]);
      if (!ride) return;
      if (Date.now() - new Date(ride.requested_at).getTime() > cfg.noDriverTimeoutSeconds * 1000) {
        await cancelRide(c, ride, 'system', 'no_driver_available'); return;
      }
      // Nearest idle on-duty driver seen recently, not already declined for this ride (D8).
      const { rows: cands } = await c.query(
        `SELECT d.user_id FROM drivers d JOIN driver_presence p ON p.driver_id=d.user_id
          WHERE d.on_duty AND d.active AND p.seen_at > now() - make_interval(secs => $4)
            AND NOT EXISTS (SELECT 1 FROM rides r WHERE r.driver_id=d.user_id AND r.status IN ('assigned','driver_arrived','in_progress'))
            AND NOT EXISTS (SELECT 1 FROM ride_declines x WHERE x.ride_id=$1 AND x.driver_id=d.user_id)
          ORDER BY (p.lat-$2)^2 + ((p.lng-$3)*cos(radians($2)))^2 LIMIT 5
          FOR UPDATE OF d SKIP LOCKED`, [ride.id, ride.pickup_lat, ride.pickup_lng, cfg.presenceFreshSeconds]);
      for (const cand of cands) {
        await c.query('SAVEPOINT pick');
        try {
          await c.query(`UPDATE rides SET status='assigned', driver_id=$2, assigned_at=now(), acked_at=NULL,
                         ack_deadline=now() + make_interval(secs => $3) WHERE id=$1`, [ride.id, cand.user_id, cfg.driverAckTimeoutSeconds]);
          await event(c, ride.id, 'assigned', 'system', null, { driverId: cand.user_id });
          await rideAssigned(c, ride, cand.user_id);
          return;
        } catch (e) {
          if (e.code !== '23505') throw e;     // lost a race for this driver: the unique index said no, try the next
          await c.query('ROLLBACK TO pick');
        }
      }
    });
  }
}

async function ackTimeouts() {
  const rows = (await q(`SELECT id FROM rides WHERE status='assigned' AND acked_at IS NULL AND ack_deadline < now() LIMIT 100`)).rows;
  for (const { id } of rows) await tx(async (c) => {
    const { rows: [r] } = await c.query(`SELECT * FROM rides WHERE id=$1 AND status='assigned' AND acked_at IS NULL AND ack_deadline < now() FOR UPDATE SKIP LOCKED`, [id]);
    if (!r) return;
    await c.query(`INSERT INTO ride_declines (ride_id,driver_id,reason) VALUES ($1,$2,'ack_timeout')`, [r.id, r.driver_id]);
    await c.query(`UPDATE rides SET status='searching', driver_id=NULL, assigned_at=NULL, ack_deadline=NULL WHERE id=$1`, [r.id]);
    await event(c, r.id, 'ack_timeout', 'system', null, { driverId: r.driver_id });
  });
}

// F-01: flag, never auto-cancel. A person decides, so dispatchers are pushed the moment a ride is flagged.
async function stuckRides(cfg) {
  const flagged = [
    ...(await q(`UPDATE rides r SET flags = array_append(flags,'driver_unreachable')
            WHERE status IN ('assigned','driver_arrived','in_progress') AND NOT 'driver_unreachable' = ANY(flags)
              AND NOT EXISTS (SELECT 1 FROM driver_presence p WHERE p.driver_id=r.driver_id AND p.seen_at > now() - make_interval(secs => $1)) RETURNING id`, [cfg.driverSilenceSeconds])).rows.map((r) => [r.id, 'driver_unreachable']),
    ...(await q(`UPDATE rides SET flags = array_append(flags,'overdue')
            WHERE status='in_progress' AND NOT 'overdue' = ANY(flags) AND started_at < now() - make_interval(secs => duration_s * 2 + 600) RETURNING id`)).rows.map((r) => [r.id, 'overdue']),
  ];
  for (const [id, flag] of flagged) await notifyStaff({ query: q }, ['dispatcher'], 'ride_stuck', { data: { rideId: id, flag }, dedupe: `stuck:${id}:${flag}` });
}

// Money must not depend on a webhook arriving. Ask the provider about top-ups that are still open
// (or were abandoned in the last 2 days: a late approval is still the student's money).
async function reconcileTopups() {
  const rows = (await q(`SELECT reference FROM topups WHERE status IN ('pending','abandoned')
      AND created_at < now() - interval '10 minutes' AND created_at > now() - interval '2 days'
      AND (last_checked_at IS NULL OR last_checked_at < now() - interval '9 minutes')
      ORDER BY last_checked_at NULLS FIRST LIMIT 50`)).rows;
  for (const { reference } of rows) {
    try {
      const r = await provider().checkStatus({ reference });
      await q('UPDATE topups SET last_checked_at=now() WHERE reference=$1', [reference]);
      if (r.status === 'success') {
        if (r.amountReceived == null) { log.error({ reference }, 'provider says paid but gave no amount: finance must resolve'); await q('UPDATE topups SET flagged=true WHERE reference=$1', [reference]); continue; }
        const res = await tx((c) => applyOutcome(c, 'payaza', reference, 'success', { source: 'reconcile', ...r }, { received: receivedPesewas(r.amountReceived) }));
        log.warn({ reference, res }, 'top-up settled by reconciliation (webhook was missed)');
      } else if (r.status === 'failed') {
        await tx((c) => applyOutcome(c, 'payaza', reference, 'failed', { source: 'reconcile' }));
      }
    } catch (e) { log.error({ reference, err: e.message }, 'top-up status check failed'); }
  }
}

// ---- push delivery ---------------------------------------------------------------------------------------------------------------
// Claim a batch (urgent first). Claiming pushes next_attempt_at 30 s ahead, so a worker that dies mid-send simply gets retried, and two
// workers never take the same row. Then deliver to each of the user's devices; the row is "sent" if at least one device accepted it.
const BACKOFF = [15, 60, 300, 900, 3600];                      // seconds before attempt 2, 3, 4, 5...
async function sendPushes() {
  const { rows } = await q(`UPDATE notifications SET attempts = attempts + 1, next_attempt_at = now() + interval '30 seconds'
      WHERE id IN (SELECT id FROM notifications WHERE status='pending' AND next_attempt_at <= now() ORDER BY priority DESC, id LIMIT 200 FOR UPDATE SKIP LOCKED) RETURNING *`);
  if (!rows.length) return;
  const provider = pushProvider();
  const one = async (n) => {
    if (new Date(n.expires_at) < new Date()) return q(`UPDATE notifications SET status='skipped', last_error='expired before delivery' WHERE id=$1`, [n.id]);
    const { rows: devs } = await q('SELECT id, fcm_token, platform FROM devices WHERE user_id=$1 AND user_type=$2', [n.user_id, n.user_type]);
    if (!devs.length) return q(`UPDATE notifications SET status='skipped', last_error='no registered device' WHERE id=$1`, [n.id]);
    const ttl = Math.max(30, Math.floor((new Date(n.expires_at) - Date.now()) / 1000));
    const results = await Promise.all(devs.map(async (d) => ({ d, r: await provider.send({ token: d.fcm_token, title: n.title, body: n.body, data: n.data, ttlSeconds: ttl, priority: n.priority, collapseKey: n.data?.rideId ? `${n.kind}:${n.data.rideId}` : undefined }) })));
    const dead = results.filter((x) => x.r.status === 'gone').map((x) => x.d.id);
    if (dead.length) await q('DELETE FROM devices WHERE id = ANY($1)', [dead]);                  // uninstalled apps stop costing us a call every time
    const sent = results.some((x) => x.r.status === 'sent');
    if (sent) return q(`UPDATE notifications SET status='sent', sent_at=now(), last_error=NULL WHERE id=$1`, [n.id]);
    const retry = results.find((x) => x.r.status === 'retry');
    if (retry && n.attempts < BACKOFF.length + 1)
      return q(`UPDATE notifications SET next_attempt_at = now() + make_interval(secs => $2), last_error=$3 WHERE id=$1`, [n.id, retry.r.retryAfterSeconds ?? BACKOFF[n.attempts - 1], retry.r.error]);
    const why = results.map((x) => x.r.error).filter(Boolean)[0] ?? 'undeliverable';
    return q(`UPDATE notifications SET status=$2, last_error=$3 WHERE id=$1`, [n.id, dead.length === devs.length ? 'skipped' : 'failed', why]);
  };
  // 25 at a time: enough to clear a 5,000-device announcement in well under a minute without hammering Google
  for (let i = 0; i < rows.length; i += 25) await Promise.all(rows.slice(i, i + 25).map((n) => one(n).catch((e) => log.error({ err: e.message, id: n.id }, 'push send crashed'))));
}

// Staff are warned 30 days ahead when a driver's licence, insurance or roadworthy certificate is about to expire (contract). One push per document per day at most.
async function expiringDocuments() {
  const { rows } = await q(`SELECT d.id, d.type, d.expires_on, COALESCE(u.full_name, u.first_name, 'A driver') AS name FROM driver_documents d JOIN users u ON u.id=d.driver_id
      WHERE d.deleted_at IS NULL AND d.expires_on IS NOT NULL AND d.expires_on <= current_date + 30 AND d.expires_on >= current_date - 7 LIMIT 200`);
  for (const d of rows) await notifyStaff({ query: q }, ['hr'], 'document_expiring', {
    vars: { body: `${d.name}: ${d.type.replace('_', ' ')} expires on ${new Date(d.expires_on).toISOString().slice(0, 10)}.` }, data: { documentId: d.id }, dedupe: `docexp:${d.id}:${new Date().toISOString().slice(0, 10)}` });
}

async function housekeeping() {
  await expiringDocuments();
  await q(`DELETE FROM notifications WHERE created_at < now() - interval '14 days'`);
  await q(`DELETE FROM devices WHERE failures >= 5`);
  await reconcileTopups();
  await alertWalletDrift();
  await purgeDocuments((await getSettings()).documentRetentionDays);
  // Unused upload slots and abandoned PUTs older than a day
  for (const u of (await q(`SELECT id,storage_key FROM uploads WHERE used_at IS NULL AND status<>'purged' AND created_at < now() - interval '1 day' AND purpose NOT IN ('driver_document','vehicle_document','provider_statement') LIMIT 200`)).rows) {
    await storage.remove(u.storage_key); await q(`UPDATE uploads SET status='purged', purged_at=now() WHERE id=$1`, [u.id]);
  }
  await q(`DELETE FROM driver_locations WHERE recorded_at < now() - make_interval(days => $1)`, [(await getSettings()).locationRetentionDays]);        // D24
  await q(`DELETE FROM idempotency_keys WHERE created_at < now() - interval '2 days'`);
  await q(`DELETE FROM otp_challenges WHERE created_at < now() - interval '1 day'`);
  await q(`UPDATE topups SET status='abandoned', completed_at=now() WHERE status='pending' AND created_at < now() - interval '1 hour'`);
}

// Runs one job. A failure is logged and alerted (high, once an hour per job), and the other jobs still run.
async function guarded(name, fn) {
  try { await fn(); } catch (e) { log.error({ err: e.message, job: name }, 'worker job failed'); alertWorkerError(name, e).catch(() => {}); }
}

let busy = false, last = 0, beat = 0, lastAlertCheck = 0;
async function tick() {
  if (busy) return; busy = true;
  try {
    if (Date.now() - beat > 10_000) { beat = Date.now(); await q('UPDATE worker_heartbeat SET beat_at=now(), pid=$1 WHERE id=1', [process.pid]); }
    const cfg = await getSettings();
    await guarded('assign', () => assign(cfg)); await guarded('ackTimeouts', ackTimeouts); await guarded('stuckRides', () => stuckRides(cfg));
    // Alert checks once a minute: a ride with no driver for 3 minutes, an SOS nobody has acknowledged for 2.
    if (Date.now() - lastAlertCheck > 60_000) {
      lastAlertCheck = Date.now();
      await guarded('alertStuckSearching', () => alertStuckSearching()); await guarded('alertUnackedSos', () => alertUnackedSos());
    }
    if (Date.now() - last > 600_000) { last = Date.now(); await guarded('housekeeping', housekeeping); }
  } catch (e) { log.error({ err: e.message }, 'worker tick failed'); alertWorkerError('tick', e).catch(() => {}); }
  finally { busy = false; }
}

// Push delivery has its own loop: if Google is slow, rides are still assigned on time.
let pushBusy = false;
async function pushTick() {
  if (pushBusy) return; pushBusy = true;
  try { await sendPushes(); } catch (e) { log.error({ err: e.message }, 'push tick failed'); alertWorkerError('sendPushes', e).catch(() => {}); }
  finally { pushBusy = false; }
}

log.info({ push: config.pushProvider }, 'worker started');
announceAlerts(log); announceLogpulse(log); startHealthPing();
const t = setInterval(tick, 2000), pt = setInterval(pushTick, 1000);
const stop = async () => { clearInterval(t); clearInterval(pt); for (let i = 0; (busy || pushBusy) && i < 100; i++) await new Promise((r) => setTimeout(r, 100)); await pool.end(); process.exit(0); };
process.on('SIGTERM', stop); process.on('SIGINT', stop);
tick(); pushTick();
