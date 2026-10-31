// Push notifications: the FCM adapter against a mock Google, then the whole outbox -> worker -> device path (needs API + worker running).
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import http from 'node:http';
import { call, expect, login, staffLogin, randPhone, pool, closeDb, uuid, approvedStudent, soleDriver, bookRide, until, sleep, submitVerification } from './walk-helpers.js';
import { createFcm } from '../src/lib/push.js';
import { tx } from '../src/db.js';
import { notifyUser } from '../src/domain/notify.js';
import { sign } from '../src/lib/payments.js';
after(closeDb);

// ================= the adapter, against a mock Google =================
const { publicKey, privateKey } = crypto.generateKeyPairSync('rsa', { modulusLength: 2048 });
const sa = { project_id: 'test-proj', client_email: 'push@test-proj.iam.gserviceaccount.com', private_key: privateKey.export({ type: 'pkcs8', format: 'pem' }) };

async function mockGoogle() {
  const st = { tokenCalls: 0, sends: [], badJwt: 0, expireOnce: true };
  const srv = http.createServer(async (req, res) => {
    let body = ''; for await (const ch of req) body += ch;
    const send = (code, obj, headers = {}) => { res.writeHead(code, { 'content-type': 'application/json', ...headers }); res.end(JSON.stringify(obj)); };
    if (req.url === '/token') {
      st.tokenCalls++;
      const [h, p, s] = new URLSearchParams(body).get('assertion').split('.');
      const claims = JSON.parse(Buffer.from(p, 'base64url'));
      const okSig = crypto.verify('RSA-SHA256', Buffer.from(`${h}.${p}`), publicKey, Buffer.from(s, 'base64url'));
      if (!okSig || claims.iss !== sa.client_email || !claims.scope.includes('firebase.messaging') || claims.aud !== `http://localhost:${srv.address().port}/token`) { st.badJwt++; return send(400, { error: 'invalid_grant' }); }
      return send(200, { access_token: `at-${st.tokenCalls}`, expires_in: 3600 });
    }
    const m = JSON.parse(body).message;
    st.sends.push({ auth: req.headers.authorization, m });
    if (m.token.startsWith('gone-')) return send(404, { error: { status: 'NOT_FOUND', details: [{ errorCode: 'UNREGISTERED' }] } });
    if (m.token.startsWith('bad-')) return send(400, { error: { status: 'INVALID_ARGUMENT', message: 'The registration token is not a valid FCM registration token' } });
    if (m.token.startsWith('busy-')) return send(503, { error: { status: 'UNAVAILABLE' } }, { 'retry-after': '7' });
    if (m.token.startsWith('deny-')) return send(403, { error: { status: 'PERMISSION_DENIED' } });
    if (m.token.startsWith('exp-') && st.expireOnce && req.headers.authorization === 'Bearer at-1') { st.expireOnce = false; return send(401, { error: { status: 'UNAUTHENTICATED' } }); }
    return send(200, { name: 'projects/test-proj/messages/1' });
  });
  await new Promise((r) => srv.listen(0, r));
  return { st, srv, base: `http://localhost:${srv.address().port}` };
}

test('FCM adapter: signed OAuth token, message shape, one token shared by concurrent sends', async () => {
  const g = await mockGoogle(); const fcm = createFcm({ serviceAccount: sa, tokenUrl: `${g.base}/token`, apiBase: g.base });
  const results = await Promise.all(Array.from({ length: 10 }, (_, i) => fcm.send({ token: `ok-${i}`, title: 'Hi', body: 'There', data: { type: 'ride_offer', rideId: 'r1', n: 5, skip: null }, priority: 10, ttlSeconds: 90, collapseKey: 'k' })));
  assert.ok(results.every((r) => r.status === 'sent'));
  assert.equal(g.st.tokenCalls, 1, 'ten parallel sends shared one OAuth token request');
  assert.equal(g.st.badJwt, 0, 'the JWT was signed with the service-account key and had the right claims');
  const m = g.st.sends[0].m;
  assert.deepEqual(m.data, { type: 'ride_offer', rideId: 'r1', n: '5' }, 'data values are strings; nulls dropped');
  assert.equal(m.notification.title, 'Hi'); assert.equal(m.android.priority, 'HIGH'); assert.equal(m.android.ttl, '90s'); assert.equal(m.android.collapse_key, 'k');
  assert.equal(m.apns.headers['apns-priority'], '10'); assert.equal(g.st.sends[0].auth, 'Bearer at-1');
  const low = await fcm.send({ token: 'ok-low', title: 'a', body: 'b', priority: 1 });
  assert.equal(low.status, 'sent'); assert.equal(g.st.sends.at(-1).m.android.priority, 'NORMAL');
  g.srv.close();
});

