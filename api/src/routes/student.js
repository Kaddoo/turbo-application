import { Router } from 'express';
import { q, tx } from '../db.js';
import { authenticate, requireRole, terms, bustTerms } from '../lib/auth.js';
import { ApiError, notFound, conflict } from '../lib/errors.js';
import { haversineM, inPolygon, isUuid, sha256, randomPin } from '../lib/util.js';
import { getSettings, getFareBands, getArea, fareFor } from '../lib/settings.js';
import { route } from '../lib/routing.js';
import { idempotent } from '../lib/idempotency.js';
import { seal } from '../lib/secrets.js';
import { config } from '../config.js';
import { ensureBody } from '../lib/contract.js';
import { pageArgs, pageOf } from '../lib/page.js';
import * as wallet from '../domain/wallet.js';
import { ACTIVE, event, lockRide, cancelRide } from '../domain/rides.js';
import { serviceAreaView } from '../domain/config.js';
import { notifyUser, quickText } from '../domain/notify.js';
import * as places from '../lib/places.js';
import { studentView, location, point, rideView, RIDE_SQL, driverLocationView, iso, opt } from '../views.js';

export const student = Router();
// Every student endpoint requires a student token whose terms/privacy versions are current (403 terms_not_accepted otherwise).
const S = [authenticate, requireRole('student'), terms];
// Endpoints a student may use even before accepting the new terms (they are how they accept).
const S0 = [authenticate, requireRole('student')];
const invalid = (field, message) => new ApiError(422, 'validation_failed', 'Invalid request', { errors: [{ field, message }] });

// ---------- service area (public) ----------
student.get('/service-area', async (_req, res) => res.set('cache-control', 'public, max-age=300').json(await serviceAreaView()));

// ---------- profile ----------
const ME_SQL = `SELECT u.*, s.verification_status FROM users u JOIN students s ON s.user_id=u.id WHERE u.id=$1`;
const me = async (id) => (await q(ME_SQL, [id])).rows[0];

student.get('/me', ...S0, async (req, res) => res.json(studentView(await me(req.user.id))));

student.patch('/me', ...S, async (req, res) => {
  const { fullName, email } = req.body;
  if (fullName !== undefined && !fullName.trim()) throw invalid('fullName', 'cannot be empty');
  const parts = fullName ? fullName.trim().split(/\s+/) : null;
  await q(`UPDATE users SET full_name=COALESCE($2,full_name), first_name=COALESCE($3,first_name),
           last_name = CASE WHEN $2::text IS NULL THEN last_name ELSE $4 END, email=COALESCE($5,email), updated_at=now() WHERE id=$1`,
    [req.user.id, fullName?.trim() ?? null, parts?.[0] ?? null, parts ? parts.slice(1).join(' ') || null : null, email?.toLowerCase() ?? null]);
  res.json(studentView(await me(req.user.id)));
});

student.post('/me/terms-acceptance', ...S0, async (req, res) => {
  const { termsVersion, privacyVersion } = req.body;
  if (termsVersion !== config.termsVersion || privacyVersion !== config.privacyVersion)
    throw new ApiError(422, 'validation_failed', 'Those are not the current versions', { errors: [{ field: 'termsVersion', message: `current: terms ${config.termsVersion}, privacy ${config.privacyVersion}` }] });
  await q('UPDATE users SET terms_version=$2, privacy_version=$3, terms_accepted_at=now() WHERE id=$1', [req.user.id, termsVersion, privacyVersion]);
  bustTerms(req.user.id);
  res.status(204).end();
});

// D19: a deletion request becomes a ticket for staff, and the account is flagged; ledger rows are anonymised later, never deleted.
student.post('/me/deletion-request', ...S, async (req, res) => {
  const r = await tx(async (c) => {
    const { rows: [open] } = await c.query(`SELECT * FROM deletion_requests WHERE student_id=$1 AND status<>'completed'`, [req.user.id]);
    if (open) return open;
    const { rows: [d] } = await c.query(`INSERT INTO deletion_requests (student_id) VALUES ($1) RETURNING *`, [req.user.id]);
    const { rows: [t] } = await c.query(`INSERT INTO support_tickets (user_id,user_role,category,subject) VALUES ($1,'student','data_request','Account deletion request') RETURNING id`, [req.user.id]);
    await c.query(`INSERT INTO support_messages (ticket_id,author,author_id,body) VALUES ($1,'user',$2,'I would like my account and personal data deleted.')`, [t.id, req.user.id]);
    return d;
  });
  res.status(202).json({ id: r.id, status: r.status, requestedAt: iso(r.requested_at), scheduledFor: iso(r.scheduled_for) });
});

