/**
 * In-browser stand-in for the API, used only when VITE_APP_ENV=demo.
 * Handles the admin endpoints the dashboard calls, applies actions to the
 * in-memory sample data, and answers with contract-shaped JSON or problems.
 */
import type { Schemas } from '@/types';
import * as db from '@/demo/data';

type S = Schemas;
type Json = unknown;
type Handler = (m: string[], q: URLSearchParams, body: Json) => Response | Promise<Response>;

const json = (status: number, data?: Json) =>
  new Response(data === undefined ? null : JSON.stringify(data), { status, headers: { 'Content-Type': 'application/json' } });
const problem = (status: number, code: S['ProblemCode'], title: string) =>
  new Response(JSON.stringify({ type: 'about:blank', title, status, code }), { status, headers: { 'Content-Type': 'application/problem+json' } });
const notFound = () => problem(404, 'not_found', 'Not found');

function page<T>(rows: T[], q: URLSearchParams, key: 'data' | 'items' = 'data') {
  const offset = Number(q.get('cursor') ?? 0) || 0;
  const limit = Math.min(Number(q.get('limit') ?? 25) || 25, 100);
  const slice = rows.slice(offset, offset + limit);
  const hasMore = offset + limit < rows.length;
  return { [key]: slice, page: { nextCursor: hasMore ? String(offset + limit) : null, hasMore } };
}

// --- demo session -----------------------------------------------------------
const store = {
  get: (k: string) => { try { return sessionStorage.getItem(k); } catch { return null; } },
  set: (k: string, v: string | null) => { try { if (v === null) sessionStorage.removeItem(k); else sessionStorage.setItem(k, v); } catch { /* blocked */ } },
};
function me(): S['StaffUser'] {
  const role = (store.get('demo.role') ?? 'super_admin') as S['StaffRole'];
  return db.staff.find((s) => s.staffRole === role) ?? db.staff[0]!;
}
function tokens(): S['AuthTokens'] {
  const u = me();
  return { accessToken: `demo.${u.id}`, expiresInSeconds: 900, user: { id: u.id, role: 'admin', staffRole: u.staffRole, displayName: u.fullName } };
}

const rideById = (id: string) => db.rides.find((r) => r.ride.id === id);
const detail = (r: db.DemoRide): S['AdminRideDetail'] => ({
  ride: r.ride,
  student: db.summaryOf(db.students.find((s) => s.id === r.studentId)!),
  driver: db.drivers.find((d) => d.id === r.driverId) ?? null,
  events: r.events,
  flags: r.flags,
});
const event = (r: db.DemoRide, type: string, detailText: string | null) => r.events.push({ at: new Date().toISOString(), type, actor: `staff:${me().id}`, detail: detailText });
const audit = (action: string, entityType: string, entityId: string, d: Record<string, unknown> = {}) =>
  db.audit.unshift({ id: db.uid(), at: new Date().toISOString(), actorStaffId: me().id, action, entityType, entityId, detail: d });

function liveRides(): S['LiveRides'] {
  const active = db.rides.filter((r) => ['searching', 'assigned', 'driver_arrived', 'in_progress'].includes(r.ride.status));
  const t = Date.now() / 60_000;
  return {
    rides: active.map((r) => {
      const d = db.drivers.find((x) => x.id === r.driverId);
      const frozen = r.flags.includes('driver_unreachable');
      const loc = d?.lastLocation ? {
        ...d.lastLocation,
        point: frozen ? d.lastLocation.point : { lat: d.lastLocation.point.lat + Math.sin(t) * 0.002, lng: d.lastLocation.point.lng + Math.cos(t) * 0.002 },
        recordedAt: frozen ? d.lastLocation.recordedAt : new Date().toISOString(),
      } : null;
      return { ride: db.adminRideSummary(r), driverLocation: loc };
    }),
    onDutyDrivers: db.drivers.filter((d) => d.dutyStatus === 'on_duty').map((d) => ({
      driverId: d.id, fullName: d.fullName, idle: !d.currentRideId, location: d.lastLocation,
    })),
  };
}