test('FCM adapter: dead token, invalid token, outage, denial, expired OAuth token', async () => {
  const g = await mockGoogle(); const fcm = createFcm({ serviceAccount: sa, tokenUrl: `${g.base}/token`, apiBase: g.base });
  const s = (token) => fcm.send({ token, title: 't', body: 'b' });
  assert.equal((await s('gone-1')).status, 'gone', 'uninstalled app -> delete the device');
  assert.equal((await s('bad-1')).status, 'gone', 'malformed token -> delete the device');
  const busy = await s('busy-1'); assert.equal(busy.status, 'retry'); assert.equal(busy.retryAfterSeconds, 7, 'honours Retry-After');
  assert.equal((await s('deny-1')).status, 'failed', 'a permission error is not retried forever');
  assert.equal((await s('exp-1')).status, 'sent', 'a 401 fetches a fresh OAuth token once and retries');
  assert.equal(g.st.tokenCalls, 2);
  g.srv.close();
  const down = createFcm({ serviceAccount: sa, tokenUrl: 'http://localhost:1/token', apiBase: 'http://localhost:1' });
  assert.equal((await down.send({ token: 'x', title: 't', body: 'b' })).status, 'retry', 'Google unreachable -> retry later, never crash');
});

// ================= the whole path through the API and worker =================
const device = (token, fcmToken, deviceId = uuid()) => call('POST', '/devices', { token, body: { deviceId, fcmToken, platform: 'android', appVersion: '1.0.0' } });
const notes = async (userId, kind) => (await pool.query(`SELECT * FROM notifications WHERE user_id=$1 ${kind ? 'AND kind=$2' : ''} ORDER BY id`, kind ? [userId, kind] : [userId])).rows;
// optional rideId narrows to one ride: the seeded drivers are reused across runs and would otherwise match an older ride's notification
const sentNote = (userId, kind, rideId, ms = 15000) => until(async () => (await notes(userId, kind)).find((n) => n.status === 'sent' && (!rideId || n.data.rideId === rideId)), ms);

test('a ride sends the right pushes to the right people, and never a PIN or phone number', async () => {
  const s = await approvedStudent(20000), d = await soleDriver();
  expect(await device(s.accessToken, 'tok-student-' + uuid()), 204); expect(await device(d.accessToken, 'tok-driver-' + uuid()), 204);
  const { ride } = await bookRide(s);
  const offer = await sentNote(d.user.id, 'ride_offer', ride.id);
  assert.equal(offer.data.rideId, ride.id); assert.equal(offer.priority, 10);
  const assigned = await sentNote(s.user.id, 'ride_assigned', ride.id);
  assert.match(assigned.body, /Yaw in a White Toyota is coming/);
  const mine = (await call('GET', `/rides/${ride.id}`, { token: s.accessToken })).body;
  expect(await call('POST', `/driver/rides/${ride.id}/ack`, { token: d.accessToken }), 200);
  expect(await call('POST', `/driver/rides/${ride.id}/arrived`, { token: d.accessToken, body: {} }), 200);
  assert.ok(await sentNote(s.user.id, 'ride_arrived', ride.id));
  expect(await call('POST', `/driver/rides/${ride.id}/start`, { token: d.accessToken, body: { pin: mine.pin } }), 200);
  expect(await call('POST', `/driver/rides/${ride.id}/complete`, { token: d.accessToken, body: {} }), 200);
  const done = await sentNote(s.user.id, 'ride_completed', ride.id); assert.match(done.body, /GH₵\d/);
  const phone = (await call('GET', '/me', { token: s.accessToken })).body.phone;
  for (const n of [...await notes(s.user.id), ...await notes(d.user.id)].filter((x) => x.data.rideId === ride.id)) {
    const blob = JSON.stringify([n.title, n.body, n.data]);
    assert.ok(!blob.includes(mine.pin) && !blob.includes(phone), `no PIN or phone in "${n.kind}"`);
    assert.ok(Object.values(n.data).every((v) => typeof v === 'string'), 'data carries only ids and a type');
  }
  assert.equal((await notes(d.user.id, 'ride_completed')).filter((n) => n.data.rideId === ride.id).length, 0, 'the driver is not told what the rider paid');
});

