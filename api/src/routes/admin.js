import { Router } from 'express';
import { q, tx } from '../db.js';
import { authenticate, requireRole, bustTerms } from '../lib/auth.js';
import { ApiError, notFound, conflict } from '../lib/errors.js';
import { isUuid, normalizePhone } from '../lib/util.js';
import { getSettings, bustConfig } from '../lib/settings.js';
import { sendSms } from '../lib/notify.js';
import { pageArgs, pageOf } from '../lib/page.js';
import { qEnum, qUuid, qDate, qText } from '../lib/query.js';
import { signedUrl } from '../lib/storage.js';
import { open } from '../lib/secrets.js';
import { serviceAreaView, publicSettings } from '../domain/config.js';
import { driverDetails, stripPrivate } from '../domain/people.js';
import { event, lockRide, cancelRide, completeRide } from '../domain/rides.js';
import { walletView, studentView, studentSummary, rideView, RIDE_SQL, iso, fullName, firstNameOf, driverLocationView, point } from '../views.js';
import * as wallet from '../domain/wallet.js';
import { rideAssigned, rideCancelled, notifyUser, notifyAudience } from '../domain/notify.js';

export const admin = Router();
const A = (...roles) => [authenticate, requireRole('admin', roles.length ? roles : undefined)];
export const audit = (c, req, action, target, data) =>
  c.query('INSERT INTO audit_log (actor_type,actor_id,action,target,data) VALUES ($1,$2,$3,$4,$5)', ['staff', req.user.id, action, target ?? null, data ? JSON.stringify(data) : null]);
const invalid = (field, message) => new ApiError(422, 'validation_failed', 'Invalid request', { errors: [{ field, message }] });
const needUuid = (v, what) => { if (!isUuid(v)) throw notFound(what); };

admin.get('/admin/me', ...A(), async (req, res) => {
  const { rows: [s] } = await q('SELECT id,email,name,role,is_active,mfa_secret_enc,last_login_at,locked_until,invite_pending FROM staff_users WHERE id=$1', [req.user.id]);
  const { staffView } = await import('../views.js');
  // Finance and super admin decide wallet adjustments, so they may see the amount above which a second person must approve.
  const approves = ['finance', 'super_admin'].includes(s.role);
  res.json({ ...staffView(s), ...(approves && { adjustmentApprovalThresholdPesewas: (await getSettings()).adjustmentApprovalThresholdPesewas }) });
});

// ================= verification =================
const STUDENT_SQL = `SELECT u.*, s.verification_status, s.no_show_count, s.student_id_number FROM users u JOIN students s ON s.user_id=u.id`;
const summary = (r) => ({ id: r.id, student: { id: r.id, fullName: r.submitted_full_name || fullName(r), phone: r.phone }, status: r.status, submittedAt: iso(r.submitted_at),
  claimedBy: r.claim_expires_at > new Date() ? r.claimed_by : null, claimExpiresAt: r.claim_expires_at > new Date() ? iso(r.claim_expires_at) : null });
const VSUM_SQL = `SELECT s.user_id AS id, u.first_name, u.last_name, u.full_name, u.phone, s.submitted_full_name, s.verification_status AS status, s.submitted_at, s.claimed_by, s.claim_expires_at
  FROM students s JOIN users u ON u.id=s.user_id`;

admin.get('/admin/verifications', ...A('verifier'), async (req, res) => {
  const a = pageArgs(req), status = qEnum(req, 'status', ['not_submitted', 'pending', 'approved', 'needs_attention', 'rejected']) ?? 'pending';
  // oldest first: the queue is worked in the order students submitted
  const { rows } = await q(`${VSUM_SQL} WHERE s.verification_status=$1 AND s.submitted_at IS NOT NULL AND ($2::timestamptz IS NULL OR (s.submitted_at, s.user_id) > ($2::timestamptz, $3::uuid))
      ORDER BY s.submitted_at, s.user_id LIMIT $4`, [status, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.submitted_at, r.id], summary));
});

