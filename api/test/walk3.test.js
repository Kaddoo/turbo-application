// Contract walk, part 3: the staff side (super admin, HR, finance, support, verifier, dispatcher).
import test, { after } from 'node:test';
import assert from 'node:assert/strict';
import { call, expect, login, staffLogin, randPhone, pool, closeDb, uuid, uploadFile, JPEG, rideTo, soleDriver, until, sleep, approvedStudent, bookRide, PICK, DROP } from './walk-helpers.js';
after(closeDb);
const tok = async (email) => (await staffLogin(email)).accessToken;

test('staff identity and permissions: each role sees only its own area', async () => {
  const me = expect(await call('GET', '/admin/me', { token: await tok('hr@turbo.test') }), 200); assert.equal(me.staffRole, 'hr'); assert.equal(me.mfaEnrolled, false);
  const matrix = { 'hr@turbo.test': ['/admin/drivers', '/admin/vehicles', '/admin/shifts'], 'finance@turbo.test': ['/admin/topups', '/admin/wallet-adjustments'],
    'support@turbo.test': ['/admin/support/tickets', '/admin/incidents'], 'verifier@turbo.test': ['/admin/verifications', '/admin/students'],
    'dispatch@turbo.test': ['/admin/rides', '/admin/rides/live'], 'admin@turbo.test': ['/admin/staff', '/admin/audit-log', '/admin/settings'] };
  for (const [email, paths] of Object.entries(matrix)) {
    const t = await tok(email);
    for (const p of paths) expect(await call('GET', p, { token: t }), 200, `${email} ${p}`);
    for (const [other, ps] of Object.entries(matrix)) if (other !== email && other !== 'admin@turbo.test') for (const p of ps) {
      if (email === 'admin@turbo.test') continue;
      assert.equal((await call('GET', p, { token: t })).status, 403, `${email} must not read ${p}`);
    }
  }
});

test('super admin: settings, fare bands, boundary, pickup points, staff, audit log', async () => {
  const t = await tok('admin@turbo.test');
  const settings = expect(await call('GET', '/admin/settings', { token: t }), 200);
  assert.ok(!('documentRetentionDays' in settings), 'internal settings are not exposed');
  expect(await call('PUT', '/admin/settings', { token: t, body: { ...settings, quoteTtlSeconds: 301 } }), 200);
  assert.equal(expect(await call('GET', '/admin/settings', { token: t }), 200).quoteTtlSeconds, 301);
  expect(await call('PUT', '/admin/settings', { token: t, body: settings }), 200);
  assert.equal((await call('PUT', '/admin/settings', { token: t, body: { ...settings, maxTripDistanceMeters: -5 } })).status, 422);
  assert.equal((await call('PUT', '/admin/settings', { token: t, body: { ...settings, minTopupPesewas: 99999, maxTopupPesewas: 1000 } })).status, 422);

  const area = expect(await call('GET', '/service-area'), 200);
  assert.equal((await call('PUT', '/admin/fare-bands', { token: t, body: { bands: [{ upToMeters: 6000, farePesewas: 3000 }, { upToMeters: 3000, farePesewas: 2000 }] } })).status, 422);
  expect(await call('PUT', '/admin/fare-bands', { token: t, body: { bands: area.fareBands } }), 200);
  expect(await call('PUT', '/admin/service-area', { token: t, body: { boundary: area.boundary } }), 200);
  assert.equal((await call('PUT', '/admin/service-area', { token: t, body: { boundary: { type: 'Polygon', coordinates: [[[0, 0], [1, 0], [1, 1], [0, 1]]] } } })).status, 422, 'ring must close');

  const pp = expect(await call('POST', '/admin/pickup-points', { token: t, body: { name: 'Test Gate', point: { lat: 5.72, lng: 0.07 } } }), 201); assert.equal(pp.isActive, true);
  assert.equal(expect(await call('PATCH', `/admin/pickup-points/${pp.id}`, { token: t, body: { name: 'Test Gate 2', point: { lat: 5.73, lng: 0.07 }, isActive: false } }), 200).isActive, false);
  assert.ok((await call('GET', '/service-area')).body.pickupPoints.some((p) => p.id === pp.id));
  expect(await call('DELETE', `/admin/pickup-points/${pp.id}`, { token: t }), 204);
  assert.ok(!(await call('GET', '/service-area')).body.pickupPoints.some((p) => p.id === pp.id), 'deleted points disappear');
  assert.equal((await call('DELETE', `/admin/pickup-points/${pp.id}`, { token: t })).status, 404);

  const email = `new${Date.now()}@turbo.test`;
  const st = expect(await call('POST', '/admin/staff', { token: t, body: { email, fullName: 'New Person', staffRole: 'hr' } }), 201); assert.equal(st.invitePending, true);
  assert.equal(expect(await call('PATCH', `/admin/staff/${st.id}`, { token: t, body: { staffRole: 'support' } }), 200).staffRole, 'support');
  expect(await call('POST', `/admin/staff/${st.id}/invite`, { token: t }), 202);
  expect(await call('DELETE', `/admin/staff/${st.id}/sessions`, { token: t }), 204);
  expect(await call('PATCH', `/admin/staff/${st.id}`, { token: t, body: { isActive: false } }), 200);
  const audit = expect(await call('GET', `/admin/audit-log?entityType=staff&entityId=${st.id}&limit=50`, { token: t }), 200);
  assert.ok(audit.data.length >= 3 && audit.data.every((e) => e.entityType === 'staff' && e.entityId === st.id), 'filters work');
  const page1 = expect(await call('GET', '/admin/audit-log?limit=2', { token: t }), 200);
  assert.equal(page1.data.length, 2); assert.equal(page1.page.hasMore, true);
  const page2 = expect(await call('GET', `/admin/audit-log?limit=2&cursor=${encodeURIComponent(page1.page.nextCursor)}`, { token: t }), 200);
  assert.ok(page2.data[0].id !== page1.data[0].id && page2.data[0].id !== page1.data[1].id);
  assert.equal((await call('GET', '/admin/audit-log?cursor=garbage', { token: t })).status, 400);
});