test('cancelling tells the other side; a missing driver tells the student they were not charged', async () => {
  const s = await approvedStudent(20000), d = await soleDriver('+233200000002');
  await device(s.accessToken, 'tok-s-' + uuid()); await device(d.accessToken, 'tok-d-' + uuid());
  const { ride } = await bookRide(s);
  await until(async () => (await call('GET', `/rides/${ride.id}`, { token: s.accessToken })).body.status === 'assigned');
  expect(await call('POST', `/rides/${ride.id}/cancel`, { token: s.accessToken, body: {} }), 200);
  assert.ok(await sentNote(d.user.id, 'ride_cancelled_driver', ride.id), 'driver told the rider cancelled');
  assert.equal((await notes(s.user.id, 'ride_cancelled')).filter((n) => n.data.rideId === ride.id).length, 0, 'the rider who cancelled is not notified of their own cancel');
  // system cancel -> student only
  const s2 = await approvedStudent(20000); await device(s2.accessToken, 'tok-s2-' + uuid());
  const r2 = (await pool.query(`INSERT INTO rides (student_id,status,pickup_lat,pickup_lng,drop_lat,drop_lng,distance_m,duration_s,fare_pesewas,pin,requested_at) VALUES ($1,'searching',5.72,0.07,5.69,-0.03,9000,900,5000,'1234', now() - interval '10 minutes') RETURNING id`, [s2.user.id])).rows[0].id;
  await pool.query('UPDATE drivers SET on_duty=false');
  const n = await sentNote(s2.user.id, 'ride_cancelled'); assert.match(n.body, /not been charged/); assert.equal(n.data.rideId, r2);
});

test('dead tokens are removed, flaky ones back off, users without a device cost nothing, and a rollback sends nothing', async () => {
  const s = await login(randPhone());
  expect(await device(s.accessToken, 'good-' + uuid()), 204); expect(await device(s.accessToken, 'gone-' + uuid()), 204);
  await tx((c) => notifyUser(c, s.user.id, 'support_reply', { data: { ticketId: uuid() } }));
  await sentNote(s.user.id, 'support_reply');
  assert.equal((await pool.query(`SELECT count(*)::int n FROM devices WHERE user_id=$1`, [s.user.id])).rows[0].n, 1, 'the dead device was deleted, the good one kept');

  const flaky = await login(randPhone());
  expect(await device(flaky.accessToken, 'retry-' + uuid()), 204);
  await tx((c) => notifyUser(c, flaky.user.id, 'support_reply', { data: { ticketId: uuid() } }));
  const n = await until(async () => (await notes(flaky.user.id, 'support_reply')).find((x) => x.attempts >= 1 && x.last_error));
  assert.equal(n.status, 'pending'); assert.equal(n.last_error, 'simulated outage'); assert.ok(new Date(n.next_attempt_at) > new Date(), 'backed off, not hammering');

  const none = await login(randPhone());
  await tx((c) => notifyUser(c, none.user.id, 'support_reply', {}));
  assert.equal((await notes(none.user.id)).length, 0, 'no device, no row');

  await assert.rejects(tx(async (c) => { await notifyUser(c, s.user.id, 'refund', { vars: { amount: 100 }, dedupe: 'rollback-test-' + uuid() }); throw new Error('boom'); }));
  assert.equal((await notes(s.user.id, 'refund')).length, 0, 'the transaction rolled back, so no notification exists');

  const dedupe = 'once-' + uuid();
  await tx((c) => notifyUser(c, s.user.id, 'refund', { vars: { amount: 100 }, dedupe })); await tx((c) => notifyUser(c, s.user.id, 'refund', { vars: { amount: 100 }, dedupe }));
  assert.equal((await notes(s.user.id, 'refund')).length, 1, 'a dedupe key makes a repeated event send once');

  await tx((c) => notifyUser(c, s.user.id, 'announcement', { vars: { title: 'Old', body: 'x' } }));
  const old = (await notes(s.user.id, 'announcement'))[0];
  await pool.query(`UPDATE notifications SET expires_at = now() - interval '1 minute' WHERE id=$1`, [old.id]);
  await until(async () => (await notes(s.user.id, 'announcement'))[0].status !== 'pending');
  assert.equal((await notes(s.user.id, 'announcement'))[0].status, 'skipped', 'an expired message is dropped, not delivered late');
});

