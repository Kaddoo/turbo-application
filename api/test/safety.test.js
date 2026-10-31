// Trusted contacts, trip sharing, SOS/incidents and support tickets (D15, audit F-10).
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import { call, expect, login, staffLogin, randPhone, pool, closeDb, uuid, uploadFile } from './walk-helpers.js';
after(closeDb);
const newStudent = async () => { const s = await login(randPhone('+23327')); await pool.query(`UPDATE users SET first_name='Ama', full_name='Ama Test' WHERE id=$1`, [s.user.id]); return s; };
const insertRide = async (studentId, status = 'in_progress') => (await pool.query(
  `INSERT INTO rides (student_id,status,pickup_lat,pickup_lng,drop_lat,drop_lng,drop_label,distance_m,duration_s,fare_pesewas,pin)
   VALUES ($1,$2,5.72,0.07,5.69,-0.03,'Ashaiman China Mall',9000,900,5000,'1234') RETURNING id`, [studentId, status])).rows[0].id;   // never 'searching': the worker would assign it
const here = { lat: 5.7203, lng: 0.0757 };

test('trusted contacts: validation, limit of five, soft delete, isolation', async () => {
  const s = await newStudent(), t = s.accessToken;
  assert.equal((await call('POST', '/me/trusted-contacts', { token: t, body: { name: 'Mum', phone: '0244000000' } })).status, 422);
  const ids = [];
  for (let i = 0; i < 5; i++) ids.push(expect(await call('POST', '/me/trusted-contacts', { token: t, body: { name: 'C' + i, phone: randPhone('+23324'), relationship: 'friend' } }), 201).id);
  assert.equal((await call('POST', '/me/trusted-contacts', { token: t, body: { name: 'Six', phone: randPhone('+23324') } })).status, 422, 'sixth refused');
  assert.equal(expect(await call('GET', '/me/trusted-contacts', { token: t }), 200).data.length, 5);
  expect(await call('DELETE', `/me/trusted-contacts/${ids[0]}`, { token: t }), 204);
  assert.equal((await call('DELETE', `/me/trusted-contacts/${ids[0]}`, { token: t })).status, 404);
  assert.equal((await call('DELETE', `/me/trusted-contacts/${ids[1]}`, { token: (await newStudent()).accessToken })).status, 404, 'not yours');
  expect(await call('POST', '/me/trusted-contacts', { token: t, body: { name: 'Again', phone: randPhone('+23324') } }), 201);
});

test('trip share: only own active ride and own contacts; public view is minimal and dies after the ride', async () => {
  const s = await newStudent(), t = s.accessToken;
  const c = expect(await call('POST', '/me/trusted-contacts', { token: t, body: { name: 'Mum', phone: randPhone('+23324') } }), 201);
  const rideId = await insertRide(s.user.id);
  const stranger = await newStudent();
  assert.equal((await call('POST', `/rides/${rideId}/share`, { token: stranger.accessToken, body: { trustedContactIds: [c.id] } })).status, 404, 'not their ride');
  assert.equal((await call('POST', `/rides/${rideId}/share`, { token: t, body: { trustedContactIds: [uuid()] } })).status, 422, "someone else's contact");
  const sh = expect(await call('POST', `/rides/${rideId}/share`, { token: t, body: { trustedContactIds: [c.id] } }), 201);
  assert.deepEqual(sh.notifiedContactIds, [c.id]);
  const token = sh.shareUrl.split('/').pop();
  const pub = expect(await call('GET', `/public/trip-shares/${token}`), 200);
  assert.equal(pub.studentFirstName, 'Ama'); assert.equal(pub.rideStatus, 'in_progress'); assert.equal(pub.dropoff.label, 'Ashaiman China Mall');
  assert.ok(!JSON.stringify(pub).includes(s.user.id) && !JSON.stringify(pub).includes('1234'), 'no ids, no PIN');
  assert.equal((await call('GET', '/public/trip-shares/nope')).status, 404);
  assert.notEqual((await pool.query('SELECT token_hash FROM trip_shares WHERE ride_id=$1', [rideId])).rows[0].token_hash, token, 'token is stored hashed');
  await pool.query(`UPDATE rides SET status='cancelled', cancelled_at=now() WHERE id=$1`, [rideId]);
  expect(await call('GET', `/public/trip-shares/${token}`), 200, 'still viewable right after the ride ends');
  assert.equal((await call('POST', `/rides/${rideId}/share`, { token: t, body: { trustedContactIds: [c.id] } })).status, 409, 'ended rides cannot be shared');
  await pool.query(`UPDATE rides SET cancelled_at = now() - interval '11 minutes' WHERE id=$1`, [rideId]);
  assert.equal((await call('GET', `/public/trip-shares/${token}`)).status, 404, 'link dies 10 minutes after the ride');
});

