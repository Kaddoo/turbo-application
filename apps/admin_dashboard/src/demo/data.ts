/**
 * Sample data for presentations (VITE_APP_ENV=demo only). Every object is typed
 * against the generated contract types, so the compiler rejects any shape the
 * API would not return. Names and places are illustrative, not real people.
 */
import type { Schemas } from '../api/client';

type S = Schemas;
const NOW = Date.now();
export const ago = (min: number) => new Date(NOW - min * 60_000).toISOString();
const ahead = (min: number) => new Date(NOW + min * 60_000).toISOString();
const day = (offset: number) => new Date(NOW + offset * 86_400_000).toISOString().slice(0, 10);
let seq = 0;
export const uid = () => {
  seq += 1;
  const hex = seq.toString(16).padStart(12, '0');
  return `0193a7c2-5e4b-7d10-8a3f-${hex}`;
};

// Campus area (illustrative coordinates; the real boundary awaits Turbo, D1).
const CAMPUS = { lat: 5.7425, lng: 0.0675 };
const jitter = (n: number, spread = 0.012) => ({ lat: CAMPUS.lat + Math.sin(n * 1.7) * spread, lng: CAMPUS.lng + Math.cos(n * 2.3) * spread });
const place = (label: string, n: number, landmark?: string): S['Location'] => ({ point: jitter(n), label, pickupPointId: null, ...(landmark ? { landmark } : {}) });
const MALL: S['Location'] = { point: { lat: 5.6957, lng: -0.0331 }, label: 'Ashaiman China Mall', pickupPointId: null };

export const staff: S['StaffUser'][] = [
  ['Abena Mensah', 'abena.mensah', 'super_admin'], ['Kwame Boateng', 'kwame.boateng', 'verifier'], ['Efua Owusu', 'efua.owusu', 'dispatcher'],
  ['Yaw Asante', 'yaw.asante', 'finance'], ['Esi Quaye', 'esi.quaye', 'finance'], ['Akosua Darko', 'akosua.darko', 'support'], ['Kojo Appiah', 'kojo.appiah', 'hr'],
].map(([fullName, handle, staffRole], i) => ({
  id: uid(), email: `${handle}@turbo.example`, fullName: fullName!, staffRole: staffRole as S['StaffRole'], isActive: true,
  mfaEnrolled: true, lastLoginAt: ago(30 + i * 95), lockedUntil: null, invitePending: false,
}));
staff.push({ id: uid(), email: 'nana.ofori@turbo.example', fullName: 'Nana Ofori', staffRole: 'support', isActive: true, mfaEnrolled: false, lastLoginAt: null, lockedUntil: null, invitePending: true });

const studentNames = ['Ama Serwaa', 'Kofi Mensah', 'Akua Boatemaa', 'Yaw Darko', 'Adwoa Pokuaa', 'Kwabena Osei', 'Abena Kyei', 'Kwesi Arthur',
  'Afia Amponsah', 'Kojo Antwi', 'Efua Badu', 'Nii Armah', 'Naa Adjeley', 'Selorm Agbeko', 'Delali Kpodo', 'Esinam Dogbe'];
const vStatus: S['VerificationStatus'][] = ['approved', 'approved', 'approved', 'pending', 'approved', 'pending', 'approved', 'needs_attention',
  'approved', 'pending', 'approved', 'pending', 'approved', 'pending', 'rejected', 'pending'];

export const wallets = new Map<string, S['Wallet']>();
export const students: S['StudentDetail'][] = studentNames.map((fullName, i) => {
  const balance = [6000, 2350, 12000, 0, 4500, 0, 800, 0, 15500, 0, 3100, 0, 9900, 0, 0, 0][i]!;
  const reserved = i === 0 ? 3500 : i === 2 ? 2500 : 0;
  const wallet: S['Wallet'] = { balancePesewas: balance, reservedPesewas: reserved, availablePesewas: balance - reserved, currency: 'GHS', owedPesewas: null };
  const id = uid();
  wallets.set(id, wallet);
  return {
    id, phone: `+23324${String(1234567 + i * 7919).slice(0, 7)}`, fullName, email: `${fullName.split(' ')[0]!.toLowerCase()}@cu.edu.gh`,
    studentIdNumber: `CU/${String(22 + (i % 3))}/${String(4100 + i * 37)}`, accountStatus: i === 11 ? 'suspended' : 'active',
    verificationStatus: vStatus[i]!, wallet, completedRides: (i * 7) % 23, createdAt: ago(60 * 24 * (40 - i * 2)),
  };
});
export const noShows = new Map(students.map((s, i) => [s.id, i === 6 ? 3 : i === 1 ? 1 : 0]));
export const summaryOf = (s: S['StudentDetail']): S['StudentSummary'] => ({
  id: s.id, phone: s.phone, fullName: s.fullName, accountStatus: s.accountStatus, verificationStatus: s.verificationStatus, createdAt: s.createdAt, noShowCount: noShows.get(s.id) ?? 0,
});