async function verificationDetail(c, id) {
  const { rows: [r] } = await c.query(`SELECT s.*, u.phone, u.first_name, u.last_name, u.full_name, u.status AS account_status, u.created_at AS u_created, s.verification_status AS vstatus
      FROM students s JOIN users u ON u.id=s.user_id WHERE s.user_id=$1`, [id]);
  if (!r || !r.submitted_at) throw notFound('Verification');
  const docs = [];
  if (!r.documents_purged_at) for (const [purpose, uid] of [['ghana_card_front', r.front_upload_id], ['ghana_card_back', r.back_upload_id], ['student_id', r.id_upload_id], ['selfie_with_card', r.selfie_upload_id]]) {
    if (!uid) continue;
    const { url, expiresAt } = signedUrl('GET', uid, 300);
    docs.push({ purpose, url, expiresAt: iso(expiresAt) });
  }
  const { rows: hist } = await c.query('SELECT decision,reason_code,decided_by,created_at FROM verification_decisions WHERE student_id=$1 ORDER BY created_at DESC', [id]);
  return { id: r.user_id, student: studentSummary({ ...r, id: r.user_id, status: r.account_status, verification_status: r.vstatus, created_at: r.u_created }), status: r.vstatus,
    submittedFullName: r.submitted_full_name, studentIdNumber: r.student_id_number, submittedAt: iso(r.submitted_at), documents: docs,
    ghanaCardNumber: r.ghana_card_enc ? open(r.ghana_card_enc) : '', history: hist.map((h) => ({ decision: h.decision, reasonCode: h.reason_code ?? null, decidedByStaffId: h.decided_by, decidedAt: iso(h.created_at) })) };
}

admin.get('/admin/verifications/:id', ...A('verifier'), async (req, res) => {
  needUuid(req.params.id, 'Verification');
  const out = await tx(async (c) => {
    const d = await verificationDetail(c, req.params.id);
    await audit(c, req, 'verification.view', req.params.id, { documents: d.documents.length });   // reading identity documents is always logged
    return d;
  });
  res.set('cache-control', 'no-store').json(out);
});

admin.post('/admin/verifications/:id/claim', ...A('verifier'), async (req, res) => {
  needUuid(req.params.id, 'Verification');
  const row = await tx(async (c) => {
    const { rows: [s] } = await c.query(`SELECT verification_status,claimed_by,claim_expires_at FROM students WHERE user_id=$1 FOR UPDATE`, [req.params.id]);
    if (!s) throw notFound('Verification');
    if (s.verification_status !== 'pending') throw conflict('verification_not_pending', `Verification is ${s.verification_status}`);
    if (s.claimed_by && s.claimed_by !== req.user.id && s.claim_expires_at > new Date()) throw conflict('verification_claimed', 'Another reviewer is working on this submission');
    await c.query(`UPDATE students SET claimed_by=$2, claim_expires_at=now() + interval '15 minutes' WHERE user_id=$1`, [req.params.id, req.user.id]);
    return (await c.query(`${VSUM_SQL} WHERE s.user_id=$1`, [req.params.id])).rows[0];
  });
  res.json(summary(row));
});