test('SOS: one incident, flags the ride, dedupes; staff acknowledge then resolve; audit trail', async () => {
  const s = await newStudent(), rideId = await insertRide(s.user.id);
  assert.equal((await call('POST', '/safety/sos', { token: s.accessToken, body: { note: 'help' } })).status, 422, 'location required');
  assert.equal((await call('POST', '/safety/sos', { body: { location: here } })).status, 401);
  assert.equal((await call('POST', '/safety/sos', { token: s.accessToken, body: { location: here, rideId: uuid() } })).status, 404, 'not their ride');
  const a = expect(await call('POST', '/safety/sos', { token: s.accessToken, body: { location: here, rideId, note: 'Driver is taking a wrong turn' } }), 201);
  assert.equal(a.status, 'open');
  assert.equal(expect(await call('POST', '/safety/sos', { token: s.accessToken, body: { location: here, rideId } }), 201).id, a.id, 'double press does not create a second incident');
  assert.ok((await pool.query('SELECT flags FROM rides WHERE id=$1', [rideId])).rows[0].flags.includes('sos'));
  const sup = (await staffLogin('support@turbo.test')).accessToken, ver = (await staffLogin('verifier@turbo.test')).accessToken;
  assert.equal((await call('GET', '/admin/incidents', { token: ver })).status, 403);
  const mine = expect(await call('GET', '/admin/incidents?status=open&limit=100', { token: sup }), 200).data.find((i) => i.id === a.id);
  assert.ok(mine); assert.equal(mine.note, 'Driver is taking a wrong turn'); assert.ok(mine.reporter.phone);
  assert.equal((await call('PATCH', `/admin/incidents/${a.id}`, { token: sup, body: { status: 'open' } })).status, 422);
  assert.equal(expect(await call('PATCH', `/admin/incidents/${a.id}`, { token: sup, body: { status: 'acknowledged', note: 'Called the driver' } }), 200).status, 'acknowledged');
  assert.equal((await call('PATCH', `/admin/incidents/${a.id}`, { token: sup, body: { status: 'acknowledged' } })).status, 409);
  assert.equal(expect(await call('PATCH', `/admin/incidents/${a.id}`, { token: sup, body: { status: 'resolved', note: 'Safe' } }), 200).status, 'resolved');
  assert.equal((await call('PATCH', `/admin/incidents/${a.id}`, { token: sup, body: { status: 'resolved' } })).status, 409);
  assert.deepEqual((await pool.query(`SELECT action FROM audit_log WHERE target=$1 ORDER BY id`, [a.id])).rows.map((x) => x.action), ['incident.acknowledged', 'incident.resolved']);
  assert.notEqual(expect(await call('POST', '/safety/sos', { token: s.accessToken, body: { location: here } }), 201).id, a.id, 'a resolved incident does not swallow a new SOS');
});

test('a driver can raise SOS too', async () => {
  const d = await login('+233200000002', 'driver');
  const r = expect(await call('POST', '/safety/sos', { token: d.accessToken, body: { location: here } }), 201);
  assert.equal((await pool.query('SELECT reporter_role FROM incidents WHERE id=$1', [r.id])).rows[0].reporter_role, 'driver');
});