// --- routes -------------------------------------------------------------------
const routes: [string, RegExp, Handler][] = [
  ['POST', /^\/auth\/admin\/login$/, (_m, _q, b) => {
    const body = b as S['AdminLogin'];
    if (!body.password || body.password.length < 10) return problem(401, 'invalid_credentials', 'Invalid credentials');
    if (!body.totpCode) return problem(401, 'mfa_required', 'MFA code required');
    const prefix = body.email.split(/[@.]/)[0]?.toLowerCase();
    // Same staff emails as the API's dev seed (docs/api-integration.md §8): dispatch@, finance2@, admin@ ...
    const alias: Record<string, S['StaffRole']> = { verifier: 'verifier', dispatch: 'dispatcher', dispatcher: 'dispatcher', finance: 'finance', finance2: 'finance', support: 'support', hr: 'hr' };
    const role = alias[prefix ?? ''] ?? 'super_admin';
    store.set('demo.role', role);
    return json(200, tokens());
  }],
  ['POST', /^\/auth\/refresh$/, () => (store.get('demo.role') ? json(200, tokens()) : problem(401, 'unauthenticated', 'No session'))],
  ['POST', /^\/auth\/logout$/, () => { store.set('demo.role', null); return json(204); }],
  ['POST', /^\/auth\/admin\/password\/forgot$/, () => json(202)],
  ['POST', /^\/auth\/admin\/password\/reset$/, () => json(204)],
  ['POST', /^\/auth\/admin\/invite\/accept$/, () => json(200, { enrollmentToken: 'demo-enrol', secret: 'JBSWY3DPEHPK3PXP', otpauthUri: 'otpauth://totp/Turbo:new.staff@turbo.example?secret=JBSWY3DPEHPK3PXP&issuer=Turbo' })],
  ['POST', /^\/auth\/admin\/mfa\/confirm$/, () => { store.set('demo.role', 'super_admin'); return json(200, tokens()); }],
  ['GET', /^\/admin\/me$/, () => json(200, me())],
  ['POST', /^\/admin\/me\/password$/, () => json(204)],
  ['GET', /^\/service-area$/, () => json(200, db.serviceArea)],
  ['GET', /^\/admin\/settings$/, () => json(200, db.settings)],
  ['PUT', /^\/admin\/settings$/, (_m, _q, b) => { Object.assign(db.settings, b); audit('settings.updated', 'settings', db.uid()); return json(200, db.settings); }],
  ['PUT', /^\/admin\/service-area$/, (_m, _q, b) => { db.serviceArea.boundary = (b as S['ServiceAreaWrite']).boundary; db.serviceArea.version += 1; audit('service_area.replaced', 'service_area', db.uid()); return json(200, db.serviceArea); }],
  ['PUT', /^\/admin\/fare-bands$/, (_m, _q, b) => { db.serviceArea.fareBands = (b as S['FareBandSet']).bands; audit('fare_bands.replaced', 'fare_bands', db.uid()); return json(200, b); }],
  ['POST', /^\/admin\/pickup-points$/, (_m, _q, b) => { const w = b as S['PickupPointWrite']; const p = { id: db.uid(), ...w, isActive: w.isActive ?? true }; db.serviceArea.pickupPoints.push(p); return json(201, p); }],
  ['PATCH', /^\/admin\/pickup-points\/([^/]+)$/, ([, id], _q, b) => { const p = db.serviceArea.pickupPoints.find((x) => x.id === id); if (!p) return notFound(); Object.assign(p, b); return json(200, p); }],
  ['DELETE', /^\/admin\/pickup-points\/([^/]+)$/, ([, id]) => { db.serviceArea.pickupPoints = db.serviceArea.pickupPoints.filter((x) => x.id !== id); return json(204); }],

  ['GET', /^\/admin\/verifications$/, (_m, q) => {
    const status = q.get('status');
    const rows = db.verifications.filter((v) => !status || v.status === status).map((v): S['VerificationSummary'] => {
      const c = db.claims.get(v.id);
      return { id: v.id, student: { id: v.student.id, fullName: v.student.fullName, phone: v.student.phone }, status: v.status, submittedAt: v.submittedAt,
        claimedBy: c && c.until > new Date().toISOString() ? c.by : null, claimExpiresAt: c?.until ?? null };
    }).sort((a, b) => a.submittedAt.localeCompare(b.submittedAt));
    return json(200, page(rows, q));
  }],
  ['POST', /^\/admin\/verifications\/([^/]+)\/claim$/, ([, id]) => {
    const v = db.verifications.find((x) => x.id === id); if (!v) return notFound();
    const c = db.claims.get(id!);
    if (c && c.by !== me().id && c.until > new Date().toISOString()) return problem(409, 'verification_claimed', 'Claimed by another reviewer');
    const until = new Date(Date.now() + 15 * 60_000).toISOString();
    db.claims.set(id!, { by: me().id, until });
    return json(200, { id, student: { id: v.student.id, fullName: v.student.fullName, phone: v.student.phone }, status: v.status, submittedAt: v.submittedAt, claimedBy: me().id, claimExpiresAt: until });
  }],
  ['GET', /^\/admin\/verifications\/([^/]+)$/, ([, id]) => { const v = db.verifications.find((x) => x.id === id); if (!v) return notFound(); audit('verification.document_viewed', 'verification', v.id); return json(200, v); }],
  ['POST', /^\/admin\/verifications\/([^/]+)\/decision$/, ([, id], _q, b) => {
    const v = db.verifications.find((x) => x.id === id); if (!v) return notFound();
    const d = b as S['VerificationDecision'];
    if (v.status !== 'pending') return problem(409, 'conflict', 'Already decided');
    v.status = d.decision;
    v.history.unshift({ decision: d.decision, reasonCode: d.reasonCode ?? null, decidedByStaffId: me().id, decidedAt: new Date().toISOString() });
    const s = db.students.find((x) => x.id === v.student.id); if (s) s.verificationStatus = d.decision;
    db.claims.delete(id!);
    audit(`verification.${d.decision}`, 'verification', v.id, { student: v.submittedFullName });
    return json(200, v);
  }],

  ['GET', /^\/admin\/students$/, (_m, q) => {
    const term = (q.get('q') ?? '').toLowerCase();
    const rows = db.students.filter((s) => (!term || s.fullName?.toLowerCase().includes(term) || s.phone.includes(term))
      && (!q.get('verificationStatus') || s.verificationStatus === q.get('verificationStatus'))
      && (!q.get('accountStatus') || s.accountStatus === q.get('accountStatus'))).map(db.summaryOf);
    return json(200, page(rows, q));
  }],
  ['GET', /^\/admin\/students\/([^/]+)$/, ([, id]) => { const s = db.students.find((x) => x.id === id); return s ? json(200, s) : notFound(); }],
  ['PATCH', /^\/admin\/students\/([^/]+)$/, ([, id], _q, b) => { const s = db.students.find((x) => x.id === id); if (!s) return notFound(); s.accountStatus = (b as S['AccountStatusUpdate']).accountStatus; audit(`student.${s.accountStatus}`, 'student', s.id); return json(200, s); }],
  ['PUT', /^\/admin\/students\/([^/]+)\/phone$/, ([, id], _q, b) => { const s = db.students.find((x) => x.id === id); if (!s) return notFound(); s.phone = (b as S['PhoneChange']).newPhone; audit('student.phone_changed', 'student', s.id); return json(200, s); }],
  ['DELETE', /^\/admin\/students\/([^/]+)\/sessions$/, () => json(204)],
  ['GET', /^\/admin\/students\/([^/]+)\/wallet$/, ([, id]) => { const w = db.wallets.get(id!); return w ? json(200, w) : notFound(); }],
  ['GET', /^\/admin\/students\/([^/]+)\/wallet\/transactions$/, ([, id], q) => json(200, page(db.txByStudent.get(id!) ?? [], q))],
  ['POST', /^\/admin\/students\/([^/]+)\/wallet\/adjustments$/, ([, id], _q, b) => {
    const w = db.wallets.get(id!); if (!w) return notFound();
    const a = b as S['WalletAdjustment'];
    if (Math.abs(a.amountPesewas) > db.settings.adjustmentApprovalThresholdPesewas!) {
      const req: S['AdjustmentRequest'] = { id: db.uid(), studentId: id!, amountPesewas: a.amountPesewas, reasonCode: a.reasonCode, note: a.note, status: 'pending', requestedBy: me().id, decidedBy: null, createdAt: new Date().toISOString(), decidedAt: null };
      db.adjustmentRequests.unshift(req);
      return json(202, req);
    }
    if (w.balancePesewas + a.amountPesewas < 0) return problem(422, 'validation_failed', 'Balance cannot go below zero');
    w.balancePesewas += a.amountPesewas; w.availablePesewas += a.amountPesewas;
    const tx: S['WalletTransaction'] = { id: db.uid(), type: 'adjustment', amountPesewas: a.amountPesewas, affectsBalance: true, balanceAfterPesewas: w.balancePesewas, rideId: null, description: `Adjustment: ${a.reasonCode.replace(/_/g, ' ')}`, createdAt: new Date().toISOString() };
    db.txByStudent.set(id!, [tx, ...(db.txByStudent.get(id!) ?? [])]);
    audit('wallet.adjusted', 'wallet', id!, { amount: a.amountPesewas });
    return json(201, tx);
  }],

  ['GET', /^\/admin\/drivers$/, (_m, q) => json(200, page(db.drivers.filter((d) => (!q.get('status') || d.status === q.get('status')) && (!q.get('dutyStatus') || d.dutyStatus === q.get('dutyStatus'))), q))],
  ['POST', /^\/admin\/drivers$/, (_m, _q, b) => {
    const c = b as S['DriverCreate'];
    const d: S['DriverDetail'] = { id: db.uid(), fullName: c.fullName, phone: c.phone, email: c.email ?? null, status: 'active', dutyStatus: 'off_duty',
      vehicle: db.vehicles.find((v) => v.id === c.vehicleId) ?? null, currentRideId: null, lastLocation: null, documents: [], createdAt: new Date().toISOString() };
    db.drivers.push(d); audit('driver.created', 'driver', d.id, { name: d.fullName });
    return json(201, d);
  }],
  ['GET', /^\/admin\/drivers\/([^/]+)$/, ([, id]) => { const d = db.drivers.find((x) => x.id === id); return d ? json(200, d) : notFound(); }],
  ['PATCH', /^\/admin\/drivers\/([^/]+)$/, ([, id], _q, b) => {
    const d = db.drivers.find((x) => x.id === id); if (!d) return notFound();
    const u = b as S['DriverUpdate'];
    if (u.fullName) d.fullName = u.fullName;
    if (u.status) d.status = u.status;
    if (u.vehicleId !== undefined) d.vehicle = db.vehicles.find((v) => v.id === u.vehicleId) ?? null;
    return json(200, d);
  }],
  ['POST', /^\/admin\/drivers\/([^/]+)\/documents$/, ([, id], _q, b) => {
    const d = db.drivers.find((x) => x.id === id); if (!d) return notFound();
    const doc: S['DriverDocument'] = { id: db.uid(), ...(b as S['DriverDocumentCreate']), expiresOn: (b as S['DriverDocumentCreate']).expiresOn ?? null };
    d.documents = [...(d.documents ?? []), doc];
    return json(201, doc);
  }],
  ['GET', /^\/admin\/driver-documents\/expiring$/, (_m, q) => {
    const within = Number(q.get('withinDays') ?? 30);
    const items: S['DriverDocumentExpiry'][] = db.drivers.flatMap((d) => (d.documents ?? []).filter((x) => x.expiresOn).map((x) => ({
      driverId: d.id, driverName: d.fullName, documentType: x.type, expiresOn: x.expiresOn!, daysLeft: Math.round((new Date(x.expiresOn!).getTime() - Date.now()) / 86_400_000),
    }))).filter((x) => x.daysLeft <= within).sort((a, b) => a.daysLeft - b.daysLeft);
    return json(200, { items });
  }],
  ['GET', /^\/admin\/drivers\/([^/]+)\/salary-profile$/, ([, id]) => { const p = db.salaryProfiles.get(id!); return p ? json(200, p) : notFound(); }],
  ['PUT', /^\/admin\/drivers\/([^/]+)\/salary-profile$/, ([, id], _q, b) => { const p = { driverId: id!, ...(b as S['SalaryProfileWrite']), updatedAt: new Date().toISOString() }; db.salaryProfiles.set(id!, p); return json(200, p); }],
  ['GET', /^\/admin\/vehicles$/, (_m, q) => json(200, page(db.vehicles, q))],
  ['POST', /^\/admin\/vehicles$/, (_m, _q, b) => { const v = { id: db.uid(), status: 'active' as const, ...(b as S['VehicleWrite']) }; db.vehicles.push(v); return json(201, v); }],
  ['PATCH', /^\/admin\/vehicles\/([^/]+)$/, ([, id], _q, b) => { const v = db.vehicles.find((x) => x.id === id); if (!v) return notFound(); Object.assign(v, b); return json(200, v); }],

  ['GET', /^\/admin\/rides\/live$/, () => json(200, liveRides())],
  ['GET', /^\/admin\/rides$/, (_m, q) => {
    const from = q.get('from'); const to = q.get('to');
    const rows = db.rides.filter((r) => (!q.get('status') || r.ride.status === q.get('status')) && (!q.get('flag') || r.flags.includes(q.get('flag') as S['RideFlag']))
      && (!q.get('studentId') || r.studentId === q.get('studentId')) && (!q.get('driverId') || r.driverId === q.get('driverId'))
      && (!from || r.ride.requestedAt >= from) && (!to || r.ride.requestedAt <= to))
      .sort((a, b) => b.ride.requestedAt.localeCompare(a.ride.requestedAt)).map(db.adminRideSummary);
    return json(200, page(rows, q));
  }],
  ['GET', /^\/admin\/rides\/([^/]+)$/, ([, id]) => { const r = rideById(id!); return r ? json(200, detail(r)) : notFound(); }],
  ['POST', /^\/admin\/rides\/([^/]+)\/reassign$/, ([, id], _q, b) => {
    const r = rideById(id!); if (!r) return notFound();
    const { driverId, reason } = b as S['ReassignRequest'];
    const next = db.drivers.find((d) => d.id === driverId); if (!next) return notFound();
    if (next.currentRideId) return problem(409, 'driver_has_active_ride', 'Driver busy');
    const prev = db.drivers.find((d) => d.id === r.driverId); if (prev) prev.currentRideId = null;
    next.currentRideId = r.ride.id; r.driverId = next.id; r.ride.status = 'assigned';
    event(r, 'reassigned', `${next.fullName}: ${reason}`); audit('ride.reassigned', 'ride', r.ride.id, { to: next.fullName });
    return json(200, detail(r));
  }],
  ['POST', /^\/admin\/rides\/([^/]+)\/cancel$/, ([, id], _q, b) => {
    const r = rideById(id!); if (!r) return notFound();
    if (['completed', 'cancelled'].includes(r.ride.status)) return problem(409, 'invalid_ride_state', 'Ride is finished');
    r.ride.status = 'cancelled'; r.ride.payment.status = 'released'; r.flags = [];
    r.ride.cancellation = { by: 'admin', reasonCode: 'admin_decision', note: (b as S['AdminCancelRequest']).reason, cancelledAt: new Date().toISOString() };
    const d = db.drivers.find((x) => x.id === r.driverId); if (d) d.currentRideId = null;
    event(r, 'cancelled', (b as S['AdminCancelRequest']).reason); audit('ride.cancelled', 'ride', r.ride.id);
    return json(200, detail(r));
  }],
  ['POST', /^\/admin\/rides\/([^/]+)\/complete$/, ([, id], _q, b) => {
    const r = rideById(id!); if (!r) return notFound();
    if (r.ride.status !== 'in_progress') return problem(409, 'invalid_ride_state', 'Only in-progress rides');
    r.ride.status = 'completed'; r.ride.completedAt = new Date().toISOString(); r.ride.payment = { ...r.ride.payment, status: 'charged', chargedPesewas: r.ride.farePesewas };
    r.flags = r.flags.filter((f) => f !== 'driver_unreachable' && f !== 'overdue');
    const d = db.drivers.find((x) => x.id === r.driverId); if (d) d.currentRideId = null;
    event(r, 'completed', `Force-completed: ${(b as S['AdminCompleteRequest']).note}`); audit('ride.force_completed', 'ride', r.ride.id);
    return json(200, detail(r));
  }],
  ['POST', /^\/admin\/rides\/([^/]+)\/refund$/, ([, id], _q, b) => {
    const r = rideById(id!); if (!r) return notFound();
    const left = r.ride.payment.chargedPesewas - r.ride.payment.refundedPesewas;
    const amount = (b as S['RefundRequest']).amountPesewas ?? left;
    if (amount > left) return problem(409, 'refund_exceeds_charge', 'Too much');
    r.ride.payment.refundedPesewas += amount; r.ride.payment.status = r.ride.payment.refundedPesewas === r.ride.payment.chargedPesewas ? 'refunded' : 'partially_refunded';
    event(r, 'refunded', `${amount / 100} cedis`); audit('ride.refunded', 'ride', r.ride.id, { amount });
    const w = db.wallets.get(r.studentId)!; w.balancePesewas += amount; w.availablePesewas += amount;
    return json(201, { id: db.uid(), type: 'refund', amountPesewas: amount, affectsBalance: true, balanceAfterPesewas: w.balancePesewas, rideId: r.ride.id, description: 'Refund', createdAt: new Date().toISOString() });
  }],
  ['POST', /^\/admin\/announcements$/, (_m, _q, b) => json(202, { id: db.uid(), ...(b as S['AnnouncementCreate']), sentBy: me().id, recipientCount: (b as S['AnnouncementCreate']).audience === 'drivers' ? db.drivers.length : 412, createdAt: new Date().toISOString() })],

  ['GET', /^\/admin\/topups$/, (_m, q) => {
    const rows = db.topups.filter((t) => (q.get('flagged') !== 'true' || (t.flagged && !t.resolvedAt)) && (!q.get('status') || t.status === q.get('status')) && (!q.get('studentId') || t.studentId === q.get('studentId')));
    return json(200, page(rows, q));
  }],
  ['POST', /^\/admin\/topups\/([^/]+)\/resolve$/, ([, id]) => { const t = db.topups.find((x) => x.id === id); if (!t) return notFound(); t.resolvedAt = new Date().toISOString(); audit('topup.resolved', 'topup', t.id); return json(200, t); }],
  ['GET', /^\/admin\/wallet-adjustments$/, (_m, q) => json(200, page(db.adjustmentRequests.filter((a) => !q.get('status') || a.status === q.get('status')), q, 'items'))],
  ['POST', /^\/admin\/wallet-adjustments\/([^/]+)\/(approve|reject)$/, ([, id, action]) => {
    const a = db.adjustmentRequests.find((x) => x.id === id); if (!a) return notFound();
    if (a.requestedBy === me().id) return problem(409, 'approval_by_requester_forbidden', 'Cannot approve own request');
    if (a.status !== 'pending') return problem(409, 'conflict', 'Already decided');
    a.status = action === 'approve' ? 'approved' : 'rejected'; a.decidedBy = me().id; a.decidedAt = new Date().toISOString();
    if (a.status === 'approved') { const w = db.wallets.get(a.studentId); if (w) { w.balancePesewas += a.amountPesewas; w.availablePesewas += a.amountPesewas; } }
    audit(`wallet_adjustment.${a.status}`, 'wallet', a.studentId);
    return json(200, a);
  }],
  ['GET', /^\/admin\/reconciliation\/reports$/, (_m, q) => json(200, page(db.reconReports, q, 'items'))],
  ['POST', /^\/admin\/reconciliation\/reports$/, (_m, _q, b) => {
    const run = b as S['ReconciliationRun'];
    const r: S['ReconciliationReport'] = { ...db.reconReports[0]!, id: db.uid(), periodFrom: run.periodFrom, periodTo: run.periodTo, matchedCount: 96,
      providerTotalPesewas: 842_000, ourTotalPesewas: 842_000, exceptions: [], createdAt: new Date().toISOString() };
    db.reconReports.unshift(r); return json(201, r);
  }],
  ['POST', /^\/uploads$/, (_m, _q, b) => {
    const id = db.uid();
    return json(201, { uploadId: id, uploadUrl: `${window.location.origin}/demo-storage/${id}`, method: 'PUT',
      headers: { 'Content-Type': (b as S['UploadRequest']).contentType }, expiresAt: new Date(Date.now() + 600_000).toISOString() });
  }],
  ['PUT', /^\/demo-storage\/[^/]+$/, () => json(204)],

  ['GET', /^\/admin\/support\/tickets$/, (_m, q) => json(200, page(db.tickets.filter((t) => (!q.get('status') || t.status === q.get('status')) && (!q.get('category') || t.category === q.get('category')))
    .map(({ messages: _x, ...t }) => t), q))],
  ['GET', /^\/admin\/support\/tickets\/([^/]+)$/, ([, id]) => { const t = db.tickets.find((x) => x.id === id); return t ? json(200, t) : notFound(); }],
  ['PATCH', /^\/admin\/support\/tickets\/([^/]+)$/, ([, id], _q, b) => { const t = db.tickets.find((x) => x.id === id); if (!t) return notFound(); Object.assign(t, b, { updatedAt: new Date().toISOString() }); return json(200, t); }],
  ['POST', /^\/admin\/support\/tickets\/([^/]+)\/messages$/, ([, id], _q, b) => {
    const t = db.tickets.find((x) => x.id === id); if (!t) return notFound();
    const m: S['SupportMessage'] = { id: db.uid(), author: 'staff', body: (b as S['SupportMessageCreate']).body, internal: !!(b as S['SupportMessageCreate']).internal, createdAt: new Date().toISOString() };
    t.messages = [...(t.messages ?? []), m]; t.updatedAt = m.createdAt; return json(201, m);
  }],
  ['GET', /^\/admin\/incidents$/, (_m, q) => json(200, page(db.incidents.filter((i) => !q.get('status') || i.status === q.get('status')), q))],
  ['PATCH', /^\/admin\/incidents\/([^/]+)$/, ([, id], _q, b) => {
    const i = db.incidents.find((x) => x.id === id); if (!i) return notFound();
    const u = b as S['IncidentUpdate']; i.status = u.status; if (u.note) i.note = `${i.note ?? ''}${i.note ? ' · ' : ''}${u.note}`;
    audit(`incident.${u.status}`, 'incident', i.id); return json(200, i);
  }],

  ['GET', /^\/admin\/shifts$/, (_m, q) => json(200, page(db.shifts.filter((s) => !q.get('driverId') || s.driverId === q.get('driverId')), q))],
  ['POST', /^\/admin\/shifts$/, (_m, _q, b) => {
    const c = b as S['ShiftCreate'];
    if (db.shifts.some((s) => s.driverId === c.driverId && s.status !== 'missed' && c.startsAt < s.endsAt && c.endsAt > s.startsAt)) return problem(409, 'shift_overlap', 'Overlap');
    const s: S['Shift'] = { id: db.uid(), ...c, status: 'scheduled' }; db.shifts.push(s); return json(201, s);
  }],
  ['DELETE', /^\/admin\/shifts\/([^/]+)$/, ([, id]) => { const i = db.shifts.findIndex((s) => s.id === id); if (i < 0) return notFound(); db.shifts.splice(i, 1); return json(204); }],
  ['GET', /^\/admin\/attendance$/, (_m, q) => json(200, page(db.attendance.filter((a) => !q.get('driverId') || a.driverId === q.get('driverId')).sort((a, b) => b.date.localeCompare(a.date)), q))],
  ['PATCH', /^\/admin\/attendance\/([^/]+)$/, ([, id], _q, b) => {
    const a = db.attendance.find((x) => x.id === id); if (!a) return notFound();
    const c = b as S['AttendanceCorrection'];
    if (c.clockInAt) a.clockInAt = c.clockInAt; if (c.clockOutAt) a.clockOutAt = c.clockOutAt;
    if (a.clockInAt && a.clockOutAt) a.minutesWorked = Math.max(0, Math.round((new Date(a.clockOutAt).getTime() - new Date(a.clockInAt).getTime()) / 60_000));
    a.status = 'corrected'; a.correctionNote = c.note; audit('attendance.corrected', 'attendance', a.id, { reason: c.reasonCode });
    return json(200, a);
  }],
  ['GET', /^\/admin\/salary-payments$/, (_m, q) => json(200, page(db.salaryPayments.filter((p) => !q.get('driverId') || p.driverId === q.get('driverId')), q))],
  ['POST', /^\/admin\/salary-payments$/, (_m, _q, b) => { const p: S['SalaryPayment'] = { id: db.uid(), reference: null, ...(b as S['SalaryPaymentCreate']) }; db.salaryPayments.unshift(p); return json(201, p); }],

  ['GET', /^\/admin\/staff$/, (_m, q) => json(200, page(db.staff, q))],
  ['POST', /^\/admin\/staff$/, (_m, _q, b) => { const u: S['StaffUser'] = { id: db.uid(), ...(b as S['StaffCreate']), isActive: true, mfaEnrolled: false, lastLoginAt: null, lockedUntil: null, invitePending: true }; db.staff.push(u); audit('staff.invited', 'staff', u.id); return json(201, u); }],
  ['PATCH', /^\/admin\/staff\/([^/]+)$/, ([, id], _q, b) => { const u = db.staff.find((x) => x.id === id); if (!u) return notFound(); Object.assign(u, b); return json(200, u); }],
  ['POST', /^\/admin\/staff\/([^/]+)\/invite$/, () => json(202)],
  ['DELETE', /^\/admin\/staff\/([^/]+)\/sessions$/, () => json(204)],
  ['GET', /^\/admin\/audit-log$/, (_m, q) => json(200, page(db.audit.filter((a) => (!q.get('entityType') || a.entityType === q.get('entityType'))
    && (!q.get('entityId') || a.entityId === q.get('entityId')) && (!q.get('actorStaffId') || a.actorStaffId === q.get('actorStaffId'))), q))],
];

const delay = (ms: number) => new Promise((r) => setTimeout(r, ms));

export const demoFetch: typeof fetch = async (input, init) => {
  const request = input instanceof Request ? input : new Request(input, init);
  const url = new URL(request.url, window.location.origin);
  const path = url.pathname.replace(/^\/api/, '');
  const isJson = (request.headers.get('Content-Type') ?? '').includes('json');
  const text = request.method === 'GET' || request.method === 'DELETE' || !isJson ? '' : await request.text();
  const body: Json = text ? JSON.parse(text) : {};
  await delay(180 + Math.random() * 220); // feel of a real network
  for (const [method, re, handler] of routes) {
    if (method !== request.method) continue;
    const m = path.match(re);
    if (m) return handler(m as unknown as string[], url.searchParams, body);
  }
  return problem(404, 'not_found', `Demo has no ${request.method} ${path}`);
};