admin.post('/admin/verifications/:id/decision', ...A('verifier'), async (req, res) => {
  const { decision, reasonCode, studentMessage, internalNote } = req.body;
  if (decision !== 'approved' && !/^[a-z0-9_]{3,40}$/.test(reasonCode || '')) throw invalid('reasonCode', 'required unless approved: 3 to 40 lowercase letters, digits or underscores');
  needUuid(req.params.id, 'Verification');
  const out = await tx(async (c) => {
    const { rows: [s] } = await c.query('SELECT verification_status,claimed_by,claim_expires_at FROM students WHERE user_id=$1 FOR UPDATE', [req.params.id]);
    if (!s) throw notFound('Verification');
    if (s.verification_status !== 'pending') throw conflict('verification_not_pending', `Verification is ${s.verification_status}`);
    if (s.claimed_by && s.claimed_by !== req.user.id && s.claim_expires_at > new Date()) throw conflict('verification_claimed', 'Another reviewer holds this submission');
    await c.query(`UPDATE students SET verification_status=$2, decided_at=now(), reason_code=$3, student_message=$4, claimed_by=NULL, claim_expires_at=NULL WHERE user_id=$1`,
      [req.params.id, decision, decision === 'approved' ? null : reasonCode, decision === 'approved' ? null : (studentMessage ?? null), ]);
    await c.query('INSERT INTO verification_decisions (student_id,decision,reason_code,note,decided_by) VALUES ($1,$2,$3,$4,$5)',
      [req.params.id, decision, decision === 'approved' ? null : reasonCode, internalNote ?? null, req.user.id]);
    await audit(c, req, 'verification.decision', req.params.id, { decision, reasonCode: reasonCode ?? null });
    const msg = decision === 'approved' ? { title: "You're verified", body: 'You can book rides now.' }
      : decision === 'needs_attention' ? { title: 'Action needed on your ID', body: studentMessage || 'Please resubmit clear photos of your documents.' }
      : { title: 'Verification not approved', body: studentMessage || 'Contact Turbo support if you think this is a mistake.' };
    await notifyUser(c, req.params.id, 'verification', { vars: msg, data: { status: decision } });
    return verificationDetail(c, req.params.id);
  });
  // The contract promises push AND SMS. SMS goes out after the commit and never blocks or fails the decision.
  q('SELECT phone FROM users WHERE id=$1', [req.params.id]).then(({ rows: [u] }) => u && sendSms(u.phone, decision === 'approved' ? 'Turbo: your ID is verified. You can book rides now.' : 'Turbo: we need to look at your ID again. Open the app for details.')).catch(() => {});
  res.set('cache-control', 'no-store').json(out);
});

// ================= students =================
admin.get('/admin/students', ...A('verifier'), async (req, res) => {
  const a = pageArgs(req);
  const v = qEnum(req, 'verificationStatus', ['not_submitted', 'pending', 'approved', 'needs_attention', 'rejected']), acc = qEnum(req, 'accountStatus', ['active', 'suspended']), text = qText(req, 'q');
  const { rows } = await q(`${STUDENT_SQL} WHERE u.deleted_at IS NULL AND ($1::text IS NULL OR s.verification_status=$1) AND ($2::text IS NULL OR u.status=$2)
      AND ($3::text IS NULL OR u.phone LIKE $3 || '%' ESCAPE '\\' OR COALESCE(u.full_name, u.first_name || ' ' || COALESCE(u.last_name,'')) ILIKE '%' || $3 || '%' ESCAPE '\\')
      AND ($4::timestamptz IS NULL OR (u.created_at, u.id) < ($4::timestamptz, $5::uuid)) ORDER BY u.created_at DESC, u.id DESC LIMIT $6`, [v, acc, text, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.created_at, r.id], studentSummary));
});

// Reduced views. Support may open a student and support and finance may open a ride (they need them to do their own work), but only
// the owner role (verifier for students, dispatcher for rides) and super admin get the full record. Every reduced view is audited.
const OWNER = { student: 'verifier', ride: 'dispatcher' };
const isOwner = (req, kind) => ['super_admin', OWNER[kind]].includes(req.user.staffRole);
export const maskPhone = (p) => (typeof p === 'string' && p.length > 6 ? `${p.slice(0, 4)} ${p.slice(4, 6)} *** **${p.slice(-2)}` : '***');
const auditReduced = (req, kind, id) => audit({ query: q }, req, `${kind}.view_reduced`, id, { role: req.user.staffRole });

async function studentDetail(id) {
  if (!isUuid(id)) throw notFound('Student');
  const { rows: [r] } = await q(`${STUDENT_SQL} WHERE u.id=$1 AND u.deleted_at IS NULL`, [id]);
  if (!r) throw notFound('Student');
  const [{ rows: [w] }, { rows: [n] }] = await Promise.all([q('SELECT * FROM wallets WHERE student_id=$1', [id]), q(`SELECT count(*)::int n FROM rides WHERE student_id=$1 AND status='completed'`, [id])]);
  return { id: r.id, phone: r.phone, fullName: fullName(r), email: r.email ?? null, studentIdNumber: r.student_id_number ?? null, accountStatus: r.status,
    verificationStatus: r.verification_status, wallet: walletView(w), completedRides: n.n, createdAt: iso(r.created_at) };
}
admin.get('/admin/students/:id', ...A('verifier', 'support'), async (req, res) => {
  const d = await studentDetail(req.params.id);
  if (isOwner(req, 'student')) return res.json(d);
  await auditReduced(req, 'student', d.id);
  res.json({ ...d, studentIdNumber: null });          // support needs who they are, not their student id number
});

