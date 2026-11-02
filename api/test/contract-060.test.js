// Contract 0.6.0: top-up network and msisdn (422 network_unknown), the home-screen notice in app-config, notification choices,
// and place search. Needs the running API and worker, migrated and seeded.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import { call, expect, closeDb, login, staffLogin, randPhone } from './walk-helpers.js';
import { pool } from '../src/db.js';
after(closeDb);

test('a top-up names its network; a number we cannot place needs one chosen', async () => {
  const phone = randPhone('+23324');
  const s = await login(phone, 'student');
  const t = expect(await call('POST', '/wallet/topups', { token: s.accessToken, body: { amountPesewas: 2000, channel: 'mobile_money' }, idem: true }), 201);
  assert.equal(t.network, 'mtn', 'an MTN number is recognised');
  const other = expect(await call('POST', '/wallet/topups', { token: s.accessToken, body: { amountPesewas: 2000, channel: 'mobile_money', msisdn: '+233201234567' }, idem: true }), 201);
  assert.equal(other.network, 'telecel', 'a different paying number gives its own network');
  const odd = await call('POST', '/wallet/topups', { token: s.accessToken, body: { amountPesewas: 2000, channel: 'mobile_money', msisdn: '+233301234567' }, idem: true });
  assert.equal(odd.status, 422);
  assert.equal(odd.body.code, 'network_unknown');
  const chosen = expect(await call('POST', '/wallet/topups', { token: s.accessToken, body: { amountPesewas: 2000, channel: 'mobile_money', msisdn: '+233301234567', network: 'at' }, idem: true }), 201);
  assert.equal(chosen.network, 'at');
  await pool.query(`UPDATE topups SET status='abandoned' WHERE student_id=$1 AND status='pending'`, [s.user?.id ?? null]);
});

test('the home-screen notice goes in through settings and comes out of app-config', async () => {
  const t = (await staffLogin('admin@turbo.test')).accessToken;
  assert.equal(expect(await call('GET', '/app-config'), 200).announcement, null);
  const all = expect(await call('GET', '/admin/settings', { token: t }), 200);       // PUT replaces the whole document
  const put = (announcement) => call('PUT', '/admin/settings', { token: t, body: { ...all, announcement } });
  assert.equal((await put({ message: 'x', severity: 'loud' })).status, 422);
  assert.equal((await put({ message: 'No rides on Sunday', severity: 'warning' })).status, 200);
  await new Promise((r) => setTimeout(r, 11_000));            // settings are cached for 10 s
  const a = expect(await call('GET', '/app-config'), 200).announcement;
  assert.equal(a.message, 'No rides on Sunday'); assert.equal(a.severity, 'warning'); assert.ok(a.id.length >= 8);
  assert.equal((await put(null)).status, 200);
});

test('notification choices start at news off, tips on, and are replaced as a pair', async () => {
  const s = await login(randPhone('+23326'), 'student');
  assert.deepEqual(expect(await call('GET', '/me/notification-settings', { token: s.accessToken }), 200), { newsAndOffers: false, tips: true });
  assert.deepEqual(expect(await call('PUT', '/me/notification-settings', { token: s.accessToken, body: { newsAndOffers: true, tips: false } }), 200), { newsAndOffers: true, tips: false });
  assert.deepEqual(expect(await call('GET', '/me/notification-settings', { token: s.accessToken }), 200), { newsAndOffers: true, tips: false });
  assert.equal((await call('PUT', '/me/notification-settings', { token: s.accessToken, body: { newsAndOffers: true } })).status, 422);
});

test('place search finds an official pickup point and resolves it', async () => {
  const s = await login(randPhone('+23326'), 'student');
  const none = expect(await call('GET', '/places/autocomplete?q=g', { token: s.accessToken }), 200);
  assert.deepEqual(none.items, [], 'one letter returns nothing');
  const found = expect(await call('GET', '/places/autocomplete?q=gate', { token: s.accessToken }), 200).items;
  const gate = found.find((i) => i.isPickupPoint);
  assert.ok(gate, 'a pickup point matching "gate"');
  const loc = expect(await call('GET', `/places/${encodeURIComponent(gate.placeId)}`, { token: s.accessToken }), 200);
  assert.ok(loc.pickupPointId); assert.equal(typeof loc.point.lat, 'number');
  assert.equal((await call('GET', '/places/pp_00000000-0000-4000-8000-000000000000', { token: s.accessToken })).status, 404);
  assert.equal((await call('GET', '/places/g_nonsense', { token: s.accessToken })).status, 404);
});
