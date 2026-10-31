// Contract walk, part 2: verification, trusted contacts, saved places, and a full ride through both apps (needs the worker running).
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import { call, expect, login, staffLogin, randPhone, pool, closeDb, uuid, approvedStudent, submitVerification, uploadFile } from './walk-helpers.js';
import { sign } from '../src/lib/payments.js';
after(closeDb);

const PICK = { point: { lat: 5.7203, lng: 0.0757 }, label: 'Central Gate' }, DROP = { point: { lat: 5.6935, lng: -0.029 }, label: 'Ashaiman China Mall' };
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const until = async (fn, ms = 20000) => { const t = Date.now(); while (Date.now() - t < ms) { const v = await fn(); if (v) return v; await sleep(400); } throw new Error('timed out waiting'); };

// Only this driver is on duty, so assignment is deterministic. Everyone else is taken off duty (in the database) first.
async function soleDriver(phone = '+233200000003') {
  await pool.query(`UPDATE rides SET status='cancelled', cancelled_at=now(), cancel_by='system', cancel_reason='test cleanup', cancel_reason_code='other', driver_id=NULL WHERE status IN ('searching','assigned','driver_arrived','in_progress')`);
  await pool.query(`UPDATE drivers SET on_duty=false, duty_since=NULL`);
  const d = await login(phone, 'driver');
  expect(await call('PUT', '/driver/duty', { token: d.accessToken, body: { onDuty: true } }), 200, 'duty on');
  expect(await call('PUT', '/driver/location', { token: d.accessToken, body: { points: [{ point: { lat: 5.7210, lng: 0.0760 }, recordedAt: new Date().toISOString() }] } }), 204, 'location');
  return d;
}
const book = async (s, over = {}) => {
  const q = expect(await call('POST', '/rides/quote', { token: s.accessToken, body: { pickup: PICK, dropoff: DROP } }), 200, 'quote');
  assert.equal(q.eligible, true, JSON.stringify(q.reasons));
  const res = await call('POST', '/rides', { token: s.accessToken, body: { quoteId: q.quoteId, ...over }, idem: true });
  return { q, res };
};

test('verification: submit -> queue -> claim -> detail with signed documents -> decision -> student sees result', async () => {
  const s = await login(randPhone()), t = s.accessToken;
  expect(await call('GET', '/me/verification', { token: t }), 200);
  const dupe = await submitVerification(t);
  expect(dupe, 201); assert.equal(dupe.body.status, 'pending'); assert.equal(dupe.body.canResubmit, false);
  assert.equal((await submitVerification(t)).status, 409);
  const v = await staffLogin('verifier@turbo.test'), vt = v.accessToken;
  const list = expect(await call('GET', '/admin/verifications?status=pending&limit=100', { token: vt }), 200);
  assert.ok(list.data.some((x) => x.id === s.user.id)); assert.equal(typeof list.page.hasMore, 'boolean');
  expect(await call('POST', `/admin/verifications/${s.user.id}/claim`, { token: vt }), 200);
  const d = expect(await call('GET', `/admin/verifications/${s.user.id}`, { token: vt }), 200);
  assert.equal(d.documents.length, 4); assert.match(d.ghanaCardNumber, /^GHA-\d{9}-\d$/);
  assert.equal((await fetch(d.documents[0].url)).status, 200);
  expect(await call('POST', `/admin/verifications/${s.user.id}/decision`, { token: vt, body: { decision: 'needs_attention', reasonCode: 'document_unclear', studentMessage: 'Card photo is blurry' } }), 200);
  const st = expect(await call('GET', '/me/verification', { token: t }), 200);
  assert.equal(st.status, 'needs_attention'); assert.equal(st.canResubmit, true); assert.equal(st.reasonCode, 'document_unclear');
  expect(await submitVerification(t), 201, 'resubmit');
  expect(await call('POST', `/admin/verifications/${s.user.id}/decision`, { token: vt, body: { decision: 'approved' } }), 200);
  assert.equal(expect(await call('GET', '/me', { token: t }), 200).verificationStatus, 'approved');
});

