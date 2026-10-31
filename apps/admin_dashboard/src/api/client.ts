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

/** 426 `upgrade_required`: this build is older than the API allows. Layout shows a reload banner. */
const upgradeListeners = new Set<() => void>();
export function onUpgradeRequired(listener: () => void): () => void {
  upgradeListeners.add(listener);
  return () => upgradeListeners.delete(listener);
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
    if (response.status === 426) upgradeListeners.forEach((l) => l());
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
    const header = Number(response.headers.get('Retry-After'));
    throw new ApiError(response.status, isProblem(error) ? error : null, Number.isFinite(header) && header > 0 ? header : undefined);
  }
  return data as T;
}

type UploadPurpose = Schemas['UploadRequest']['purpose'];
type UploadContentType = Schemas['UploadRequest']['contentType'];

/**
 * The type to declare for a file. Browsers often report CSV as '' or
 * 'application/vnd.ms-excel'; the API wants 'text/csv' (contract 0.2.2, for
 * `provider_statement` only).
 */
export function uploadContentType(file: File): UploadContentType {
  if (/\.csv$/i.test(file.name)) return 'text/csv' as UploadContentType;
  return file.type as UploadContentType;
}

/**
 * Signed upload (docs/api-integration.md §5): ask for a slot, PUT the raw
 * bytes with exactly the declared Content-Type and no auth header, and only
 * hand back the uploadId once storage has accepted the file.
 */
export async function uploadFile(purpose: UploadPurpose, file: File): Promise<string> {
  const contentType = uploadContentType(file);
  const slot = await call(api.POST('/uploads', { body: { purpose, contentType, sizeBytes: file.size } }));
  const res = await transport(slot.uploadUrl, {
    method: slot.method,
    body: file,
    headers: { ...slot.headers, 'Content-Type': contentType },
  });
  if (!res.ok) throw new ApiError(res.status, null);
  return slot.uploadId;
}

/** One UUID per user intention; keep it while the same intention is retried. */
export function newIdempotencyKey(): string {
  return crypto.randomUUID();
}