// ---------- verification ----------
const SLOTS = [['ghanaCardFrontUploadId', 'ghana_card_front'], ['ghanaCardBackUploadId', 'ghana_card_back'], ['studentIdUploadId', 'student_id'], ['selfieUploadId', 'selfie_with_card']];

async function verificationState(uid) {
  const { rows: [s] } = await q('SELECT verification_status,reason_code,student_message,submitted_at,decided_at FROM students WHERE user_id=$1', [uid]);
  return { status: s.verification_status, reasonCode: s.reason_code ?? null, message: s.student_message ?? null, submittedAt: iso(s.submitted_at), decidedAt: iso(s.decided_at),
    canResubmit: ['not_submitted', 'needs_attention'].includes(s.verification_status) };
}
student.get('/me/verification', ...S, async (req, res) => res.json(await verificationState(req.user.id)));

student.post('/me/verification', ...S, async (req, res) => {
  const b = req.body;
  const ids = SLOTS.map(([f]) => b[f]);
  if (new Set(ids).size !== ids.length) throw invalid('uploads', 'each document needs its own upload');
  await tx(async (c) => {
    const { rows: [s] } = await c.query('SELECT verification_status FROM students WHERE user_id=$1 FOR UPDATE', [req.user.id]);
    if (!['not_submitted', 'needs_attention'].includes(s.verification_status))
      throw new ApiError(409, 'verification_not_resubmittable', `Verification is ${s.verification_status}`);
    const { rows: ups } = await c.query('SELECT id,purpose,status,used_at FROM uploads WHERE id = ANY($1) AND owner_id=$2 FOR UPDATE', [ids, req.user.id]);
    for (const [f, purpose] of SLOTS) {
      const u = ups.find((x) => x.id === b[f]);
      if (!u || u.purpose !== purpose) throw invalid(f, `must be a ${purpose} upload of yours`);
      if (u.status !== 'stored') throw new ApiError(422, 'upload_expired', 'An upload has no file yet; upload it and try again', { errors: [{ field: f, message: 'PUT the file to uploadUrl first' }] });
      if (u.used_at) throw invalid(f, 'already used; upload a fresh photo');
    }
    try {
      await c.query(
        `UPDATE students SET verification_status='pending', student_id_number=$2, ghana_card_hash=$3, ghana_card_enc=$4,
                submitted_full_name=$5, front_upload_id=$6, back_upload_id=$7, id_upload_id=$8, selfie_upload_id=$9,
                submitted_at=now(), decided_at=NULL, reason_code=NULL, student_message=NULL, claimed_by=NULL, claim_expires_at=NULL, documents_purged_at=NULL
          WHERE user_id=$1`,
        [req.user.id, b.studentIdNumber.trim(), sha256(b.ghanaCardNumber), seal(b.ghanaCardNumber), b.fullName.trim(), ...ids]);
    } catch (e) {
      if (e.code === '23505') throw new ApiError(409, 'duplicate_identity', 'This Ghana Card is already registered');
      throw e;
    }
    await c.query('UPDATE uploads SET used_at=now() WHERE id = ANY($1)', [ids]);
    const [first, ...rest] = b.fullName.trim().split(/\s+/);
    await c.query('UPDATE users SET full_name=$2, first_name=$3, last_name=$4, updated_at=now() WHERE id=$1', [req.user.id, b.fullName.trim(), first, rest.join(' ') || null]);
  });
  res.status(201).json(await verificationState(req.user.id));
});

// ---------- notification choices and place search (contract 0.6.0) ----------
const choicesView = (r) => ({ newsAndOffers: r.notify_news, tips: r.notify_tips });
student.get('/me/notification-settings', ...S, async (req, res) => {
  const { rows: [r] } = await q('SELECT notify_news, notify_tips FROM students WHERE user_id=$1', [req.user.id]);
  res.json(choicesView(r));
});
student.put('/me/notification-settings', ...S, async (req, res) => {
  const { rows: [r] } = await q('UPDATE students SET notify_news=$2, notify_tips=$3 WHERE user_id=$1 RETURNING notify_news, notify_tips', [req.user.id, req.body.newsAndOffers, req.body.tips]);
  res.json(choicesView(r));
});
student.get('/places/autocomplete', ...S, async (req, res) => {
  const text = typeof req.query.q === 'string' ? req.query.q : '';
  if (text.length > 80) throw new ApiError(400, 'validation_failed', 'q is too long');
  res.json({ items: await places.autocomplete(text, typeof req.query.sessionToken === 'string' ? req.query.sessionToken : undefined) });
});
student.get('/places/:placeId', ...S, async (req, res) => {
  const loc = await places.resolve(req.params.placeId, typeof req.query.sessionToken === 'string' ? req.query.sessionToken : undefined);
  if (!loc) throw notFound('Place');
  res.json(loc);
});