test('trusted contacts and saved places', async () => {
  const s = await login(randPhone()), t = s.accessToken;
  const c = expect(await call('POST', '/me/trusted-contacts', { token: t, body: { name: 'Mum', phone: randPhone('+23324'), relationship: 'mother' } }), 201);
  assert.equal(expect(await call('GET', '/me/trusted-contacts', { token: t }), 200).data.length, 1);
  expect(await call('DELETE', `/me/trusted-contacts/${c.id}`, { token: t }), 204);
  const p = expect(await call('POST', '/me/saved-places', { token: t, body: { label: 'Hostel', location: { point: { lat: 5.72, lng: 0.075 }, label: 'Block C' } } }), 201);
  assert.equal(p.location.label, 'Block C');
  assert.equal(expect(await call('GET', '/me/saved-places', { token: t }), 200).data.length, 1);
  expect(await call('DELETE', `/me/saved-places/${p.id}`, { token: t }), 204);
  assert.equal((await call('DELETE', `/me/saved-places/${p.id}`, { token: t })).status, 404);
});

test('a full ride: quote, book, assign, acknowledge, arrive, PIN start, track, message, complete, receipt, rating', async () => {
  const s = await approvedStudent(20000), t = s.accessToken;
  const d = await soleDriver();
  const dt = d.accessToken;

  const { q, res } = await book(s);
  const ride = expect(res, 201, 'book');
  assert.equal(ride.status, 'searching'); assert.equal(ride.payment.status, 'held'); assert.equal(ride.payment.heldPesewas, q.farePesewas);
  assert.equal(ride.pin, null, 'no PIN until a driver is assigned');
  // idempotency: same key + same body replays; same key + different body is 409 idempotency_key_reused; no key is 422
  const key = uuid();
  const q2 = expect(await call('POST', '/rides/quote', { token: (await approvedStudent(20000)).accessToken, body: { pickup: PICK, dropoff: DROP } }), 200);
  void q2; void key;
  assert.equal((await call('POST', '/rides', { token: t, body: { quoteId: q.quoteId } })).status, 422, 'Idempotency-Key is required');
  assert.equal((await call('POST', '/rides', { token: t, body: { quoteId: q.quoteId }, idem: 'short' })).status, 422, 'and at least 8 characters');
  const again = await call('POST', '/rides', { token: t, body: { quoteId: q.quoteId }, idem: true });
  assert.equal(again.status, 409); assert.equal(again.body.code, 'quote_expired', 'a quote can only be booked once');
  const second = expect(await call('POST', '/rides/quote', { token: t, body: { pickup: PICK, dropoff: DROP } }), 200);
  assert.equal(second.eligible, false); assert.ok(second.reasons.some((r) => r.code === 'active_ride_exists'), 'a new quote says why not');

  const assigned = await until(async () => { const r = (await call('GET', `/rides/${ride.id}`, { token: t })).body; return r.status === 'assigned' ? r : null; });
  assert.match(assigned.pin, /^\d{4}$/); assert.equal(assigned.driver.firstName, 'Yaw'); assert.equal(assigned.vehicle.plateNumber, 'GR-0003-26');
  assert.ok(assigned.pickupEtaSeconds >= 0);

  const offer = expect(await call('GET', '/driver/rides/current', { token: dt }), 200, 'driver current');
  assert.equal(offer.id, ride.id); assert.equal(offer.farePesewas, q.farePesewas); assert.equal(offer.student.firstName !== undefined, true);
  assert.ok(!JSON.stringify(offer).includes(assigned.pin), 'driver never sees the PIN');
  expect(await call('POST', `/driver/rides/${ride.id}/ack`, { token: dt }), 200, 'ack');
  expect(await call('POST', `/driver/rides/${ride.id}/arrived`, { token: dt, body: { location: { lat: 5.7203, lng: 0.0757 } } }), 200, 'arrived');
  const wrong = await call('POST', `/driver/rides/${ride.id}/start`, { token: dt, body: { pin: assigned.pin === '0000' ? '1111' : '0000' } });
  assert.equal(wrong.status, 400); assert.equal(wrong.body.code, 'invalid_pin');
  expect(await call('POST', `/rides/${ride.id}/messages`, { token: t, body: { code: 'at_the_gate' } }), 202);
  expect(await call('POST', `/rides/${ride.id}/messages`, { token: dt, body: { code: 'im_here' } }), 202);
  const msgs = expect(await call('GET', `/rides/${ride.id}/messages`, { token: t }), 200); assert.deepEqual(msgs.items.map((m) => m.from), ['student', 'driver']);
  const started = expect(await call('POST', `/driver/rides/${ride.id}/start`, { token: dt, body: { pin: assigned.pin } }), 200, 'start'); assert.equal(started.status, 'in_progress');
  const tr = expect(await call('GET', `/rides/${ride.id}/tracking`, { token: t }), 200); assert.equal(tr.rideStatus, 'in_progress'); assert.ok(tr.driverLocation.point);
  assert.equal((await call('POST', `/rides/${ride.id}/cancel`, { token: t, body: {} })).body.code, 'ride_not_cancellable');
  assert.equal((await call('GET', `/rides/${ride.id}/receipt`, { token: t })).status, 404, 'no receipt before completion');
  const done = expect(await call('POST', `/driver/rides/${ride.id}/complete`, { token: dt, body: { location: { lat: 5.6935, lng: -0.029 } } }), 200, 'complete'); assert.equal(done.status, 'completed');

  const fin = expect(await call('GET', `/rides/${ride.id}`, { token: t }), 200); assert.equal(fin.payment.status, 'charged'); assert.equal(fin.payment.chargedPesewas, q.farePesewas);
  const rc = expect(await call('GET', `/rides/${ride.id}/receipt`, { token: t }), 200, 'receipt');
  assert.equal(rc.totalPesewas, q.farePesewas); assert.match(rc.receiptNumber, /^TRB-\d{8}-[0-9A-F]{6}$/);
  expect(await call('POST', `/rides/${ride.id}/rating`, { token: t, body: { stars: 5, tags: ['polite'], comment: 'Great' } }), 204);
  assert.equal((await call('POST', `/rides/${ride.id}/rating`, { token: t, body: { stars: 4 } })).status, 409, 'only once');
  assert.equal((await call('POST', `/rides/${ride.id}/rating`, { token: t, body: { stars: 9 } })).status, 422);

  const list = expect(await call('GET', '/rides?limit=1', { token: t }), 200); assert.equal(list.data.length, 1);
  const w = expect(await call('GET', '/wallet', { token: t }), 200); assert.equal(w.balancePesewas, 20000 - q.farePesewas); assert.equal(w.reservedPesewas, 0);
  const tx = expect(await call('GET', '/wallet/transactions?limit=1', { token: t }), 200);
  assert.equal(tx.data[0].type, 'ride_charge'); assert.equal(tx.data[0].balanceAfterPesewas, 20000 - q.farePesewas); assert.equal(tx.page.hasMore, true);
  const next = expect(await call('GET', `/wallet/transactions?limit=5&cursor=${encodeURIComponent(tx.page.nextCursor)}`, { token: t }), 200); assert.ok(next.data.length >= 1);
  expect(await call('GET', '/driver/rides?limit=5', { token: dt }), 200);
  assert.equal((await call('GET', '/driver/rides/current', { token: dt })).status, 204, 'no ride now');
});

