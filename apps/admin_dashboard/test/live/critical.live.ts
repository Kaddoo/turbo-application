import { afterAll, describe, expect, it, vi } from 'vitest';

/**
 * Critical dashboard endpoints against a REAL API, through the dashboard's own
 * client. Never part of `npm test`; run with:
 *   LIVE_API_URL=https://api.example/v1 npm run test:live
 * Read-only checks and harmless error cases run by default. Calls that change
 * data run only with LIVE_WRITES=1, and only against a non-production API.
 * Accounts are the API's dev seed (docs/api-integration.md §8); override with
 * LIVE_ADMIN_EMAIL, LIVE_VERIFIER_EMAIL, LIVE_PASSWORD.
 * Results go to test/live/results.json for the tracker's verification log.
 */
const base = process.env.LIVE_API_URL;
if (!base) throw new Error('Set LIVE_API_URL');
vi.stubEnv('VITE_API_BASE_URL', base);

const { api, call, setAccessToken } = await import('../../src/api/client');
const { ApiError } = await import('../../src/lib/problems');
const fs = await import('node:fs');

const password = process.env.LIVE_PASSWORD ?? 'Turbo-demo-1';
const adminEmail = process.env.LIVE_ADMIN_EMAIL ?? 'admin@turbo.test';
const verifierEmail = process.env.LIVE_VERIFIER_EMAIL ?? 'verifier@turbo.test';
const writes = process.env.LIVE_WRITES === '1';

type Result = { endpoint: string; check: string; ok: boolean; detail: string };
const results: Result[] = [];

/** Runs one check, records it, and fails the test if it failed. */
async function check(endpoint: string, what: string, run: () => Promise<string>) {
  try {
    const detail = await run();
    results.push({ endpoint, check: what, ok: true, detail });
  } catch (e) {
    const detail = e instanceof ApiError ? `${e.status} ${e.code ?? ''} ${e.problem?.detail ?? ''}`.trim() : String(e);
    results.push({ endpoint, check: what, ok: false, detail });
    throw e;
  }
}
async function expectProblem(p: Promise<unknown>, status: number, code?: string): Promise<string> {
  const e = await p.then(() => null, (x) => x);
  if (!(e instanceof ApiError)) throw new Error(`expected ${status}, got success`);
  if (e.status !== status || (code && e.code !== code)) throw e;
  return `${e.status} ${e.code}`;
}

async function signIn(email: string) {
  setAccessToken(null);
  const t = await call(api.POST('/auth/admin/login', { body: { email, password } }));
  setAccessToken(t.accessToken);
  return t;
}

afterAll(() => {
  fs.writeFileSync(new URL('./results.json', import.meta.url), JSON.stringify({ base, at: new Date().toISOString(), writes, results }, null, 2));
});

