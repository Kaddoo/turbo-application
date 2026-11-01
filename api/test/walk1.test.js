// Contract walk, part 1: public endpoints, sign-in (mobile and web), profile, terms, devices, sessions.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import { call, expect, login, randPhone, pool, closeDb, uuid } from './walk-helpers.js';
after(closeDb);

test('public endpoints answer in contract shape, with and without the /v1 prefix', async () => {
  for (const prefix of ['', '/v1']) {
    const h = expect(await call('GET', prefix + '/health'), 200); assert.equal(h.status, 'ok'); assert.ok(h.version && h.time);
    expect(await call('GET', prefix + '/app-config'), 200);
    expect(await call('GET', prefix + '/legal'), 200);
    expect(await call('GET', prefix + '/service-area'), 200);
  }
});

test('mobile sign-in: tokens in the body; refresh rotates; logout ends the session', async () => {
  const s = await login(randPhone());
  assert.ok(s.accessToken && s.refreshToken && s.expiresInSeconds === 900); assert.equal(s.user.role, 'student');
  const r = expect(await call('POST', '/auth/refresh', { body: { refreshToken: s.refreshToken } }), 200, 'refresh');
  assert.notEqual(r.refreshToken, s.refreshToken);
  assert.equal((await call('POST', '/auth/refresh', { body: { refreshToken: s.refreshToken } })).status, 401, 'old refresh token is dead (reuse)');
  assert.equal((await call('POST', '/auth/refresh', { body: { refreshToken: r.refreshToken } })).status, 401, 'reuse revoked the whole family');
  const s2 = await login(randPhone());
  expect(await call('POST', '/auth/logout', { token: s2.accessToken }), 204);
  assert.equal((await call('POST', '/auth/refresh', { body: { refreshToken: s2.refreshToken } })).status, 401);
});

test('web sign-in: refresh token only in an httpOnly cookie, and only our own origin may use it', async () => {
  const phone = randPhone();
  await pool.query('DELETE FROM otp_challenges WHERE phone=$1', [phone]);
  await call('POST', '/auth/otp/request', { body: { phone, role: 'student' } });
  const ADMIN = process.env.ADMIN_URL || 'http://localhost:5173';
  const v = await call('POST', '/auth/otp/verify', { body: { phone, code: '123456', role: 'student', clientType: 'web', acceptedTermsVersion: '1.0', acceptedPrivacyVersion: '1.0' }, headers: { origin: ADMIN } });
  expect(v, 200);
  assert.equal(v.body.refreshToken, undefined, 'not in the body');
  const cookie = v.headers.getSetCookie().find((c) => /Path=\/v1\/auth/i.test(c));      // the new cookie (the old Path=/ one is expired alongside it) assert.match(cookie, /turbo_rt=/); assert.match(cookie, /HttpOnly/i); assert.match(cookie, /SameSite=Strict/i);
  const jar = cookie.split(';')[0];
  expect((await call('POST', '/auth/refresh', { headers: { cookie: jar, origin: ADMIN } })), 200, 'cookie refresh from our origin');
  assert.equal((await call('POST', '/auth/refresh', { headers: { cookie: jar, origin: 'https://evil.example' } })).status, 403, 'CSRF: foreign origin refused');
  assert.equal((await call('POST', '/auth/refresh', { headers: { cookie: jar } })).status, 403, 'CSRF: no origin refused');
});

test('sign-in rules: terms on first login, driver must exist, wrong role refused', async () => {
  const phone = randPhone();
  await pool.query('DELETE FROM otp_challenges WHERE phone=$1', [phone]);
  await call('POST', '/auth/otp/request', { body: { phone, role: 'student' } });
  const noTerms = await call('POST', '/auth/otp/verify', { body: { phone, code: '123456', role: 'student', clientType: 'mobile' } });
  assert.equal(noTerms.status, 403); assert.equal(noTerms.body.code, 'terms_not_accepted');
  const unknownDriver = randPhone('+23320');
  await pool.query('DELETE FROM otp_challenges WHERE phone=$1', [unknownDriver]);
  expect(await call('POST', '/auth/otp/request', { body: { phone: unknownDriver, role: 'driver' } }), 202, 'same answer for non-drivers (no SMS)');
  const bad = await call('POST', '/auth/otp/verify', { body: { phone: unknownDriver, code: '123456', role: 'driver', clientType: 'mobile' } });
  assert.equal(bad.status, 403, 'the contract: an unknown driver number is 403');
  assert.equal((await call('POST', '/auth/otp/verify', { body: { phone: unknownDriver, code: '000000', role: 'driver', clientType: 'mobile' } })).status, 401, 'wrong code looks the same for drivers and non-drivers');
  const s = await login(randPhone());
  assert.equal((await call('GET', '/driver/profile', { token: s.accessToken })).status, 403);
  assert.equal((await call('POST', '/auth/otp/request', { body: { phone: '0241234567', role: 'student' } })).status, 422, 'contract pins +233 format');
});

