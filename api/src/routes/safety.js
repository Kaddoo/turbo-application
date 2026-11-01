import { Router } from 'express';
import { q, tx } from '../db.js';
import { authenticate, requireRole, terms } from '../lib/auth.js';
import { ApiError, bad, notFound, conflict } from '../lib/errors.js';
import { isUuid, num, sha256, randomToken } from '../lib/util.js';
import { safeForMessage } from '../lib/sanitize.js';
import { limit } from '../lib/ratelimit.js';
import { pageArgs, pageOf } from '../lib/page.js';
import { qEnum } from '../lib/query.js';
import { sendSms } from '../lib/notify.js';
import { config } from '../config.js';
import { ensureBody } from '../lib/contract.js';
import { notifyStaff, notifyUser } from '../domain/notify.js';
import { ACTIVE, event } from '../domain/rides.js';
import { log } from '../app.js';

export const safety = Router();
const S = [authenticate, requireRole('student'), terms];
const MAX_CONTACTS = 5;

// ---------- trusted contacts ----------
const contactView = (c) => ({ id: c.id, name: c.name, phone: c.phone, relationship: c.relationship });

safety.get('/me/trusted-contacts', ...S, async (req, res) => {
  const { rows } = await q('SELECT * FROM trusted_contacts WHERE student_id=$1 AND deleted_at IS NULL ORDER BY created_at', [req.user.id]);
  res.json({ data: rows.map(contactView) });
});

safety.post('/me/trusted-contacts', ...S, async (req, res) => {
  const { name, phone, relationship } = req.body || {};
  const errors = [];
  if (typeof name !== 'string' || !name.trim() || name.length > 80) errors.push({ field: 'name', message: '1 to 80 characters' });
  if (typeof phone !== 'string' || !/^\+233[0-9]{9}$/.test(phone)) errors.push({ field: 'phone', message: 'format +233XXXXXXXXX' });
  if (relationship != null && (typeof relationship !== 'string' || relationship.length > 40)) errors.push({ field: 'relationship', message: 'up to 40 characters' });
  if (errors.length) throw new ApiError(422, 'validation_failed', 'Invalid contact', { errors });
  const c = await tx(async (cl) => {
    await cl.query('SELECT 1 FROM students WHERE user_id=$1 FOR UPDATE', [req.user.id]);          // serialises concurrent adds
    const { rows: [n] } = await cl.query('SELECT count(*)::int n FROM trusted_contacts WHERE student_id=$1 AND deleted_at IS NULL', [req.user.id]);
    if (n.n >= MAX_CONTACTS) throw new ApiError(422, 'validation_failed', `You can have at most ${MAX_CONTACTS} trusted contacts`);
    return (await cl.query('INSERT INTO trusted_contacts (student_id,name,phone,relationship) VALUES ($1,$2,$3,$4) RETURNING *',
      [req.user.id, name.trim(), phone, relationship?.trim() || null])).rows[0];
  });
  res.status(201).json(contactView(c));
});

safety.delete('/me/trusted-contacts/:id', ...S, async (req, res) => {
  if (!isUuid(req.params.id)) throw notFound('Contact');
  const { rowCount } = await q('UPDATE trusted_contacts SET deleted_at=now() WHERE id=$1 AND student_id=$2 AND deleted_at IS NULL', [req.params.id, req.user.id]);
  if (!rowCount) throw notFound('Contact');
  res.status(204).end();
});

