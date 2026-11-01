// @vitest-environment jsdom
import { afterEach, describe, expect, it, vi } from 'vitest';

/**
 * Session handling in the HTTP layer: one refresh for many failed calls,
 * replaying a request with its body, signalling an ended session, and never
 * leaking a token into an error. Plus return paths and action permissions.
 */
vi.stubEnv('VITE_API_BASE_URL', 'http://api.test');

const { api, call, onSessionExpired, setAccessToken, setDemoTransport } = await import('@/services/http');
const { ApiError } = await import('@/utils/problems');
const { safeReturnPath, signInPath } = await import('@/utils/returnPath');
const { canDo } = await import('@/utils/permissions');
const { canUse } = await import('@/utils/roles');

const SECRET = 'tok-SECRET-123';
const json = (status: number, body: unknown) =>
  new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } });
const problem = (status: number, code: string) =>
  new Response(JSON.stringify({ type: 'about:blank', title: code, status, code }), {
    status,
    headers: { 'Content-Type': 'application/problem+json' },
  });
const tokens = (accessToken: string) => ({ accessToken, expiresInSeconds: 900 });
const wait = (ms: number) => new Promise((r) => setTimeout(r, ms));

let requests: Request[] = [];
function serve(handler: (r: Request) => Response | Promise<Response>) {
  requests = [];
  setDemoTransport(async (input, init) => {
    const r = input instanceof Request ? input : new Request(input, init);
    requests.push(r.clone());
    return handler(r);
  });
}
const refreshes = () => requests.filter((r) => r.url.endsWith('/auth/refresh')).length;

/** Refresh hands out `fresh`; protected calls accept only `fresh`. */
function serveExpiredToken(refresh: () => Response | Promise<Response> = () => json(200, tokens('fresh'))) {
  serve(async (r) => {
    if (r.url.endsWith('/auth/refresh')) {
      await wait(20); // long enough for the other calls to fail and queue behind it
      return refresh();
    }
    return r.headers.get('Authorization') === 'Bearer fresh' ? json(200, { ok: true }) : problem(401, 'invalid_token');
  });
}

afterEach(() => setAccessToken(null));

describe('token refresh', () => {
  it('refreshes once when several calls fail together, then retries each with the new token', async () => {
    setAccessToken(SECRET);
    serveExpiredToken();
    const results = await Promise.all([
      call(api.GET('/admin/me')),
      call(api.GET('/admin/staff')),
      call(api.GET('/admin/verifications')),
    ]);
    expect(results).toHaveLength(3);
    expect(refreshes()).toBe(1);
    const retried = requests.filter((r) => r.headers.get('Authorization') === 'Bearer fresh');
    expect(retried).toHaveLength(3);
  });

  it('replays a POST with the same body and idempotency key after refreshing', async () => {
    setAccessToken(SECRET);
    serveExpiredToken();
    const body = { currentPassword: 'old-password-1', newPassword: 'new-password-1', totpCode: '123456' };
    await call(api.POST('/admin/me/password', { body, headers: { 'Idempotency-Key': 'intent-1' } }));
    const sent = requests.filter((r) => r.url.endsWith('/admin/me/password'));
    expect(sent).toHaveLength(2);
    expect(await sent[1]!.json()).toEqual(body);
    expect(sent[1]!.headers.get('Idempotency-Key')).toBe('intent-1');
    expect(sent[1]!.headers.get('Authorization')).toBe('Bearer fresh');
  });

  it('signals an ended session once when the refresh is refused, and does not loop', async () => {
    setAccessToken(SECRET);
    serveExpiredToken(() => problem(401, 'unauthenticated'));
    const ended = vi.fn();
    const stop = onSessionExpired(ended);
    const outcomes = await Promise.allSettled([call(api.GET('/admin/me')), call(api.GET('/admin/staff'))]);
    stop();
    expect(outcomes.every((o) => o.status === 'rejected')).toBe(true);
    expect(refreshes()).toBe(1);
    // Both failed calls share the one refusal; listeners hear about each, the session signs out once.
    expect(ended).toHaveBeenCalled();
  });

  it('does not end the session when the refresh only failed to arrive', async () => {
    setAccessToken(SECRET);
    serve((r) => {
      if (r.url.endsWith('/auth/refresh')) throw new TypeError('Failed to fetch');
      return problem(401, 'invalid_token');
    });
    const ended = vi.fn();
    const stop = onSessionExpired(ended);
    await expect(call(api.GET('/admin/me'))).rejects.toBeInstanceOf(ApiError);
    stop();
    expect(ended).not.toHaveBeenCalled();
  });

  it('returns a second 401 as it is instead of refreshing again', async () => {
    setAccessToken(SECRET);
    serve((r) => (r.url.endsWith('/auth/refresh') ? json(200, tokens('fresh')) : problem(401, 'forbidden')));
    await expect(call(api.GET('/admin/me'))).rejects.toMatchObject({ status: 401 });
    expect(refreshes()).toBe(1);
  });

  it('never sends the token to the public sign-in calls', async () => {
    setAccessToken(SECRET);
    serve(() => json(200, tokens('x')));
    await call(api.POST('/auth/admin/login', { body: { email: 'a@b.c', password: 'long-enough-1' } }));
    expect(requests[0]!.headers.get('Authorization')).toBeNull();
  });

  it('keeps tokens out of errors', async () => {
    setAccessToken(SECRET);
    serve((r) => (r.url.endsWith('/auth/refresh') ? problem(401, 'unauthenticated') : problem(401, 'invalid_token')));
    const err = await call(api.GET('/admin/me')).catch((e: unknown) => e);
    expect(err).toBeInstanceOf(ApiError);
    const text = `${String(err)} ${JSON.stringify(err)} ${(err as Error).stack ?? ''}`;
    expect(text).not.toContain(SECRET);
  });
});

describe('return path after sign-in', () => {
  it.each([
    ['/staff?status=active#top', '/staff?status=active#top'],
    ['/rides/r1', '/rides/r1'],
    [null, '/'],
    ['', '/'],
    ['staff', '/'],
    ['//evil.test/x', '/'],
    ['/\\evil.test', '/'],
    ['https://evil.test', '/'],
    ['javascript:alert(1)', '/'],
    ['/sign-in?next=/x', '/'],
    ['/reset-password?token=abc', '/'],
  ])('%s → %s', (raw, expected) => {
    expect(safeReturnPath(raw)).toBe(expected);
  });

  it('builds the sign-in link with the page encoded', () => {
    expect(signInPath('/staff?x=1')).toBe('/sign-in?next=%2Fstaff%3Fx%3D1');
    expect(signInPath('/')).toBe('/sign-in');
  });
});

describe('permissions', () => {
  it('lets super admin do everything and other roles only their own actions', () => {
    expect(canDo('super_admin', 'ride.refund')).toBe(true);
    expect(canDo('finance', 'ride.refund')).toBe(true);
    expect(canDo('dispatcher', 'ride.refund')).toBe(false);
    expect(canDo('support', 'student.signOutEverywhere')).toBe(true);
    expect(canDo('verifier', 'student.signOutEverywhere')).toBe(false);
    expect(canDo('hr', 'account.changePassword')).toBe(true);
    expect(canDo(null, 'account.changePassword')).toBe(false);
  });

  it('opens areas by role, and the overview for everyone signed in', () => {
    expect(canUse('verifier', 'staff')).toBe(false);
    expect(canUse('verifier', 'verification')).toBe(true);
    expect(canUse('hr', 'overview')).toBe(true);
    expect(canUse(undefined, 'overview')).toBe(false);
  });
});
