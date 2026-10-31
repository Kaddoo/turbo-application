import { ApiError, conflict } from '../lib/errors.js';
import { haversineM } from '../lib/util.js';
import * as wallet from './wallet.js';
import { rideCancelled, rideCompleted } from './notify.js';

export const ACTIVE = ['searching', 'assigned', 'driver_arrived', 'in_progress'];

export async function event(c, rideId, type, actorType, actorId, data) {
  await c.query('INSERT INTO ride_events (ride_id,type,actor_type,actor_id,data) VALUES ($1,$2,$3,$4,$5)',
    [rideId, type, actorType, actorId ?? null, data ? JSON.stringify(data) : null]);
}

export async function lockRide(c, id) {
  const { rows } = await c.query('SELECT * FROM rides WHERE id=$1 FOR UPDATE', [id]);
  if (!rows[0]) throw new ApiError(404, 'not_found', 'Ride not found');
  return rows[0];
}

const need = (ride, states, msg) => {
  if (!states.includes(ride.status)) throw conflict('invalid_ride_state', msg || `Ride is ${ride.status}`);
};

// Cancel and release the hold. Lock order is always ride -> wallet.
// reasonCode is one of the contract's Cancellation.reasonCode values; note is free text.
export async function cancelRide(c, ride, by, reasonCode, actorId, note = null) {
  need(ride, ['searching', 'assigned', 'driver_arrived'], ride.status === 'in_progress' ? 'Trip already started' : `Ride is ${ride.status}`);
  await c.query(`UPDATE rides SET status='cancelled', cancel_by=$2, cancel_reason=$3, cancel_reason_code=$3, cancel_note=$4, cancelled_at=now(), ack_deadline=NULL WHERE id=$1`, [ride.id, by, reasonCode, note]);
  await wallet.release(c, ride.student_id, ride.id);
  await event(c, ride.id, 'cancelled', by, actorId, { reasonCode, note });
  await rideCancelled(c, ride, by, reasonCode);
}

export async function completeRide(c, ride, actorType, actorId, loc, reason) {
  need(ride, ['in_progress']);
  const flags = [...ride.flags];
  if (loc) {
    if (haversineM(loc.lat, loc.lng, ride.drop_lat, ride.drop_lng) > 500) flags.push('completed_far_from_destination');
  }
  if (Date.now() - new Date(ride.started_at).getTime() < 60_000) flags.push('completed_too_fast');
  await c.query(`UPDATE rides SET status='completed', completed_at=now(), complete_lat=$2, complete_lng=$3, flags=$4 WHERE id=$1`,
    [ride.id, loc?.lat ?? null, loc?.lng ?? null, flags]);
  const charged = await wallet.charge(c, ride.student_id, ride.id);
  await event(c, ride.id, 'completed', actorType, actorId, { charged, reason, flags });
  await rideCompleted(c, ride);
  return charged;
}