const docSvg = (title: string, line: string) => `data:image/svg+xml;utf8,${encodeURIComponent(
  `<svg xmlns="http://www.w3.org/2000/svg" width="600" height="400"><rect width="600" height="400" rx="24" fill="#E8E5DB"/><rect x="24" y="24" width="552" height="352" rx="16" fill="#F3F1EA" stroke="#0B0C0A" stroke-width="2"/><circle cx="140" cy="190" r="70" fill="#D7D6CF"/><text x="250" y="150" font-family="sans-serif" font-size="28" font-weight="600" fill="#0B0C0A">${title}</text><text x="250" y="200" font-family="sans-serif" font-size="22" fill="#5C5C58">${line}</text><text x="250" y="320" font-family="sans-serif" font-size="16" fill="#5C5C58">SAMPLE · DEMO DATA</text></svg>`)}`;

export const verifications: S['VerificationDetail'][] = students
  .map((s, i) => ({ s, i }))
  .filter(({ s }) => s.verificationStatus !== 'not_submitted')
  .map(({ s, i }) => ({
    id: uid(),
    student: summaryOf(s),
    status: s.verificationStatus,
    submittedFullName: s.fullName!,
    studentIdNumber: s.studentIdNumber!,
    submittedAt: ago(s.verificationStatus === 'pending' ? [26 * 60, 5 * 60, 95, 40, 12, 3][i % 6]! : 60 * 24 * 20),
    ghanaCardNumber: `GHA-${String(712345678 + i * 1301).slice(0, 9)}-${i % 10}`,
    documents: (['ghana_card_front', 'ghana_card_back', 'student_id', 'selfie_with_card'] as const).map((purpose) => ({
      purpose,
      url: docSvg({ ghana_card_front: 'Ghana Card', ghana_card_back: 'Ghana Card (back)', student_id: 'Central University', selfie_with_card: 'Selfie with card' }[purpose], s.fullName!),
      expiresAt: ahead(5),
    })),
    history: s.verificationStatus === 'needs_attention' || s.verificationStatus === 'rejected'
      ? [{ decision: s.verificationStatus, reasonCode: s.verificationStatus === 'rejected' ? 'name_mismatch' : 'document_unclear', decidedByStaffId: staff[1]!.id, decidedAt: ago(60 * 26) }]
      : [],
  }));
export const claims = new Map<string, { by: string; until: string }>();
claims.set(verifications.find((v) => v.status === 'pending')!.id, { by: staff[1]!.id, until: ahead(9) });

export const vehicles: S['Vehicle'][] = [
  ['Toyota', 'Corolla', 'Silver', 'GT 4521-23'], ['Hyundai', 'Elantra', 'White', 'GR 1187-24'], ['Kia', 'Rio', 'Blue', 'GE 3390-22'],
  ['Toyota', 'Vitz', 'Red', 'GT 7764-23'], ['Hyundai', 'Accent', 'Black', 'GN 2201-24'], ['Toyota', 'Corolla', 'Grey', 'GR 9045-21'],
].map(([make, model, colour, plateNumber], i) => ({ id: uid(), make: make!, model: model!, colour: colour!, plateNumber: plateNumber!, seats: 4, status: i === 5 ? 'maintenance' : 'active' }));