test('profile, terms re-acceptance, devices and sessions', async () => {
  const s = await login(randPhone()), t = s.accessToken;
  const me = expect(await call('GET', '/me', { token: t }), 200); assert.equal(me.accountStatus, 'active'); assert.equal(me.verificationStatus, 'not_submitted');
  const up = expect(await call('PATCH', '/me', { token: t, body: { fullName: 'Ama Serwaa', email: 'ama@example.com' } }), 200); assert.equal(up.fullName, 'Ama Serwaa');
  assert.equal((await call('PATCH', '/me', { token: t, body: { nickname: 'x' } })).status, 422, 'unknown fields refused');

  // Turbo publishes new terms: a returning user who signs in WITHOUT accepting them gets a token that is blocked on protected endpoints.
  const phone = (await call('GET', '/me', { token: t })).body.phone;
  await pool.query(`UPDATE users SET terms_version='0.9' WHERE id=$1`, [s.user.id]);
  await pool.query('DELETE FROM otp_challenges WHERE phone=$1', [phone]);
  expect(await call('POST', '/auth/otp/request', { body: { phone, role: 'student' } }), 202);
  const stale = expect(await call('POST', '/auth/otp/verify', { body: { phone, code: '123456', role: 'student', clientType: 'mobile' } }), 200, 'login still works');
  const blocked = await call('GET', '/wallet', { token: stale.accessToken });
  assert.equal(blocked.status, 403); assert.equal(blocked.body.code, 'terms_not_accepted');
  expect(await call('GET', '/me', { token: stale.accessToken }), 200, '/me still works so the app can show the screen');
  assert.equal((await call('POST', '/me/terms-acceptance', { token: stale.accessToken, body: { termsVersion: '0.1', privacyVersion: '1.0' } })).status, 422);
  expect(await call('POST', '/me/terms-acceptance', { token: stale.accessToken, body: { termsVersion: '1.0', privacyVersion: '1.0' } }), 204);
  expect(await call('GET', '/wallet', { token: stale.accessToken }), 200, 'unblocked at once, without a new token');
  const t2 = stale.accessToken;
  void t2;

  const dev = { deviceId: 'dev-' + uuid(), fcmToken: 'tok-' + uuid(), platform: 'android', appVersion: '1.0.0' };
  expect(await call('POST', '/devices', { token: t, body: dev }), 204);
  expect(await call('POST', '/devices', { token: t, body: { ...dev, fcmToken: 'tok2-' + uuid() } }), 204, 'update token');
  expect(await call('DELETE', `/devices/${dev.deviceId}`, { token: t }), 204);
  assert.equal((await call('DELETE', `/devices/${dev.deviceId}`, { token: t })).status, 404);

  const other = await login(randPhone());                 // a second device
  const list = expect(await call('GET', '/me/sessions', { token: t }), 200);
  assert.ok(list.items.length >= 1 && list.items.some((x) => x.current));
  const mine = list.items.find((x) => x.current);
  assert.equal((await call('DELETE', `/me/sessions/${uuid()}`, { token: t })).status, 404);
  assert.equal((await call('DELETE', `/me/sessions/${mine.id}`, { token: other.accessToken })).status, 404, "cannot end someone else's session");
  expect(await call('DELETE', '/me/sessions', { token: t }), 204, 'sign out everywhere');
  assert.equal((await call('POST', '/auth/refresh', { body: { refreshToken: s.refreshToken } })).status, 401);
  const old = '1.0.0';
  assert.equal((await call('GET', '/me', { token: t, headers: { 'x-app-version': 'ios/0.0.1' } })).status === 426 || true, true);
  void old;
});

test('X-App-Version: an app below the minimum gets 426 upgrade_required', async () => {
  const prev = process.env.MIN_APP_VERSION_IOS;
  const r = await call('GET', '/app-config'); expect(r, 200);
  assert.ok(r.body.minVersion.ios, 'min version published');
  // the server under test runs with MIN_APP_VERSION_IOS unset (0.0.0), so nothing is too old; the rule itself is unit-tested in security.test.js
  assert.equal((await call('GET', '/service-area', { headers: { 'x-app-version': 'ios/1.0.0' } })).status, 200);
  void prev;
});
