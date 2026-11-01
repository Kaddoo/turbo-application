// @vitest-environment jsdom
import { beforeEach, describe, expect, it, vi } from 'vitest';

/** Client behaviour the API guide asks for (docs/api-integration.md §3 and §5). */
vi.stubEnv('VITE_API_BASE_URL', 'http://api.test');

const { call, onUpgradeRequired, setDemoTransport, api, TIMEOUT_MS } = await import('@/services/http');
const { uploadContentType, uploadFile } = await import('@/services/uploads');
const { ApiError, problemMessage } = await import('@/utils/problems');

const problem = (status: number, code: string, extra: object = {}, headers: Record<string, string> = {}) =>
  new Response(JSON.stringify({ type: 'about:blank', title: code, status, code, ...extra }), {
    status, headers: { 'Content-Type': 'application/problem+json', ...headers },
  });

let requests: Request[] = [];
function serve(handler: (r: Request) => Response) {
  requests = [];
  setDemoTransport(async (input, init) => {
    const r = input instanceof Request ? input : new Request(input, init);
    requests.push(r);
    return handler(r);
  });
}

beforeEach(() => serve(() => new Response(null, { status: 500 })));

describe('uploads', () => {
  it('declares CSV as text/csv whatever the browser reports', () => {
    expect(uploadContentType(new File(['a,b'], 'statement.CSV', { type: 'application/vnd.ms-excel' }))).toBe('text/csv');
    expect(uploadContentType(new File(['a,b'], 'statement.csv', { type: '' }))).toBe('text/csv');
    expect(uploadContentType(new File(['x'], 'licence.pdf', { type: 'application/pdf' }))).toBe('application/pdf');
  });

  it('PUTs the bytes with the declared type and no auth header, then returns the uploadId', async () => {
    serve((r) => r.url.endsWith('/uploads')
      ? new Response(JSON.stringify({ uploadId: 'u1', uploadUrl: 'https://store.test/slot', method: 'PUT', headers: { 'x-amz-meta': '1' }, expiresAt: '2026-10-31T00:10:00Z' }), { status: 201, headers: { 'Content-Type': 'application/json' } })
      : new Response(null, { status: 204 }));
    const file = new File(['date,amount'], 'statement.csv', { type: '' });
    await expect(uploadFile('provider_statement', file)).resolves.toBe('u1');
    expect(await requests[0]!.json()).toEqual({ purpose: 'provider_statement', contentType: 'text/csv', sizeBytes: file.size });
    const put = requests[1]!;
    expect(put.method).toBe('PUT');
    expect(put.headers.get('Content-Type')).toBe('text/csv');
    expect(put.headers.get('x-amz-meta')).toBe('1');
    expect(put.headers.get('Authorization')).toBeNull();
  });

  it('fails when storage rejects the file instead of carrying on', async () => {
    serve((r) => r.url.endsWith('/uploads')
      ? new Response(JSON.stringify({ uploadId: 'u1', uploadUrl: 'https://store.test/slot', method: 'PUT', expiresAt: '2026-10-31T00:10:00Z' }), { status: 201, headers: { 'Content-Type': 'application/json' } })
      : new Response(null, { status: 403 }));
    await expect(uploadFile('driver_document', new File(['x'], 'a.pdf', { type: 'application/pdf' }))).rejects.toBeInstanceOf(ApiError);
  });
});

describe('problems', () => {
  it('reads Retry-After from the body, else the header, and says how long to wait', async () => {
    serve(() => problem(429, 'rate_limited', { retryAfterSeconds: 30 }));
    const fromBody = await call(api.GET('/admin/me')).catch((e) => e);
    expect(fromBody.retryAfterSeconds).toBe(30);
    expect(problemMessage(fromBody)).toBe('Too many requests right now. Try again in 30 seconds.');

    serve(() => problem(503, 'sms_budget_exceeded', {}, { 'Retry-After': '120' }));
    const fromHeader = await call(api.GET('/admin/me')).catch((e) => e);
    expect(fromHeader.retryAfterSeconds).toBe(120);
    expect(problemMessage(fromHeader)).toMatch(/Try again in 2 minutes\.$/);
  });

  it('keeps the fixed sentence for a locked account', () => {
    expect(problemMessage(new ApiError(429, { type: 'about:blank', title: 'x', status: 429, code: 'account_locked', retryAfterSeconds: 900 })))
      .toBe('Too many failed attempts. This account is locked for 15 minutes.');
  });

  it('signals 426 upgrade_required so the layout can ask for a reload', async () => {
    const seen = vi.fn();
    const off = onUpgradeRequired(seen);
    serve(() => problem(426, 'upgrade_required'));
    await call(api.GET('/admin/me')).catch(() => undefined);
    off();
    expect(seen).toHaveBeenCalledOnce();
  });

  it('sends X-App-Version on every call', async () => {
    serve(() => new Response('{}', { status: 200, headers: { 'Content-Type': 'application/json' } }));
    await call(api.GET('/admin/me'));
    expect(requests[0]!.headers.get('X-App-Version')).toMatch(/^web\//);
  });
});

describe('failures without a problem body', () => {
  it('turns a dropped connection into code network', async () => {
    serve(() => { throw new TypeError('Failed to fetch'); });
    const e = await call(api.GET('/admin/me')).catch((x) => x);
    expect(e).toBeInstanceOf(ApiError);
    expect([e.status, e.code]).toEqual([0, 'network']);
    expect(problemMessage(e)).toBe('Cannot reach the server. Check your connection and try again.');
  });

  it('gives up after the time limit with code timeout', async () => {
    vi.useFakeTimers();
    try {
      setDemoTransport(() => new Promise<Response>(() => {}));
      const pending = call(api.GET('/admin/me')).catch((x) => x);
      await vi.advanceTimersByTimeAsync(TIMEOUT_MS + 1);
      const e = await pending;
      expect([e.status, e.code]).toEqual([0, 'timeout']);
      expect(problemMessage(e)).toMatch(/taking too long/);
    } finally {
      vi.useRealTimers();
    }
  });

  it('marks an error page that is not a problem (an empty proxy 503) as unexpected', async () => {
    serve(() => new Response('', { status: 503 }));
    const e = await call(api.GET('/admin/me')).catch((x) => x);
    expect([e.status, e.code]).toEqual([503, 'unexpected']);
    expect(problemMessage(e)).toBe('Something went wrong on our side. Try again in a moment.');
  });
});
