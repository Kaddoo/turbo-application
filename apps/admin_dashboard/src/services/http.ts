import createClient, { type Middleware } from 'openapi-fetch';
import type { paths } from '@/types';
import { ApiError, isProblem } from '@/utils/problems';

/**
 * The one place that talks HTTP. Services build on `api` and `call`; nothing
 * else imports openapi-fetch.
 */

const APP_VERSION = `web/${import.meta.env.VITE_APP_VERSION ?? '0.1.0'}`;

/** Ordinary calls give up after 15 s; file uploads to storage after 2 minutes. */
export const TIMEOUT_MS = 15_000;
export const UPLOAD_TIMEOUT_MS = 120_000;

/**
 * Access token lives in memory only (prompts/02). The refresh token is the
 * httpOnly cookie the API sets for web clients, so every call sends cookies.
 */
let accessToken: string | null = null;

export function setAccessToken(token: string | null): void {
  accessToken = token;
}

export function hasAccessToken(): boolean {
  return accessToken !== null;
}

/** Same-origin '/api' in development (Vite proxies it), a full URL from VITE_API_BASE_URL in real builds. */
const baseUrl = import.meta.env.VITE_API_BASE_URL ?? '/api';

/**
 * Demo mode serves realistic sample data from `src/demo` for presentations.
 * It is only reachable when VITE_APP_ENV=demo; real builds never load it.
 */
export const isDemo = import.meta.env.VITE_APP_ENV === 'demo';
const networkTransport: typeof fetch = (input, init) => globalThis.fetch(input, init);
let transport: typeof fetch = networkTransport;

export function setDemoTransport(demoFetch: typeof fetch): void {
  transport = demoFetch;
}

/**
 * Sends one request with a time limit and turns transport failures into an
 * ApiError (`timeout` or `network`), so screens only ever see ApiError.
 * A caller's own cancellation (React Query leaving a page) is passed through.
 */
export async function send(input: Request | string, init?: RequestInit, timeoutMs = TIMEOUT_MS): Promise<Response> {
  const callerSignal = init?.signal ?? (input instanceof Request ? input.signal : undefined);
  const controller = new AbortController();
  let timedOut = false;
  let timer: ReturnType<typeof setTimeout> | undefined;
  const expired = new Promise<never>((_, reject) => {
    timer = setTimeout(() => {
      timedOut = true;
      controller.abort();
      reject(new ApiError(0, null, undefined, 'timeout'));
    }, timeoutMs);
  });
  const cancel = () => controller.abort();
  callerSignal?.addEventListener('abort', cancel, { once: true });
  try {
    // Only the real network gets the abort signal; test and demo transports run in memory.
    const pending =
      transport === networkTransport
        ? transport(input, { ...init, signal: controller.signal })
        : transport(input, init);
    return await Promise.race([pending, expired]);
  } catch (e) {
    if (e instanceof ApiError) throw e;
    if (timedOut) throw new ApiError(0, null, undefined, 'timeout');
    if (callerSignal?.aborted) throw e;
    throw new ApiError(0, null, undefined, 'network');
  } finally {
    clearTimeout(timer);
    callerSignal?.removeEventListener('abort', cancel);
  }
}

/** Calls that must not carry a bearer token or trigger a refresh. */
const PUBLIC_AUTH = /^\/auth\/(admin\/|refresh$)/;

/**
 * Outcome of a refresh: `ok`, `expired` (the API refused the cookie, so the
 * session is over) or `failed` (no answer; the session may still be fine).
 */
type RefreshResult = 'ok' | 'expired' | 'failed';

let refreshing: Promise<RefreshResult> | null = null;

/**
 * Refresh tokens rotate and reusing an old one revokes the whole session, so
 * two tabs must never refresh at the same moment. The Web Locks API queues
 * them across tabs (each tab then sends the newest cookie); where it is
 * missing, the single in-tab attempt below still applies.
 */
function withRefreshLock<T>(work: () => Promise<T>): Promise<T> {
  const locks = typeof navigator !== 'undefined' ? navigator.locks : undefined;
  return locks ? (locks.request('turbo-admin-refresh', work) as Promise<T>) : work();
}

/**
 * The refresh call goes through its own typed client without the auth
 * middleware, so a refused refresh can never trigger another refresh.
 */
