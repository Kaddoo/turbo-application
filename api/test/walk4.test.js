// Contract walk, part 4: staff authentication lifecycle, plus the remaining student/driver reads.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import { call, expect, login, staffLogin, randPhone, pool, closeDb, uuid } from './walk-helpers.js';
import { codeAt, stepNow } from '../src/lib/totp.js';
import { sha256 } from '../src/lib/util.js';
after(closeDb);

const giveToken = async (staffId, purpose) => {
  const token = crypto.randomUUID() + crypto.randomUUID();
  await pool.query(`INSERT INTO staff_tokens (staff_id,purpose,token_hash,expires_at) VALUES ($1,$2,$3, now() + interval '1 hour')`, [staffId, purpose, sha256(token)]);
  return token;
};

test('staff lifecycle: invite -> password -> MFA -> login -> replay -> password change -> reset -> lockout -> deactivate', async () => {
  const admin = await staffLogin('admin@turbo.test');
  const email = `t${Date.now()}@turbo.test`;
  try {
    const created = expect(await call('POST', '/admin/staff', { token: admin.accessToken, body: { email, fullName: 'Test Staff', staffRole: 'finance' } }), 201);
    const sid = created.id;
    assert.equal((await call('POST', '/auth/admin/login', { body: { email, password: 'whatever-long-1' } })).status, 401, 'cannot sign in before the invite is accepted');

    const invite = await giveToken(sid, 'invite');
    assert.equal((await call('POST', '/auth/admin/invite/accept', { body: { token: invite, password: 'short' } })).status, 422, 'contract: at least 10 characters');
    const enrol = expect(await call('POST', '/auth/admin/invite/accept', { body: { token: invite, password: 'a-long-password-1' } }), 200);
    assert.match(enrol.otpauthUri, /^otpauth:\/\/totp\//);
    assert.equal((await call('POST', '/auth/admin/invite/accept', { body: { token: invite, password: 'a-long-password-1' } })).status, 401, 'invite is single use');

    assert.equal((await call('POST', '/auth/admin/mfa/confirm', { body: { enrollmentToken: enrol.enrollmentToken, totpCode: '000000' } })).status, 401);
    const secret = enrol.secret, step = stepNow();
    const first = expect(await call('POST', '/auth/admin/mfa/confirm', { body: { enrollmentToken: enrol.enrollmentToken, totpCode: codeAt(secret, step) } }), 200);
    assert.ok(first.refreshToken && first.accessToken && first.user.staffRole === 'finance');

    // The server accepts a code only within about a minute of now, and only once. To use valid codes again later in this test we rewind
    // the stored 'last used' counter; replay protection itself is asserted above.
    const fresh = async () => { await pool.query('UPDATE staff_users SET mfa_last_step=$2 WHERE id=$1', [sid, step - 5]); return codeAt(secret, step + 1); };
    const doLogin = (totpCode, pw = 'a-long-password-1') => call('POST', '/auth/admin/login', { body: { email, password: pw, ...(totpCode && { totpCode }) } });
    assert.equal((await doLogin()).body.code, 'mfa_required', 'code is mandatory once enrolled');
    assert.equal((await doLogin(codeAt(secret, step))).status, 401, 'the code used at enrolment cannot be replayed');
    const ok = expect(await doLogin(codeAt(secret, step + 1)), 200);
    assert.equal((await doLogin(codeAt(secret, step + 1))).status, 401, 'a code works once');

    // signed-in password change needs the current password and a fresh code, and keeps this session but ends the others
    const newPw = 'changed-password-9';
    assert.equal((await call('POST', '/admin/me/password', { token: ok.accessToken, body: { currentPassword: 'wrong-wrong-wrong', newPassword: newPw, totpCode: await fresh() } })).status, 401);
    expect(await call('POST', '/admin/me/password', { token: ok.accessToken, body: { currentPassword: 'a-long-password-1', newPassword: newPw, totpCode: await fresh() } }), 204);
    assert.equal((await call('POST', '/auth/refresh', { body: { refreshToken: first.refreshToken } })).status, 401, 'other sessions ended');

    // reset revokes sessions
    const reset = await giveToken(sid, 'reset');
    expect(await call('POST', '/auth/admin/password/reset', { body: { token: reset, password: 'another-long-pw-2' } }), 204);
    assert.equal((await call('POST', '/auth/refresh', { body: { refreshToken: ok.refreshToken } })).status, 401, 'reset signs the user out everywhere');
    expect(await call('POST', '/auth/admin/password/forgot', { body: { email: 'nobody@nowhere.test' } }), 202, 'no enumeration');
    expect(await call('POST', '/auth/admin/password/forgot', { body: { email } }), 202);

    // lockout after five bad attempts
    for (let i = 0; i < 5; i++) await call('POST', '/auth/admin/login', { body: { email, password: 'wrong-password-x' } });
    const locked = await doLogin(await fresh(), 'another-long-pw-2');
    assert.equal(locked.status, 429); assert.equal(locked.body.code, 'account_locked'); assert.ok(locked.headers.get('retry-after'));

    await pool.query('UPDATE staff_users SET locked_until=NULL, failed_logins=0 WHERE id=$1', [sid]);
    const off = expect(await call('PATCH', `/admin/staff/${sid}`, { token: admin.accessToken, body: { isActive: false } }), 200); assert.equal(off.isActive, false);
    assert.equal((await call('PATCH', `/admin/staff/${admin.user.id}`, { token: admin.accessToken, body: { isActive: false } })).status, 409, 'cannot lock yourself out');
    assert.ok([401, 403].includes((await doLogin(await fresh(), 'another-long-pw-2')).status));
  } finally {
    await pool.query('DELETE FROM staff_users WHERE email=$1', [email]);
  }
});

test('a staff browser session keeps its refresh token in a cookie, not the response body', async () => {
  const ADMIN = process.env.ADMIN_URL || 'http://localhost:5173';
  const r = await call('POST', '/auth/admin/login', { body: { email: 'support@turbo.test', password: 'Turbo-demo-1' }, headers: { origin: ADMIN } });
  expect(r, 200); assert.equal(r.body.refreshToken, undefined);
  const fresh = r.headers.getSetCookie().find((c) => /Path=\/v1\/auth/i.test(c));
  assert.match(fresh, /HttpOnly/i);
  assert.equal(r.headers.get('access-control-allow-credentials'), 'true');
  const jar = fresh.split(';')[0];
  const next = await call('POST', '/auth/refresh', { headers: { cookie: jar, origin: ADMIN } });
  expect(next, 200); assert.equal(next.body.user.staffRole, 'support');
});

test('remaining student and driver reads and writes', async () => {
  const s = await login(randPhone()), t = s.accessToken;
  expect(await call('PATCH', '/me', { token: t, body: { fullName: 'Kwame Test' } }), 200);
  const tk = expect(await call('POST', '/support/tickets', { token: t, body: { category: 'other', subject: 'Question', message: 'Hello' } }), 201);
  expect(await call('POST', `/support/tickets/${tk.id}/messages`, { token: t, body: { body: 'Following up' } }), 201);
  assert.equal(expect(await call('GET', '/support/tickets?limit=1', { token: t }), 200).data.length, 1);
  const a = await login(randPhone());                           // second device for the same number is impossible, so use sessions of one login
  void a;
  const s2 = await login(s.user && (await pool.query('SELECT phone FROM users WHERE id=$1', [s.user.id])).rows[0].phone);
  const list = expect(await call('GET', '/me/sessions', { token: t }), 200);
  const other = list.items.find((x) => !x.current);
  if (other) expect(await call('DELETE', `/me/sessions/${other.id}`, { token: t }), 204);
  void s2;
  const d = await login('+233200000001', 'driver');
  const p = expect(await call('GET', '/driver/profile', { token: d.accessToken }), 200); assert.ok(p.vehicle.plateNumber && ['on_duty', 'off_duty'].includes(p.dutyStatus));
});

test('input hygiene still holds under the contract validator', async () => {
  const s = await login(randPhone()), t = s.accessToken;
  for (const raw of ['{"fullName":"x","__proto__":{"a":1}}', '{"fullName":"Ama\\u0000"}', '{"fullName":"Esi\\u202eevil"}', '[]'])
    assert.equal((await call('PATCH', '/me', { token: t, raw, headers: { 'content-type': 'application/json' } })).status, 400, raw);
  assert.equal((await call('PATCH', '/me', { token: t, body: { fullName: 5 } })).status, 422, 'wrong type is a contract violation');
  assert.equal((await call('PATCH', '/me', { token: t, body: { email: 'not-an-email' } })).status, 422);
  assert.equal((await call('POST', '/rides/quote', { token: t, body: { pickup: { lat: 1, lng: 1 }, dropoff: { lat: 1, lng: 1 } } })).status, 422, 'old flat location shape is refused, not guessed at');
  const e = await call('PATCH', '/me', { token: t, body: { fullName: 5 } });
  assert.ok(e.body.errors.some((x) => x.field === 'fullName'), 'errors name the field so the app can highlight it');
});