// ---------- trip share ----------
const SHARE_HOURS = 6;
safety.post('/rides/:id/share', ...S, async (req, res) => {
  const ids = req.body?.trustedContactIds;
  if (!Array.isArray(ids) || ids.length < 1 || ids.length > MAX_CONTACTS || !ids.every(isUuid) || new Set(ids).size !== ids.length)
    throw new ApiError(422, 'validation_failed', 'Choose 1 to 5 of your trusted contacts', { errors: [{ field: 'trustedContactIds', message: '1 to 5 distinct ids' }] });
  if (!isUuid(req.params.id)) throw notFound('Ride');
  const { rows: [ride] } = await q(`SELECT r.id,r.status,u.first_name FROM rides r JOIN users u ON u.id=r.student_id WHERE r.id=$1 AND r.student_id=$2`, [req.params.id, req.user.id]);
  if (!ride) throw notFound('Ride');
  if (!ACTIVE.includes(ride.status)) throw conflict('invalid_ride_state', 'Only a ride in progress can be shared');
  const { rows: contacts } = await q('SELECT * FROM trusted_contacts WHERE id = ANY($1) AND student_id=$2 AND deleted_at IS NULL', [ids, req.user.id]);
  if (contacts.length !== ids.length) throw new ApiError(422, 'validation_failed', 'Unknown trusted contact', { errors: [{ field: 'trustedContactIds', message: 'not yours' }] });

  // SMS is paid and goes out under Turbo's name, so it cannot be a free text-anyone tool: 10 messages per student per day,
  // and no more than 3 per recipient number per day from all students combined.
  const { rows: [lim] } = await q(`SELECT (SELECT count(*)::int FROM share_sms_log WHERE student_id=$1 AND created_at > now() - interval '1 day') AS mine,
      (SELECT max(n)::int FROM (SELECT count(*) n FROM share_sms_log WHERE phone = ANY($2) AND created_at > now() - interval '1 day' GROUP BY phone) x) AS theirs`,
    [req.user.id, contacts.map((c) => c.phone)]);
  if (lim.mine + contacts.length > 10 || (lim.theirs ?? 0) >= 3) throw new ApiError(429, 'rate_limited', 'Sharing limit reached for today', { retryAfterSeconds: 3600 });
  await q('INSERT INTO share_sms_log (student_id,phone) SELECT $1, unnest($2::text[])', [req.user.id, contacts.map((c) => c.phone)]);

  const token = randomToken(24);
  const { rows: [sh] } = await q(
    `INSERT INTO trip_shares (ride_id,student_id,token_hash,contact_ids,expires_at) VALUES ($1,$2,$3,$4, now() + make_interval(hours => $5)) RETURNING expires_at`,
    [ride.id, req.user.id, sha256(token), ids, SHARE_HOURS]);
  const shareUrl = `${config.shareBaseUrl}/${token}`;
  const notified = [];
  await Promise.all(contacts.map(async (c) => {
    try { await sendSms(c.phone, `${safeForMessage(ride.first_name)} shared a live trip with you on Turbo. Follow it here: ${shareUrl}`); notified.push(c.id); }
    catch (e) { log.warn({ err: e.message, contactId: c.id }, 'trip share sms failed'); }
  }));
  res.status(201).json({ shareUrl, expiresAt: sh.expires_at, notifiedContactIds: notified });
});

// No auth: the token is the credential. 24 random bytes, stored hashed, rate limited per IP.
safety.get('/public/trip-shares/:token', limit('share', 60, 60_000, (req) => req.ip), async (req, res) => {
  const { rows: [r] } = await q(
    `SELECT sh.expires_at, r.status, r.completed_at, r.cancelled_at, r.drop_lat, r.drop_lng, r.drop_label,
            su.first_name AS s_first, du.first_name AS d_first, d.vehicle_make, d.vehicle_model, d.vehicle_color, d.plate,
            p.lat, p.lng, p.heading, p.speed, p.seen_at
       FROM trip_shares sh JOIN rides r ON r.id=sh.ride_id JOIN users su ON su.id=r.student_id
       LEFT JOIN users du ON du.id=r.driver_id LEFT JOIN drivers d ON d.user_id=r.driver_id LEFT JOIN driver_presence p ON p.driver_id=r.driver_id
      WHERE sh.token_hash=$1 AND sh.expires_at > now()`, [sha256(String(req.params.token).slice(0, 128))]);
  // A link dies shortly after the ride ends.
  const ended = r && (r.completed_at || r.cancelled_at);
  if (!r || (ended && Date.now() - new Date(ended).getTime() > 10 * 60_000)) throw notFound('Trip share');
  const live = r.lat != null && ['assigned', 'driver_arrived', 'in_progress'].includes(r.status);
  res.set('cache-control', 'no-store').json({
    rideStatus: r.status, studentFirstName: r.s_first || 'Rider', driverFirstName: r.d_first ?? null,
    vehicle: r.vehicle_make ? { make: r.vehicle_make, model: r.vehicle_model, colour: r.vehicle_color, plateNumber: r.plate } : null,
    driverLocation: live ? { point: { lat: r.lat, lng: r.lng }, headingDegrees: r.heading, speedMps: r.speed, recordedAt: r.seen_at } : null,
    dropoff: { point: { lat: r.drop_lat, lng: r.drop_lng }, label: r.drop_label }, expiresAt: r.expires_at });
});

// ---------- SOS ----------
const incidentView = (i) => ({ id: i.id, type: i.type, status: i.status, rideId: i.ride_id, location: i.lat != null ? { lat: i.lat, lng: i.lng } : null,
  note: i.note, createdAt: i.created_at });

