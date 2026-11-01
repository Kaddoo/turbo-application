import { Router } from 'express';
import { q, tx } from '../db.js';
import { authenticate, requireRole, terms } from '../lib/auth.js';
import { ApiError, notFound, conflict } from '../lib/errors.js';
import { isUuid, normalizePhone } from '../lib/util.js';
import { idempotent } from '../lib/idempotency.js';
import { pageArgs, pageOf } from '../lib/page.js';
import { qEnum, qUuid, qDate, qInt } from '../lib/query.js';
import { driverDetails, stripPrivate, docView } from '../domain/people.js';
import { vehicleView, iso } from '../views.js';
import { audit } from './admin.js';

export const hr = Router();
const H = [authenticate, requireRole('admin', ['hr'])];
const DRIVER = [authenticate, requireRole('driver'), terms];
const invalid = (field, message) => new ApiError(422, 'validation_failed', 'Invalid request', { errors: [{ field, message }] });
const need = (id, what) => { if (!isUuid(id)) throw notFound(what); };
const day = (d) => (d ? new Date(d).toISOString().slice(0, 10) : null);
const noTime = (res) => res.set('cache-control', 'no-store');

// ================= vehicles =================
hr.get('/admin/vehicles', ...H, async (req, res) => {
  const a = pageArgs(req);
  const { rows } = await q(`SELECT * FROM vehicles WHERE deleted_at IS NULL AND ($1::timestamptz IS NULL OR (created_at, id) < ($1::timestamptz, $2::uuid)) ORDER BY created_at DESC, id DESC LIMIT $3`, [a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.created_at, r.id], vehicleView));
});
const vehicleWrite = async (req, res, id) => {
  const { make, model, colour, plateNumber, seats = 4, status = 'active' } = req.body;
  try {
    const { rows: [v] } = id
      ? await q(`UPDATE vehicles SET make=$2,model=$3,colour=$4,plate_number=$5,seats=$6,status=$7,updated_at=now() WHERE id=$1 AND deleted_at IS NULL RETURNING *`, [id, make.trim(), model.trim(), colour.trim(), plateNumber.trim().toUpperCase(), seats, status])
      : await q(`INSERT INTO vehicles (make,model,colour,plate_number,seats,status) VALUES ($1,$2,$3,$4,$5,$6) RETURNING *`, [make.trim(), model.trim(), colour.trim(), plateNumber.trim().toUpperCase(), seats, status]);
    if (!v) throw notFound('Vehicle');
    await q(`INSERT INTO audit_log (actor_type,actor_id,action,target) VALUES ('staff',$1,$2,$3)`, [req.user.id, id ? 'vehicle.update' : 'vehicle.create', v.id]);
    res.status(id ? 200 : 201).json(vehicleView(v));
  } catch (e) {
    if (e.code !== '23505') throw e;
    // Say which vehicle holds the plate, so staff know whether to reactivate it or fix a typo.
    const { rows: [other] } = await q(`SELECT status FROM vehicles WHERE deleted_at IS NULL AND id IS DISTINCT FROM $2::uuid AND plate_normalised = regexp_replace(upper($1), '[^A-Z0-9]', '', 'g')`, [plateNumber, id]);
    const word = { active: 'an active', maintenance: 'a maintenance', retired: 'a retired' }[other?.status] ?? 'another';
    throw conflict('duplicate_plate', 'A vehicle with that plate number already exists', {
      detail: `The same plate is already registered to ${word} vehicle.${other?.status === 'retired' ? ' Reactivate that vehicle instead of adding it again.' : ''}`,
    });
  }
};
hr.post('/admin/vehicles', ...H, (req, res) => vehicleWrite(req, res, null));
hr.patch('/admin/vehicles/:id', ...H, (req, res) => { need(req.params.id, 'Vehicle'); return vehicleWrite(req, res, req.params.id); });