const revokeSessions = (c, uid) => c.query(`UPDATE refresh_tokens SET revoked_at=now() WHERE subject_id=$1 AND subject_type='user' AND revoked_at IS NULL`, [uid]);

admin.patch('/admin/students/:id', ...A('verifier'), async (req, res) => {
  const { accountStatus, reason } = req.body;
  await studentDetail(req.params.id);
  await tx(async (c) => {
    await c.query('UPDATE users SET status=$2, updated_at=now() WHERE id=$1', [req.params.id, accountStatus]);
    if (accountStatus === 'suspended') await revokeSessions(c, req.params.id);       // suspension must end their sessions now, not in 15 minutes
    await audit(c, req, 'student.status', req.params.id, { accountStatus, reason });
  });
  res.json(await studentDetail(req.params.id));
});

admin.put('/admin/students/:id/phone', ...A('verifier'), async (req, res) => {
  const { newPhone, ticketId, note } = req.body;
  const phone = normalizePhone(newPhone);
  const old = await studentDetail(req.params.id);
  const { rows: [t] } = await q(`SELECT id FROM support_tickets WHERE id=$1 AND user_id=$2 AND category='phone_change'`, [ticketId, req.params.id]);
  if (!t) throw invalid('ticketId', 'must be this student\'s phone_change support ticket (the evidence)');
  await tx(async (c) => {
    try { await c.query('UPDATE users SET phone=$2, updated_at=now() WHERE id=$1', [req.params.id, phone]); }
    catch (e) { if (e.code === '23505') throw conflict('duplicate_phone', 'That number already belongs to another account'); throw e; }
    await revokeSessions(c, req.params.id);
    await audit(c, req, 'student.phone_change', req.params.id, { from: old.phone.slice(0, 7) + '***', ticketId, note });
  });
  sendSms(old.phone, 'Your Turbo phone number was changed by support. If this was not you, contact Turbo immediately.').catch(() => {});
  const { rows: [r] } = await q(ME_SQL, [req.params.id]);
  res.json(studentView(r));
});
const ME_SQL = `SELECT u.*, s.verification_status FROM users u JOIN students s ON s.user_id=u.id WHERE u.id=$1`;

admin.delete('/admin/students/:id/sessions', ...A('support'), async (req, res) => {
  await studentDetail(req.params.id);
  await tx(async (c) => { await revokeSessions(c, req.params.id); await audit(c, req, 'student.sessions_revoked', req.params.id); });
  res.status(204).end();
});

// ================= rides =================
const FLAGS = ['driver_unreachable', 'overdue', 'completed_far_from_destination', 'completed_too_fast'];
const flagsOf = (r) => (r.flags || []).filter((f) => FLAGS.includes(f));
const rideSummary = (r) => ({ id: r.id, status: r.status, studentId: r.student_id, studentName: r.s_full ?? null, driverId: r.driver_id ?? null, driverName: r.d_full ?? null,
  routeDistanceMeters: r.distance_m, farePesewas: r.fare_pesewas, requestedAt: iso(r.requested_at), flags: flagsOf(r) });

admin.get('/admin/rides', ...A('dispatcher'), async (req, res) => {
  const a = pageArgs(req);
  const status = qEnum(req, 'status', ['searching', 'assigned', 'driver_arrived', 'in_progress', 'completed', 'cancelled']), sid = qUuid(req, 'studentId'), did = qUuid(req, 'driverId');
  const from = qDate(req, 'from'), to = qDate(req, 'to'), flag = qEnum(req, 'flag', FLAGS);
  const { rows } = await q(`${RIDE_SQL} WHERE ($1::text IS NULL OR r.status=$1) AND ($2::uuid IS NULL OR r.student_id=$2) AND ($3::uuid IS NULL OR r.driver_id=$3)
      AND ($4::date IS NULL OR r.requested_at >= $4) AND ($5::date IS NULL OR r.requested_at < $5::date + 1) AND ($6::text IS NULL OR $6 = ANY(r.flags))
      AND ($7::timestamptz IS NULL OR (r.requested_at, r.id) < ($7::timestamptz, $8::uuid)) ORDER BY r.requested_at DESC, r.id DESC LIMIT $9`,
    [status, sid, did, from, to, flag, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.requested_at, r.id], rideSummary));
});

