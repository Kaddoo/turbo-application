// Idempotency-Key on the four operations added in contract 0.2.3: OTP request (optional key, no second SMS), top-up resolve,
// reconciliation reports and driver creation (key required). Needs the running API and a migrated, seeded database.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import { call, expect, staffLogin, randPhone, pool, closeDb, uuid, uploadFile, login } from './walk-helpers.js';
after(closeDb);

const challenges = async (phone) => (await pool.query('SELECT count(*)::int n FROM otp_challenges WHERE phone=$1', [phone])).rows[0].n;
const otp = (phone, key, extra = {}) => call('POST', '/auth/otp/request', { body: { phone, role: 'student', ...extra }, headers: key ? { 'Idempotency-Key': key } : {} });

test('OTP request: a retry with the same key replays the answer and sends no second code', async () => {
  const phone = randPhone(); const key = uuid();
  const a = await otp(phone, key);
  assert.equal(a.status, 202);
  const b = await otp(phone, key);
  assert.equal(b.status, 202);
  assert.deepEqual(b.body, a.body);
  assert.equal(await challenges(phone), 1, 'one SMS, not two');
});

test('OTP request: a new key is a deliberate resend, and the 30 second cooldown still applies to it', async () => {
  const phone = randPhone();
  assert.equal((await otp(phone, uuid())).status, 202);
  const again = await otp(phone, uuid());
  assert.equal(again.status, 429);
  assert.equal(again.body.code, 'otp_rate_limited');
  assert.equal(await challenges(phone), 1);
});

test('OTP request: after the cooldown a new key sends a new code', async () => {
  const phone = randPhone();
  assert.equal((await otp(phone, uuid())).status, 202);
  await pool.query(`UPDATE otp_challenges SET created_at = created_at - interval '1 minute' WHERE phone=$1`, [phone]);
  assert.equal((await otp(phone, uuid())).status, 202);
  assert.equal(await challenges(phone), 2);
});

test('OTP request: the same key with a different body is 409 idempotency_key_reused', async () => {
  const phone = randPhone(); const key = uuid();
  assert.equal((await otp(phone, key)).status, 202);
  const r = await otp(phone, key, { role: 'driver' });
  assert.equal(r.status, 409);
  assert.equal(r.body.code, 'idempotency_key_reused');
});

test('OTP request: the key belongs to the number, so the same key for another number is a separate request', async () => {
  const key = uuid(); const p1 = randPhone(), p2 = randPhone();
  assert.equal((await otp(p1, key)).status, 202);
  assert.equal((await otp(p2, key)).status, 202);
  assert.equal(await challenges(p1), 1); assert.equal(await challenges(p2), 1);
});

test('OTP request: no key still works as before, and a key is forgotten after 10 minutes', async () => {
  const phone = randPhone();
  assert.equal((await otp(phone)).status, 202);
  const key = uuid(); const p2 = randPhone();
  assert.equal((await otp(p2, key)).status, 202);
  await pool.query(`UPDATE idempotency_keys SET created_at = now() - interval '11 minutes' WHERE key=$1`, [key]);
  await pool.query(`UPDATE otp_challenges SET created_at = created_at - interval '11 minutes' WHERE phone=$1`, [p2]);
  assert.equal((await otp(p2, key)).status, 202);
  assert.equal(await challenges(p2), 2, 'the old key no longer replays; a fresh request ran');
});

test('OTP request: a key that is too short is refused', async () => {
  assert.equal((await otp(randPhone(), 'short')).status, 422);
});

// ---- staff operations: the key is required
test('create driver: no key is 422; the same key twice makes one driver; a different body is 409', async () => {
  const hr = await staffLogin('hr@turbo.test');
  const phone = '+23320' + String(Math.floor(Math.random() * 9e6) + 1e6);
  const body = { fullName: 'Kojo Test Driver', phone, vehicleId: null };
  const none = await call('POST', '/admin/drivers', { token: hr.accessToken, body });
  assert.equal(none.status, 422);
  const key = uuid();
  const a = await call('POST', '/admin/drivers', { token: hr.accessToken, body, idem: key });
  assert.equal(a.status, 201);
  const b = await call('POST', '/admin/drivers', { token: hr.accessToken, body, idem: key });
  assert.equal(b.status, 201);
  assert.equal(b.body.id, a.body.id);
  assert.equal((await pool.query('SELECT count(*)::int n FROM users WHERE phone=$1', [phone])).rows[0].n, 1);
  const c = await call('POST', '/admin/drivers', { token: hr.accessToken, body: { ...body, fullName: 'Someone Else' }, idem: key });
  assert.equal(c.status, 409);
  assert.equal(c.body.code, 'idempotency_key_reused');
});

test('resolve top-up: no key is 422; the same key replays the first resolution instead of failing "already resolved"', async () => {
  const fin = await staffLogin('finance@turbo.test');
  const s = await login(randPhone());
  const { rows: [t] } = await pool.query(`INSERT INTO topups (student_id,status,amount_pesewas,reference,flagged,validation) VALUES ($1,'succeeded',5000,$2,true,'amount_mismatch') RETURNING id`, [s.user.id, 'TEST-' + uuid()]);
  const body = { resolution: 'no_action', note: 'Checked with the provider statement' };
  assert.equal((await call('POST', `/admin/topups/${t.id}/resolve`, { token: fin.accessToken, body })).status, 422);
  const key = uuid();
  const a = await call('POST', `/admin/topups/${t.id}/resolve`, { token: fin.accessToken, body, idem: key });
  assert.equal(a.status, 200);
  const b = await call('POST', `/admin/topups/${t.id}/resolve`, { token: fin.accessToken, body, idem: key });
  assert.equal(b.status, 200, 'a retry of the same request is not a conflict');
  assert.deepEqual(b.body, a.body);
  const fresh = await call('POST', `/admin/topups/${t.id}/resolve`, { token: fin.accessToken, body, idem: uuid() });
  assert.equal(fresh.status, 409, 'a new request on a resolved top-up is still refused');
});

test('reconciliation report: no key is 422; the same key makes one report', async () => {
  const fin = await staffLogin('finance@turbo.test');
  const csv = Buffer.from('reference,amount,status\nNOPE-1,5.00,success\n');
  const up = await uploadFile(fin.accessToken, 'provider_statement', csv, 'text/csv');
  const body = { statementUploadId: up, periodFrom: '2026-10-01', periodTo: '2026-10-31' };
  assert.equal((await call('POST', '/admin/reconciliation/reports', { token: fin.accessToken, body })).status, 422);
  const key = uuid();
  const a = await call('POST', '/admin/reconciliation/reports', { token: fin.accessToken, body, idem: key });
  assert.equal(a.status, 201, JSON.stringify(a.body)?.slice(0, 200));
  const b = await call('POST', '/admin/reconciliation/reports', { token: fin.accessToken, body, idem: key });
  assert.equal(b.status, 201);
  assert.equal(b.body.id, a.body.id);
});