const driverNames = ['Emmanuel Tetteh', 'Samuel Addo', 'Isaac Nkansah', 'Daniel Ocran', 'Prince Agyei', 'Richard Lartey'];
export const drivers: S['DriverDetail'][] = driverNames.map((fullName, i) => ({
  id: uid(), fullName, phone: `+23320${String(5550101 + i * 4111).slice(0, 7)}`, email: null, status: 'active',
  dutyStatus: i < 4 ? 'on_duty' : 'off_duty', vehicle: vehicles[i] ?? null, currentRideId: null,
  lastLocation: i < 4 ? { point: jitter(i + 10, 0.02), headingDegrees: (i * 80) % 360, speedMps: i % 2 ? 8 : 0, recordedAt: ago(i === 2 ? 6 : 0.1) } : null,
  documents: [
    { id: uid(), type: 'drivers_licence', expiresOn: day(i === 3 ? -4 : i === 1 ? 12 : 300), uploadId: uid() },
    { id: uid(), type: 'insurance', expiresOn: day(i === 4 ? 21 : 180), uploadId: uid() },
    { id: uid(), type: 'roadworthy', expiresOn: day(200 - i * 10), uploadId: uid() },
  ],
  createdAt: ago(60 * 24 * (90 - i * 5)),
}));
export const salaryProfiles = new Map<string, S['SalaryProfile']>(drivers.map((d, i) => [d.id, { driverId: d.id, monthlySalaryPesewas: 250000 + (i % 3) * 20000, payPeriod: 'monthly', updatedAt: ago(60 * 24 * 30) }]));

const pickupNames: [string, string][] = [['Main gate', 'By the security post'], ['Hall A car park', 'Under the big neem tree'], ['Library', 'Front steps'], ['Chapel junction', 'Bus stop shelter']];
export const serviceArea: S['ServiceArea'] = {
  version: 3,
  boundary: null,
  pickupPoints: pickupNames.map(([name], i) => ({ id: uid(), name, point: jitter(i + 30, 0.004), isActive: i !== 3 })),
  maxTripDistanceMeters: 18000,
  fareBands: [{ upToMeters: 3000, farePesewas: 1800 }, { upToMeters: 6000, farePesewas: 2500 }, { upToMeters: 12000, farePesewas: 3500 }, { upToMeters: 18000, farePesewas: 5000 }],
  operatingHours: null,
};

export const settings: S['Settings'] = {
  maxTripDistanceMeters: 18000, quoteTtlSeconds: 300, driverAckTimeoutSeconds: 45, noDriverTimeoutSeconds: 300, minTopupPesewas: 500,
  maxTopupPesewas: 50000, operatingHours: null, driverSilenceSeconds: 180, noShowWaitSeconds: 300, quoteLimitPerMinute: 10,
  smsDailyLimit: 500, adjustmentApprovalThresholdPesewas: 5000, locationRetentionDays: 90, bookingsPaused: false, pauseMessage: null,
};

const destinations: [string, number, number][] = [['Ashaiman China Mall', 17400, 5000], ['Prampram Junction', 5200, 2500], ['Dawhenya market', 9100, 3500], ['Miotso township', 2400, 1800], ['Tema Community 25', 14800, 5000]];
const fare = (m: number) => serviceArea.fareBands.find((b) => m <= b.upToMeters)!.farePesewas;