// ================= drivers =================
const oneDriver = async (id) => {
  need(id, 'Driver');
  const [d] = await driverDetails('WHERE u.id=$2', [id]);
  if (!d) throw notFound('Driver');
  return stripPrivate(d);
};
hr.get('/admin/drivers', ...H, async (req, res) => {
  const a = pageArgs(req), status = qEnum(req, 'status', ['active', 'suspended']), duty = qEnum(req, 'dutyStatus', ['off_duty', 'on_duty']);
  const rows = await driverDetails(`WHERE ($2::text IS NULL OR u.status=$2) AND ($3::boolean IS NULL OR d.on_duty=$3)
      AND ($4::timestamptz IS NULL OR (u.created_at, u.id) < ($4::timestamptz, $5::uuid)) ORDER BY u.created_at DESC, u.id DESC LIMIT $6`,
    [status, duty ? duty === 'on_duty' : null, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.createdAt, r.id], stripPrivate));
});
hr.get('/admin/drivers/:id', ...H, async (req, res) => res.json(await oneDriver(req.params.id)));

async function assignVehicle(c, driverId, vehicleId) {
  if (!vehicleId) return;
  const { rows: [v] } = await c.query(`SELECT id, status FROM vehicles WHERE id=$1 AND deleted_at IS NULL`, [vehicleId]);
  if (!v) throw invalid('vehicleId', 'no such vehicle');
  if (v.status !== 'active') throw conflict('conflict', `That vehicle is ${v.status}`);
  const { rows: [other] } = await c.query('SELECT user_id FROM drivers WHERE vehicle_id=$1 AND user_id<>$2', [vehicleId, driverId]);
  if (other) throw conflict('vehicle_already_assigned', 'That vehicle is already assigned to another driver');
}

hr.post('/admin/drivers', ...H, async (req, res) => idempotent(req, res, 'drivercreate', async () => {
  const { fullName, phone, email, vehicleId } = req.body;
  const p = normalizePhone(phone);
  const id = await tx(async (c) => {
    let u;
    try {
      ({ rows: [u] } = await c.query(`INSERT INTO users (role,phone,full_name,first_name,last_name) VALUES ('driver',$1,$2,$3,$4) RETURNING id`,
        [p, fullName.trim(), fullName.trim().split(/\s+/)[0], fullName.trim().split(/\s+/).slice(1).join(' ') || null]));
    } catch (e) { if (e.code === '23505') throw conflict('duplicate_phone', 'That phone number is already registered'); throw e; }
    await assignVehicle(c, u.id, vehicleId);
    try { await c.query('INSERT INTO drivers (user_id,vehicle_id,email) VALUES ($1,$2,$3)', [u.id, vehicleId ?? null, email?.toLowerCase() ?? null]); }
    catch (e) { if (e.code === '23505') throw conflict('vehicle_already_assigned', 'That vehicle is already assigned to another driver'); throw e; }
    await audit(c, req, 'driver.create', u.id);
    return u.id;
  });
  return { status: 201, body: await oneDriver(id) };
}));

hr.patch('/admin/drivers/:id', ...H, async (req, res) => {
  const { fullName, status, vehicleId } = req.body;
  await oneDriver(req.params.id);
  await tx(async (c) => {
    if (vehicleId !== undefined) await assignVehicle(c, req.params.id, vehicleId);
    if (fullName) await c.query(`UPDATE users SET full_name=$2, first_name=$3, last_name=$4, updated_at=now() WHERE id=$1`, [req.params.id, fullName.trim(), fullName.trim().split(/\s+/)[0], fullName.trim().split(/\s+/).slice(1).join(' ') || null]);
    if (status) {
      await c.query('UPDATE users SET status=$2, updated_at=now() WHERE id=$1', [req.params.id, status]);
      await c.query('UPDATE drivers SET active=$2, on_duty = on_duty AND $2 WHERE user_id=$1', [req.params.id, status === 'active']);
      if (status === 'suspended') await c.query(`UPDATE refresh_tokens SET revoked_at=now() WHERE subject_id=$1 AND subject_type='user' AND revoked_at IS NULL`, [req.params.id]);
    }
    if (vehicleId !== undefined) {
      try { await c.query('UPDATE drivers SET vehicle_id=$2 WHERE user_id=$1', [req.params.id, vehicleId]); }
      catch (e) { if (e.code === '23505') throw conflict('vehicle_already_assigned', 'That vehicle is already assigned to another driver'); throw e; }
    }
    await audit(c, req, 'driver.update', req.params.id, { fullName, status, vehicleId });
  });
  res.json(await oneDriver(req.params.id));
});