// ---------- saved places ----------
const placeView = (p) => ({ id: p.id, label: p.label, location: location(p.lat, p.lng, p.place_label, { ...(p.landmark && { landmark: p.landmark }), ...(p.pickup_point_id && { pickupPointId: p.pickup_point_id }) }) });
student.get('/me/saved-places', ...S, async (req, res) => {
  const { rows } = await q('SELECT * FROM saved_places WHERE student_id=$1 AND deleted_at IS NULL ORDER BY created_at', [req.user.id]);
  res.json({ data: rows.map(placeView) });
});
student.post('/me/saved-places', ...S, async (req, res) => {
  const { label, location: l } = req.body;
  const p = await tx(async (c) => {
    await c.query('SELECT 1 FROM students WHERE user_id=$1 FOR UPDATE', [req.user.id]);
    const { rows: [n] } = await c.query('SELECT count(*)::int n FROM saved_places WHERE student_id=$1 AND deleted_at IS NULL', [req.user.id]);
    if (n.n >= 20) throw invalid('label', 'you can save up to 20 places');
    return (await c.query(`INSERT INTO saved_places (student_id,label,lat,lng,place_label,landmark,pickup_point_id) VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING *`,
      [req.user.id, label.trim(), l.point.lat, l.point.lng, l.label ?? null, l.landmark ?? null, l.pickupPointId ?? null])).rows[0];
  });
  res.status(201).json(placeView(p));
});
student.delete('/me/saved-places/:id', ...S, async (req, res) => {
  if (!isUuid(req.params.id)) throw notFound('Saved place');
  const { rowCount } = await q('UPDATE saved_places SET deleted_at=now() WHERE id=$1 AND student_id=$2 AND deleted_at IS NULL', [req.params.id, req.user.id]);
  if (!rowCount) throw notFound('Saved place');
  res.status(204).end();
});

// ---------- sessions (signed-in devices) ----------
export const sessionRoutes = Router();
const U = [authenticate, (req, _res, next) => { if (!['student', 'driver'].includes(req.user.role)) return next(new ApiError(403, 'forbidden', 'Not allowed for this account')); try { ensureBody(req); } catch (e) { return next(e); } next(); }, terms];
sessionRoutes.get('/me/sessions', ...U, async (req, res) => {
  const { rows } = await q(`SELECT family_id, max(platform) platform, max(device_name) device_name, max(last_used_at) last_used FROM refresh_tokens
      WHERE subject_id=$1 AND subject_type='user' AND revoked_at IS NULL AND expires_at > now() GROUP BY family_id ORDER BY max(last_used_at) DESC LIMIT 50`, [req.user.id]);
  res.json({ items: rows.map((r) => ({ id: r.family_id, platform: r.platform ?? 'android', deviceName: r.device_name ?? null, lastUsedAt: iso(r.last_used), current: r.family_id === req.user.sid })) });
});
sessionRoutes.delete('/me/sessions', ...U, async (req, res) => {
  await q(`UPDATE refresh_tokens SET revoked_at=now() WHERE subject_id=$1 AND subject_type='user' AND revoked_at IS NULL`, [req.user.id]);
  res.status(204).end();
});
sessionRoutes.delete('/me/sessions/:id', ...U, async (req, res) => {
  if (!isUuid(req.params.id)) throw notFound('Session');
  const { rowCount } = await q(`UPDATE refresh_tokens SET revoked_at=now() WHERE family_id=$1 AND subject_id=$2 AND subject_type='user' AND revoked_at IS NULL`, [req.params.id, req.user.id]);
  if (!rowCount) throw notFound('Session');
  res.status(204).end();
});