export interface DemoRide { ride: S['Ride']; studentId: string; driverId: string | null; flags: S['RideFlag'][]; events: S['RideEvent'][] }
export const rides: DemoRide[] = [];
function addRide(i: number, status: S['RideStatus'], minutesAgo: number, driverIdx: number | null, flags: S['RideFlag'][] = []) {
  const [label, meters] = destinations[i % destinations.length]!;
  const student = students[[0, 2, 4, 6, 8, 10, 12, 1][i % 8]!]!;
  const driver = driverIdx === null ? null : drivers[driverIdx]!;
  const f = fare(meters);
  const charged = status === 'completed' ? f : 0;
  const refunded = i === 9 ? 1000 : 0;
  const pickupName = pickupNames[i % 3]!;
  const ride: S['Ride'] = {
    id: uid(), status, pickup: place(`${pickupName[0]}, Central University`, i % 3 + 30, pickupName[1]),
    dropoff: label === 'Ashaiman China Mall' ? MALL : place(label, i + 50, undefined), routeDistanceMeters: meters, farePesewas: f, pin: null,
    pickupEtaSeconds: status === 'assigned' ? 240 : null,
    driver: driver ? { id: driver.id, firstName: driver.fullName.split(' ')[0]!, averageRating: 4.8 } : null,
    vehicle: driver?.vehicle ? { make: driver.vehicle.make, model: driver.vehicle.model, colour: driver.vehicle.colour, plateNumber: driver.vehicle.plateNumber } : null,
    payment: { status: status === 'completed' ? (refunded ? 'partially_refunded' : 'charged') : status === 'cancelled' ? 'released' : 'held', heldPesewas: f, chargedPesewas: charged, refundedPesewas: refunded },
    cancellation: status === 'cancelled' ? { by: i % 2 ? 'student' : 'system', reasonCode: i % 2 ? 'student_changed_mind' : 'no_driver_available', note: null, cancelledAt: ago(minutesAgo - 4) } : null,
    requestedAt: ago(minutesAgo), assignedAt: driver ? ago(minutesAgo - 1) : null, driverArrivedAt: ['driver_arrived', 'in_progress', 'completed'].includes(status) ? ago(minutesAgo - 6) : null,
    startedAt: ['in_progress', 'completed'].includes(status) ? ago(minutesAgo - 8) : null, completedAt: status === 'completed' ? ago(minutesAgo - 30) : null,
  };
  const ev = (m: number, type: string, actor: string, detail: string | null = null): S['RideEvent'] => ({ at: ago(minutesAgo - m), type, actor, detail });
  const events = [ev(0, 'requested', 'student', `Fare ${f / 100} cedis held`)];
  if (driver) events.push(ev(1, 'assigned', 'system', `${driver.fullName}, nearest idle driver`));
  if (i === 2 && driver) events.push(ev(1.5, 'driver_declined', 'driver', 'Vehicle issue'), ev(2, 'reassigned', 'system', driver.fullName));
  if (ride.driverArrivedAt) events.push(ev(6, 'arrived', 'driver'));
  if (ride.startedAt) events.push(ev(8, 'started', 'driver', 'PIN correct'));
  if (status === 'completed') events.push(ev(30, 'completed', 'driver', `Charged ${f / 100} cedis`));
  if (status === 'cancelled') events.push(ev(4, 'cancelled', ride.cancellation!.by, humanizeCode(ride.cancellation!.reasonCode)));
  if (refunded) events.push(ev(-60, 'refunded', `staff:${staff[3]!.id}`, 'Partial refund, 10 cedis: detour'));
  if (driver && ['assigned', 'driver_arrived', 'in_progress'].includes(status)) driver.currentRideId = ride.id;
  rides.push({ ride, studentId: student.id, driverId: driver?.id ?? null, flags, events });
}
function humanizeCode(c: string) { return c.replace(/_/g, ' '); }

addRide(0, 'in_progress', 14, 0);
addRide(1, 'assigned', 3, 1);
addRide(2, 'in_progress', 48, 2, ['driver_unreachable']);
addRide(3, 'searching', 1, null);
for (let i = 4; i < 26; i++) addRide(i, i % 6 === 5 ? 'cancelled' : 'completed', 60 * (i * 3 + 2), i % 4, i === 7 ? ['completed_too_fast'] : []);

export const adminRideSummary = (r: DemoRide): S['AdminRideSummary'] => ({
  id: r.ride.id, status: r.ride.status, studentId: r.studentId, studentName: students.find((s) => s.id === r.studentId)?.fullName ?? null,
  driverId: r.driverId, driverName: drivers.find((d) => d.id === r.driverId)?.fullName ?? null, routeDistanceMeters: r.ride.routeDistanceMeters,
  farePesewas: r.ride.farePesewas, requestedAt: r.ride.requestedAt, flags: r.flags,
});

export const incidents: S['Incident'][] = [
  { id: uid(), type: 'sos', status: 'open', rideId: rides[0]!.ride.id, location: jitter(70, 0.01), note: 'SOS pressed in the student app', createdAt: ago(1.2) },
  { id: uid(), type: 'safety_report', status: 'acknowledged', rideId: rides[6]!.ride.id, location: null, note: 'Driver was speeding on the Tema road', createdAt: ago(180) },
  { id: uid(), type: 'sos', status: 'resolved', rideId: rides[9]!.ride.id, location: jitter(71), note: 'Pressed by mistake; called back, all fine', createdAt: ago(60 * 26) },
];

export const topups: S['Topup'][] = students.slice(0, 12).map((s, i) => {
  const amount = [5000, 2000, 10000, 3000, 5000, 1500, 20000, 5000, 2500, 10000, 4000, 6000][i]!;
  const flagged = i === 2 || i === 6 || i === 9;
  const received = i === 2 ? 9500 : i === 6 ? 20000 : amount;
  return {
    id: uid(), studentId: s.id, status: i === 4 ? 'pending' : i === 8 ? 'failed' : 'succeeded', amountPesewas: amount, channel: 'mobile_money',
    reference: `TRB-${(240000 + i * 377).toString(36).toUpperCase()}`, checkout: null, createdAt: ago(40 + i * 170), completedAt: i === 4 ? null : ago(38 + i * 170),
    amountReceivedPesewas: i === 4 || i === 8 ? null : received, validation: i === 2 ? 'underpayment' : i === 4 || i === 8 ? null : 'exact', flagged,
    flagReason: i === 2 ? 'Payaza reported an underpayment' : i === 6 ? 'Reversed by the network after it was credited' : i === 9 ? 'Reconciliation: missing at provider' : null,
    resolvedAt: null,
  };
});

