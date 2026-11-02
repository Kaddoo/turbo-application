// Approves a top-up by hand, for staging while the payment provider is not connected (or a real payment is stuck): it credits the
// student's wallet through the same code path the Payaza webhook uses (domain/topups.js), so the ledger, the notification and the
// idempotency rules are identical. Dry run unless you pass --yes. Refuses unless ALLOW_MANUAL_TOPUP=true is in the command's environment.
//
//   List open top-ups:
//     ALLOW_MANUAL_TOPUP=true node --env-file=/etc/turbo/api.env scripts/approve-topup.js --list
//   Approve one the student already made in the app (by reference):
//     ... scripts/approve-topup.js --ref TU1234abcd --yes
//   Give a student money without a top-up in the app (creates a MANUAL top-up of GHS 50 and approves it):
//     ... scripts/approve-topup.js --phone +233200000003 --amount 50 --yes
//   --amount on its own with --ref credits that many cedis instead of the requested amount (the top-up is then flagged for finance).
//
// Every approval is written to the audit log. Phone numbers are masked in the output.
import crypto from 'node:crypto';
import os from 'node:os';
import { pool, tx } from '../src/db.js';
import { getSettings } from '../src/lib/settings.js';
import { applyOutcome } from '../src/domain/topups.js';

const arg = (name) => { const i = process.argv.indexOf(name); return i === -1 ? undefined : (process.argv[i + 1]?.startsWith('--') ? true : process.argv[i + 1] ?? true); };
const mask = (p) => (p ? `${p.slice(0, 7)} *** ${p.slice(-3)}` : '?');
const cedis = (pesewas) => `GH₵${(pesewas / 100).toFixed(2)}`;
const fail = (msg) => { console.error(msg); process.exitCode = 1; };

async function main() {
  if (process.env.ALLOW_MANUAL_TOPUP !== 'true') return fail('Refusing: set ALLOW_MANUAL_TOPUP=true for this one command to confirm you mean to credit a wallet by hand.');
  const yes = process.argv.includes('--yes');
  const ref = arg('--ref'), phone = arg('--phone'), amountArg = arg('--amount');
  const amountPesewas = amountArg === undefined || amountArg === true ? undefined : Math.round(Number(amountArg) * 100);
  if (amountPesewas !== undefined && (!Number.isInteger(amountPesewas) || amountPesewas <= 0)) return fail('--amount must be a positive number of cedis, for example 50');

  if (process.argv.includes('--list') || (!ref && !phone)) {
    const { rows } = await pool.query(
      `SELECT t.reference, t.amount_pesewas, t.network, t.created_at, u.phone FROM topups t JOIN users u ON u.id=t.student_id
        WHERE t.status='pending' ORDER BY t.created_at DESC LIMIT 25`);
    if (!rows.length) console.log('No open top-ups.');
    for (const r of rows) console.log(`${r.reference}  ${cedis(r.amount_pesewas).padEnd(10)} ${String(r.network ?? '').padEnd(8)} ${mask(r.phone)}  ${r.created_at.toISOString()}`);
    return;
  }

  let topup;
  if (ref) {
    ({ rows: [topup] } = await pool.query(`SELECT * FROM topups WHERE reference=$1`, [ref]));
    if (!topup) return fail(`No top-up with reference ${ref}.`);
    if (topup.status === 'succeeded') return fail('That top-up is already succeeded; nothing to do.');
  } else {
    const { rows: [u] } = await pool.query(`SELECT u.id, u.phone FROM users u JOIN students s ON s.user_id=u.id WHERE u.phone=$1`, [phone]);
    if (!u) return fail(`No student with the phone ${mask(phone)}.`);
    ({ rows: [topup] } = await pool.query(`SELECT * FROM topups WHERE student_id=$1 AND status='pending' ORDER BY created_at DESC LIMIT 1`, [u.id]));
    if (!topup) {
      if (!amountPesewas) return fail('That student has no open top-up. Pass --amount <cedis> to create one and approve it.');
      const cfg = await getSettings();
      if (amountPesewas < cfg.minTopupPesewas || amountPesewas > cfg.maxTopupPesewas) return fail(`Amount must be between ${cedis(cfg.minTopupPesewas)} and ${cedis(cfg.maxTopupPesewas)}.`);
      topup = { id: null, student_id: u.id, amount_pesewas: amountPesewas, reference: 'MANUAL-' + crypto.randomBytes(5).toString('hex'), network: null, create: true };
    }
  }
  const received = amountPesewas ?? topup.amount_pesewas;
  console.log(`${yes ? 'Approving' : 'Would approve'} ${topup.reference}: credit ${cedis(received)}${topup.create ? ' (new MANUAL top-up)' : ''}${received !== topup.amount_pesewas ? ` — the student asked for ${cedis(topup.amount_pesewas)}, so it will be flagged for finance` : ''}.`);
  if (!yes) return console.log('Dry run. Add --yes to do it.');

  const outcome = await tx(async (c) => {
    if (topup.create) await c.query(`INSERT INTO topups (student_id,amount_pesewas,reference,network,channel) VALUES ($1,$2,$3,$4,'mobile_money')`, [topup.student_id, topup.amount_pesewas, topup.reference, topup.network]);
    const result = await applyOutcome(c, 'manual', topup.reference, 'success', { by: os.userInfo().username, at: new Date().toISOString() }, { received });
    await c.query(`INSERT INTO audit_log (actor_type,actor_id,action,target,data) VALUES ('system',NULL,'topup.manual_approve',$1,$2)`,
      [topup.reference, JSON.stringify({ result, receivedPesewas: received, by: os.userInfo().username })]);
    return result;
  });
  console.log(outcome === 'credited' ? `Done: ${cedis(received)} added to the wallet.` : `Not credited: ${outcome}.`);
  if (outcome !== 'credited') process.exitCode = 1;
}
try { await main(); } finally { await pool.end(); }
