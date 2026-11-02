import { Router } from 'express';
import crypto from 'node:crypto';
import { q, tx } from '../db.js';
import { authenticate, requireRole, terms } from '../lib/auth.js';
import { ApiError, notFound, conflict } from '../lib/errors.js';
import { isUuid, haversineM } from '../lib/util.js';
import { getSettings } from '../lib/settings.js';
import { pageArgs, pageOf } from '../lib/page.js';
import { ACTIVE, event, lockRide, cancelRide, completeRide } from '../domain/rides.js';
import { RIDE_SQL, rideView, location, vehicleView, iso, fullName, opt, cancelCode } from '../views.js';
import { clockIn, clockOut } from '../domain/attendance.js';
import { rideArrived } from '../domain/notify.js';

export const driver = Router();
const D = [authenticate, requireRole('driver'), terms];

async function profile(uid) {
  const { rows: [d] } = await q(
    // v.* first: its id and status are null for a driver with no vehicle, and the last column of a name wins, so the user's must come after.
    `SELECT v.*, v.id AS vid, u.id, u.full_name, u.first_name, u.last_name, u.phone, u.status, d.on_duty, d.active,
            (SELECT id FROM rides WHERE driver_id=u.id AND status = ANY($2) LIMIT 1) AS current_ride
       FROM users u JOIN drivers d ON d.user_id=u.id LEFT JOIN vehicles v ON v.id=d.vehicle_id WHERE u.id=$1`, [uid, ACTIVE]);
  // One row per type: the document that expires last (a renewal replaces the old one). Days are counted on the Accra date.
  const { rows: docs } = await q(
    `SELECT DISTINCT ON (type) type, expires_on::text AS expires_on, (expires_on - (now() AT TIME ZONE 'Africa/Accra')::date) AS days_left
       FROM driver_documents WHERE driver_id=$1 AND deleted_at IS NULL AND type IN ('drivers_licence','vehicle_registration','insurance','roadworthy')
       ORDER BY type, expires_on DESC NULLS FIRST`, [uid]);
  return {
    id: d.id, fullName: fullName(d) ?? 'Driver', phone: d.phone, status: d.status, dutyStatus: d.on_duty ? 'on_duty' : 'off_duty',
    vehicle: d.vid ? vehicleView({ ...d, id: d.vid }) : null, currentRideId: d.current_ride ?? null,
    documents: docs.map((x) => ({ type: x.type, expiresOn: x.expires_on, daysLeft: x.days_left, status: x.days_left == null ? 'valid' : x.days_left < 0 ? 'expired' : x.days_left < 30 ? 'expiring' : 'valid' })),
  };
}
driver.get('/driver/profile', ...D, async (req, res) => res.json(await profile(req.user.id)));

driver.put('/driver/duty', ...D, async (req, res) => {
  const on = req.body.onDuty;
  await tx(async (c) => {
    const { rows: [d] } = await c.query('SELECT * FROM drivers WHERE user_id=$1 FOR UPDATE', [req.user.id]);
    if (!d.active) throw new ApiError(403, 'account_suspended', 'Driver account inactive');
    if (!on) {
      const { rows } = await c.query('SELECT 1 FROM rides WHERE driver_id=$1 AND status = ANY($2)', [req.user.id, ACTIVE]);
      if (rows.length) throw conflict('driver_has_active_ride', 'Finish your current ride first');
      if (d.on_duty) { await c.query('UPDATE drivers SET on_duty=false, duty_since=NULL WHERE user_id=$1', [req.user.id]); await clockOut(c, req.user.id, d.duty_since); }
    } else if (!d.on_duty) {
      // A licence, the vehicle's insurance or its roadworthy certificate that has expired keeps the driver off the road.
      const { rows: [bad] } = await c.query(
        `SELECT type, expires_on::text AS expired_on FROM driver_documents WHERE driver_id=$1 AND deleted_at IS NULL AND expires_on < current_date AND type IN ('drivers_licence','insurance','roadworthy') ORDER BY expires_on LIMIT 1`, [req.user.id]);
      if (bad) throw conflict('document_expired', `Your ${bad.type.replace('_', ' ')} has expired. Contact the office to renew it.`, { documentType: bad.type, expiredOn: bad.expired_on });
      await c.query('UPDATE drivers SET on_duty=true, duty_since=now() WHERE user_id=$1', [req.user.id]);
      await clockIn(c, req.user.id);
    }
  });
  res.json(await profile(req.user.id));
});