export const adjustmentRequests: S['AdjustmentRequest'][] = [
  { id: uid(), studentId: students[4]!.id, amountPesewas: 7500, reasonCode: 'duplicate_charge', note: 'Charged twice for the same mall trip on Friday', status: 'pending', requestedBy: staff[4]!.id, decidedBy: null, createdAt: ago(55), decidedAt: null },
  { id: uid(), studentId: students[8]!.id, amountPesewas: -12000, reasonCode: 'provider_reconciliation', note: 'MoMo reversal on TRB-… recovered from balance', status: 'pending', requestedBy: staff[3]!.id, decidedBy: null, createdAt: ago(130), decidedAt: null },
  { id: uid(), studentId: students[0]!.id, amountPesewas: 6000, reasonCode: 'goodwill', note: 'Driver no-show during the storm', status: 'approved', requestedBy: staff[3]!.id, decidedBy: staff[4]!.id, createdAt: ago(60 * 30), decidedAt: ago(60 * 29) },
];

export const txByStudent = new Map<string, S['WalletTransaction'][]>(students.map((s, i) => {
  const list: S['WalletTransaction'][] = [];
  let bal = 0;
  const push = (type: S['TransactionType'], amount: number, desc: string, min: number, affects = true, rideId: string | null = null) => {
    if (affects) bal += amount;
    list.unshift({ id: uid(), type, amountPesewas: amount, affectsBalance: affects, balanceAfterPesewas: Math.max(bal, 0), rideId, description: desc, createdAt: ago(min) });
  };
  push('topup', 10000, 'Top-up by MTN Mobile Money', 60 * 24 * 6 + i);
  push('ride_hold', -2500, 'Held for your ride to Prampram Junction', 60 * 24 * 5, false);
  push('ride_charge', -2500, 'Ride to Prampram Junction', 60 * 24 * 5 - 30);
  push('topup', 2000, 'Top-up by Telecel Cash', 60 * 24 * 2);
  return [s.id, list];
}));

export const reconReports: S['ReconciliationReport'][] = [{
  id: uid(), periodFrom: day(-8), periodTo: day(-1), matchedCount: 142, providerTotalPesewas: 1_284_500, ourTotalPesewas: 1_289_000,
  exceptions: [
    { providerReference: topups[9]!.reference, topupId: topups[9]!.id, providerAmountPesewas: null, ourAmountPesewas: 10000, issue: 'missing_at_provider' },
    { providerReference: topups[2]!.reference, topupId: topups[2]!.id, providerAmountPesewas: 9500, ourAmountPesewas: 10000, issue: 'amount_mismatch' },
    { providerReference: 'PZA-77Q1K2', topupId: null, providerAmountPesewas: 5500, ourAmountPesewas: null, issue: 'missing_here' },
  ],
  createdAt: ago(60 * 20),
}];

const msg = (author: 'user' | 'staff', body: string, min: number, internal = false): S['SupportMessage'] => ({ id: uid(), author, body, internal, createdAt: ago(min) });
export const tickets: S['SupportTicket'][] = [
  { id: uid(), category: 'wrong_charge', status: 'open', subject: 'Charged twice for one trip', rideId: rides[9]!.ride.id, assignedToStaffId: null, createdAt: ago(42), updatedAt: ago(42),
    messages: [msg('user', 'I was charged two times for my trip to the mall on Friday. Please help.', 42)] },
  { id: uid(), category: 'lost_item', status: 'in_progress', subject: 'Left my calculator in the car', rideId: rides[5]!.ride.id, assignedToStaffId: staff[5]!.id, createdAt: ago(60 * 5), updatedAt: ago(60 * 2),
    messages: [msg('user', 'Black Casio fx-991 on the back seat.', 300), msg('staff', 'Thank you. We have asked the driver to check the car and will update you today.', 180), msg('staff', 'Driver Samuel confirms he has it. Arrange handover at the main gate.', 120, true)] },
  { id: uid(), category: 'phone_change', status: 'waiting_on_user', subject: 'New SIM after my phone was stolen', rideId: null, assignedToStaffId: staff[5]!.id, createdAt: ago(60 * 26), updatedAt: ago(60 * 20),
    messages: [msg('user', 'My phone was stolen. I have a new number. My wallet has money on it.', 60 * 26), msg('staff', 'Sorry to hear that. Please bring your Ghana Card to the transport office so we can confirm it is you.', 60 * 20)] },
  { id: uid(), category: 'driver_conduct', status: 'open', subject: 'Driver was on the phone while driving', rideId: rides[6]!.ride.id, assignedToStaffId: null, createdAt: ago(200), updatedAt: ago(200),
    messages: [msg('user', 'The driver talked on his phone for most of the trip.', 200)] },
  { id: uid(), category: 'account', status: 'resolved', subject: 'Cannot see my verification result', rideId: null, assignedToStaffId: staff[5]!.id, createdAt: ago(60 * 50), updatedAt: ago(60 * 47),
    messages: [msg('user', 'It still says pending.', 60 * 50), msg('staff', 'You were approved this morning. Close and reopen the app to refresh.', 60 * 47)] },
];