// ---------- quote ----------
const reason = (code, message) => ({ code, message });
student.post('/rides/quote', ...S, async (req, res) => {
  const pk = req.body.pickup.point, dp = req.body.dropoff.point;
  const pickup = { lat: pk.lat, lng: pk.lng, label: req.body.pickup.label ?? null }, dropoff = { lat: dp.lat, lng: dp.lng, label: req.body.dropoff.label ?? null };
  const [cfg, bands, area] = await Promise.all([getSettings(), getFareBands(), getArea()]);

  const { rows: [lim] } = await q(`SELECT count(*)::int n FROM quotes WHERE student_id=$1 AND created_at > now() - interval '1 minute'`, [req.user.id]);
  if (lim.n >= cfg.quoteLimitPerMinute) throw new ApiError(429, 'rate_limited', 'Too many quotes', { retryAfterSeconds: 30 });

  const [{ rows: [st] }, { rows: [w] }, { rows: [act] }, { rows: [duty] }] = await Promise.all([
    q('SELECT verification_status FROM students WHERE user_id=$1', [req.user.id]),
    q('SELECT balance_pesewas-reserved_pesewas AS avail FROM wallets WHERE student_id=$1', [req.user.id]),
    q(`SELECT 1 FROM rides WHERE student_id=$1 AND status = ANY($2)`, [req.user.id, ACTIVE]),
    q(`SELECT count(*)::int n FROM drivers d JOIN driver_presence p ON p.driver_id=d.user_id
        WHERE d.on_duty AND d.active AND p.seen_at > now() - make_interval(secs => $1)`, [cfg.presenceFreshSeconds]),
  ]);

  const reasons = [];
  if (cfg.bookingsPaused) reasons.push(reason('bookings_paused', cfg.pauseMessage || 'Bookings are paused right now'));
  if (st.verification_status !== 'approved') reasons.push(reason('verification_required', 'Your identity must be verified before you can ride'));
  if (act) reasons.push(reason('active_ride_exists', 'You already have a ride in progress'));
  let r = null;
  if (!area.polygon || !inPolygon(pickup.lat, pickup.lng, area.polygon) || !inPolygon(dropoff.lat, dropoff.lng, area.polygon))
    reasons.push(reason('outside_service_area', 'Pickup and drop-off must both be inside the service area'));
  else {
    r = await route(pickup, dropoff);
    if (!r) reasons.push(reason('route_unavailable', 'No road route found between these points'));
    else if (r.distanceM > cfg.maxTripDistanceMeters) reasons.push(reason('route_too_long', `Trips are limited to ${cfg.maxTripDistanceMeters / 1000} km by road`));
  }
  if (duty.n === 0) reasons.push(reason('no_drivers_on_duty', 'No drivers are available right now'));

  const avail = w.avail, base = { routeDistanceMeters: r?.distanceM ?? null, routeDurationSeconds: r?.durationS ?? null, routePolyline: r?.polyline ?? null };
  const fare = r ? fareFor(bands, r.distanceM) : null;
  if (!reasons.length && fare == null) reasons.push(reason('route_too_long', 'No fare is defined for this distance'));
  if (reasons.length) return res.json({ eligible: false, quoteId: null, reasons, ...base, farePesewas: null, pickupEtaSeconds: null, expiresAt: null,
    wallet: { availablePesewas: avail, sufficient: false, shortfallPesewas: 0 } });

  const { rows: [qt] } = await q(
    `INSERT INTO quotes (student_id,pickup_lat,pickup_lng,pickup_label,drop_lat,drop_lng,drop_label,distance_m,duration_s,fare_pesewas,expires_at,route_polyline)
     VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10, now() + make_interval(secs => $11), $12) RETURNING id, expires_at`,
    [req.user.id, pickup.lat, pickup.lng, pickup.label, dropoff.lat, dropoff.lng, dropoff.label, r.distanceM, r.durationS, fare, cfg.quoteTtlSeconds, r.polyline ?? null]);
  res.json({ eligible: true, quoteId: qt.id, reasons: [], ...base, farePesewas: fare, pickupEtaSeconds: null, expiresAt: iso(qt.expires_at),
    wallet: { availablePesewas: avail, sufficient: avail >= fare, shortfallPesewas: Math.max(0, fare - avail) } });
});

// ---------- book ----------
const loadRide = async (id, uid) => {
  const { rows: [r] } = await q(`${RIDE_SQL} WHERE r.id=$1 AND r.student_id=$2`, [id, uid]);
  if (!r) throw notFound('Ride');
  return r;
};

