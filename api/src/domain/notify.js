// Everything the apps are told by push. Each function takes the caller's database client so the notification joins the caller's transaction:
// it exists only if the event it announces really happened. Delivery is the worker's job (worker.js -> sendPushes).
//
// Rules for what goes in a push (it lands on a lock screen, and Google carries it):
//  - never a PIN, a phone number, an identity detail, or a full address; the app fetches the details after the user taps
//  - `data` carries only ids and a `type`, so the app knows where to navigate
const cedis = (p) => `GH₵${(p / 100).toFixed(2).replace(/\.00$/, '')}`;

// kind -> text, delivery priority and how long the message stays useful
const KINDS = {
  ride_offer:        { title: 'New ride request', body: 'Tap to see the pickup and the fare, then accept.', priority: 10, ttl: 60 },
  ride_assigned:     { title: 'Driver on the way', body: (v) => (v.driver ? `${v.driver}${v.vehicle ? ` in a ${v.vehicle}` : ''} is coming to pick you up.` : 'A driver has been assigned.'), priority: 10, ttl: 600 },
  ride_reassigned:   { title: 'New driver assigned', body: 'Your ride has a new driver. Tap for details.', priority: 10, ttl: 600 },
  ride_arrived:      { title: 'Your driver has arrived', body: 'Tell them your PIN to start the trip.', priority: 10, ttl: 300 },
  ride_completed:    { title: 'Trip complete', body: (v) => `You paid ${cedis(v.fare)}. Tap to see your receipt and rate your driver.`, priority: 5, ttl: 86400 },
  ride_cancelled:    { title: 'Ride cancelled', body: (v) => v.body || 'Your ride was cancelled.', priority: 10, ttl: 3600 },
  ride_cancelled_driver: { title: 'Ride cancelled', body: 'The rider cancelled this trip. You are free for the next request.', priority: 10, ttl: 600 },
  quick_message:     { title: (v) => (v.fromDriver ? 'Message from your driver' : 'Message from your rider'), body: (v) => v.text, priority: 10, ttl: 300 },
  verification:      { title: (v) => v.title, body: (v) => v.body, priority: 5, ttl: 7 * 86400 },
  topup_succeeded:   { title: 'Top-up received', body: (v) => `${cedis(v.amount)} was added to your wallet.`, priority: 5, ttl: 86400 },
  refund:            { title: 'Refund issued', body: (v) => `${cedis(v.amount)} was returned to your wallet.`, priority: 5, ttl: 86400 },
  support_reply:     { title: 'Turbo support replied', body: 'Tap to read the reply.', priority: 5, ttl: 7 * 86400 },
  incident_ack:      { title: 'Help is on the way', body: 'Our team has seen your alert and is responding.', priority: 10, ttl: 3600 },
  sos:               { title: 'SOS alert', body: 'A rider or driver needs help now. Open the dashboard.', priority: 10, ttl: 900 },
  ride_stuck:        { title: 'Ride needs attention', body: 'A ride has been flagged (driver unreachable or overdue).', priority: 5, ttl: 3600 },
  document_expiring: { title: 'Driver document expiring', body: (v) => v.body, priority: 1, ttl: 7 * 86400 },
  announcement:      { title: (v) => v.title, body: (v) => v.body, priority: 1, ttl: 86400 },
};
const text = (x, v) => (typeof x === 'function' ? x(v) : x);
const QUICK = { im_here: "I'm here", running_late: "I'm running a little late", at_the_gate: "I'm at the gate", cannot_find_you: "I can't find you",
  please_come_out: 'Please come out, I am waiting', on_my_way: "I'm on my way" };
export const quickText = (code) => QUICK[code] ?? 'New message';

const safe = (s, n) => String(s ?? '').replace(/[\u0000-\u001f\u007f]/g, ' ').slice(0, n);

// One user, if they have at least one registered device (no device = nothing to send = no row).
export async function notifyUser(c, userId, kind, { vars = {}, data = {}, dedupe = null, userType = 'user' } = {}) {
  const k = KINDS[kind];
  await c.query(
    `INSERT INTO notifications (user_id,user_type,kind,title,body,data,priority,dedupe_key,expires_at)
     SELECT $1,$2,$3,$4,$5,$6,$7,$8, now() + make_interval(secs => $9)
      WHERE EXISTS (SELECT 1 FROM devices d WHERE d.user_id=$1 AND d.user_type=$2)
     ON CONFLICT (dedupe_key) WHERE dedupe_key IS NOT NULL DO NOTHING`,
    [userId, userType, kind, safe(text(k.title, vars), 80), safe(text(k.body, vars), 200), JSON.stringify({ type: kind, ...data }), k.priority, dedupe, k.ttl]);
}