export const shifts: S['Shift'][] = [];
for (let d = -1; d < 6; d++) {
  drivers.slice(0, 5).forEach((drv, i) => {
    const start = new Date(`${day(d)}T${i % 2 ? '14' : '06'}:00:00Z`);
    const end = new Date(start.getTime() + 8 * 3_600_000);
    shifts.push({ id: uid(), driverId: drv.id, startsAt: start.toISOString(), endsAt: end.toISOString(),
      status: d < 0 ? (i === 3 ? 'missed' : 'completed') : d === 0 && i < 4 ? 'in_progress' : 'scheduled' });
  });
}

export const attendance: S['AttendanceRecord'][] = [];
for (let d = -6; d <= 0; d++) {
  drivers.slice(0, 5).forEach((drv, i) => {
    const absent = d === -1 && i === 3;
    const late = (d + i) % 5 === 0;
    const startH = i % 2 ? 14 : 6;
    const inAt = absent ? null : new Date(`${day(d)}T${String(startH).padStart(2, '0')}:${late ? '22' : '02'}:00Z`).toISOString();
    const outAt = absent || d === 0 ? null : new Date(`${day(d)}T${String(startH + 8).padStart(2, '0')}:00:00Z`).toISOString();
    attendance.push({ id: uid(), driverId: drv.id, shiftId: null, date: day(d), clockInAt: inAt, clockOutAt: outAt,
      minutesWorked: absent ? 0 : d === 0 ? 0 : late ? 458 : 478, status: absent ? 'absent' : late ? 'late' : 'present', correctionNote: null });
  });
}

export const salaryPayments: S['SalaryPayment'][] = drivers.slice(0, 5).map((d, i) => ({
  id: uid(), driverId: d.id, periodStart: day(-61), periodEnd: day(-31), amountPesewas: salaryProfiles.get(d.id)!.monthlySalaryPesewas,
  method: i % 2 ? 'bank_transfer' : 'mobile_money', reference: `SAL-${(i + 1) * 1043}`, paidAt: ago(60 * 24 * 29),
}));

export const audit: S['AuditEntry'][] = [
  ['verification.approved', 'verification', staff[1]!, { student: 'Abena Kyei' }, 25],
  ['ride.reassigned', 'ride', staff[2]!, { from: 'Isaac Nkansah', to: 'Daniel Ocran' }, 70],
  ['wallet.adjusted', 'wallet', staff[3]!, { amount: '60.00', reason: 'goodwill' }, 60 * 29],
  ['verification.document_viewed', 'verification', staff[1]!, { document: 'ghana_card_front' }, 26],
  ['settings.updated', 'settings', staff[0]!, { field: 'noShowWaitSeconds', from: 240, to: 300 }, 60 * 50],
  ['staff.invited', 'staff', staff[0]!, { email: 'nana.ofori@turbo.example', role: 'support' }, 60 * 52],
  ['attendance.corrected', 'attendance', staff[6]!, { reason: 'app_issue' }, 60 * 70],
  ['incident.acknowledged', 'incident', staff[5]!, { minutes_to_ack: 1 }, 178],
  ['ride.refunded', 'ride', staff[3]!, { amount: '10.00' }, 60 * 30],
  ['driver.created', 'driver', staff[6]!, { name: 'Richard Lartey' }, 60 * 24 * 60],
].map(([action, entityType, who, detail, min]) => ({
  id: uid(), at: ago(min as number), actorStaffId: (who as S['StaffUser']).id, action: action as string, entityType: entityType as string, entityId: uid(), detail: detail as Record<string, unknown>,
}));
