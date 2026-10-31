// Duty on/off feeds attendance (contract: "Duty events also feed attendance"). One record per driver per day (UTC; Ghana has no DST,
// so UTC and Accra are the same). Minutes accumulate across several on/off periods.
const LATE_AFTER_MIN = 15;

export async function clockIn(c, driverId) {
  const { rows: [shift] } = await c.query(
    `SELECT id, starts_at FROM shifts WHERE driver_id=$1 AND deleted_at IS NULL AND ends_at > now() AND starts_at < now() + interval '2 hours' ORDER BY starts_at LIMIT 1`, [driverId]);
  const late = shift && Date.now() - new Date(shift.starts_at).getTime() > LATE_AFTER_MIN * 60_000;
  await c.query(
    `INSERT INTO attendance_records (driver_id, shift_id, date, clock_in_at, status) VALUES ($1,$2,current_date,now(),$3)
     ON CONFLICT (driver_id, date) DO UPDATE SET clock_out_at=NULL, shift_id=COALESCE(attendance_records.shift_id, EXCLUDED.shift_id)`,
    [driverId, shift?.id ?? null, late ? 'late' : 'present']);
  if (shift) await c.query(`UPDATE shifts SET status='in_progress' WHERE id=$1 AND status='scheduled'`, [shift.id]);
}

export async function clockOut(c, driverId, since) {
  const minutes = since ? Math.max(0, Math.round((Date.now() - new Date(since).getTime()) / 60_000)) : 0;
  await c.query(`UPDATE attendance_records SET clock_out_at=now(), minutes_worked = minutes_worked + $2 WHERE driver_id=$1 AND date=current_date`, [driverId, minutes]);
}