// Hot path: one upsert (+ a sampled history insert). Latest point lives in an UNLOGGED table.
// A batch (after a dropped connection) is reduced to its newest point; we stamp it with SERVER time so a wrong phone clock cannot make a stale position look fresh.
driver.put('/driver/location', ...D, async (req, res) => {
  const pts = [...req.body.points].sort((a, b) => new Date(a.recordedAt) - new Date(b.recordedAt));
  const last = pts.at(-1), p = last.point;
  const { rows: [r] } = await q(
    `INSERT INTO driver_presence AS dp (driver_id,lat,lng,heading,speed,seen_at,last_sampled_at)
     VALUES ($1,$2,$3,$4,$5,now(),now() - interval '1 day')
     ON CONFLICT (driver_id) DO UPDATE SET lat=$2, lng=$3, heading=$4, speed=$5, seen_at=now(),
       last_sampled_at = CASE WHEN dp.last_sampled_at < now() - interval '30 seconds'
                                OR EXISTS (SELECT 1 FROM rides WHERE driver_id=$1 AND status IN ('assigned','driver_arrived','in_progress'))
                              THEN now() ELSE dp.last_sampled_at END
     RETURNING (last_sampled_at = now()) AS sampled`,
    [req.user.id, p.lat, p.lng, last.headingDegrees ?? null, last.speedMps ?? null]);
  if (r.sampled) await q(
    `INSERT INTO driver_locations (driver_id,ride_id,lat,lng)
     VALUES ($1,(SELECT id FROM rides WHERE driver_id=$1 AND status IN ('assigned','driver_arrived','in_progress')),$2,$3)`, [req.user.id, p.lat, p.lng]);
  res.status(204).end();
});

// Driver never sees the PIN or the student's phone (D17). They do see what they need to decide on an offer: where, how far, what it pays.
const driverRide = (r, cfg) => {
  const base = rideView(r);
  let dist = null, eta = null;
  if (r.p_lat != null && ['assigned', 'driver_arrived'].includes(r.status)) {
    dist = Math.round(haversineM(r.p_lat, r.p_lng, r.pickup_lat, r.pickup_lng) * 1.3);
    eta = r.status === 'assigned' ? Math.round(dist / (25000 / 3600)) : 0;
  }
  return {
    id: r.id, status: r.status, pickup: base.pickup, dropoff: base.dropoff, routeDistanceMeters: r.distance_m, routePolyline: r.route_polyline ?? null, farePesewas: r.fare_pesewas,
    pickupDistanceMeters: dist, pickupEtaSeconds: eta, routeDurationSeconds: r.duration_s, student: { firstName: r.s_first ?? 'Student' },
    assignedAt: iso(r.assigned_at ?? r.requested_at), acknowledgedAt: iso(r.acked_at),
    arrivedAt: iso(r.arrived_at), startedAt: iso(r.started_at), completedAt: iso(r.completed_at), cancelledAt: iso(r.cancelled_at),
    cancelledBy: r.status === 'cancelled' ? r.cancel_by : null, cancelReasonCode: r.status === 'cancelled' ? cancelCode(r.cancel_reason_code ?? r.cancel_reason) : null,
    noShowAvailableAt: r.status === 'driver_arrived' && r.arrived_at ? new Date(new Date(r.arrived_at).getTime() + cfg.noShowWaitSeconds * 1000).toISOString() : null,
  };
};

driver.get('/driver/rides/current', ...D, async (req, res) => {
  const { rows: [r] } = await q(`${RIDE_SQL} WHERE r.driver_id=$1 AND r.status IN ('assigned','driver_arrived','in_progress')`, [req.user.id]);
  if (!r) return res.status(204).end();
  res.json(driverRide(r, await getSettings()));
});

driver.get('/driver/rides', ...D, async (req, res) => {
  const a = pageArgs(req), cfg = await getSettings();
  const { rows } = await q(`${RIDE_SQL} WHERE r.driver_id=$1 AND ($2::timestamptz IS NULL OR (r.requested_at, r.id) < ($2::timestamptz, $3::uuid))
      ORDER BY r.requested_at DESC, r.id DESC LIMIT $4`, [req.user.id, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.requested_at, r.id], (r) => driverRide(r, cfg)));
});