admin.get('/admin/rides/live', ...A('dispatcher'), async (_req, res) => {
  const [{ rows }, { rows: drv }] = await Promise.all([
    q(`${RIDE_SQL} WHERE r.status IN ('searching','assigned','driver_arrived','in_progress') ORDER BY r.requested_at LIMIT 500`),
    q(`SELECT u.id, COALESCE(u.full_name, u.first_name, 'Driver') AS name, p.lat, p.lng, p.heading, p.speed, p.seen_at,
         NOT EXISTS (SELECT 1 FROM rides r WHERE r.driver_id=u.id AND r.status IN ('assigned','driver_arrived','in_progress')) AS idle
         FROM drivers d JOIN users u ON u.id=d.user_id LEFT JOIN driver_presence p ON p.driver_id=u.id WHERE d.on_duty AND d.active LIMIT 500`)]);
  res.json({
    rides: rows.map((r) => ({ ride: rideSummary(r), ...(r.p_lat != null && { driverLocation: driverLocationView(r) }) })),
    onDutyDrivers: drv.map((d) => ({ driverId: d.id, fullName: d.name, idle: d.idle, ...(d.lat != null && { location: driverLocationView(d) }) })),
  });
});

async function adminRideDetail(id) {
  needUuid(id, 'Ride');
  const { rows: [r] } = await q(`${RIDE_SQL} WHERE r.id=$1`, [id]);
  if (!r) throw notFound('Ride');
  const [{ rows: ev }, st, dr] = await Promise.all([
    q('SELECT type,actor_type,actor_id,data,created_at FROM ride_events WHERE ride_id=$1 ORDER BY id', [id]),
    q(`${STUDENT_SQL} WHERE u.id=$1`, [r.student_id]),
    r.driver_id ? driverDetails('WHERE u.id=$2', [r.driver_id]) : [],
  ]);
  return { ride: rideView(r), student: studentSummary(st.rows[0]), driver: dr[0] ? stripPrivate(dr[0]) : null,
    events: ev.map((e) => ({ at: iso(e.created_at), type: e.type, actor: e.actor_type, detail: e.data ? JSON.stringify(e.data) : null })), flags: flagsOf(r) };
}
admin.get('/admin/rides/:id', ...A('dispatcher', 'support', 'finance'), async (req, res) => {
  const d = await adminRideDetail(req.params.id);
  if (isOwner(req, 'ride')) return res.json(d);
  await auditReduced(req, 'ride', d.ride.id);
  // Fare, status, ids, times and the public driver and vehicle: no PIN, no driver detail or last position, no event details, a masked phone.
  res.json({
    ...d, ride: { ...d.ride, pin: null }, driver: null,
    student: { id: d.student.id, fullName: d.student.fullName, phone: maskPhone(d.student.phone), accountStatus: d.student.accountStatus, verificationStatus: d.student.verificationStatus, createdAt: d.student.createdAt },
    events: d.events.map((e) => ({ at: e.at, type: e.type, actor: e.actor, detail: null })),
  });
});