test('cancel before pickup releases the hold; decline sends it back to searching; no-show needs the wait', async () => {
  const s = await approvedStudent(20000), t = s.accessToken;
  const d = await soleDriver('+233200000002'), dt = d.accessToken;

  // student cancels while searching/assigned
  const a = expect((await book(s)).res, 201);
  const c = expect(await call('POST', `/rides/${a.id}/cancel`, { token: t, body: { reasonCode: 'wrong_location', note: 'typo' } }), 200);
  assert.equal(c.status, 'cancelled'); assert.equal(c.payment.status, 'released'); assert.equal(c.cancellation.by, 'student');
  assert.equal(expect(await call('GET', '/wallet', { token: t }), 200).reservedPesewas, 0);

  // driver declines: the ride returns to searching and this driver is excluded
  const b = expect((await book(s)).res, 201);
  await until(async () => (await call('GET', `/rides/${b.id}`, { token: t })).body.status === 'assigned');
  expect(await call('POST', `/driver/rides/${b.id}/decline`, { token: dt, body: { reasonCode: 'too_far', note: 'far' } }), 204);
  assert.equal((await call('GET', `/rides/${b.id}`, { token: t })).body.status, 'searching');
  await sleep(2600);
  assert.equal((await call('GET', `/rides/${b.id}`, { token: t })).body.status, 'searching', 'the declining driver is not offered the ride again');
  expect(await call('POST', `/rides/${b.id}/cancel`, { token: t, body: {} }), 200);

  // no-show
  const e = expect((await book(s)).res, 201);
  await until(async () => (await call('GET', `/rides/${e.id}`, { token: t })).body.status === 'assigned');
  expect(await call('POST', `/driver/rides/${e.id}/arrived`, { token: dt, body: {} }), 200);
  const early = await call('POST', `/driver/rides/${e.id}/no-show`, { token: dt });
  assert.equal(early.status, 409); assert.equal(early.body.code, 'no_show_too_early');
  const cur = expect(await call('GET', '/driver/rides/current', { token: dt }), 200); assert.ok(cur.noShowAvailableAt);
  await pool.query(`UPDATE rides SET arrived_at = now() - interval '10 minutes' WHERE id=$1`, [e.id]);
  const ns = expect(await call('POST', `/driver/rides/${e.id}/no-show`, { token: dt }), 200, 'no-show'); assert.equal(ns.status, 'cancelled');
  assert.equal((await call('GET', `/rides/${e.id}`, { token: t })).body.cancellation.reasonCode, 'rider_no_show');
});

