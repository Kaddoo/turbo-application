// What a driver sees on an offer, before and after acknowledging (D8, D17).
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import { call, expect, login, randPhone, pool, closeDb } from './walk-helpers.js';
after(closeDb);
const cleanup = (id) => pool.query(`UPDATE rides SET status='cancelled', cancelled_at=now(), cancel_by='system', cancel_reason='test cleanup', cancel_reason_code='other' WHERE driver_id=$1 AND status IN ('assigned','driver_arrived','in_progress')`, [id]);

test('an offered ride shows the driver the price, pickup and ETA before they acknowledge; never the PIN or phone', async () => {
  const d = await login('+233200000003', 'driver');
  await cleanup(d.user.id);
  const s = await login(randPhone('+23326'));
  const phone = (await call('GET', '/me', { token: s.accessToken })).body.phone;
  await pool.query(`UPDATE users SET first_name='Ama', full_name='Ama Test' WHERE id=$1`, [s.user.id]);
  await pool.query(`INSERT INTO driver_presence (driver_id,lat,lng) VALUES ($1,5.7203,0.0900) ON CONFLICT (driver_id) DO UPDATE SET lat=5.7203, lng=0.0900, seen_at=now()`, [d.user.id]);
  const ride = (await pool.query(
    `INSERT INTO rides (student_id,driver_id,status,assigned_at,ack_deadline,pickup_lat,pickup_lng,pickup_label,drop_lat,drop_lng,drop_label,distance_m,duration_s,fare_pesewas,pin)
     VALUES ($1,$2,'assigned',now(), now() + interval '45 seconds',5.7203,0.0757,'Central Gate',5.6935,-0.029,'Ashaiman China Mall',9000,900,3500,'4321') RETURNING id`, [s.user.id, d.user.id])).rows[0].id;

  const offer = expect(await call('GET', '/driver/rides/current', { token: d.accessToken }), 200);
  assert.equal(offer.id, ride); assert.equal(offer.status, 'assigned'); assert.equal(offer.acknowledgedAt, null);
  assert.equal(offer.farePesewas, 3500, 'price shown before accepting');
  assert.equal(offer.pickup.point.lat, 5.7203); assert.equal(offer.pickup.label, 'Central Gate'); assert.equal(offer.dropoff.label, 'Ashaiman China Mall');
  assert.equal(offer.routeDistanceMeters, 9000); assert.equal(offer.routeDurationSeconds, 900);
  assert.ok(offer.pickupDistanceMeters > 1500 && offer.pickupDistanceMeters < 2500, `distance to pickup ${offer.pickupDistanceMeters}`);
  assert.ok(offer.pickupEtaSeconds > 150 && offer.pickupEtaSeconds < 400, `eta ${offer.pickupEtaSeconds}`);
  assert.equal(offer.student.firstName, 'Ama');
  const text = JSON.stringify(offer);
  assert.ok(!text.includes('4321') && !text.includes(phone), 'no PIN, no student phone');
  assert.equal(expect(await call('GET', '/driver/rides', { token: d.accessToken }), 200).data[0].farePesewas, 3500, 'history shows fares too');
  const acked = expect(await call('POST', `/driver/rides/${ride}/ack`, { token: d.accessToken }), 200);
  assert.ok(acked.acknowledgedAt); assert.equal(acked.farePesewas, 3500);
  const other = await login('+233200000002', 'driver');
  assert.equal((await call('POST', `/driver/rides/${ride}/ack`, { token: other.accessToken })).status, 403, "another driver's ride");
  await cleanup(d.user.id);
});

test('no position yet means no ETA rather than a made-up one', async () => {
  const d = await login('+233200000001', 'driver');
  await cleanup(d.user.id);
  await pool.query('DELETE FROM driver_presence WHERE driver_id=$1', [d.user.id]);
  const s = await login(randPhone('+23326'));
  const ride = (await pool.query(`INSERT INTO rides (student_id,driver_id,status,assigned_at,pickup_lat,pickup_lng,drop_lat,drop_lng,distance_m,duration_s,fare_pesewas,pin)
     VALUES ($1,$2,'assigned',now(),5.72,0.07,5.69,-0.03,9000,900,3500,'1111') RETURNING id`, [s.user.id, d.user.id])).rows[0].id;
  const offer = expect(await call('GET', '/driver/rides/current', { token: d.accessToken }), 200);
  assert.equal(offer.pickupEtaSeconds, null); assert.equal(offer.pickupDistanceMeters, null); assert.equal(offer.farePesewas, 3500);
  await cleanup(d.user.id);
});

test('a wrong PIN is 400 invalid_pin; five wrong tries lock it with 409 pin_locked', async () => {
  const d = await login('+233200000003', 'driver');
  await cleanup(d.user.id);
  const s = await login(randPhone('+23326'));
  const ride = (await pool.query(`INSERT INTO rides (student_id,driver_id,status,assigned_at,arrived_at,pickup_lat,pickup_lng,drop_lat,drop_lng,distance_m,duration_s,fare_pesewas,pin)
     VALUES ($1,$2,'driver_arrived',now(),now(),5.72,0.07,5.69,-0.03,9000,900,3500,'1234') RETURNING id`, [s.user.id, d.user.id])).rows[0].id;
  for (let i = 0; i < 5; i++) { const r = await call('POST', `/driver/rides/${ride}/start`, { token: d.accessToken, body: { pin: '0000' } }); assert.equal(r.status, 400); assert.equal(r.body.code, 'invalid_pin'); }
  const locked = await call('POST', `/driver/rides/${ride}/start`, { token: d.accessToken, body: { pin: '1234' } });
  assert.equal(locked.status, 409); assert.equal(locked.body.code, 'pin_locked', 'even the right PIN is refused once locked');
  assert.equal((await call('POST', `/driver/rides/${ride}/start`, { token: d.accessToken, body: { pin: '12' } })).status, 422, 'contract: exactly 4 digits');
  await cleanup(d.user.id);
});
