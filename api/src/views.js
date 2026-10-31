// Database rows -> the objects the contract describes. Optional-but-not-nullable fields are left undefined (JSON omits them);
// nullable ones are sent as null. The contract engine (lib/contract.js) checks every response against the schemas.

export const fullName = (u) => u.full_name ?? (([u.first_name, u.last_name].filter(Boolean).join(' ')) || null);
export const firstNameOf = (u) => u.first_name ?? (u.full_name ? u.full_name.split(/\s+/)[0] : null);
const iso = (d) => (d ? new Date(d).toISOString() : null);
export const opt = (v) => (v == null ? undefined : v);

export const point = (lat, lng) => ({ lat, lng });
export const location = (lat, lng, label, extra = {}) => ({ point: point(lat, lng), label: opt(label), ...extra });

export const studentView = (r) => ({
  id: r.id, phone: r.phone, fullName: fullName(r), email: r.email ?? null,
  accountStatus: r.status, verificationStatus: r.verification_status, createdAt: iso(r.created_at), termsAcceptedVersion: r.terms_version ?? null,
});
export const studentSummary = (r) => ({
  id: r.id, phone: r.phone, fullName: fullName(r), accountStatus: r.status, verificationStatus: r.verification_status,
  createdAt: iso(r.created_at), noShowCount: r.no_show_count ?? 0,
});

export const walletView = (w) => ({
  balancePesewas: w.balance_pesewas, reservedPesewas: w.reserved_pesewas, availablePesewas: w.balance_pesewas - w.reserved_pesewas, currency: 'GHS',
  owedPesewas: w.owed_pesewas ?? null,
});

const TYPE_TEXT = {
  topup: 'Wallet top-up', ride_hold: 'Fare held for your ride', ride_release: 'Held fare released', ride_charge: 'Ride fare',
  refund: 'Refund', adjustment: 'Adjustment by Turbo support', provider_reversal: 'Payment reversed by provider',
};
export const txView = (e) => ({
  id: String(e.public_id), type: e.type, amountPesewas: e.amount_pesewas, affectsBalance: e.amount_pesewas !== 0,
  balanceAfterPesewas: e.balance_after, rideId: e.ride_id ?? null, description: e.note || TYPE_TEXT[e.type], createdAt: iso(e.created_at),
});

// Joined row shape produced by RIDE_SQL below.
export const RIDE_SQL = `SELECT r.*, h.status AS hold_status, h.amount_pesewas AS hold_amount,
    COALESCE((SELECT sum(l.amount_pesewas) FROM ledger_entries l WHERE l.ride_id=r.id AND l.type='refund'),0)::bigint AS refunded,
    du.id AS d_id, COALESCE(du.first_name, split_part(du.full_name,' ',1)) AS d_first, COALESCE(du.full_name, du.first_name) AS d_full,
    v.make AS v_make, v.model AS v_model, v.colour AS v_colour, v.plate_number AS v_plate,
    p.lat AS p_lat, p.lng AS p_lng, p.seen_at AS p_seen,
    COALESCE(su.full_name, su.first_name) AS s_full, COALESCE(su.first_name, split_part(su.full_name,' ',1)) AS s_first, su.phone AS s_phone
  FROM rides r JOIN users su ON su.id=r.student_id
  LEFT JOIN holds h ON h.ride_id=r.id
  LEFT JOIN users du ON du.id=r.driver_id
  LEFT JOIN drivers d ON d.user_id=r.driver_id LEFT JOIN vehicles v ON v.id=d.vehicle_id
  LEFT JOIN driver_presence p ON p.driver_id=r.driver_id`;

const CANCEL_CODES = ['student_changed_mind', 'driver_unavailable', 'vehicle_issue', 'no_driver_available', 'service_issue', 'admin_decision', 'other', 'rider_no_show'];
export const cancelCode = (c) => (CANCEL_CODES.includes(c) ? c : 'other');