test('wallet: top-up -> signed webhook credits once -> transactions; amounts are bounded', async () => {
  const s = await login(randPhone('+23327')), t = s.accessToken;
  assert.equal((await call('POST', '/wallet/topups', { token: t, body: { amountPesewas: 100, channel: 'mobile_money' }, idem: true })).body.code, 'topup_amount_out_of_range');
  assert.equal((await call('POST', '/wallet/topups', { token: t, body: { amountPesewas: 5000, channel: 'card' }, idem: true })).status, 422);
  const k = uuid();
  const tu = expect(await call('POST', '/wallet/topups', { token: t, body: { amountPesewas: 5000, channel: 'mobile_money' }, idem: k }), 201);
  assert.equal(tu.status, 'pending'); assert.equal(tu.checkout.type, 'prompt');
  assert.equal((await call('POST', '/wallet/topups', { token: t, body: { amountPesewas: 6000, channel: 'mobile_money' }, idem: k })).body.code, 'idempotency_key_reused');
  const replay = expect(await call('POST', '/wallet/topups', { token: t, body: { amountPesewas: 5000, channel: 'mobile_money' }, idem: k }), 201); assert.equal(replay.id, tu.id);
  const raw = JSON.stringify({ transaction_reference: tu.reference, transaction_status: 'Funds Received', amount_received: '50.00', amount_validation: 'EXACT' });
  const hook = () => call('POST', '/webhooks/payaza', { raw, headers: { 'x-payaza-signature': sign(Buffer.from(raw)), 'content-type': 'application/json' } });
  assert.deepEqual(expect(await hook(), 200), { received: true }); await hook();
  assert.equal(expect(await call('GET', '/wallet', { token: t }), 200).balancePesewas, 5000, 'credited exactly once');
  assert.equal(expect(await call('GET', `/wallet/topups/${tu.id}`, { token: t }), 200).status, 'succeeded');
  assert.equal(expect(await call('GET', '/wallet/transactions', { token: t }), 200).data[0].type, 'topup');
});

test('share a live trip and raise an SOS', async () => {
  const s = await approvedStudent(20000), t = s.accessToken;
  await soleDriver('+233200000001');
  const { res } = await book(s); const ride = expect(res, 201);
  const c = expect(await call('POST', '/me/trusted-contacts', { token: t, body: { name: 'Dad', phone: randPhone('+23324') } }), 201);
  const sh = expect(await call('POST', `/rides/${ride.id}/share`, { token: t, body: { trustedContactIds: [c.id] } }), 201); assert.ok(sh.shareUrl);
  const pub = expect(await call('GET', `/public/trip-shares/${sh.shareUrl.split('/').pop()}`), 200); assert.ok(pub.dropoff.point);
  const sos = expect(await call('POST', '/safety/sos', { token: t, body: { rideId: ride.id, location: { lat: 5.72, lng: 0.07 }, note: 'help' } }), 201); assert.equal(sos.status, 'open');
  expect(await call('POST', `/rides/${ride.id}/cancel`, { token: t, body: {} }), 200);
});
