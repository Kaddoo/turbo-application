/**
 * The landing page's only door to the Turbo API: three public reads, no tokens.
 * Types come from api/contract/openapi.yaml (`npm run gen:api`), calls go
 * through the generated openapi-fetch client, and every 200 body is checked
 * against the contract before a component sees it. Components never call
 * fetch(); they use these resources through `useApi`.
 */
import createClient from "openapi-fetch";
import type { components, paths } from "@/api/schema";
import { appConfigIssues, legalIssues, serviceAreaIssues } from "./guards";
import { fromResponse, fromThrown, type ApiProblem } from "./problems";

type Schemas = components["schemas"];
export type ServiceArea = Schemas["ServiceArea"];
export type FareBand = Schemas["FareBand"];
export type PickupPoint = Schemas["PickupPoint"];
export type LegalVersions = Schemas["LegalVersions"];
export type AppConfig = Schemas["AppConfig"];

export type ApiResult<T> = { ok: true; data: T; maxAgeMs: number } | { ok: false; problem: ApiProblem };

/** A cacheable read. `key` identifies it in the shared cache. */
export type Resource<T> = { key: string; load: (signal: AbortSignal) => Promise<ApiResult<T>> };

const BASE = (process.env.PUBLIC_API_BASE_URL || "").replace(/\/$/, "");
/** Without a base URL the page renders its static fallbacks and makes no calls. */
export const HAS_API = Boolean(BASE);
const TIMEOUT_MS = 6000;
/** Used when the response carries no Cache-Control max-age. */
const DEFAULT_MAX_AGE_MS = 60_000;

const client = createClient<paths>({
  baseUrl: BASE,
  headers: { Accept: "application/json", "X-App-Version": `web/${process.env.PUBLIC_APP_VERSION || "0.0.0"}` },
});

function maxAge(res: Response): number {
  const m = /max-age=(\d+)/.exec(res.headers.get("cache-control") ?? "");
  return m ? Number(m[1]) * 1000 : DEFAULT_MAX_AGE_MS;
}

type Sent = { data?: unknown; error?: unknown; response: Response };

/** Runs one call with a timeout, the caller's cancel signal and the contract check. */
async function call<T>(key: string, send: (signal: AbortSignal) => Promise<Sent>, issues: (body: unknown) => string[], signal: AbortSignal): Promise<ApiResult<T>> {
  if (!HAS_API) return { ok: false, problem: { kind: "not_configured" } };
  const ctrl = new AbortController();
  let timedOut = false;
  const timer = setTimeout(() => {
    timedOut = true;
    ctrl.abort();
  }, TIMEOUT_MS);
  const cancel = () => ctrl.abort();
  if (signal.aborted) ctrl.abort();
  else signal.addEventListener("abort", cancel, { once: true });
  try {
    const { data, error, response } = await send(ctrl.signal);
    if (!response.ok) return { ok: false, problem: fromResponse(response.status, error, response.headers.get("retry-after")) };
    const found = issues(data);
    if (found.length) {
      // The API answered but not in the documented shape. Report it; do not patch around it.
      console.error(`[turbo api] GET ${key} does not match api/contract/openapi.yaml: ${found.join(", ")}`);
      return { ok: false, problem: { kind: "contract_mismatch", status: response.status } };
    }
    return { ok: true, data: data as T, maxAgeMs: maxAge(response) };
  } catch {
    const online = typeof navigator === "undefined" || navigator.onLine;
    return { ok: false, problem: fromThrown({ cancelled: signal.aborted, timedOut, online }) };
  } finally {
    clearTimeout(timer);
    signal.removeEventListener("abort", cancel);
  }
}

/** GET /service-area: fare bands, pickup points, operating hours. Cached for the API's max-age (5 min). */
export const serviceArea: Resource<ServiceArea> = {
  key: "/service-area",
  load: (signal) => call("/service-area", (s) => client.GET("/service-area", { signal: s }), serviceAreaIssues, signal),
};

/** GET /legal: current terms and privacy versions and URLs. */
export const legal: Resource<LegalVersions> = {
  key: "/legal",
  load: (signal) => call("/legal", (s) => client.GET("/legal", { signal: s }), legalIssues, signal),
};

/** GET /app-config: maintenance and paused bookings. Cached for 1 min. */
export const appConfig: Resource<AppConfig> = {
  key: "/app-config",
  load: (signal) => call("/app-config", (s) => client.GET("/app-config", { signal: s }), appConfigIssues, signal),
};

/** Money arrives as integer pesewas and is formatted only here. */
export const formatCedis = (pesewas: number) =>
  `GH₵${(pesewas / 100).toLocaleString("en-GH", { minimumFractionDigits: pesewas % 100 ? 2 : 0, maximumFractionDigits: 2 })}`;

export const formatKm = (m: number) => `${(m / 1000).toLocaleString("en-GH", { maximumFractionDigits: 1 })} km`;
