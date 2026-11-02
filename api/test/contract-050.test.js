// Contract 0.5.0: driver documents with a server-computed status, the document_expired details, phone numbers in app-config,
// and event times on the driver's ride. Needs the running API and worker, migrated and seeded.
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import { call, expect, closeDb, rideTo, login, staffLogin, randPhone, uploadFile } from './walk-helpers.js';
import { pool } from '../src/db.js';
after(closeDb);

test('app-config has the two phone numbers, null until set', async () => {
  const c = expect(await call('GET', '/app-config'), 200);
  assert.ok('supervisorPhone' in c && 'campusSecurityPhone' in c);
});

test('the driver profile lists documents with valid, expiring and expired, and an expired one names itself', async () => {
  const t = (await staffLogin('hr@turbo.test')).accessToken;
  const phone = randPhone('+23320');
  const dr = expect(await call('POST', '/admin/drivers', { token: t, body: { fullName: 'Doc Check', phone }, idem: true }), 201);
  const dtok = (await login(phone, 'driver')).accessToken;
  assert.deepEqual(expect(await call('GET', '/driver/profile', { token: dtok }), 200).documents, []);
  const day = (n) => new Date(Date.now() + n * 86400_000).toISOString().slice(0, 10);
  const add = async (type, expiresOn) => expect(await call('POST', `/admin/drivers/${dr.id}/documents`, { token: t, body: { type, uploadId: await uploadFile(t, 'driver_document'), expiresOn }, idem: true }), 201);
  await add('drivers_licence', day(200));
  const ins = await add('insurance', day(10));
  await add('roadworthy', day(-5));
  const docs = expect(await call('GET', '/driver/profile', { token: dtok }), 200).documents;
  const by = Object.fromEntries(docs.map((x) => [x.type, x]));
  assert.equal(by.drivers_licence.status, 'valid');
  assert.equal(by.insurance.status, 'expiring');
  assert.ok(by.insurance.daysLeft >= 9 && by.insurance.daysLeft <= 10);
  assert.equal(by.roadworthy.status, 'expired');
  assert.ok(by.roadworthy.daysLeft < 0);
  const blocked = await call('PUT', '/driver/duty', { token: dtok, body: { onDuty: true } });
  assert.equal(blocked.status, 409);
  assert.equal(blocked.body.code, 'document_expired');
  assert.equal(blocked.body.documentType, 'roadworthy');
  assert.equal(blocked.body.expiredOn, day(-5));
  await pool.query('UPDATE driver_documents SET expires_on=$2 WHERE id=$1', [ins.id, day(-1)]);
});

test('the driver ride carries its event times, and a cancelled ride says who and why', async () => {
  const { s, d, ride } = await rideTo('assigned');
  const a = expect(await call('GET', '/driver/rides/current', { token: d.accessToken }), 200);
  assert.equal(a.arrivedAt, null); assert.equal(a.cancelledBy, null);
  expect(await call('POST', `/rides/${ride.id}/cancel`, { token: s.accessToken, body: { reasonCode: 'student_changed_mind' }, idem: true }), 200);
  const listed = expect(await call('GET', '/driver/rides', { token: d.accessToken }), 200).data.find((x) => x.id === ride.id);
  assert.equal(listed.status, 'cancelled');
  assert.equal(listed.cancelledBy, 'student');
  assert.equal(listed.cancelReasonCode, 'student_changed_mind');
  assert.ok(listed.cancelledAt);
});