hr.post('/admin/drivers/:id/documents', ...H, async (req, res) => {
  const { type, uploadId, expiresOn } = req.body;
  await oneDriver(req.params.id);
  const d = await tx(async (c) => {
    const { rows: [u] } = await c.query(`SELECT id, purpose, status, used_at FROM uploads WHERE id=$1 AND owner_id=$2 FOR UPDATE`, [uploadId, req.user.id]);
    if (!u || !['driver_document', 'vehicle_document'].includes(u.purpose)) throw invalid('uploadId', 'must be your own driver_document or vehicle_document upload');
    if (u.status !== 'stored') throw invalid('uploadId', 'the file has not been uploaded yet');
    if (u.used_at) throw invalid('uploadId', 'already attached to a document');
    await c.query('UPDATE uploads SET used_at=now() WHERE id=$1', [uploadId]);
    const { rows: [d] } = await c.query(`INSERT INTO driver_documents (driver_id,type,upload_id,expires_on) VALUES ($1,$2,$3,$4) RETURNING *`, [req.params.id, type, uploadId, expiresOn ?? null]);
    await audit(c, req, 'driver.document_add', req.params.id, { type, expiresOn: expiresOn ?? null });
    return d;
  });
  res.status(201).json(docView(d));
});

hr.get('/admin/driver-documents/expiring', ...H, async (req, res) => {
  const within = qInt(req, 'withinDays', 1, 365, 30);
  const { rows } = await q(`SELECT d.driver_id, COALESCE(u.full_name, u.first_name, 'Driver') AS name, d.type, d.expires_on, (d.expires_on - current_date)::int AS days_left
      FROM driver_documents d JOIN users u ON u.id=d.driver_id WHERE d.deleted_at IS NULL AND d.expires_on IS NOT NULL AND d.expires_on <= current_date + $1::int ORDER BY d.expires_on LIMIT 500`, [within]);
  res.json({ items: rows.map((r) => ({ driverId: r.driver_id, driverName: r.name, documentType: r.type, expiresOn: day(r.expires_on), daysLeft: r.days_left })) });
});

// ================= salary =================
const profileView = (p) => ({ driverId: p.driver_id, monthlySalaryPesewas: Number(p.monthly_salary_pesewas), payPeriod: p.pay_period, updatedAt: iso(p.updated_at) });
hr.get('/admin/drivers/:id/salary-profile', ...H, async (req, res) => {
  await oneDriver(req.params.id);
  const { rows: [p] } = await q('SELECT * FROM salary_profiles WHERE driver_id=$1', [req.params.id]);
  if (!p) throw notFound('Salary profile');
  res.json(profileView(p));
});
hr.put('/admin/drivers/:id/salary-profile', ...H, async (req, res) => {
  const { monthlySalaryPesewas, payPeriod } = req.body;
  await oneDriver(req.params.id);
  const p = await tx(async (c) => {
    const { rows: [p] } = await c.query(`INSERT INTO salary_profiles (driver_id,monthly_salary_pesewas,pay_period,updated_by) VALUES ($1,$2,$3,$4)
       ON CONFLICT (driver_id) DO UPDATE SET monthly_salary_pesewas=$2, pay_period=$3, updated_by=$4, updated_at=now() RETURNING *`, [req.params.id, monthlySalaryPesewas, payPeriod, req.user.id]);
    await audit(c, req, 'salary.profile', req.params.id, { monthlySalaryPesewas, payPeriod });
    return p;
  });
  res.json(profileView(p));
});