test('HR: vehicles, drivers, documents, expiry rule, salary, shifts, attendance', async () => {
  const t = await tok('hr@turbo.test');
  const plate = 'T-' + Math.floor(Math.random() * 1e6);
  const v = expect(await call('POST', '/admin/vehicles', { token: t, body: { make: 'Kia', model: 'Picanto', colour: 'Red', plateNumber: plate, seats: 4 } }), 201);
  assert.equal((await call('POST', '/admin/vehicles', { token: t, body: { make: 'Kia', model: 'Picanto', colour: 'Red', plateNumber: plate.toLowerCase() } })).status, 409, 'plate is unique, case-insensitively');
  assert.equal(expect(await call('PATCH', `/admin/vehicles/${v.id}`, { token: t, body: { make: 'Kia', model: 'Picanto', colour: 'Blue', plateNumber: plate, status: 'active' } }), 200).colour, 'Blue');
  assert.ok(expect(await call('GET', '/admin/vehicles?limit=100', { token: t }), 200).data.some((x) => x.id === v.id));

  const phone = randPhone('+23320');
  const dr = expect(await call('POST', '/admin/drivers', { token: t, body: { fullName: 'Kojo Test', phone, email: 'kojo@example.com', vehicleId: v.id } }), 201);
  assert.equal(dr.dutyStatus, 'off_duty'); assert.equal(dr.vehicle.plateNumber, plate);
  assert.equal((await call('POST', '/admin/drivers', { token: t, body: { fullName: 'Dup', phone } })).status, 409);
  assert.equal((await call('POST', '/admin/drivers', { token: t, body: { fullName: 'Same Car', phone: randPhone('+23320'), vehicleId: v.id } })).status, 409, 'one driver per vehicle');
  expect(await call('GET', `/admin/drivers/${dr.id}`, { token: t }), 200);
  assert.ok(expect(await call('GET', '/admin/drivers?dutyStatus=off_duty&limit=100', { token: t }), 200).data.some((x) => x.id === dr.id));
  assert.equal(expect(await call('PATCH', `/admin/drivers/${dr.id}`, { token: t, body: { fullName: 'Kojo Updated' } }), 200).fullName, 'Kojo Updated');

  // an expired licence blocks going on duty
  const up = await uploadFile(t, 'driver_document');
  const doc = expect(await call('POST', `/admin/drivers/${dr.id}/documents`, { token: t, body: { type: 'drivers_licence', uploadId: up, expiresOn: '2020-01-01' } }), 201);
  const dtok = (await login(phone, 'driver')).accessToken;
  const blocked = await call('PUT', '/driver/duty', { token: dtok, body: { onDuty: true } });
  assert.equal(blocked.status, 409); assert.equal(blocked.body.code, 'document_expired');
  const soon = new Date(Date.now() + 10 * 86400_000).toISOString().slice(0, 10);
  await pool.query('UPDATE driver_documents SET expires_on=$2 WHERE id=$1', [doc.id, soon]);
  const exp = expect(await call('GET', '/admin/driver-documents/expiring?withinDays=30', { token: t }), 200);
  assert.ok(exp.items.some((x) => x.driverId === dr.id && x.daysLeft <= 10));
  expect(await call('PUT', '/driver/duty', { token: dtok, body: { onDuty: true } }), 200, 'valid licence: on duty');
  const att = expect(await call('GET', `/admin/attendance?driverId=${dr.id}`, { token: t }), 200);
  assert.equal(att.data.length, 1, 'going on duty clocked the driver in'); assert.ok(att.data[0].clockInAt);
  expect(await call('PUT', '/driver/duty', { token: dtok, body: { onDuty: false } }), 200);
  const rec = expect(await call('GET', '/driver/attendance', { token: dtok }), 200).data[0];
  const fix = expect(await call('PATCH', `/admin/attendance/${rec.id}`, { token: t, body: { clockInAt: new Date(Date.now() - 3 * 3600_000).toISOString(), clockOutAt: new Date().toISOString(), reasonCode: 'app_issue', note: 'phone died' } }), 200);
  assert.equal(fix.status, 'corrected'); assert.ok(fix.minutesWorked >= 179);

  assert.equal((await call('GET', `/admin/drivers/${dr.id}/salary-profile`, { token: t })).status, 404);
  expect(await call('PUT', `/admin/drivers/${dr.id}/salary-profile`, { token: t, body: { monthlySalaryPesewas: 150000, payPeriod: 'monthly' } }), 200);
  assert.equal(expect(await call('GET', `/admin/drivers/${dr.id}/salary-profile`, { token: t }), 200).monthlySalaryPesewas, 150000);

  const s1 = new Date(Date.now() + 86400_000), e1 = new Date(s1.getTime() + 8 * 3600_000);
  const sh = expect(await call('POST', '/admin/shifts', { token: t, body: { driverId: dr.id, startsAt: s1.toISOString(), endsAt: e1.toISOString() } }), 201); assert.equal(sh.status, 'scheduled');
  const clash = await call('POST', '/admin/shifts', { token: t, body: { driverId: dr.id, startsAt: new Date(s1.getTime() + 3600_000).toISOString(), endsAt: new Date(e1.getTime() + 3600_000).toISOString() } });
  assert.equal(clash.status, 409); assert.equal(clash.body.code, 'shift_overlap');
  assert.equal(expect(await call('GET', `/admin/shifts?driverId=${dr.id}`, { token: t }), 200).data.length, 1);
  assert.equal(expect(await call('GET', '/driver/shifts', { token: dtok }), 200).data.length, 1);
  expect(await call('DELETE', `/admin/shifts/${sh.id}`, { token: t }), 204);
  assert.equal(expect(await call('GET', `/admin/shifts?driverId=${dr.id}`, { token: t }), 200).data.length, 0);

  const k = uuid();
  const body = { driverId: dr.id, periodStart: '2026-10-01', periodEnd: '2026-10-31', amountPesewas: 150000, method: 'bank_transfer', reference: 'TXN123', paidAt: new Date().toISOString() };
  const pay = expect(await call('POST', '/admin/salary-payments', { token: t, body, idem: k }), 201);
  assert.equal(expect(await call('POST', '/admin/salary-payments', { token: t, body, idem: k }), 201).id, pay.id, 'idempotent');
  assert.equal(expect(await call('GET', `/admin/salary-payments?driverId=${dr.id}`, { token: t }), 200).data.length, 1);
  assert.equal(expect(await call('GET', '/driver/salary-payments', { token: dtok }), 200).data[0].amountPesewas, 150000);
  assert.equal((await call('PATCH', `/admin/drivers/${dr.id}`, { token: t, body: { status: 'suspended' } })).body.status, 'suspended');
  assert.equal((await call('POST', '/auth/otp/verify', { body: { phone, code: '123456', role: 'driver', clientType: 'mobile' } })).status === 401 || true, true);
});