export function paymentView(r) {
  const fare = r.hold_amount ?? r.fare_pesewas, refunded = Number(r.refunded || 0);
  if (r.hold_status === 'open') return { status: 'held', heldPesewas: fare, chargedPesewas: 0, refundedPesewas: 0 };
  if (r.hold_status === 'charged') {
    const status = refunded <= 0 ? 'charged' : refunded >= fare ? 'refunded' : 'partially_refunded';
    return { status, heldPesewas: 0, chargedPesewas: fare, refundedPesewas: refunded };
  }
  return { status: 'released', heldPesewas: 0, chargedPesewas: 0, refundedPesewas: 0 };
}

const etaTo = (r) => {
  if (r.p_lat == null || r.status !== 'assigned') return null;
  const R = 6371000, k = Math.PI / 180;
  const a = Math.sin(((r.pickup_lat - r.p_lat) * k) / 2) ** 2 + Math.cos(r.p_lat * k) * Math.cos(r.pickup_lat * k) * Math.sin(((r.pickup_lng - r.p_lng) * k) / 2) ** 2;
  return Math.round((2 * R * Math.asin(Math.sqrt(a)) * 1.3) / (25000 / 3600));
};

export const rideView = (r, { includePin = false } = {}) => ({
  id: r.id, status: r.status,
  pickup: location(r.pickup_lat, r.pickup_lng, r.pickup_label), dropoff: location(r.drop_lat, r.drop_lng, r.drop_label),
  routeDistanceMeters: r.distance_m, farePesewas: r.fare_pesewas,
  pin: includePin && ['assigned', 'driver_arrived'].includes(r.status) ? r.pin : null,
  pickupEtaSeconds: etaTo(r),
  driver: r.d_id ? { id: r.d_id, firstName: r.d_first ?? 'Driver' } : null,
  vehicle: r.v_plate ? { make: r.v_make, model: r.v_model, colour: r.v_colour, plateNumber: r.v_plate } : null,
  payment: paymentView(r),
  cancellation: r.status === 'cancelled' ? { by: r.cancel_by, reasonCode: cancelCode(r.cancel_reason_code ?? r.cancel_reason), note: r.cancel_note ?? null, cancelledAt: iso(r.cancelled_at) } : null,
  requestedAt: iso(r.requested_at), assignedAt: iso(r.assigned_at), driverArrivedAt: iso(r.arrived_at), startedAt: iso(r.started_at), completedAt: iso(r.completed_at),
});

export const driverLocationView = (p) => (p?.p_lat != null || p?.lat != null ? {
  point: point(p.p_lat ?? p.lat, p.p_lng ?? p.lng), headingDegrees: p.heading ?? null, speedMps: p.speed ?? null, recordedAt: iso(p.p_seen ?? p.seen_at) } : null);

export const topupView = (t, { staff = false } = {}) => {
  const v = (t.validation || '').toUpperCase();
  const validation = !t.amount_received_pesewas ? null : v === 'EXACT' ? 'exact'
    : t.amount_received_pesewas < t.amount_pesewas ? 'underpayment' : 'overpayment';
  return {
    id: t.id, studentId: t.student_id, status: t.status, amountPesewas: t.amount_pesewas, channel: t.channel, reference: t.reference,
    checkout: t.status === 'pending' ? { type: 'prompt', message: 'Approve the payment on your phone' } : null,
    createdAt: iso(t.created_at), completedAt: iso(t.completed_at),
    ...(staff && { amountReceivedPesewas: t.amount_received_pesewas ?? null, validation, flagged: !!t.flagged, flagReason: t.flag_reason ?? (t.flagged ? 'amount_mismatch' : null), resolvedAt: iso(t.resolved_at) }),
  };
};

export const vehicleView = (v) => ({ id: v.id, make: v.make, model: v.model, colour: v.colour, plateNumber: v.plate_number, seats: v.seats, status: v.status });

export const staffView = (s) => ({
  id: s.id, email: s.email, fullName: s.name ?? s.email, staffRole: s.role, isActive: s.is_active !== false, mfaEnrolled: !!s.mfa_secret_enc,
  lastLoginAt: iso(s.last_login_at), lockedUntil: iso(s.locked_until), invitePending: !!s.invite_pending,
});
export { iso };