student.post('/rides', ...S, async (req, res) => idempotent(req, res, 'ride', async () => {
  const { quoteId } = req.body;
  const cfg = await getSettings();
  if (cfg.bookingsPaused) throw conflict('bookings_paused', cfg.pauseMessage || 'Bookings are paused');
  const rideId = await tx(async (c) => {
    const { rows: [qt] } = await c.query('SELECT * FROM quotes WHERE id=$1 AND student_id=$2 FOR UPDATE', [quoteId, req.user.id]);
    if (!qt) throw notFound('Quote');
    if (qt.used_at || qt.expires_at < new Date()) throw conflict('quote_expired', 'Quote expired; request a new one');
    const { rows: [st] } = await c.query('SELECT verification_status FROM students WHERE user_id=$1', [req.user.id]);
    if (st.verification_status !== 'approved') throw new ApiError(403, 'verification_required', 'Identity not verified');
    let ride;
    try {
      ({ rows: [ride] } = await c.query(
        `INSERT INTO rides (student_id,status,pickup_lat,pickup_lng,pickup_label,drop_lat,drop_lng,drop_label,distance_m,duration_s,fare_pesewas,pin,route_polyline)
         VALUES ($1,'searching',$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12) RETURNING id`,
        [req.user.id, qt.pickup_lat, qt.pickup_lng, qt.pickup_label, qt.drop_lat, qt.drop_lng, qt.drop_label, qt.distance_m, qt.duration_s, qt.fare_pesewas, randomPin(), qt.route_polyline]));
    } catch (e) {
      if (e.code === '23505') throw conflict('active_ride_exists', 'You already have a ride in progress');
      throw e;
    }
    await wallet.hold(c, req.user.id, ride.id, qt.fare_pesewas);
    await c.query('UPDATE quotes SET used_at=now() WHERE id=$1', [qt.id]);
    await event(c, ride.id, 'requested', 'student', req.user.id, { quoteId });
    return ride.id;
  });
  return { status: 201, body: rideView(await loadRide(rideId, req.user.id), { includePin: true }) };
}));

student.get('/rides', ...S, async (req, res) => {
  const a = pageArgs(req);
  const status = ['searching', 'assigned', 'driver_arrived', 'in_progress', 'completed', 'cancelled'].includes(req.query.status) ? req.query.status : null;
  const { rows } = await q(`${RIDE_SQL} WHERE r.student_id=$1 AND ($2::text IS NULL OR r.status=$2)
      AND ($3::timestamptz IS NULL OR (r.requested_at, r.id) < ($3::timestamptz, $4::uuid)) ORDER BY r.requested_at DESC, r.id DESC LIMIT $5`,
    [req.user.id, status, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.requested_at, r.id], (r) => rideView(r)));
});

student.get('/rides/:id', ...S, async (req, res) => {
  if (!isUuid(req.params.id)) throw notFound('Ride');
  res.json(rideView(await loadRide(req.params.id, req.user.id), { includePin: true }));
});

// Polled every 5 s by every active rider, so this is ONE small query (not the full ride view).
student.get('/rides/:id/tracking', ...S, async (req, res) => {
  if (!isUuid(req.params.id)) throw notFound('Ride');
  const { rows: [r] } = await q(`SELECT r.status, r.driver_id, r.pickup_lat, r.pickup_lng, p.lat, p.lng, p.heading, p.speed, p.seen_at
      FROM rides r LEFT JOIN driver_presence p ON p.driver_id=r.driver_id WHERE r.id=$1 AND r.student_id=$2`, [req.params.id, req.user.id]);
  if (!r) throw notFound('Ride');
  const live = r.lat != null && ['assigned', 'driver_arrived', 'in_progress'].includes(r.status);
  res.json({
    rideStatus: r.status,
    driverLocation: live ? driverLocationView(r) : null,
    etaSeconds: live && r.status === 'assigned' ? Math.round(haversineM(r.lat, r.lng, r.pickup_lat, r.pickup_lng) * 1.3 / (25000 / 3600)) : null,
    updatedAt: new Date().toISOString(),
  });
});

const STUDENT_CANCEL = { student_changed_mind: 'student_changed_mind', wait_too_long: 'service_issue', wrong_location: 'student_changed_mind', other: 'other' };
student.post('/rides/:id/cancel', ...S, async (req, res) => {
  if (!isUuid(req.params.id)) throw notFound('Ride');
  const { reasonCode = 'other', note } = req.body ?? {};
  await tx(async (c) => {
    const { rows: [own] } = await c.query('SELECT 1 FROM rides WHERE id=$1 AND student_id=$2', [req.params.id, req.user.id]);
    if (!own) throw notFound('Ride');
    const ride = await lockRide(c, req.params.id);
    if (ride.status === 'in_progress') throw conflict('ride_not_cancellable', 'The trip has started; contact support');
    if (['completed', 'cancelled'].includes(ride.status)) throw conflict('invalid_ride_state', `Ride is already ${ride.status}`);
    await cancelRide(c, ride, 'student', STUDENT_CANCEL[reasonCode], req.user.id, note ?? null);
  });
  res.json(rideView(await loadRide(req.params.id, req.user.id)));
});