// Every active staff member with one of these roles (super_admin always included).
export async function notifyStaff(c, roles, kind, { vars = {}, data = {}, dedupe = null } = {}) {
  const k = KINDS[kind];
  await c.query(
    `INSERT INTO notifications (user_id,user_type,kind,title,body,data,priority,dedupe_key,expires_at)
     SELECT s.id,'staff',$1,$2,$3,$4,$5, CASE WHEN $6::text IS NULL THEN NULL ELSE $6 || ':' || s.id END, now() + make_interval(secs => $7)
       FROM staff_users s WHERE s.is_active AND (s.role = 'super_admin' OR s.role = ANY($8))
        AND EXISTS (SELECT 1 FROM devices d WHERE d.user_id=s.id AND d.user_type='staff')
     ON CONFLICT (dedupe_key) WHERE dedupe_key IS NOT NULL DO NOTHING`,
    [kind, safe(text(k.title, vars), 80), safe(text(k.body, vars), 200), JSON.stringify({ type: kind, ...data }), k.priority, dedupe, k.ttl, roles]);
}

// Announcement fan-out: one row per active user in the audience who has a device (a single INSERT ... SELECT, even for thousands).
export async function notifyAudience(c, audience, { title, body, announcementId }) {
  const roles = audience === 'students' ? ['student'] : audience === 'drivers' ? ['driver'] : ['student', 'driver'];
  const k = KINDS.announcement;
  const { rowCount } = await c.query(
    `INSERT INTO notifications (user_id,user_type,kind,title,body,data,priority,dedupe_key,expires_at)
     SELECT u.id,'user','announcement',$1,$2,$3,$4,'announce:' || $5 || ':' || u.id, now() + make_interval(secs => $6)
       FROM users u WHERE u.role = ANY($7) AND u.status='active' AND u.deleted_at IS NULL
        AND EXISTS (SELECT 1 FROM devices d WHERE d.user_id=u.id AND d.user_type='user')
     ON CONFLICT (dedupe_key) WHERE dedupe_key IS NOT NULL DO NOTHING`,
    [safe(title, 80), safe(body, 200), JSON.stringify({ type: 'announcement', announcementId }), k.priority, announcementId, k.ttl, roles]);
  return rowCount;
}

// ---- ride events ----------------------------------------------------------------------------------------------------------------
const rideData = (ride) => ({ rideId: ride.id });

export async function rideAssigned(c, ride, driverId, { reassigned = false } = {}) {
  const { rows: [d] } = await c.query(
    `SELECT COALESCE(u.first_name, split_part(u.full_name,' ',1)) AS name, v.colour, v.make FROM users u LEFT JOIN drivers dr ON dr.user_id=u.id LEFT JOIN vehicles v ON v.id=dr.vehicle_id WHERE u.id=$1`, [driverId]);
  // no dedupe: every assignment (including an admin re-offering a ride) is a new event the driver must hear about
  await notifyUser(c, driverId, 'ride_offer', { data: rideData(ride) });
  await notifyUser(c, ride.student_id, reassigned ? 'ride_reassigned' : 'ride_assigned',
    { vars: { driver: d?.name, vehicle: d?.colour && d?.make ? `${d.colour} ${d.make}` : null }, data: rideData(ride) });
}
export const rideArrived = (c, ride) => notifyUser(c, ride.student_id, 'ride_arrived', { data: rideData(ride), dedupe: `arrived:${ride.id}` });
export const rideCompleted = (c, ride) => notifyUser(c, ride.student_id, 'ride_completed', { vars: { fare: ride.fare_pesewas }, data: rideData(ride), dedupe: `completed:${ride.id}` });

// Tell the OTHER party. by: 'student' | 'driver' | 'admin' | 'system'
export async function rideCancelled(c, ride, by, reasonCode) {
  const data = rideData(ride);
  if (by === 'student') {
    if (ride.driver_id) await notifyUser(c, ride.driver_id, 'ride_cancelled_driver', { data, dedupe: `cancel-d:${ride.id}:${ride.driver_id}` });
    return;
  }
  const body = reasonCode === 'no_driver_available' ? "We couldn't find a driver this time. You have not been charged."
    : reasonCode === 'rider_no_show' ? 'Your driver waited and could not find you, so the ride was cancelled. You have not been charged.'
    : 'Your ride was cancelled and you have not been charged.';
  await notifyUser(c, ride.student_id, 'ride_cancelled', { vars: { body }, data, dedupe: `cancel-s:${ride.id}` });
  if (by === 'admin' && ride.driver_id) await notifyUser(c, ride.driver_id, 'ride_cancelled_driver', { data, dedupe: `cancel-d:${ride.id}:${ride.driver_id}` });
}