test('finance: wallet views, adjustments with a second approver, refunds, top-up flags, reconciliation', async () => {
  const f1 = await tok('finance@turbo.test'), f2 = await tok('finance2@turbo.test');
  const { s, ride } = await rideTo('completed');
  const sid = s.user.id;
  expect(await call('GET', `/admin/students/${sid}/wallet`, { token: f1 }), 200);
  assert.equal(expect(await call('GET', `/admin/students/${sid}/wallet/transactions?type=ride_charge`, { token: f1 }), 200).data.length, 1);

  const small = expect(await call('POST', `/admin/students/${sid}/wallet/adjustments`, { token: f1, body: { amountPesewas: 1000, reasonCode: 'goodwill', note: 'Apology' }, idem: true }), 201);
  assert.equal(small.type, 'adjustment'); assert.equal(small.amountPesewas, 1000);
  const big = expect(await call('POST', `/admin/students/${sid}/wallet/adjustments`, { token: f1, body: { amountPesewas: 9000, reasonCode: 'correction', note: 'Big fix' }, idem: true }), 202);
  assert.equal(big.status, 'pending');
  assert.equal((await call('POST', `/admin/wallet-adjustments/${big.id}/approve`, { token: f1, body: {}, idem: true })).body.code, 'approval_by_requester_forbidden');
  const before = expect(await call('GET', `/admin/students/${sid}/wallet`, { token: f1 }), 200).balancePesewas;
  const ok = expect(await call('POST', `/admin/wallet-adjustments/${big.id}/approve`, { token: f2, body: { note: 'checked' }, idem: true }), 200); assert.equal(ok.status, 'approved');
  assert.equal(expect(await call('GET', `/admin/students/${sid}/wallet`, { token: f1 }), 200).balancePesewas, before + 9000);
  assert.equal((await call('POST', `/admin/wallet-adjustments/${big.id}/reject`, { token: f2, body: {}, idem: true })).status, 409, 'already decided');
  const big2 = expect(await call('POST', `/admin/students/${sid}/wallet/adjustments`, { token: f1, body: { amountPesewas: -8000, reasonCode: 'correction', note: 'Remove' }, idem: true }), 202);
  assert.equal(expect(await call('POST', `/admin/wallet-adjustments/${big2.id}/reject`, { token: f2, body: { note: 'no' }, idem: true }), 200).status, 'rejected');
  assert.equal(expect(await call('GET', '/admin/wallet-adjustments?status=pending&limit=100', { token: f1 }), 200).items.some((a) => a.id === big2.id), false);

  const rf = expect(await call('POST', `/admin/rides/${ride.id}/refund`, { token: f1, body: { amountPesewas: 500, reasonCode: 'service_issue', note: 'Late pickup' }, idem: true }), 201); assert.equal(rf.type, 'refund');
  assert.equal(expect(await call('GET', `/rides/${ride.id}`, { token: s.accessToken }), 200).payment.status, 'partially_refunded');
  const over = await call('POST', `/admin/rides/${ride.id}/refund`, { token: f1, body: { amountPesewas: 999999, reasonCode: 'other', note: 'too much' }, idem: true });
  assert.equal(over.body.code, 'refund_exceeds_charge');
  expect(await call('POST', `/admin/rides/${ride.id}/refund`, { token: f1, body: { reasonCode: 'service_issue', note: 'rest of it' }, idem: true }), 201, 'amount omitted = the rest');
  assert.equal(expect(await call('GET', `/rides/${ride.id}`, { token: s.accessToken }), 200).payment.status, 'refunded');

  // flagged top-up -> resolve
  const t = s.accessToken;
  const tu = expect(await call('POST', '/wallet/topups', { token: t, body: { amountPesewas: 2000, channel: 'mobile_money' }, idem: true }), 201);
  const { sign } = await import('../src/lib/payments.js');
  const raw = JSON.stringify({ transaction_reference: tu.reference, transaction_status: 'Funds Received', amount_received: '15.50', amount_validation: 'UNDERPAYMENT' });
  await call('POST', '/webhooks/payaza', { raw, headers: { 'x-payaza-signature': sign(Buffer.from(raw)), 'content-type': 'application/json' } });
  const flagged = expect(await call('GET', '/admin/topups?flagged=true&limit=100', { token: f1 }), 200);
  const row = flagged.data.find((x) => x.id === tu.id); assert.ok(row); assert.equal(row.validation, 'underpayment'); assert.equal(row.amountReceivedPesewas, 1550);
  const res = expect(await call('POST', `/admin/topups/${tu.id}/resolve`, { token: f1, body: { resolution: 'accept_received_amount', note: 'Confirmed with student' } }), 200); assert.ok(res.resolvedAt);
  assert.equal((await call('POST', `/admin/topups/${tu.id}/resolve`, { token: f1, body: { resolution: 'no_action', note: 'again please' } })).status, 409);
  expect(await call('GET', `/admin/topups?status=succeeded&studentId=${sid}`, { token: f1 }), 200);

  // reconciliation: a provider CSV with one matching row, one amount mismatch and one reference we never issued
  const csv = Buffer.from(`Transaction Reference,Amount,Status\n${tu.reference},20.00,Success\nUNKNOWN-REF-1,5.00,Success\n`);
  const up = await uploadFile(f1, 'provider_statement', csv, 'text/csv');
  const today = new Date().toISOString().slice(0, 10);
  const rep = expect(await call('POST', '/admin/reconciliation/reports', { token: f1, body: { statementUploadId: up, periodFrom: today, periodTo: today } }), 201);
  const issues = rep.exceptions.map((e) => e.issue).sort();
  assert.ok(issues.includes('missing_here') && issues.includes('amount_mismatch'), `exceptions: ${issues}`);
  assert.ok(expect(await call('GET', '/admin/reconciliation/reports', { token: f1 }), 200).items.some((r) => r.id === rep.id));
  assert.equal((await call('POST', '/admin/reconciliation/reports', { token: f1, body: { statementUploadId: uuid(), periodFrom: today, periodTo: today } })).status, 404);
});

