import { q } from '../db.js';
import { ACTIVE } from './rides.js';
import { fullName, iso, driverLocationView } from '../views.js';

export const docView = (d) => ({ id: d.id, type: d.type, expiresOn: d.expires_on ? new Date(d.expires_on).toISOString().slice(0, 10) : null, uploadId: d.upload_id });

const DRIVER_SQL = `SELECT u.id, u.full_name, u.first_name, u.last_name, u.phone, u.status, u.created_at, d.on_duty, d.email,
    v.id AS vid, v.make, v.model, v.colour, v.plate_number, v.seats, v.status AS vstatus,
    p.lat, p.lng, p.heading, p.speed, p.seen_at,
    (SELECT id FROM rides WHERE driver_id=u.id AND status = ANY($1) LIMIT 1) AS current_ride
  FROM users u JOIN drivers d ON d.user_id=u.id LEFT JOIN vehicles v ON v.id=d.vehicle_id LEFT JOIN driver_presence p ON p.driver_id=u.id`;

export async function driverDetails(extraSql = '', params = [], { documents = true } = {}) {
  const { rows } = await q(`${DRIVER_SQL} ${extraSql}`, [ACTIVE, ...params]);
  const docs = documents && rows.length ? (await q('SELECT * FROM driver_documents WHERE driver_id = ANY($1) AND deleted_at IS NULL ORDER BY created_at', [rows.map((r) => r.id)])).rows : [];
  return rows.map((r) => ({
    id: r.id, fullName: fullName(r) ?? 'Driver', phone: r.phone, ...(r.email && { email: r.email }), status: r.status,
    dutyStatus: r.on_duty ? 'on_duty' : 'off_duty',
    vehicle: r.vid ? { id: r.vid, make: r.make, model: r.model, colour: r.colour, plateNumber: r.plate_number, seats: r.seats, status: r.vstatus } : null,
    currentRideId: r.current_ride ?? null, lastLocation: r.lat != null ? driverLocationView(r) : null,
    ...(documents && { documents: docs.filter((d) => d.driver_id === r.id).map(docView) }), createdAt: iso(r.created_at),
    _seen: r.seen_at,
  }));
}
export const stripPrivate = ({ _seen, ...rest }) => rest;
