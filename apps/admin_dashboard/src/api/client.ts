import createClient, { type Middleware } from 'openapi-fetch';
import type { components, paths } from './schema';
import { ApiError } from '../lib/problems';

export type Schemas = components['schemas'];
export type Problem = Schemas['Problem'];
export type ProblemCode = Schemas['ProblemCode'];

const APP_VERSION = `web/${import.meta.env.VITE_APP_VERSION ?? '0.1.0'}`;

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

/** Same-origin '/api' in development (Vite proxies it to the mock), a full URL in real builds. */
const baseUrl = import.meta.env.VITE_API_BASE_URL ?? '/api';

/**
 * Demo mode serves realistic sample data from `src/demo` for presentations.
 * It is only reachable when VITE_APP_ENV=demo; real builds never load it.
 */
export const isDemo = import.meta.env.VITE_APP_ENV === 'demo';
let transport: typeof fetch = (input, init) => globalThis.fetch(input, init);

export function setDemoTransport(demoFetch: typeof fetch): void {
  transport = demoFetch;
}

/** Calls that must not carry a bearer token or trigger a refresh. */
const PUBLIC_AUTH = /^\/auth\/(admin\/|refresh$)/;

let refreshing: Promise<boolean> | null = null;

/** One refresh at a time; concurrent 401s wait for the same attempt. */
async function refreshAccessToken(): Promise<boolean> {
  refreshing ??= (async () => {
    try {
      const res = await transport(`${baseUrl}/auth/refresh`, {
        method: 'POST',
        credentials: 'include',
        headers: { 'X-App-Version': APP_VERSION },
      });
      if (!res.ok) {
        accessToken = null;
        return false;
      }
      const tokens = (await res.json()) as Schemas['AuthTokens'];
      accessToken = tokens.accessToken;
      return true;
    } catch {
      return false;
    } finally {
      refreshing = null;
    }
  })();
  return refreshing;
}

const authMiddleware: Middleware = {
  onRequest({ request, schemaPath }) {
    request.headers.set('X-App-Version', APP_VERSION);
    if (accessToken && !PUBLIC_AUTH.test(schemaPath)) {
      request.headers.set('Authorization', `Bearer ${accessToken}`);
    }
    return request;
  },
  async onResponse({ request, response, schemaPath }) {
    if (response.status !== 401 || PUBLIC_AUTH.test(schemaPath)) return undefined;
    // Retry once after a refresh. Requests with a consumed body cannot be replayed safely.
    if (request.bodyUsed || !(await refreshAccessToken())) return undefined;
    const retry = new Request(request);
    retry.headers.set('Authorization', `Bearer ${accessToken}`);
    return transport(retry);
  },
};

export const api = createClient<paths>({
  baseUrl,
  credentials: 'include',
  fetch: (request: Request) => transport(request),
});
api.use(authMiddleware);

/** Narrow an unknown error body to an RFC 9457 problem with a stable code. */
export function isProblem(value: unknown): value is Problem {
  return typeof value === 'object' && value !== null && 'code' in value && 'status' in value;
}

/** Try to restore a session from the refresh cookie (page load). */
export function restoreSession(): Promise<boolean> {
  return refreshAccessToken();
}

/**
 * Unwraps an openapi-fetch result: returns the data or throws an ApiError
 * carrying the RFC 9457 problem, so screens can switch on its `code`.
 */
export async function call<T>(
  pending: Promise<{ data?: T; error?: unknown; response: Response }>,
): Promise<T> {
  const { data, error, response } = await pending;
  if (!response.ok || error !== undefined) {
    throw new ApiError(response.status, isProblem(error) ? error : null);
  }
  return data as T;
}

/** One UUID per user intention; keep it while the same intention is retried. */
export function newIdempotencyKey(): string {
  return crypto.randomUUID();
}
