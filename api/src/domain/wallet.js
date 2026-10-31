import { ApiError } from '../lib/errors.js';

// All wallet mutations take a client inside a transaction and lock the wallet row first.
export async function lockWallet(c, studentId) {
  const { rows } = await c.query('SELECT * FROM wallets WHERE student_id=$1 FOR UPDATE', [studentId]);
  if (!rows[0]) throw new ApiError(404, 'not_found', 'Wallet not found');
  return rows[0];
}

async function entry(c, e) {
  await c.query(
    `INSERT INTO ledger_entries (student_id,type,amount_pesewas,reserved_delta,ride_id,ref,note,created_by)
     VALUES ($1,$2,$3,$4,$5,$6,$7,$8)`,
    [e.studentId, e.type, e.amount ?? 0, e.reserved ?? 0, e.rideId ?? null, e.ref ?? null, e.note ?? null, e.by ?? null]);
}

export async function credit(c, studentId, pesewas, type, o = {}) {
  await lockWallet(c, studentId);
  await c.query('UPDATE wallets SET balance_pesewas = balance_pesewas + $2 WHERE student_id=$1', [studentId, pesewas]);
  await entry(c, { studentId, type, amount: pesewas, ...o });
}

export async function debitAdjustment(c, studentId, pesewas, o = {}) {
  const w = await lockWallet(c, studentId);
  if (w.balance_pesewas - w.reserved_pesewas < pesewas) throw new ApiError(409, 'insufficient_balance', 'Adjustment would take the wallet below zero');
  await c.query('UPDATE wallets SET balance_pesewas = balance_pesewas - $2 WHERE student_id=$1', [studentId, pesewas]);
  await entry(c, { studentId, type: 'adjustment', amount: -pesewas, ...o });
}

export async function hold(c, studentId, rideId, pesewas) {
  const w = await lockWallet(c, studentId);
  if (w.balance_pesewas - w.reserved_pesewas < pesewas)
    throw new ApiError(409, 'insufficient_balance', 'Wallet cannot cover the fare', { detail: `Short by ${pesewas - (w.balance_pesewas - w.reserved_pesewas)} pesewas` });
  await c.query('UPDATE wallets SET reserved_pesewas = reserved_pesewas + $2 WHERE student_id=$1', [studentId, pesewas]);
  await c.query('INSERT INTO holds (ride_id,student_id,amount_pesewas) VALUES ($1,$2,$3)', [rideId, studentId, pesewas]);
  await entry(c, { studentId, type: 'ride_hold', reserved: pesewas, rideId });
}

// Idempotent: a hold already settled is left alone.
export async function release(c, studentId, rideId) {
  await lockWallet(c, studentId);
  const { rows } = await c.query(`UPDATE holds SET status='released' WHERE ride_id=$1 AND status='open' RETURNING amount_pesewas`, [rideId]);
  if (!rows[0]) return;
  await c.query('UPDATE wallets SET reserved_pesewas = reserved_pesewas - $2 WHERE student_id=$1', [studentId, rows[0].amount_pesewas]);
  await entry(c, { studentId, type: 'ride_release', reserved: -rows[0].amount_pesewas, rideId });
}

export async function charge(c, studentId, rideId) {
  await lockWallet(c, studentId);
  const { rows } = await c.query(`UPDATE holds SET status='charged' WHERE ride_id=$1 AND status='open' RETURNING amount_pesewas`, [rideId]);
  if (!rows[0]) return 0;
  const a = rows[0].amount_pesewas;
  await c.query('UPDATE wallets SET balance_pesewas = balance_pesewas - $2, reserved_pesewas = reserved_pesewas - $2 WHERE student_id=$1', [studentId, a]);
  await entry(c, { studentId, type: 'ride_charge', amount: -a, reserved: -a, rideId });
  return a;
}

export async function refund(c, studentId, rideId, pesewas, o = {}) {
  const { rows: [r] } = await c.query(
    `SELECT COALESCE(SUM(-amount_pesewas) FILTER (WHERE type='ride_charge'),0) AS charged,
            COALESCE(SUM(amount_pesewas) FILTER (WHERE type='refund'),0) AS refunded
       FROM ledger_entries WHERE ride_id=$1`, [rideId]);
  if (Number(r.refunded) + pesewas > Number(r.charged))
    throw new ApiError(409, 'refund_exceeds_charge', 'Refund would exceed the amount charged');
  await credit(c, studentId, pesewas, 'refund', { rideId, ...o });
}

export const walletView = (w) => ({
  balancePesewas: w.balance_pesewas, reservedPesewas: w.reserved_pesewas,
  availablePesewas: w.balance_pesewas - w.reserved_pesewas, currency: 'GHS', owedPesewas: null,
});
