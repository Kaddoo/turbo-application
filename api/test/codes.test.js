// Problem codes added in contract 0.3.0: each situation answers its own code, not a bare `conflict`; 503 is service_busy; staff links say
// link_invalid or link_expired. Needs the running API and a migrated, seeded database.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import { call, expect, staffLogin, randPhone, pool, closeDb, uuid, login } from './walk-helpers.js';
import { errorHandler, ApiError } from '../src/lib/errors.js';
import { spec } from '../src/lib/contract.js';
after(closeDb);

const code = (r, status) => { assert.equal(r.status, status, JSON.stringify(r.body)?.slice(0, 200)); return r.body.code; };
const driver = (t, body) => call('POST', '/admin/drivers', { token: t, body, idem: true });
const phone20 = () => '+23320' + String(Math.floor(Math.random() * 9e6) + 1e6);
const plate = () => 'GR-' + Math.floor(1000 + Math.random() * 8999) + '-' + (20 + Math.floor(Math.random() * 9));

test('every new code is in the contract', () => {
  const have = new Set(spec.components.schemas.ProblemCode.enum);
  for (const c of ['duplicate_phone', 'duplicate_email', 'duplicate_plate', 'vehicle_already_assigned', 'verification_not_pending', 'ticket_state_invalid',
    'topup_not_resolvable', 'incident_state_invalid', 'service_busy', 'link_expired', 'link_invalid']) assert.ok(have.has(c), c);
});

test('HR: duplicate plate, duplicate phone and a vehicle that is already assigned each have their own code', async () => {
  const hr = (await staffLogin('hr@turbo.test')).accessToken;
  const pl = plate();
  const v = expect(await call('POST', '/admin/vehicles', { token: hr, body: { make: 'Kia', model: 'Picanto', colour: 'Red', plateNumber: pl, seats: 4 } }), 201);
  assert.equal(code(await call('POST', '/admin/vehicles', { token: hr, body: { make: 'Kia', model: 'Picanto', colour: 'Red', plateNumber: pl.toLowerCase() } }), 409), 'duplicate_plate');
  const ph = phone20();
  expect(await driver(hr, { fullName: 'Ama Driver', phone: ph, vehicleId: v.id }), 201);
  assert.equal(code(await driver(hr, { fullName: 'Dup Phone', phone: ph }), 409), 'duplicate_phone');
  assert.equal(code(await driver(hr, { fullName: 'Same Car', phone: phone20(), vehicleId: v.id }), 409), 'vehicle_already_assigned');
});

test('super admin: a duplicate staff email is duplicate_email', async () => {
  const sa = (await staffLogin('admin@turbo.test')).accessToken;
  assert.equal(code(await call('POST', '/admin/staff', { token: sa, body: { email: 'hr@turbo.test', fullName: 'Copy Cat', staffRole: 'hr' } }), 409), 'duplicate_email');
});

test('finance: a top-up that is not flagged, or already resolved, is topup_not_resolvable', async () => {
  const fin = (await staffLogin('finance@turbo.test')).accessToken;
  const s = await login(randPhone());
  const mk = async (flagged) => (await pool.query(`INSERT INTO topups (student_id,status,amount_pesewas,reference,flagged) VALUES ($1,'succeeded',5000,$2,$3) RETURNING id`, [s.user.id, 'T-' + uuid(), flagged])).rows[0].id;
  const body = { resolution: 'no_action', note: 'Checked with the statement' };
  assert.equal(code(await call('POST', `/admin/topups/${await mk(false)}/resolve`, { token: fin, body, idem: true }), 409), 'topup_not_resolvable');
  const id = await mk(true);
  expect(await call('POST', `/admin/topups/${id}/resolve`, { token: fin, body, idem: true }), 200);
  assert.equal(code(await call('POST', `/admin/topups/${id}/resolve`, { token: fin, body, idem: true }), 409), 'topup_not_resolvable');
});

test('verifier: deciding a submission that is not pending is verification_not_pending', async () => {
  const v = (await staffLogin('verifier@turbo.test')).accessToken;
  const s = await login(randPhone());           // never submitted anything
  await pool.query(`UPDATE students SET verification_status='approved' WHERE user_id=$1`, [s.user.id]);
  assert.equal(code(await call('POST', `/admin/verifications/${s.user.id}/decision`, { token: v, body: { decision: 'approved' } }), 409), 'verification_not_pending');
  assert.equal(code(await call('POST', `/admin/verifications/${s.user.id}/claim`, { token: v }), 409), 'verification_not_pending');
});

test('support: an incident that is already resolved is incident_state_invalid', async () => {
  const sup = (await staffLogin('support@turbo.test')).accessToken;
  const s = await login(randPhone());
  const { rows: [i] } = await pool.query(`INSERT INTO incidents (type,reporter_id,reporter_role,status) VALUES ('sos',$1,'student','resolved') RETURNING id`, [s.user.id]);
  assert.equal(code(await call('PATCH', `/admin/incidents/${i.id}`, { token: sup, body: { status: 'acknowledged' } }), 409), 'incident_state_invalid');
});

test('a closed support ticket is ticket_state_invalid', async () => {
  const s = await login(randPhone());
  const made = expect(await call('POST', '/support/tickets', { token: s.accessToken, body: { category: 'other', subject: 'Hello there', message: 'Please help' } }), 201);
  await pool.query(`UPDATE support_tickets SET status='closed' WHERE id=$1`, [made.id]);
  assert.equal(code(await call('POST', `/support/tickets/${made.id}/messages`, { token: s.accessToken, body: { body: 'Still there?' } }), 409), 'ticket_state_invalid');
});

test('staff links: an unknown or used link is link_invalid, an expired one is link_expired, and neither is invalid_token', async () => {
  const bad = await call('POST', '/auth/admin/invite/accept', { body: { token: 'x'.repeat(43), password: 'A-long-enough-pass-1' } });
  assert.equal(code(bad, 401), 'link_invalid');
  const { rows: [st] } = await pool.query(`SELECT id FROM staff_users WHERE email='support@turbo.test'`);
  const tok = crypto.randomBytes(32).toString('base64url');
  await pool.query(`INSERT INTO staff_tokens (staff_id,purpose,token_hash,expires_at) VALUES ($1,'invite',$2, now() - interval '1 minute')`, [st.id, crypto.createHash('sha256').update(tok).digest('hex')]);
  assert.equal(code(await call('POST', '/auth/admin/invite/accept', { body: { token: tok, password: 'A-long-enough-pass-1' } }), 401), 'link_expired');
  assert.equal(code(await call('POST', '/auth/admin/mfa/confirm', { body: { enrollmentToken: 'y'.repeat(43), totpCode: '123456' } }), 401), 'link_invalid');
});

test('a busy database answers 503 service_busy with Retry-After, not conflict', () => {
  const sent = {}; const res = { set: (k, v) => { sent[k.toLowerCase()] = v; return res; }, status: (n) => { sent.status = n; return res; }, type: () => res, json: (b) => { sent.body = b; return res; } };
  const logs = { warn() {}, error() {}, info() {} };
  errorHandler(logs)(Object.assign(new Error('canceling statement due to statement timeout'), { code: '57014' }), { id: 'r1' }, res, () => {});
  assert.equal(sent.status, 503);
  assert.equal(sent.body.code, 'service_busy');
  assert.equal(sent['retry-after'], '2');
  assert.ok(ApiError);
});