// Runs fn under the ride lock; ensures this driver owns the ride.
async function act(req, res, fn, { empty = false } = {}) {
  if (!isUuid(req.params.id)) throw notFound('Ride');
  const id = await tx(async (c) => {
    const { rows: [exists] } = await c.query('SELECT driver_id FROM rides WHERE id=$1', [req.params.id]);
    if (!exists) throw notFound('Ride');
    const ride = await lockRide(c, req.params.id);
    if (ride.driver_id !== req.user.id) throw new ApiError(403, 'driver_not_assigned', 'This ride is not assigned to you');
    await fn(c, ride);
    return ride.id;
  });
  if (empty) return res.status(204).end();
  const { rows: [r] } = await q(`${RIDE_SQL} WHERE r.id=$1`, [id]);
  res.json(driverRide(r, await getSettings()));
}
const must = (ride, st) => { if (!st.includes(ride.status)) throw conflict('invalid_ride_state', `Ride is ${ride.status}`); };

driver.post('/driver/rides/:id/ack', ...D, (req, res) => act(req, res, async (c, ride) => {
  must(ride, ['assigned']);
  await c.query('UPDATE rides SET acked_at=now(), ack_deadline=NULL WHERE id=$1', [ride.id]);
  await event(c, ride.id, 'driver_acknowledged', 'driver', req.user.id);
}));

driver.post('/driver/rides/:id/decline', ...D, (req, res) => act(req, res, async (c, ride) => {
  must(ride, ['assigned', 'driver_arrived']);
  await c.query('INSERT INTO ride_declines (ride_id,driver_id,reason) VALUES ($1,$2,$3)', [ride.id, req.user.id, req.body.reasonCode]);
  await c.query(`UPDATE rides SET status='searching', driver_id=NULL, assigned_at=NULL, acked_at=NULL, arrived_at=NULL, ack_deadline=NULL WHERE id=$1`, [ride.id]);
  await event(c, ride.id, 'driver_declined', 'driver', req.user.id, { reasonCode: req.body.reasonCode, note: req.body.note ?? null });
}, { empty: true }));

driver.post('/driver/rides/:id/arrived', ...D, (req, res) => act(req, res, async (c, ride) => {
  must(ride, ['assigned']);
  await c.query(`UPDATE rides SET status='driver_arrived', arrived_at=now(), acked_at=COALESCE(acked_at,now()), ack_deadline=NULL WHERE id=$1`, [ride.id]);
  await event(c, ride.id, 'driver_arrived', 'driver', req.user.id, req.body?.location ? { location: req.body.location } : null);
  await rideArrived(c, ride);
}));

driver.post('/driver/rides/:id/start', ...D, (req, res) => act(req, res, async (c, ride) => {
  must(ride, ['driver_arrived']);
  if (ride.pin_attempts >= 5) throw conflict('pin_locked', 'Too many wrong PINs; contact staff');
  const pin = req.body.pin;
  const ok = typeof ride.pin === 'string' && ride.pin.length === 4 && crypto.timingSafeEqual(Buffer.from(pin), Buffer.from(ride.pin));
  if (!ok) {
    await c.query('UPDATE rides SET pin_attempts=pin_attempts+1 WHERE id=$1', [ride.id]);
    await c.query('COMMIT'); await c.query('BEGIN');            // keep the attempt count
    throw new ApiError(400, 'invalid_pin', 'Wrong PIN');
  }
  await c.query(`UPDATE rides SET status='in_progress', started_at=now(), pin=NULL WHERE id=$1`, [ride.id]);
  await event(c, ride.id, 'trip_started', 'driver', req.user.id);
}));

driver.post('/driver/rides/:id/complete', ...D, (req, res) => act(req, res, async (c, ride) => {
  await completeRide(c, ride, 'driver', req.user.id, req.body?.location ?? null);
}));

driver.post('/driver/rides/:id/no-show', ...D, (req, res) => act(req, res, async (c, ride) => {
  must(ride, ['driver_arrived']);
  const cfg = await getSettings();
  if (Date.now() - new Date(ride.arrived_at).getTime() < cfg.noShowWaitSeconds * 1000)
    throw conflict('no_show_too_early', `Wait ${cfg.noShowWaitSeconds} seconds after arriving`);
  await cancelRide(c, ride, 'driver', 'rider_no_show', req.user.id);
  await c.query('UPDATE students SET no_show_count=no_show_count+1 WHERE user_id=$1', [ride.student_id]);
}));
