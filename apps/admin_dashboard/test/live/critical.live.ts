import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';

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

  describe.runIf(writes)('writes (LIVE_WRITES=1)', () => {
    beforeAll(() => signIn(adminEmail));
    // Filled in only after the environment is confirmed as non-production.
    it.todo('claim, decide, create vehicle and driver, assign vehicle, acknowledge incident, save boundary');
  });
});