describe(`critical dashboard endpoints on ${base}`, () => {
  it('POST /auth/admin/login rejects a wrong password', () => check('POST /auth/admin/login', 'wrong password → 401 invalid_credentials',
    () => expectProblem(call(api.POST('/auth/admin/login', { body: { email: adminEmail, password: 'wrong-password-123' } })), 401, 'invalid_credentials')));

  it('POST /auth/admin/login signs in the super admin', () => check('POST /auth/admin/login', 'valid login → 200 AuthTokens', async () => {
    const t = await signIn(adminEmail);
    expect(t.accessToken).toBeTruthy();
    expect(t.user.staffRole).toBe('super_admin');
    return `200, staffRole ${t.user.staffRole}, expires ${t.expiresInSeconds}s`;
  }));

  it('GET /admin/me', () => check('GET /admin/me', '200 StaffUser', async () => {
    const me = await call(api.GET('/admin/me'));
    expect(me.staffRole).toBe('super_admin');
    return `200, ${me.staffRole}, mfaEnrolled ${me.mfaEnrolled}`;
  }));

  it('GET /admin/me without a token', () => check('GET /admin/me', 'no token → 401', async () => {
    const saved = await signIn(adminEmail);
    setAccessToken(null);
    try { return await expectProblem(call(api.GET('/admin/me')), 401); } finally { setAccessToken(saved.accessToken); }
  }));

  let verificationId: string | undefined;
  it('GET /admin/verifications', () => check('GET /admin/verifications', '200 cursor list', async () => {
    const r = await call(api.GET('/admin/verifications', { params: { query: { limit: 5 } } }));
    expect(Array.isArray(r.data)).toBe(true);
    expect(r.page).toBeTruthy();
    verificationId = r.data[0]?.id;
    return `200, ${r.data.length} rows, hasMore ${r.page.hasMore}`;
  }));

  it('GET /admin/verifications/{id}', async () => {
    if (!verificationId) { results.push({ endpoint: 'GET /admin/verifications/{id}', check: 'skipped', ok: false, detail: 'queue empty, nothing to open' }); return; }
    await check('GET /admin/verifications/{id}', '200 VerificationDetail', async () => {
      const v = await call(api.GET('/admin/verifications/{id}', { params: { path: { id: verificationId! } } }));
      expect(v.id).toBe(verificationId);
      return `200, status ${v.status}, ${v.documents?.length ?? 0} documents`;
    });
  });

  it('GET /admin/verifications/{id} unknown id', () => check('GET /admin/verifications/{id}', 'unknown id → 404 not_found',
    () => expectProblem(call(api.GET('/admin/verifications/{id}', { params: { path: { id: '00000000-0000-4000-8000-000000000000' } } })), 404, 'not_found')));

  it('GET /admin/rides/live', () => check('GET /admin/rides/live', '200 LiveRides', async () => {
    const l = await call(api.GET('/admin/rides/live'));
    expect(Array.isArray(l.rides)).toBe(true);
    return `200, ${l.rides.length} active rides, ${l.onDutyDrivers.length} on duty`;
  }));

  it('GET /admin/incidents', () => check('GET /admin/incidents', '200 cursor list (status=open)', async () => {
    const r = await call(api.GET('/admin/incidents', { params: { query: { status: 'open', limit: 10 } } }));
    expect(Array.isArray(r.data)).toBe(true);
    return `200, ${r.data.length} open`;
  }));

  it('GET /service-area', () => check('GET /service-area', '200 ServiceArea', async () => {
    const a = await call(api.GET('/service-area'));
    return `200, boundary ${a.boundary ? `${a.boundary.coordinates?.[0]?.length ?? '?'} points` : 'null'}, ${a.pickupPoints.length} pickup points`;
  }));

  it('roles: a verifier cannot read live rides', () => check('GET /admin/rides/live', 'verifier → 403 forbidden', async () => {
    await signIn(verifierEmail);
    try { return await expectProblem(call(api.GET('/admin/rides/live')), 403); } finally { await signIn(adminEmail); }
  }));

  it('POST /auth/admin/invite/accept with a bad token', () => check('POST /auth/admin/invite/accept', 'bad token → 401',
    () => expectProblem(call(api.POST('/auth/admin/invite/accept', { body: { token: 'not-a-real-invite-token', password: 'Long-enough-password-1' } })), 401)));

  it('POST /auth/admin/mfa/confirm with a bad token', () => check('POST /auth/admin/mfa/confirm', 'bad token → 401',
    () => expectProblem(call(api.POST('/auth/admin/mfa/confirm', { body: { enrollmentToken: 'not-a-real-token', totpCode: '000000' } })), 401)));

  it('POST /auth/logout', () => check('POST /auth/logout', '204', async () => {
    await signIn(adminEmail);
    const { response } = await api.POST('/auth/logout');
    expect(response.status).toBe(204);
    setAccessToken(null);
    return '204';
  }));

  /*
   * Writes. Staging only (api.turbogh.app confirmed as staging, 2026-11-01).
   * Each check leaves the least behind: the boundary is saved unchanged, the
   * test vehicle is retired, the test driver is suspended. Two checks reach a
   * real person and need their own opt-in:
   *   LIVE_DECIDE=1        decide the oldest verification (needs_attention); texts the student
   *   LIVE_DRIVER_PHONE=…  create a driver with this +233 number; texts it an invite
   */
  describe.runIf(writes)('writes (LIVE_WRITES=1)', () => {
    const financeEmail = process.env.LIVE_FINANCE_EMAIL ?? 'finance@turbo.test';
    const hrEmail = process.env.LIVE_HR_EMAIL ?? 'hr@turbo.test';
    const supportEmail = process.env.LIVE_SUPPORT_EMAIL ?? 'support@turbo.test';
    const decide = process.env.LIVE_DECIDE === '1';
    const driverPhone = process.env.LIVE_DRIVER_PHONE;
    const skip = (endpoint: string, why: string) => results.push({ endpoint, check: 'skipped', ok: false, detail: why });
    const stamp = Date.now().toString(36).toUpperCase();

    it('PUT /admin/service-area saves the current boundary unchanged', () => check('PUT /admin/service-area', 'same boundary → 200, version +1', async () => {
      await signIn(adminEmail);
      const before = await call(api.GET('/service-area'));
      if (!before.boundary) throw new Error('no boundary to save back; not saving an invented one');
      const after = await call(api.PUT('/admin/service-area', { body: { boundary: before.boundary } }));
      expect(after.boundary).toEqual(before.boundary);
      expect(after.version).toBeGreaterThan(before.version);
      return `200, version ${before.version} → ${after.version}, boundary unchanged`;
    }));

    it('PUT /admin/service-area refused for finance', () => check('PUT /admin/service-area', 'finance → 403', async () => {
      await signIn(financeEmail);
      const area = await call(api.GET('/service-area'));
      if (!area.boundary) throw new Error('no boundary');
      return expectProblem(call(api.PUT('/admin/service-area', { body: { boundary: area.boundary } })), 403);
    }));

    let claimedId: string | undefined;
    it('POST /admin/verifications/{id}/claim', async () => {
      await signIn(verifierEmail);
      const q = await call(api.GET('/admin/verifications', { params: { query: { status: 'pending', limit: 5 } } }));
      const free = q.data.find((v) => !v.claimedBy || (v.claimExpiresAt && new Date(v.claimExpiresAt) < new Date()));
      if (!free) { skip('POST /admin/verifications/{id}/claim', 'no unclaimed pending submission'); return; }
      await check('POST /admin/verifications/{id}/claim', 'verifier claims → 200, 15-minute lock', async () => {
        const c = await call(api.POST('/admin/verifications/{id}/claim', { params: { path: { id: free.id } } }));
        expect(c.id).toBe(free.id);
        expect(c.claimedBy).toBeTruthy();
        claimedId = c.id;
        return `200, claimed until ${c.claimExpiresAt ?? '?'}`;
      });
    });

    it('POST /admin/verifications/{id}/claim held by someone else', async () => {
      if (!claimedId) { skip('POST /admin/verifications/{id}/claim', 'nothing claimed above'); return; }
      await check('POST /admin/verifications/{id}/claim', 'second reviewer → 409 verification_claimed', async () => {
        await signIn(adminEmail);
        return expectProblem(call(api.POST('/admin/verifications/{id}/claim', { params: { path: { id: claimedId! } } })), 409, 'verification_claimed');
      });
    });

    it('POST /admin/verifications/{id}/decision', async () => {
      if (!decide) { skip('POST /admin/verifications/{id}/decision', 'needs LIVE_DECIDE=1 (texts the student)'); return; }
      if (!claimedId) { skip('POST /admin/verifications/{id}/decision', 'nothing claimed'); return; }
      await check('POST /admin/verifications/{id}/decision', 'needs_attention → 200', async () => {
        await signIn(verifierEmail);
        const r = await call(api.POST('/admin/verifications/{id}/decision', { params: { path: { id: claimedId! } }, body: {
          decision: 'needs_attention', reasonCode: 'document_unclear',
          studentMessage: 'Test review on staging: please upload a clearer photo of your student ID.',
          internalNote: 'Automated staging check (admin dashboard test:live).',
        } }));
        return `200, status ${(r as { status?: string }).status ?? '?'}`;
      });
    });

    let vehicleId: string | undefined;
    const plate = `TST-${stamp}`;
    it('POST /admin/vehicles', () => check('POST /admin/vehicles', 'hr creates → 201 Vehicle', async () => {
      await signIn(hrEmail);
      const v = await call(api.POST('/admin/vehicles', { body: { make: 'Test', model: 'Staging check', colour: 'Grey', plateNumber: plate, seats: 4, status: 'maintenance' } }));
      expect(v.plateNumber).toBe(plate);
      vehicleId = v.id;
      return `201, ${v.plateNumber}, ${v.status}`;
    }));

    it('POST /admin/vehicles duplicate plate', async () => {
      if (!vehicleId) { skip('POST /admin/vehicles', 'no vehicle created'); return; }
      await check('POST /admin/vehicles', 'same plate again → 409', () =>
        expectProblem(call(api.POST('/admin/vehicles', { body: { make: 'Test', model: 'Duplicate', colour: 'Grey', plateNumber: plate } })), 409));
    });

    let driverId: string | undefined;
    it('POST /admin/drivers', async () => {
      if (!driverPhone) { skip('POST /admin/drivers', 'needs LIVE_DRIVER_PHONE (texts that number an invite)'); return; }
      await check('POST /admin/drivers', 'hr creates → 201 DriverDetail', async () => {
        await signIn(hrEmail);
        const d = await call(api.POST('/admin/drivers', { body: { fullName: `Staging Check ${stamp}`, phone: driverPhone } }));
        driverId = (d as { id: string }).id;
        return '201';
      });
    });

    it('PATCH /admin/drivers/{id} assigns the vehicle', async () => {
      if (!driverId || !vehicleId) { skip('PATCH /admin/drivers/{id}', 'needs the test driver and vehicle'); return; }
      await check('PATCH /admin/drivers/{id}', 'assign vehicle → 200', async () => {
        await signIn(hrEmail);
        const d = await call(api.PATCH('/admin/drivers/{id}', { params: { path: { id: driverId! } }, body: { vehicleId } }));
        return `200, vehicle ${JSON.stringify((d as { vehicle?: { plateNumber?: string } }).vehicle?.plateNumber ?? '?')}`;
      });
    });

    it('PATCH /admin/incidents/{id} acknowledges an open incident', async () => {
      await signIn(supportEmail);
      const open = await call(api.GET('/admin/incidents', { params: { query: { status: 'open', limit: 1 } } }));
      const inc = open.data[0];
      if (!inc) { skip('PATCH /admin/incidents/{id}', 'no open incident (SOS comes from the student app)'); return; }
      await check('PATCH /admin/incidents/{id}', 'acknowledge → 200', async () => {
        const r = await call(api.PATCH('/admin/incidents/{id}', { params: { path: { id: inc.id } }, body: { status: 'acknowledged', note: 'Staging check' } }));
        expect(r.status).toBe('acknowledged');
        return '200, acknowledged';
      });
    });

    afterAll(async () => {
      // Clean up: suspend the test driver (unassigning the vehicle), retire the test vehicle.
      await signIn(hrEmail).catch(() => undefined);
      if (driverId) await api.PATCH('/admin/drivers/{id}', { params: { path: { id: driverId } }, body: { status: 'suspended', vehicleId: null } });
      if (vehicleId) await api.PATCH('/admin/vehicles/{id}', { params: { path: { id: vehicleId } }, body: { make: 'Test', model: 'Staging check', colour: 'Grey', plateNumber: plate, status: 'retired' } });
    });
  });
});
