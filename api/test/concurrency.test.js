// Money safety under contention (spec/02 "five safety mechanisms"). Needs the running API and worker.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import { call, expect, login, pool, closeDb, uuid, approvedStudent, soleDriver, PICK, DROP } from './walk-helpers.js';
import { sign } from '../src/lib/payments.js';
after(closeDb);

const hook = (body) => { const raw = JSON.stringify(body); return call('POST', '/webhooks/payaza', { raw, headers: { 'x-payaza-signature': sign(Buffer.from(raw)), 'content-type': 'application/json' } }); };
const topup = async (s, amountPesewas = 2000) => expect(await call('POST', '/wallet/topups', { token: s.accessToken, body: { amountPesewas, channel: 'mobile_money' }, idem: true }), 201);
const quote = async (s) => expect(await call('POST', '/rides/quote', { token: s.accessToken, body: { pickup: PICK, dropoff: DROP } }), 200);
const bookWith = (s, q) => call('POST', '/rides', { token: s.accessToken, body: { quoteId: q.quoteId }, idem: true });
const balance = async (s) => expect(await call('GET', '/wallet', { token: s.accessToken }), 200);

test('webhook replayed 10x in parallel credits exactly once', async () => {
  const s = await approvedStudent(), tu = await topup(s);
  await Promise.all(Array.from({ length: 10 }, () => hook({ transaction_reference: tu.reference, transaction_status: 'Funds Received', amount_received: '20.00', amount_validation: 'EXACT' })));
  assert.equal((await balance(s)).balancePesewas, 2000);
});

test('underpayment credits what was received and is flagged for finance', async () => {
  const s = await approvedStudent(), tu = await topup(s);
  await hook({ transaction_reference: tu.reference, transaction_status: 'Funds Received', amount_received: '15.50', amount_validation: 'UNDERPAYMENT' });
  assert.equal((await balance(s)).balancePesewas, 1550);
  assert.equal((await pool.query('SELECT flagged FROM topups WHERE reference=$1', [tu.reference])).rows[0].flagged, true);
});

test('unsigned or tampered webhook is rejected', async () => {
  const raw = JSON.stringify({ transaction_reference: 'x', transaction_status: 'Funds Received', amount_received: '1.00' });
  assert.equal((await call('POST', '/webhooks/payaza', { raw, headers: { 'x-payaza-signature': 'bad', 'content-type': 'application/json' } })).status, 401);
  assert.equal((await call('POST', '/webhooks/payaza', { raw, headers: { 'content-type': 'application/json' } })).status, 401, 'missing signature');
});

test('two simultaneous bookings by one student: exactly one ride, one hold', async () => {
  await soleDriver();
  const s = await approvedStudent(20000);
  const q1 = await quote(s), q2 = await quote(s);
  assert.ok(q1.eligible, JSON.stringify(q1));
  const res = await Promise.all([bookWith(s, q1), bookWith(s, q2)]);
  assert.deepEqual(res.map((r) => r.status).sort(), [201, 409]);
  assert.equal(res.find((r) => r.status === 409).body.code, 'active_ride_exists');
  assert.equal((await balance(s)).reservedPesewas, q1.farePesewas, 'one hold only');
  await call('POST', `/rides/${res.find((r) => r.status === 201).body.id}/cancel`, { token: s.accessToken, body: {} });
});

test('wallet can never be overspent by racing bookings from several quotes', async () => {
  await soleDriver();
  const s = await approvedStudent(5000);                   // exactly one fare
  const qs = await Promise.all([1, 2, 3].map(() => quote(s)));
  const res = await Promise.all(qs.map((q) => bookWith(s, q)));
  assert.equal(res.filter((r) => r.status === 201).length, 1);
  const { rows: [w] } = await pool.query('SELECT * FROM wallets WHERE student_id=$1', [s.user.id]);
  assert.ok(w.balance_pesewas >= w.reserved_pesewas && w.reserved_pesewas >= 0);
  await call('POST', `/rides/${res.find((r) => r.status === 201).body.id}/cancel`, { token: s.accessToken, body: {} });
});

test('a booking the wallet cannot cover is a 409 insufficient_balance, with nothing held', async () => {
  await soleDriver();
  const s = await approvedStudent(100);
  const q = await quote(s);
  assert.equal(q.wallet.sufficient, false); assert.ok(q.wallet.shortfallPesewas > 0);
  const r = await bookWith(s, q);
  assert.equal(r.status, 409); assert.equal(r.body.code, 'insufficient_balance');
  assert.equal((await balance(s)).reservedPesewas, 0);
});

test('double cancel in parallel releases the hold exactly once', async () => {
  await soleDriver();
  const s = await approvedStudent(10000);
  const ride = expect(await bookWith(s, await quote(s)), 201);
  await Promise.all([call('POST', `/rides/${ride.id}/cancel`, { token: s.accessToken, body: {} }), call('POST', `/rides/${ride.id}/cancel`, { token: s.accessToken, body: {} })]);
  assert.equal((await pool.query('SELECT reserved_pesewas FROM wallets WHERE student_id=$1', [s.user.id])).rows[0].reserved_pesewas, 0);
});

test('ledger invariant: reserved equals the sum of reserved deltas for every wallet with activity', async () => {
  const { rows } = await pool.query(`SELECT count(*)::int n FROM wallets w JOIN
    (SELECT student_id, sum(reserved_delta) r FROM ledger_entries GROUP BY 1) l USING (student_id) WHERE w.reserved_pesewas <> l.r`);
  assert.equal(rows[0].n, 0);   // balance is not asserted here: some tests seed balances directly
});

test('ledger rows cannot be edited or deleted', async () => {
  await assert.rejects(pool.query('UPDATE ledger_entries SET amount_pesewas = 1'), /append-only/);
  await assert.rejects(pool.query('DELETE FROM ledger_entries'), /append-only/);
});

test('a late "Funds Received" still credits a top-up the sweep had already abandoned', async () => {
  const s = await approvedStudent(), tu = await topup(s);
  await pool.query(`UPDATE topups SET status='abandoned', completed_at=now() WHERE reference=$1`, [tu.reference]);
  await hook({ transaction_reference: tu.reference, transaction_status: 'Funds Received', amount_received: '20.00', amount_validation: 'EXACT' });
  assert.equal((await balance(s)).balancePesewas, 2000);
});

test('a signed credit far above the request is held for finance, not credited', async () => {
  const s = await approvedStudent(), tu = await topup(s);
  const r = await hook({ transaction_reference: tu.reference, transaction_status: 'Funds Received', amount_received: '500.00' });
  assert.equal(r.status, 200);
  assert.equal((await balance(s)).balancePesewas, 0);
  assert.equal((await pool.query('SELECT flagged FROM topups WHERE reference=$1', [tu.reference])).rows[0].flagged, true);
});