admin.post('/admin/rides/:id/cancel', ...A('dispatcher'), async (req, res) => {
  const { reason } = req.body;
  needUuid(req.params.id, 'Ride');
  await tx(async (c) => {
    const ride = await lockRide(c, req.params.id);
    if (ride.status === 'in_progress') {   // breakdown: release (no charge); staff may then refund/charge by adjustment
      await c.query(`UPDATE rides SET status='cancelled', cancel_by='admin', cancel_reason='admin_decision', cancel_reason_code='admin_decision', cancel_note=$2, cancelled_at=now() WHERE id=$1`, [ride.id, reason]);
      await wallet.release(c, ride.student_id, ride.id);
      await event(c, ride.id, 'cancelled', 'admin', req.user.id, { reason });
      await rideCancelled(c, ride, 'admin', 'admin_decision');
    } else await cancelRide(c, ride, 'admin', 'admin_decision', req.user.id, reason);
    await audit(c, req, 'ride.cancel', ride.id, { reason });
  });
  res.json(await adminRideDetail(req.params.id));
});

admin.post('/admin/rides/:id/complete', ...A('dispatcher'), async (req, res) => {   // F-01 stuck ride
  const { reasonCode, note, completionPoint } = req.body;
  needUuid(req.params.id, 'Ride');
  await tx(async (c) => {
    const ride = await lockRide(c, req.params.id);
    await completeRide(c, ride, 'admin', req.user.id, completionPoint ?? null, `${reasonCode}: ${note}`);
    await audit(c, req, 'ride.force_complete', ride.id, { reasonCode, note });
  });
  res.json(await adminRideDetail(req.params.id));
});

admin.post('/admin/rides/:id/reassign', ...A('dispatcher'), async (req, res) => {
  const { driverId, reason } = req.body;
  needUuid(req.params.id, 'Ride');
  const cfg = await getSettings();
  await tx(async (c) => {
    const ride = await lockRide(c, req.params.id);
    if (!['searching', 'assigned', 'driver_arrived'].includes(ride.status)) throw conflict('invalid_ride_state', `Ride is ${ride.status}`);
    const { rows: [d] } = await c.query('SELECT 1 FROM drivers WHERE user_id=$1 AND active AND on_duty FOR UPDATE', [driverId]);
    if (!d) throw conflict('no_drivers_on_duty', 'Driver is not on duty');
    try {
      await c.query('SAVEPOINT s');
      await c.query(`UPDATE rides SET driver_id=$2, status='assigned', assigned_at=now(), acked_at=NULL, arrived_at=NULL, ack_deadline=now() + make_interval(secs => $3) WHERE id=$1`, [ride.id, driverId, cfg.driverAckTimeoutSeconds]);
    } catch (e) { if (e.code === '23505') throw conflict('driver_has_active_ride', 'Driver already has an active ride'); throw e; }
    await event(c, ride.id, 'reassigned', 'admin', req.user.id, { driverId, reason });
    if (ride.driver_id && ride.driver_id !== driverId) await notifyUser(c, ride.driver_id, 'ride_cancelled_driver', { data: { rideId: ride.id } });
    await rideAssigned(c, { ...ride, assigned_at: new Date() }, driverId, { reassigned: true });
    await audit(c, req, 'ride.reassign', ride.id, { driverId, reason });
  });
  res.json(await adminRideDetail(req.params.id));
});

// ================= configuration =================
admin.put('/admin/service-area', ...A('super_admin'), async (req, res) => {
  const poly = req.body.boundary;
  const ring = poly.coordinates?.[0];
  if (poly.coordinates.length !== 1 || ring.length < 4 || ring.length > 500 || ring[0][0] !== ring.at(-1)[0] || ring[0][1] !== ring.at(-1)[1] || ring.some((p) => p.length !== 2 || Math.abs(p[0]) > 180 || Math.abs(p[1]) > 90))
    throw invalid('boundary', 'must be one closed ring of 4 to 500 [lng, lat] points');
  await tx(async (c) => {
    await c.query(`INSERT INTO service_area (id,polygon,version) VALUES (1,$1,1) ON CONFLICT (id) DO UPDATE SET polygon=$1, version=service_area.version+1`, [JSON.stringify({ type: 'Polygon', coordinates: poly.coordinates })]);
    await audit(c, req, 'service_area.update');
  });
  bustConfig();
  res.json(await serviceAreaView());
});

