import { q } from '../db.js';
import { config } from '../config.js';
import { log } from '../app.js';
import { alert } from '../lib/alerts.js';
import { sendSms } from '../lib/notify.js';

// Worker checks that raise operational alerts. Each takes its database access and alert sink as arguments so tests can supply fakes.
// One alert per item per hour per worker process (a Map in memory); inlet also dedupes on the same key, so a restart cannot spam.

const sent = new Map();
function once(key, ttlMs = 3_600_000) {
  const now = Date.now();
  for (const [k, t] of sent) if (now - t > ttlMs) sent.delete(k);
  if (sent.has(key)) return false;
  sent.set(key, now);
  return true;
}
export const _forget = () => sent.clear();

/** A ride searching for longer than `minutes` (default 3) has no driver. Critical: a student is waiting. */
export async function alertStuckSearching({ query = q, send = alert, minutes = 3 } = {}) {
  const { rows } = await query(`SELECT id FROM rides WHERE status='searching' AND requested_at < now() - make_interval(mins => $1) AND coalesce(pickup_label,'') NOT LIKE 'TEST %' ORDER BY requested_at LIMIT 50`, [minutes]);
  let n = 0;
  for (const { id } of rows) {
    if (!once(`ride-stuck-${id}`)) continue;
    await send({ severity: 'critical', dedupeKey: `ride-stuck-${id}`, title: `Ride searching for over ${minutes} minutes`,
      detail: `Ride ${id} has no driver yet`, payload: { rideId: id, minutes } });
    n++;
  }
  return n;
}

/** An SOS nobody has acknowledged after 2 minutes. Alerts inlet and, independently, texts the on-call number. */
export async function alertUnackedSos({ query = q, send = alert, sms = sendSms, minutes = 2 } = {}) {
  const { rows } = await query(`SELECT id FROM incidents WHERE type='sos' AND status='open' AND created_at < now() - make_interval(mins => $1) ORDER BY created_at LIMIT 20`, [minutes]);
  let n = 0;
  for (const { id } of rows) {
    if (!once(`sos-${id}`)) continue;
    await send({ severity: 'critical', dedupeKey: `sos-${id}`, title: `SOS not acknowledged for ${minutes} minutes`,
      detail: `Incident ${id}. Open the admin dashboard, Incidents.`, payload: { incidentId: id, minutes } });
    const to = config.sosOncallPhone;
    if (to && /^\+\d{8,15}$/.test(to)) {
      try {
        await sms(to, `Turbo SOS not acknowledged for ${minutes} min. Incident ${id.slice(0, 8)}. Open the admin dashboard now.`);
        log.warn({ incidentId: id, to: `***${to.slice(-3)}` }, 'SOS fallback SMS sent');
      } catch (e) { log.error({ incidentId: id, to: `***${to.slice(-3)}`, err: e.message }, 'SOS fallback SMS failed'); }
    }
    n++;
  }
  return n;
}

/** Every wallet's balance and held amount must equal its ledger. Any difference is critical. Same test as scripts/ledger-check.sql. */
export async function alertWalletDrift({ query = q, send = alert } = {}) {
  const { rows: [r] } = await query(`SELECT count(*)::int AS n FROM wallets w
      LEFT JOIN (SELECT student_id, sum(amount_pesewas) b, sum(reserved_delta) r FROM ledger_entries GROUP BY 1) l USING (student_id)
      WHERE w.balance_pesewas <> COALESCE(l.b,0) OR w.reserved_pesewas <> COALESCE(l.r,0)`);
  if (!r?.n) return 0;
  if (!once('recon', 3_000_000)) return r.n;
  await send({ severity: 'critical', dedupeKey: 'recon', title: 'Wallet ledger does not match balances',
    detail: `${r.n} wallet(s) differ from their ledger. Run scripts/ledger-check.sql.`, payload: { wallets: r.n } });
  return r.n;
}

/** For a worker job that threw: high alert with the job name and error class only (never the message, which could hold values). */
export function alertWorkerError(jobName, err, send = alert) {
  return send({ severity: 'high', dedupeKey: `worker-error-${jobName}`, title: `Worker job failed: ${jobName}`,
    detail: `${err?.name || 'Error'}${err?.code ? ` (${err.code})` : ''}. See the turbo-worker log.`, payload: { job: jobName } });
}