const payView = (p) => ({ id: p.id, driverId: p.driver_id, periodStart: day(p.period_start), periodEnd: day(p.period_end), amountPesewas: Number(p.amount_pesewas), method: p.method, ...(p.reference && { reference: p.reference }), paidAt: iso(p.paid_at) });
async function payments(req, res, driverId) {
  const a = pageArgs(req);
  const { rows } = await q(`SELECT * FROM salary_payments WHERE ($1::uuid IS NULL OR driver_id=$1) AND ($2::timestamptz IS NULL OR (paid_at, id) < ($2::timestamptz, $3::uuid)) ORDER BY paid_at DESC, id DESC LIMIT $4`, [driverId, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.paid_at, r.id], payView));
}
hr.get('/admin/salary-payments', ...H, (req, res) => payments(req, res, qUuid(req, 'driverId')));
hr.get('/driver/salary-payments', ...DRIVER, (req, res) => payments(req, res, req.user.id));
// D12: we record salary paid outside the system; nothing here moves money.
hr.post('/admin/salary-payments', ...H, async (req, res) => idempotent(req, res, 'salarypay', async () => {
  const b = req.body;
  await oneDriver(b.driverId);
  if (b.periodEnd < b.periodStart) throw invalid('periodEnd', 'must not be before periodStart');
  if (Date.parse(b.paidAt) > Date.now() + 86400_000) throw invalid('paidAt', 'cannot be in the future');
  return tx(async (c) => {
    const { rows: [p] } = await c.query(`INSERT INTO salary_payments (driver_id,period_start,period_end,amount_pesewas,method,reference,paid_at,created_by) VALUES ($1,$2,$3,$4,$5,$6,$7,$8) RETURNING *`,
      [b.driverId, b.periodStart, b.periodEnd, b.amountPesewas, b.method, b.reference ?? null, b.paidAt, req.user.id]);
    await audit(c, req, 'salary.payment', p.id, { driverId: b.driverId, amountPesewas: b.amountPesewas, period: [b.periodStart, b.periodEnd] });
    return { status: 201, body: payView(p) };
  });
}));

// ================= shifts =================
const shiftView = (s) => ({ id: s.id, driverId: s.driver_id, startsAt: iso(s.starts_at), endsAt: iso(s.ends_at), status: s.status });
async function shifts(req, res, driverId) {
  const a = pageArgs(req), from = qDate(req, 'from'), to = qDate(req, 'to');
  const { rows } = await q(`SELECT * FROM shifts WHERE deleted_at IS NULL AND ($1::uuid IS NULL OR driver_id=$1) AND ($2::date IS NULL OR starts_at >= $2) AND ($3::date IS NULL OR starts_at < $3::date + 1)
      AND ($4::timestamptz IS NULL OR (starts_at, id) < ($4::timestamptz, $5::uuid)) ORDER BY starts_at DESC, id DESC LIMIT $6`, [driverId, from, to, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (r) => [r.starts_at, r.id], shiftView));
}
hr.get('/admin/shifts', ...H, (req, res) => shifts(req, res, qUuid(req, 'driverId')));
hr.get('/driver/shifts', ...DRIVER, (req, res) => shifts(req, res, req.user.id));
hr.post('/admin/shifts', ...H, async (req, res) => {
  const { driverId, startsAt, endsAt } = req.body;
  await oneDriver(driverId);
  if (Date.parse(endsAt) <= Date.parse(startsAt)) throw invalid('endsAt', 'must be after startsAt');
  if (Date.parse(endsAt) - Date.parse(startsAt) > 16 * 3600_000) throw invalid('endsAt', 'a shift is at most 16 hours');
  try {
    const s = await tx(async (c) => {
      const { rows: [s] } = await c.query(`INSERT INTO shifts (driver_id,starts_at,ends_at,created_by) VALUES ($1,$2,$3,$4) RETURNING *`, [driverId, startsAt, endsAt, req.user.id]);
      await audit(c, req, 'shift.create', s.id, { driverId, startsAt, endsAt });
      return s;
    });
    res.status(201).json(shiftView(s));
  } catch (e) { if (e.code === '23P01') throw conflict('shift_overlap', 'That driver already has a shift in this time'); throw e; }
});
hr.delete('/admin/shifts/:id', ...H, async (req, res) => {
  need(req.params.id, 'Shift');
  const { rowCount } = await q(`UPDATE shifts SET deleted_at=now() WHERE id=$1 AND deleted_at IS NULL`, [req.params.id]);
  if (!rowCount) throw notFound('Shift');
  await q(`INSERT INTO audit_log (actor_type,actor_id,action,target) VALUES ('staff',$1,'shift.delete',$2)`, [req.user.id, req.params.id]);
  res.status(204).end();
});