const ppView = (p) => ({ id: p.id, name: p.name, point: point(p.lat, p.lng), isActive: p.active });
admin.post('/admin/pickup-points', ...A('super_admin'), async (req, res) => {
  const { name, point: pt, isActive = true } = req.body;
  const { rows: [p] } = await q(`INSERT INTO pickup_points (name,lat,lng,active) VALUES ($1,$2,$3,$4) RETURNING *`, [name.trim(), pt.lat, pt.lng, isActive]);
  await q(`INSERT INTO audit_log (actor_type,actor_id,action,target) VALUES ('staff',$1,'pickup_point.create',$2)`, [req.user.id, p.id]);
  bustConfig();
  res.status(201).json(ppView(p));
});
admin.patch('/admin/pickup-points/:id', ...A('super_admin'), async (req, res) => {
  needUuid(req.params.id, 'Pickup point');
  const { name, point: pt, isActive } = req.body;
  const { rows: [p] } = await q(`UPDATE pickup_points SET name=$2, lat=$3, lng=$4, active=COALESCE($5,active) WHERE id=$1 AND deleted_at IS NULL RETURNING *`, [req.params.id, name.trim(), pt.lat, pt.lng, isActive ?? null]);
  if (!p) throw notFound('Pickup point');
  await q(`INSERT INTO audit_log (actor_type,actor_id,action,target) VALUES ('staff',$1,'pickup_point.update',$2)`, [req.user.id, p.id]);
  bustConfig();
  res.json(ppView(p));
});
admin.delete('/admin/pickup-points/:id', ...A('super_admin'), async (req, res) => {
  needUuid(req.params.id, 'Pickup point');
  const { rowCount } = await q(`UPDATE pickup_points SET deleted_at=now(), active=false WHERE id=$1 AND deleted_at IS NULL`, [req.params.id]);
  if (!rowCount) throw notFound('Pickup point');
  await q(`INSERT INTO audit_log (actor_type,actor_id,action,target) VALUES ('staff',$1,'pickup_point.delete',$2)`, [req.user.id, req.params.id]);
  bustConfig();
  res.status(204).end();
});

admin.put('/admin/fare-bands', ...A('super_admin'), async (req, res) => {
  const bands = req.body.bands;
  const ok = bands.length >= 1 && bands.length <= 20 && bands.every((b, i) => b.upToMeters > 0 && b.upToMeters <= 100_000 && b.farePesewas > 0 && b.farePesewas <= 1_000_000 && b.farePesewas % 100 === 0 &&
    (i === 0 || (b.upToMeters > bands[i - 1].upToMeters && b.farePesewas >= bands[i - 1].farePesewas)));
  if (!ok) throw invalid('bands', '1 to 20 bands, distances ascending, fares non-decreasing, whole cedis');
  await tx(async (c) => {
    await c.query('DELETE FROM fare_bands');
    for (const b of bands) await c.query('INSERT INTO fare_bands VALUES ($1,$2)', [b.upToMeters, b.farePesewas]);
    await audit(c, req, 'fare_bands.update', null, bands);
  });
  bustConfig();
  res.json({ bands });
});

admin.get('/admin/settings', ...A('super_admin'), async (_req, res) => res.json(publicSettings(await getSettings())));
const int = (min, max) => (v) => Number.isInteger(v) && v >= min && v <= max;
const SETTING_RULES = {
  maxTripDistanceMeters: int(500, 100_000), quoteTtlSeconds: int(30, 3600), driverAckTimeoutSeconds: int(10, 300), noDriverTimeoutSeconds: int(30, 1800),
  minTopupPesewas: int(100, 100_000), maxTopupPesewas: int(100, 5_000_000), driverSilenceSeconds: int(30, 3600), noShowWaitSeconds: int(60, 1800),
  quoteLimitPerMinute: int(1, 60), smsDailyLimit: int(100, 1_000_000), adjustmentApprovalThresholdPesewas: int(0, 1_000_000), locationRetentionDays: int(1, 365),
  bookingsPaused: (v) => typeof v === 'boolean', pauseMessage: (v) => v === null || (typeof v === 'string' && v.length <= 200), operatingHours: () => true,
};
admin.put('/admin/settings', ...A('super_admin'), async (req, res) => {
  const body = req.body, errors = [];
  for (const [k, v] of Object.entries(body)) if (!SETTING_RULES[k]?.(v)) errors.push({ field: k, message: 'out of range or wrong type' });
  if (body.minTopupPesewas > body.maxTopupPesewas) errors.push({ field: 'minTopupPesewas', message: 'must not exceed maxTopupPesewas' });
  if (errors.length) throw new ApiError(422, 'validation_failed', 'Invalid settings', { errors });
  await tx(async (c) => {
    for (const [k, v] of Object.entries(body)) await c.query(`INSERT INTO settings (key,value) VALUES ($1,$2) ON CONFLICT (key) DO UPDATE SET value=$2, updated_at=now()`, [k, JSON.stringify(v)]);
    await audit(c, req, 'settings.update', null, body);
  });
  bustConfig();
  res.json(publicSettings(await getSettings()));
});