student.get('/rides/:id/receipt', ...S, async (req, res) => {
  if (!isUuid(req.params.id)) throw notFound('Ride');
  const r = await loadRide(req.params.id, req.user.id);
  if (r.status !== 'completed') throw notFound('Receipt');
  const refunded = Number(r.refunded || 0);
  const lines = [{ label: 'Ride fare', amountPesewas: r.fare_pesewas }];
  if (refunded > 0) lines.push({ label: 'Refund', amountPesewas: -refunded });
  res.json({ rideId: r.id, receiptNumber: `TRB-${new Date(r.completed_at).toISOString().slice(0, 10).replace(/-/g, '')}-${r.id.slice(0, 6).toUpperCase()}`,
    issuedAt: iso(r.completed_at), pickup: location(r.pickup_lat, r.pickup_lng, r.pickup_label), dropoff: location(r.drop_lat, r.drop_lng, r.drop_label),
    routeDistanceMeters: r.distance_m, driverFirstName: opt(r.d_first), vehiclePlate: opt(r.v_plate), lines, totalPesewas: r.fare_pesewas - refunded });
});

student.post('/rides/:id/rating', ...S, async (req, res) => {
  const { stars, tags, comment } = req.body;
  if (!isUuid(req.params.id)) throw notFound('Ride');
  await loadRide(req.params.id, req.user.id);
  const { rowCount } = await q(`UPDATE rides SET rating=$3, rating_tags=$4, rating_comment=$5 WHERE id=$1 AND student_id=$2 AND status='completed' AND rating IS NULL`,
    [req.params.id, req.user.id, stars, tags ?? null, comment ?? null]);
  if (!rowCount) throw conflict('invalid_ride_state', 'Only a completed ride can be rated, and only once');
  res.status(204).end();
});

// ---------- quick messages (student <-> driver, presets only, no phone numbers: D17) ----------
export const messages = Router();
const M = [authenticate, (req, _res, next) => { if (!['student', 'driver'].includes(req.user.role)) return next(new ApiError(403, 'forbidden', 'Not allowed for this account')); try { ensureBody(req); } catch (e) { return next(e); } next(); }, terms];
async function rideOfParty(id, user) {
  if (!isUuid(id)) throw notFound('Ride');
  const col = user.role === 'student' ? 'student_id' : 'driver_id';
  const { rows: [r] } = await q(`SELECT id, status, student_id, driver_id FROM rides WHERE id=$1 AND ${col}=$2`, [id, user.id]);
  if (!r) throw notFound('Ride');
  return r;
}
messages.post('/rides/:id/messages', ...M, async (req, res) => {
  const r = await rideOfParty(req.params.id, req.user);
  if (!['assigned', 'driver_arrived', 'in_progress'].includes(r.status)) throw conflict('invalid_ride_state', 'Messages can only be sent while a driver is assigned');
  const { rows: [n] } = await q(`SELECT count(*)::int n FROM ride_messages WHERE ride_id=$1 AND from_role=$2 AND sent_at > now() - interval '1 minute'`, [r.id, req.user.role]);
  if (n.n >= 10) throw new ApiError(429, 'rate_limited', 'Too many messages', { retryAfterSeconds: 30 });
  await tx(async (c) => {
    await c.query('INSERT INTO ride_messages (ride_id,from_role,code) VALUES ($1,$2,$3)', [r.id, req.user.role, req.body.code]);
    // delivered by push to the other party; only a fixed preset text, never a typed message or a phone number (D17)
    const other = req.user.role === 'student' ? r.driver_id : r.student_id;
    if (other) await notifyUser(c, other, 'quick_message', { vars: { fromDriver: req.user.role === 'driver', text: quickText(req.body.code) }, data: { rideId: r.id, code: req.body.code } });
  });
  res.status(202).end();
});
messages.get('/rides/:id/messages', ...M, async (req, res) => {
  const r = await rideOfParty(req.params.id, req.user);
  const { rows } = await q('SELECT from_role, code, sent_at FROM ride_messages WHERE ride_id=$1 ORDER BY id LIMIT 200', [r.id]);
  res.json({ items: rows.map((m) => ({ from: m.from_role, code: m.code, sentAt: iso(m.sent_at) })) });
});