const authClient = createClient<paths>({
  baseUrl,
  credentials: 'include',
  headers: { 'X-App-Version': APP_VERSION },
  fetch: (request: Request) => send(request),
});

/** One refresh at a time; concurrent 401s wait for the same attempt. */
function refreshAccessToken(): Promise<RefreshResult> {
  refreshing ??= withRefreshLock(async (): Promise<RefreshResult> => {
    try {
      // Web clients send the httpOnly cookie and an empty body (contract: refreshTokens).
      const { data, response } = await authClient.POST('/auth/refresh', {});
      if (!response.ok || !data) {
        accessToken = null;
        return response.status === 401 || response.status === 403 ? 'expired' : 'failed';
      }
      accessToken = data.accessToken;
      return 'ok';
    } catch {
      return 'failed';
    }
  }).finally(() => {
    refreshing = null;
  });
  return refreshing;
}

/**
 * The signed-in session ended on the server (refresh refused). The session
 * state signs out locally and sends the user to sign in, keeping their page.
 */
const expiredListeners = new Set<() => void>();
export function onSessionExpired(listener: () => void): () => void {
  expiredListeners.add(listener);
  return () => expiredListeners.delete(listener);
}

/** 426 `upgrade_required`: this build is older than the API allows. Layout shows a reload banner. */
const upgradeListeners = new Set<() => void>();
export function onUpgradeRequired(listener: () => void): () => void {
  upgradeListeners.add(listener);
  return () => upgradeListeners.delete(listener);
}

/**
 * A request's body can be read only once, so each authenticated request keeps
 * an unread copy; after a refresh the copy is replayed with the new token. The
 * Idempotency-Key header travels with it, so a replayed POST is the same
 * intention, never a second one.
 */
const replayable = new WeakMap<Request, Request>();

const authMiddleware: Middleware = {
  onRequest({ request, schemaPath }) {
    request.headers.set('X-App-Version', APP_VERSION);
    if (!PUBLIC_AUTH.test(schemaPath)) {
      if (accessToken) request.headers.set('Authorization', `Bearer ${accessToken}`);
      replayable.set(request, request.clone());
    }
    return request;
  },
  async onResponse({ request, response, schemaPath }) {
    if (response.status === 426) upgradeListeners.forEach((l) => l());
    if (response.status !== 401 || PUBLIC_AUTH.test(schemaPath)) return undefined;
    const copy = replayable.get(request);
    const hadSession = accessToken !== null || request.headers.has('Authorization');
    const result = await refreshAccessToken();
    if (result === 'expired' && hadSession) expiredListeners.forEach((l) => l());
    if (result !== 'ok' || !copy) return undefined;
    // Retry once. A second 401 is returned as it is (no refresh loop).
    copy.headers.set('Authorization', `Bearer ${accessToken}`);
    return send(copy);
  },
};

export const api = createClient<paths>({
  baseUrl,
  credentials: 'include',
  fetch: (request: Request) => send(request),
});
api.use(authMiddleware);

/** Try to restore a session from the refresh cookie (page load, or another tab signed in). */
export async function restoreSession(): Promise<boolean> {
  return (await refreshAccessToken()) === 'ok';
}

/**
 * Unwraps an openapi-fetch result: returns the data or throws an ApiError
 * carrying the RFC 9457 problem, so screens can switch on its `code`. An error
 * without a problem body (a proxy page, an empty 503) is `unexpected`.
 */
export async function call<T>(pending: Promise<{ data?: T; error?: unknown; response: Response }>): Promise<T> {
  const { data, error, response } = await pending;
  if (!response.ok || error !== undefined) {
    const header = Number(response.headers.get('Retry-After'));
    const retryAfter = Number.isFinite(header) && header > 0 ? header : undefined;
    if (isProblem(error)) throw new ApiError(response.status, error, retryAfter);
    throw new ApiError(response.status, null, retryAfter, 'unexpected');
  }
  return data as T;
}

/** One UUID per user intention; keep it while the same intention is retried. */
export function newIdempotencyKey(): string {
  return crypto.randomUUID();
}

/** Like `call`, but also hands back the HTTP status, for operations where 200 and 202 mean different things. */
export async function callWithStatus<T>(
  pending: Promise<{ data?: T; error?: unknown; response: Response }>,
): Promise<{ data: T; status: number }> {
  const result = await pending;
  return { data: await call(Promise.resolve(result)), status: result.response.status };
}