safety.post('/safety/sos', authenticate, terms, async (req, res) => {
  if (!['student', 'driver'].includes(req.user.role)) throw new ApiError(403, 'forbidden', 'Not allowed for this account');
  ensureBody(req);
  const { rideId, location, note } = req.body || {};
  const errors = [];
  if (!location || !num(location.lat) || !num(location.lng) || Math.abs(location.lat) > 90 || Math.abs(location.lng) > 180) errors.push({ field: 'location', message: '{lat, lng} required' });
  if (rideId != null && !isUuid(rideId)) errors.push({ field: 'rideId', message: 'must be an id' });
  if (note != null && (typeof note !== 'string' || note.length > 300)) errors.push({ field: 'note', message: 'up to 300 characters' });
  if (errors.length) throw new ApiError(422, 'validation_failed', 'Invalid SOS', { errors });

  const inc = await tx(async (c) => {
    // Pressing it twice must not bury staff in duplicates: reuse an unresolved SOS from the last 5 minutes.
    const { rows: [dup] } = await c.query(
      `SELECT * FROM incidents WHERE reporter_id=$1 AND type='sos' AND status<>'resolved' AND created_at > now() - interval '5 minutes' ORDER BY created_at DESC LIMIT 1`, [req.user.id]);
    if (dup) return dup;
    if (rideId) {
      const col = req.user.role === 'student' ? 'student_id' : 'driver_id';
      const { rows: [ride] } = await c.query(`SELECT id,flags FROM rides WHERE id=$1 AND ${col}=$2 FOR UPDATE`, [rideId, req.user.id]);
      if (!ride) throw notFound('Ride');
      if (!ride.flags.includes('sos')) await c.query(`UPDATE rides SET flags = array_append(flags,'sos') WHERE id=$1`, [rideId]);
      await event(c, rideId, 'sos', req.user.role, req.user.id, { location });
    }
    const { rows: [i] } = await c.query(
      `INSERT INTO incidents (type,reporter_id,reporter_role,ride_id,lat,lng,note) VALUES ('sos',$1,$2,$3,$4,$5,$6) RETURNING *`,
      [req.user.id, req.user.role, rideId ?? null, location.lat, location.lng, note?.trim() || null]);
    // Every on-call support member (and super admins) is pushed at once, high priority. In the same transaction as the incident itself.
    await notifyStaff(c, ['support'], 'sos', { data: { incidentId: i.id, ...(rideId && { rideId }) }, dedupe: `sos:${i.id}` });
    return i;
  });
  log.warn({ incidentId: inc.id, role: req.user.role, rideId: inc.ride_id }, 'SOS raised');
  res.status(201).json(incidentView(inc));
});

// ---------- staff: incidents ----------
const A = (...roles) => [authenticate, requireRole('admin', roles)];
const adminIncidentView = (i) => ({ ...incidentView(i), reporter: { id: i.reporter_id, role: i.reporter_role, firstName: i.first_name ?? null, phone: i.phone ?? null },
  acknowledgedAt: i.acknowledged_at, resolvedAt: i.resolved_at, staffNote: i.staff_note });
const INC_SQL = 'SELECT i.*, u.first_name, u.phone FROM incidents i JOIN users u ON u.id=i.reporter_id';

safety.get('/admin/incidents', ...A('support'), async (req, res) => {
  const a = pageArgs(req), status = qEnum(req, 'status', ['open', 'acknowledged', 'resolved']);
  const { rows } = await q(`${INC_SQL} WHERE ($1::text IS NULL OR i.status=$1) AND ($2::timestamptz IS NULL OR (i.created_at, i.id) < ($2::timestamptz, $3::uuid))
      ORDER BY i.created_at DESC, i.id DESC LIMIT $4`, [status, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (i) => [i.created_at, i.id], adminIncidentView));
});

safety.patch('/admin/incidents/:id', ...A('support'), async (req, res) => {
  const { status, note } = req.body || {};
  if (!['acknowledged', 'resolved'].includes(status)) throw new ApiError(422, 'validation_failed', 'status must be acknowledged or resolved');
  if (note != null && (typeof note !== 'string' || note.length > 1000)) throw new ApiError(422, 'validation_failed', 'note up to 1000 characters');
  if (!isUuid(req.params.id)) throw notFound('Incident');
  const out = await tx(async (c) => {
    const { rows: [i] } = await c.query('SELECT * FROM incidents WHERE id=$1 FOR UPDATE', [req.params.id]);
    if (!i) throw notFound('Incident');
    if (i.status === 'resolved') throw conflict('incident_state_invalid', 'Incident is already resolved');
    if (status === 'acknowledged' && i.status !== 'open') throw conflict('incident_state_invalid', `Incident is ${i.status}`);
    await c.query(
      status === 'acknowledged'
        ? `UPDATE incidents SET status='acknowledged', acknowledged_by=$2, acknowledged_at=now(), staff_note=COALESCE($3,staff_note) WHERE id=$1`
        : `UPDATE incidents SET status='resolved', resolved_by=$2, resolved_at=now(), acknowledged_at=COALESCE(acknowledged_at,now()), acknowledged_by=COALESCE(acknowledged_by,$2), staff_note=COALESCE($3,staff_note) WHERE id=$1`,
      [i.id, req.user.id, note?.trim() || null]);
    await c.query('INSERT INTO audit_log (actor_type,actor_id,action,target,data) VALUES ($1,$2,$3,$4,$5)', ['staff', req.user.id, `incident.${status}`, i.id, JSON.stringify({ note: note ?? null })]);
    if (status === 'acknowledged') await notifyUser(c, i.reporter_id, 'incident_ack', { data: { incidentId: i.id }, dedupe: `incident-ack:${i.id}` });
    return (await c.query(`${INC_SQL} WHERE i.id=$1`, [i.id])).rows[0];
  });
  res.json(adminIncidentView(out));
});
