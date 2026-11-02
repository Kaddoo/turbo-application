/**
 * What went wrong with an API call, in terms the page can act on. The status
 * and problem `code` decide the kind; the message text never does.
 */
export type ProblemKind =
  | "not_configured" // no PUBLIC_API_BASE_URL: the static fallbacks are the design, not an error
  | "cancelled" // the visitor left before the answer came
  | "offline"
  | "network" // unreachable, or blocked by the browser (CORS)
  | "timeout"
  | "rate_limited" // 429
  | "busy" // 503 service_busy
  | "upgrade" // 426: this build is older than the API accepts
  | "bad_request" // 400 / 422
  | "unauthorized" // 401
  | "forbidden" // 403
  | "not_found" // 404
  | "conflict" // 409
  | "server" // 5xx
  | "contract_mismatch" // 200, but the body is not what api/contract/openapi.yaml says
  | "http"; // any other status

export type ApiProblem = { kind: ProblemKind; status?: number; code?: string; retryAfterSeconds?: number };

const record = (v: unknown): Record<string, unknown> => (v && typeof v === "object" ? (v as Record<string, unknown>) : {});

export function fromResponse(status: number, body: unknown, retryAfterHeader: string | null): ApiProblem {
  const b = record(body);
  const code = typeof b.code === "string" ? b.code : undefined;
  const fromBody = typeof b.retryAfterSeconds === "number" ? b.retryAfterSeconds : undefined;
  const fromHeader = retryAfterHeader && /^\d+$/.test(retryAfterHeader) ? Number(retryAfterHeader) : undefined;
  const retryAfterSeconds = fromBody ?? fromHeader;
  const base = { status, code };
  if (status === 429) return { ...base, kind: "rate_limited", retryAfterSeconds };
  if (status === 503) return { ...base, kind: "busy", retryAfterSeconds };
  if (status === 426) return { ...base, kind: "upgrade" };
  if (status === 400 || status === 422) return { ...base, kind: "bad_request" };
  if (status === 401) return { ...base, kind: "unauthorized" };
  if (status === 403) return { ...base, kind: "forbidden" };
  if (status === 404) return { ...base, kind: "not_found" };
  if (status === 409) return { ...base, kind: "conflict" };
  if (status >= 500) return { ...base, kind: "server" };
  return { ...base, kind: "http" };
}

export function fromThrown(how: { cancelled: boolean; timedOut: boolean; online: boolean }): ApiProblem {
  if (how.cancelled) return { kind: "cancelled" };
  if (how.timedOut) return { kind: "timeout" };
  return { kind: how.online ? "network" : "offline" };
}

/** Worth a "Try again" button: the same request may well work a moment later. */
export const isRetryable = (p: ApiProblem) =>
  p.kind === "offline" ||
  p.kind === "network" ||
  p.kind === "timeout" ||
  p.kind === "rate_limited" ||
  p.kind === "busy" ||
  p.kind === "server";

/** Plain words for visitors. `what` names the thing, e.g. "the current fares". */
export function problemText(p: ApiProblem, what: string): string {
  switch (p.kind) {
    case "offline":
      return `You're offline, so we can't show ${what}.`;
    case "network":
      return `We couldn't reach Turbo to load ${what}.`;
    case "timeout":
      return `Loading ${what} took too long.`;
    case "rate_limited":
      return p.retryAfterSeconds
        ? `Too many requests right now. Try again in ${p.retryAfterSeconds} seconds.`
        : "Too many requests right now. Try again in a minute.";
    case "busy":
      return "Turbo is busy right now. Try again shortly.";
    case "server":
      return `Something went wrong on our side while loading ${what}.`;
    case "upgrade":
      return "This page is out of date. Reload it to get the latest version.";
    default:
      return `We couldn't load ${what}.`;
  }
}