// ================= attendance =================
const attView = (r) => ({ id: r.id, driverId: r.driver_id, shiftId: r.shift_id ?? null, date: day(r.date), clockInAt: iso(r.clock_in_at), clockOutAt: iso(r.clock_out_at),
  minutesWorked: r.minutes_worked, status: r.status, correctionNote: r.correction_note ?? null });
async function attendance(req, res, driverId) {
  const a = pageArgs(req), from = qDate(req, 'from'), to = qDate(req, 'to');
  const { rows } = await q(`SELECT * FROM attendance_records WHERE ($1::uuid IS NULL OR driver_id=$1) AND ($2::date IS NULL OR date >= $2) AND ($3::date IS NULL OR date <= $3)
      AND ($4::date IS NULL OR (date, id) < ($4::date, $5::uuid)) ORDER BY date DESC, id DESC LIMIT $6`, [driverId, from, to, a.ts, a.id, a.fetch]);
  res.json(pageOf(rows, a, (r) => [day(r.date), r.id], attView));
}
hr.get('/admin/attendance', ...H, (req, res) => attendance(req, res, qUuid(req, 'driverId')));
hr.get('/driver/attendance', ...DRIVER, (req, res) => attendance(req, res, req.user.id));
hr.patch('/admin/attendance/:id', ...H, async (req, res) => {
  const { clockInAt, clockOutAt, reasonCode, note } = req.body;
  need(req.params.id, 'Attendance record');
  const r = await tx(async (c) => {
    const { rows: [old] } = await c.query('SELECT * FROM attendance_records WHERE id=$1 FOR UPDATE', [req.params.id]);
    if (!old) throw notFound('Attendance record');
    const inAt = clockInAt ?? old.clock_in_at, outAt = clockOutAt ?? old.clock_out_at;
    if (inAt && outAt && new Date(outAt) <= new Date(inAt)) throw invalid('clockOutAt', 'must be after clockInAt');
    if (inAt && outAt && new Date(outAt) - new Date(inAt) > 24 * 3600_000) throw invalid('clockOutAt', 'more than 24 hours after clock-in');
    const minutes = inAt && outAt ? Math.round((new Date(outAt) - new Date(inAt)) / 60_000) : old.minutes_worked;
    const { rows: [n] } = await c.query(`UPDATE attendance_records SET clock_in_at=$2, clock_out_at=$3, minutes_worked=$4, status='corrected', correction_note=$5, corrected_by=$6 WHERE id=$1 RETURNING *`,
      [old.id, inAt, outAt, minutes, `${reasonCode}: ${note}`, req.user.id]);
    await audit(c, req, 'attendance.correct', old.id, { before: { clockInAt: old.clock_in_at, clockOutAt: old.clock_out_at, minutesWorked: old.minutes_worked, status: old.status }, reasonCode, note });
    return n;
  });
  res.json(attView(r));
});