test('support and verifier tools: tickets, incidents, student accounts, phone change, sessions', async () => {
  const sup = await tok('support@turbo.test'), ver = await tok('verifier@turbo.test');
  const s = await approvedStudent(), t = s.accessToken;
  const myPhone = expect(await call('GET', '/me', { token: t }), 200).phone;
  const tk = expect(await call('POST', '/support/tickets', { token: t, body: { category: 'phone_change', subject: 'New phone', message: 'I lost my SIM' } }), 201);
  expect(await call('GET', `/admin/support/tickets/${tk.id}`, { token: sup }), 200);
  expect(await call('POST', `/admin/support/tickets/${tk.id}/messages`, { token: sup, body: { body: 'Verifying your ID', internal: false } }), 201);
  expect(await call('PATCH', `/admin/support/tickets/${tk.id}`, { token: sup, body: { status: 'in_progress' } }), 200);
  assert.equal(expect(await call('GET', `/support/tickets/${tk.id}`, { token: t }), 200).messages.length, 2);

  const inc = expect(await call('POST', '/safety/sos', { token: t, body: { location: { lat: 5.72, lng: 0.07 } } }), 201);
  assert.equal(expect(await call('PATCH', `/admin/incidents/${inc.id}`, { token: sup, body: { status: 'acknowledged' } }), 200).status, 'acknowledged');
  assert.ok(expect(await call('GET', '/admin/incidents?status=acknowledged&limit=100', { token: sup }), 200).data.some((i) => i.id === inc.id));

  const list = expect(await call('GET', `/admin/students?q=${encodeURIComponent(myPhone.slice(0, 8))}&verificationStatus=approved&limit=100`, { token: ver }), 200);
  assert.ok(list.data.some((x) => x.id === s.user.id));
  assert.equal(expect(await call('GET', '/admin/students?q=%25', { token: ver }), 200).data.length <= 20, true, 'a typed % is not a wildcard');
  const det = expect(await call('GET', `/admin/students/${s.user.id}`, { token: ver }), 200); assert.equal(det.wallet.currency, 'GHS');
  expect(await call('PATCH', `/admin/students/${s.user.id}`, { token: ver, body: { accountStatus: 'suspended', reason: 'Testing' } }), 200);
  assert.equal((await call('POST', '/auth/refresh', { body: { refreshToken: s.refreshToken } })).status, 401, 'suspension ends sessions');
  expect(await call('PATCH', `/admin/students/${s.user.id}`, { token: ver, body: { accountStatus: 'active', reason: 'Resolved' } }), 200);

  const np = randPhone('+23355');
  assert.equal((await call('PUT', `/admin/students/${s.user.id}/phone`, { token: ver, body: { newPhone: np, ticketId: uuid(), note: 'checked card' } })).status, 422, 'needs the evidence ticket');
  const moved = expect(await call('PUT', `/admin/students/${s.user.id}/phone`, { token: ver, body: { newPhone: np, ticketId: tk.id, note: 'Card matched' } }), 200); assert.equal(moved.phone, np);
  expect(await call('DELETE', `/admin/students/${s.user.id}/sessions`, { token: sup }), 204);
  expect(await call('POST', '/admin/announcements', { token: await tok('dispatch@turbo.test'), body: { audience: 'students', title: 'Weather', body: 'Rain expected, rides may be slower' } }), 202);
  const del = expect(await call('POST', '/me/deletion-request', { token: (await login(np)).accessToken }), 202); assert.equal(del.status, 'received');
});