test('SOS pushes every support staff member and super admin at once; other roles are left alone', async () => {
  const sup = await staffLogin('support@turbo.test'), adm = await staffLogin('admin@turbo.test'), ver = await staffLogin('verifier@turbo.test');
  for (const x of [sup, adm, ver]) expect(await device(x.accessToken, 'staff-' + uuid()), 204);
  const s = await approvedStudent();
  const inc = expect(await call('POST', '/safety/sos', { token: s.accessToken, body: { location: { lat: 5.72, lng: 0.07 }, note: 'help' } }), 201);
  for (const who of [sup, adm]) { const n = (await until(async () => (await notes(who.user.id, 'sos')).find((x) => x.data.incidentId === inc.id && x.status === 'sent'))); assert.equal(n.user_type, 'staff'); assert.equal(n.priority, 10); }
  assert.equal((await notes(ver.user.id, 'sos')).length, 0, 'verifiers are not paged for SOS');
  expect(await call('POST', '/safety/sos', { token: s.accessToken, body: { location: { lat: 5.72, lng: 0.07 } } }), 201);   // double press: same incident
  assert.equal((await notes(sup.user.id, 'sos')).filter((x) => x.data.incidentId === inc.id).length, 1, 'a double press does not page twice');
  // the reporter hears back once staff acknowledge
  await device(s.accessToken, 'tok-rep-' + uuid());
  expect(await call('PATCH', `/admin/incidents/${inc.id}`, { token: sup.accessToken, body: { status: 'acknowledged' } }), 200);
  assert.ok(await sentNote(s.user.id, 'incident_ack'));
});

test('announcements reach every student with a device, once, at low priority', async () => {
  const s = await login(randPhone()), d = await login('+233200000001', 'driver');
  await device(s.accessToken, 'tok-a-' + uuid()); await device(d.accessToken, 'tok-b-' + uuid());
  const disp = await staffLogin('dispatch@turbo.test');
  const ann = expect(await call('POST', '/admin/announcements', { token: disp.accessToken, body: { audience: 'students', title: 'Rain today', body: 'Rides may be slower' } }), 202);
  const n = await sentNote(s.user.id, 'announcement'); assert.equal(n.title, 'Rain today'); assert.equal(n.priority, 1); assert.equal(n.data.announcementId, ann.id);
  assert.equal((await notes(d.user.id, 'announcement')).length, 0, 'drivers were not in the audience');
  const rows = (await pool.query(`SELECT count(*)::int n FROM notifications WHERE data->>'announcementId'=$1`, [ann.id])).rows[0].n;
  const expectCount = (await pool.query(`SELECT count(DISTINCT u.id)::int n FROM users u JOIN devices dv ON dv.user_id=u.id WHERE u.role='student' AND u.status='active' AND u.deleted_at IS NULL`)).rows[0].n;
  assert.equal(rows, expectCount, 'exactly one notification per student device-owner');
});

