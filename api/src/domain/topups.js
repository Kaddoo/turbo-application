import { cedisToPesewas } from '../lib/util.js';
import * as wallet from './wallet.js';
import { notifyUser } from './notify.js';

// The one place a provider outcome becomes money. Used by the webhook and by the reconciliation job,
// so both obey the same rules. Runs inside the caller's transaction.
//   outcome: 'success' | 'failed'.  received: pesewas actually received (success only).
// A late success is credited even if the top-up was already marked abandoned or failed: the student paid.
export async function applyOutcome(c, provider, ref, outcome, payload, { received, validation } = {}) {
  const ins = await c.query(`INSERT INTO provider_events (provider,reference,outcome,payload) VALUES ($1,$2,$3,$4) ON CONFLICT DO NOTHING RETURNING 1`,
    [provider, ref, outcome, JSON.stringify(payload)]);
  if (!ins.rowCount) return 'duplicate';                      // (provider, reference, outcome) is unique: a replay changes nothing
  const { rows: [t] } = await c.query('SELECT * FROM topups WHERE reference=$1 FOR UPDATE', [ref]);
  if (!t) return 'unknown_reference';
  if (t.status === 'succeeded') return 'already_final';
  if (outcome === 'failed') {
    if (t.status !== 'pending') return 'already_final';
    await c.query(`UPDATE topups SET status='failed', completed_at=now() WHERE id=$1`, [t.id]);
    return 'failed';
  }
  // Even a correctly signed message cannot credit more than twice the requested amount without a human looking: bound the damage
  // of a provider bug or a leaked webhook secret. The money is held in a flagged top-up for finance instead of credited.
  if (!Number.isInteger(received) || received <= 0 || received > t.amount_pesewas * 2) {
    await c.query('UPDATE topups SET flagged=true, validation=$2 WHERE id=$1', [t.id, 'AMOUNT_OUT_OF_RANGE']);
    return 'held_for_review';
  }
  const v = validation || (received === t.amount_pesewas ? 'EXACT' : 'MISMATCH');
  await wallet.credit(c, t.student_id, received, 'topup', { ref });                       // credit what was actually received
  await c.query(`UPDATE topups SET status='succeeded', amount_received_pesewas=$2, validation=$3, flagged=$4, completed_at=now() WHERE id=$1`,
    [t.id, received, v, v !== 'EXACT']);
  await notifyUser(c, t.student_id, 'topup_succeeded', { vars: { amount: received }, data: { topupId: t.id }, dedupe: `topup:${t.id}` });
  return 'credited';
}

export const receivedPesewas = (amountReceived) => cedisToPesewas(amountReceived ?? 0);