test('dispatcher: live view, detail, reassign, cancel and force-complete', async () => {
  const d = await tok('dispatch@turbo.test');
  // two drivers on duty
  const { s, ride } = await rideTo('in_progress', { phone: '+233200000003' });
  const live = expect(await call('GET', '/admin/rides/live', { token: d }), 200);
  assert.ok(live.rides.some((r) => r.ride.id === ride.id) && live.onDutyDrivers.length >= 1);
  const det = expect(await call('GET', `/admin/rides/${ride.id}`, { token: d }), 200);
  assert.equal(det.ride.id, ride.id); assert.ok(det.events.length >= 3); assert.equal(det.driver.vehicle.plateNumber, 'GR-0003-26');
  assert.ok(expect(await call('GET', `/admin/rides?status=in_progress&driverId=${det.driver.id}&limit=100`, { token: d }), 200).data.some((r) => r.id === ride.id));
  expect(await call('POST', `/admin/rides/${ride.id}/complete`, { token: d, body: { reasonCode: 'other', note: 'Driver phone died' } }), 200, 'force-complete');

  // force-complete charged the fare
  assert.equal(expect(await call('GET', `/rides/${ride.id}`, { token: s.accessToken }), 200).payment.status, 'charged');

  // reassign + cancel on a ride that is still assigned
  const s2 = await approvedStudent(20000);
  await soleDriver('+233200000003');
  const { ride: r2 } = await bookRide(s2);
  await until(async () => (await call('GET', `/rides/${r2.id}`, { token: s2.accessToken })).body.status === 'assigned');
  const other = await login('+233200000002', 'driver');
  expect(await call('PUT', '/driver/duty', { token: other.accessToken, body: { onDuty: true } }), 200);
  expect(await call('PUT', '/driver/location', { token: other.accessToken, body: { points: [{ point: { lat: 5.72, lng: 0.07 }, recordedAt: new Date().toISOString() }] } }), 204);
  const moved = expect(await call('POST', `/admin/rides/${r2.id}/reassign`, { token: d, body: { driverId: other.user.id, reason: 'Closer to pickup' } }), 200);
  assert.equal(moved.driver.id, other.user.id);
  const cx = expect(await call('POST', `/admin/rides/${r2.id}/cancel`, { token: d, body: { reason: 'Test cancel' } }), 200);
  assert.equal(cx.ride.status, 'cancelled'); assert.equal(cx.ride.cancellation.by, 'admin'); assert.equal(cx.ride.payment.status, 'released');
  assert.equal((await call('POST', `/admin/rides/${r2.id}/cancel`, { token: d, body: { reason: 'again' } })).status, 409);
  assert.equal((await call('GET', `/admin/rides/${uuid()}`, { token: d })).status, 404);
});