// ================= announcements =================
admin.post('/admin/announcements', ...A('dispatcher'), async (req, res) => {
  const { audience, title, body } = req.body;
  const roles = audience === 'students' ? ['student'] : audience === 'drivers' ? ['driver'] : ['student', 'driver'];
  const a = await tx(async (c) => {
    const { rows: [n] } = await c.query(`SELECT count(*)::int n FROM users WHERE role = ANY($1) AND status='active' AND deleted_at IS NULL`, [roles]);
    const { rows: [a] } = await c.query(`INSERT INTO announcements (audience,title,body,sent_by,recipient_count) VALUES ($1,$2,$3,$4,$5) RETURNING *`, [audience, title, body, req.user.id, n.n]);
    await audit(c, req, 'announcement.create', a.id, { audience, title });
    await notifyAudience(c, audience, { title, body, announcementId: a.id });       // queued for the worker: thousands of devices, none of them awaited here
    return a;
  });
  res.status(202).json({ id: a.id, audience: a.audience, title: a.title, body: a.body, sentBy: a.sent_by, recipientCount: a.recipient_count, createdAt: iso(a.created_at) });
});

// ================= audit log & dashboard numbers =================
admin.get('/admin/audit-log', ...A('super_admin'), async (req, res) => {
  const a = pageArgs(req), actor = qUuid(req, 'actorStaffId'), entity = qUuid(req, 'entityId'), type = qText(req, 'entityType', 40);
  const cur = a.ts == null ? null : Number(a.ts);
  const { rows } = await q(`SELECT * FROM audit_log WHERE ($1::uuid IS NULL OR actor_id=$1) AND ($2::text IS NULL OR target=$2::text) AND ($3::text IS NULL OR action LIKE $3 || '.%' ESCAPE '\\')
      AND ($4::bigint IS NULL OR id < $4) ORDER BY id DESC LIMIT $5`, [actor, entity, type, cur, a.fetch]);
  const ZERO = '00000000-0000-0000-0000-000000000000';
  res.json(pageOf(rows, a, (r) => [r.id], (r) => ({ id: r.public_id, at: iso(r.created_at), actorStaffId: r.actor_id ?? null, action: r.action, entityType: r.action.split('.')[0],
    entityId: isUuid(r.target) ? r.target : ZERO, ...(r.data && { detail: r.data }) })));
});

// Extension to the contract: headline numbers for the dashboard home.
admin.get('/admin/stats', ...A(), async (_req, res) => {
  const [{ rows: [r] }, { rows: [d] }, { rows: [m] }] = await Promise.all([
    q(`SELECT count(*) FILTER (WHERE status IN ('searching','assigned','driver_arrived','in_progress'))::int AS active,
              count(*) FILTER (WHERE status='completed')::int AS completed, count(*) FILTER (WHERE status='cancelled')::int AS cancelled,
              COALESCE(sum(fare_pesewas) FILTER (WHERE status='completed'),0) AS revenue_pesewas FROM rides`),
    q(`SELECT count(*) FILTER (WHERE on_duty)::int AS on_duty, count(*)::int AS total FROM drivers`),
    q(`SELECT COALESCE(sum(balance_pesewas),0) AS balances, COALESCE(sum(reserved_pesewas),0) AS reserved FROM wallets`),
  ]);
  res.json({ rides: r, drivers: d, wallets: m });
});