test('quick messages, support replies, verification results and top-ups notify the right person', async () => {
  const s = await approvedStudent(20000), dr = await soleDriver('+233200000003');
  await device(s.accessToken, 'tok-q-' + uuid()); await device(dr.accessToken, 'tok-r-' + uuid());
  const { ride } = await bookRide(s);
  await until(async () => (await call('GET', `/rides/${ride.id}`, { token: s.accessToken })).body.status === 'assigned');
  expect(await call('POST', `/rides/${ride.id}/messages`, { token: dr.accessToken, body: { code: 'im_here' } }), 202);
  const qm = await sentNote(s.user.id, 'quick_message', ride.id); assert.equal(qm.title, 'Message from your driver'); assert.equal(qm.body, "I'm here");
  expect(await call('POST', `/rides/${ride.id}/messages`, { token: s.accessToken, body: { code: 'at_the_gate' } }), 202);
  assert.equal((await sentNote(dr.user.id, 'quick_message', ride.id)).title, 'Message from your rider');
  expect(await call('POST', `/rides/${ride.id}/cancel`, { token: s.accessToken, body: {} }), 200);

  const sup = await staffLogin('support@turbo.test');
  const tk = expect(await call('POST', '/support/tickets', { token: s.accessToken, body: { category: 'other', subject: 'Question', message: 'Hello' } }), 201);
  expect(await call('POST', `/admin/support/tickets/${tk.id}/messages`, { token: sup.accessToken, body: { body: 'note to self', internal: true } }), 201);
  assert.equal((await notes(s.user.id, 'support_reply')).length, 0, 'internal notes are never announced');
  expect(await call('POST', `/admin/support/tickets/${tk.id}/messages`, { token: sup.accessToken, body: { body: 'Here to help' } }), 201);
  assert.equal((await sentNote(s.user.id, 'support_reply')).data.ticketId, tk.id);

  const v = await login(randPhone()); await device(v.accessToken, 'tok-v-' + uuid());
  expect(await submitVerification(v.accessToken), 201);
  const ver = await staffLogin('verifier@turbo.test');
  expect(await call('POST', `/admin/verifications/${v.user.id}/decision`, { token: ver.accessToken, body: { decision: 'needs_attention', reasonCode: 'document_unclear', studentMessage: 'Your card photo is blurry' } }), 200);
  assert.equal((await sentNote(v.user.id, 'verification')).body, 'Your card photo is blurry');

  const tu = expect(await call('POST', '/wallet/topups', { token: s.accessToken, body: { amountPesewas: 2500, channel: 'mobile_money' }, idem: true }), 201);
  const raw = JSON.stringify({ transaction_reference: tu.reference, transaction_status: 'Funds Received', amount_received: '25.00', amount_validation: 'EXACT' });
  await call('POST', '/webhooks/payaza', { raw, headers: { 'x-payaza-signature': sign(Buffer.from(raw)), 'content-type': 'application/json' } });
  assert.match((await sentNote(s.user.id, 'topup_succeeded')).body, /GH₵25 was added/);
});

test('signing out of a device stops pushes to it, and a phone that changes owner stops notifying the old one', async () => {
  const a = await login(randPhone()), b = await login(randPhone());
  const shared = 'tok-shared-' + uuid(), devA = uuid();
  expect(await device(a.accessToken, shared, devA), 204);
  expect(await device(b.accessToken, shared, uuid()), 204);
  assert.equal((await pool.query('SELECT count(*)::int n FROM devices WHERE fcm_token=$1', [shared])).rows[0].n, 1, 'one phone, one owner');
  assert.equal((await pool.query('SELECT user_id FROM devices WHERE fcm_token=$1', [shared])).rows[0].user_id, b.user.id);
  expect(await call('DELETE', `/devices/${(await pool.query('SELECT device_id FROM devices WHERE user_id=$1', [b.user.id])).rows[0].device_id}`, { token: b.accessToken }), 204);
  await tx((c) => notifyUser(c, b.user.id, 'support_reply', {}));
  assert.equal((await notes(b.user.id)).length, 0, 'no device left, nothing queued');
});