test('support tickets: attachment, staff reply and internal note, status flow, isolation', async () => {
  const s = await newStudent(), t = s.accessToken;
  assert.equal((await call('POST', '/support/tickets', { token: t, body: { category: 'nope', subject: 'Hello', message: 'x' } })).status, 422);
  const att = await uploadFile(t, 'support_attachment');
  const rideId = await insertRide(s.user.id, 'completed');
  const made = expect(await call('POST', '/support/tickets', { token: t, body: { category: 'wrong_charge', subject: 'Charged twice', message: 'I was charged twice', rideId, uploadIds: [att] } }), 201);
  assert.equal(made.status, 'open'); assert.equal(made.messages.length, 1);
  assert.equal((await call('POST', '/support/tickets', { token: t, body: { category: 'other', subject: 'Reuse', message: 'x', uploadIds: [att] } })).status, 422, 'attachment is single use');
  assert.equal((await call('POST', '/support/tickets', { token: t, body: { category: 'other', subject: 'Not mine', message: 'x', rideId: await insertRide((await newStudent()).user.id, 'completed') } })).status, 404);
  const id = made.id, sup = (await staffLogin('support@turbo.test')).accessToken;
  assert.equal((await call('GET', '/admin/support/tickets', { token: (await staffLogin('verifier@turbo.test')).accessToken })).status, 403);
  assert.ok(expect(await call('GET', '/admin/support/tickets?status=open&category=wrong_charge&limit=100', { token: sup }), 200).data.some((x) => x.id === id));
  expect(await call('POST', `/admin/support/tickets/${id}/messages`, { token: sup, body: { body: 'Check the ledger first', internal: true } }), 201);
  assert.equal(expect(await call('GET', `/admin/support/tickets/${id}`, { token: sup }), 200).status, 'open', 'internal note keeps the status');
  assert.equal(expect(await call('POST', `/admin/support/tickets/${id}/messages`, { token: sup, body: { body: 'Sorry, refunding now' } }), 201).author, 'staff');
  const mine = expect(await call('GET', `/support/tickets/${id}`, { token: t }), 200);
  assert.equal(mine.status, 'waiting_on_user'); assert.deepEqual(mine.messages.map((m) => m.body), ['I was charged twice', 'Sorry, refunding now'], 'internal note hidden from the user');
  assert.ok(mine.messages.every((m) => !('internal' in m)));
  assert.equal(expect(await call('GET', `/admin/support/tickets/${id}`, { token: sup }), 200).messages.length, 3);
  assert.equal((await call('GET', `/support/tickets/${id}`, { token: (await newStudent()).accessToken })).status, 404, "another user's ticket");
  expect(await call('POST', `/support/tickets/${id}/messages`, { token: t, body: { body: 'Thanks, still waiting' } }), 201);
  assert.equal(expect(await call('GET', `/support/tickets/${id}`, { token: t }), 200).status, 'open', 'user reply reopens it for staff');
  const staffId = expect(await call('GET', '/admin/me', { token: sup }), 200).id;
  const pat = expect(await call('PATCH', `/admin/support/tickets/${id}`, { token: sup, body: { status: 'in_progress', assignedToStaffId: staffId } }), 200);
  assert.equal(pat.assignedToStaffId, staffId);
  assert.equal((await call('PATCH', `/admin/support/tickets/${id}`, { token: sup, body: { status: 'bogus' } })).status, 422);
  assert.equal((await call('PATCH', `/admin/support/tickets/${id}`, { token: sup, body: { assignedToStaffId: uuid() } })).status, 422);
  assert.equal(expect(await call('PATCH', `/admin/support/tickets/${id}`, { token: sup, body: { status: 'closed', assignedToStaffId: null } }), 200).assignedToStaffId, null);
  assert.equal((await call('POST', `/support/tickets/${id}/messages`, { token: t, body: { body: 'one more thing' } })).status, 409, 'closed');
});
