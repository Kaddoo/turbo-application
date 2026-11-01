import type { Problem, ProblemCode } from '@/types';

/** Failures that never reached a problem body: no connection, too slow, or a non-problem error page. */
export type LocalCode = 'network' | 'timeout' | 'unexpected';

/**
 * Plain-language sentence per problem code. Screens switch on `code`, never on
 * the message (prompts/00 rule 3).
 */
const messages: Partial<Record<ProblemCode | LocalCode, string>> = {
  validation_failed: 'Some details are missing or not valid. Check the highlighted fields.',
  unauthenticated: 'Your session has ended. Sign in again.',
  forbidden: 'You do not have access to this.',
  not_found: 'We could not find that. It may have been removed.',
  conflict: 'Someone else changed this at the same time. Refresh and try again.',
  rate_limited: 'Too many requests. Wait a moment, then try again.',
  invalid_credentials: 'That email and password do not match.',
  mfa_required: 'Enter the 6-digit code from your authenticator app.',
  account_locked: 'Too many failed attempts. This account is locked for 15 minutes.',
  mfa_enrollment_required: 'Finish setting up your authenticator app before signing in.',
  invalid_token: 'This link has expired or was already used. Ask for a new one.',
  account_suspended: 'This account is suspended.',
  verification_claimed: 'Another reviewer is working on this submission.',
  duplicate_identity: 'This Ghana Card is already linked to another account.',
  invalid_ride_state: 'This ride has moved on. Refresh to see its current state.',
  driver_has_active_ride: 'That driver already has an active ride.',
  refund_exceeds_charge: 'The refund is more than what is left of the charge.',
  shift_overlap: 'This driver already has a shift at that time.',
  self_adjustment_forbidden: 'You cannot adjust a wallet linked to your own phone number.',
  approval_by_requester_forbidden: 'You cannot approve your own request. Another finance user must approve it.',
  idempotency_key_reused: 'This request was already sent with different details. Start again.',
  document_expired: 'A required driver document has expired.',
  upload_expired: 'The upload expired. Choose the file again.',
  sms_budget_exceeded: 'The daily SMS limit has been reached.',
  payment_provider_error: 'The payment provider did not respond. Try again shortly.',
  upgrade_required: 'This dashboard is out of date. Reload the page.',
  network: 'Cannot reach the server. Check your connection and try again.',
  timeout: 'The server is taking too long to answer. Try again in a moment.',
};

/** Narrow an unknown error body to an RFC 9457 problem with a stable code. */
export function isProblem(value: unknown): value is Problem {
  return typeof value === 'object' && value !== null && 'code' in value && 'status' in value;
}

/** Every failed call becomes one of these. `status` is 0 when no response arrived. */
export class ApiError extends Error {
  readonly status: number;
  readonly problem: Problem | null;
  /** Seconds to wait before retrying (429, 503): the body's `retryAfterSeconds`, else the Retry-After header. */
  readonly retryAfterSeconds: number | undefined;
  private readonly localCode: LocalCode | null;

  constructor(status: number, problem: Problem | null, retryAfterHeader?: number, localCode?: LocalCode) {
    super(
      problem?.detail ??
        problem?.title ??
        (status ? `Request failed (${status})` : `Request failed (${localCode ?? 'network'})`),
    );
    this.status = status;
    this.problem = problem;
    this.retryAfterSeconds = problem?.retryAfterSeconds ?? retryAfterHeader;
    this.localCode = localCode ?? null;
  }

  get code(): ProblemCode | LocalCode | null {
    return this.problem?.code ?? this.localCode;
  }
}

export function problemMessage(error: unknown): string {
  if (error instanceof ApiError) {
    const wait = error.retryAfterSeconds;
    // account_locked has its own fixed 15-minute sentence.
    if (wait && (error.status === 429 || error.status === 503) && error.code !== 'account_locked') {
      const when = wait < 60 ? `${wait} seconds` : `${Math.ceil(wait / 60)} minutes`;
      return error.code === 'sms_budget_exceeded'
        ? `${messages.sms_budget_exceeded} Try again in ${when}.`
        : `Too many requests right now. Try again in ${when}.`;
    }
    if (error.code && messages[error.code]) return messages[error.code]!;
    if (error.status === 403) return messages.forbidden!;
    if (error.status === 404) return messages.not_found!;
    if (error.status === 429) return messages.rate_limited!;
    if (error.status >= 500) return 'Something went wrong on our side. Try again in a moment.';
  }
  if (error instanceof TypeError) return messages.network!;
  return 'Something went wrong. Try again.';
}

/** Field errors from a 422 problem, keyed by field name. */
export function fieldErrors(error: unknown): Record<string, string> {
  if (!(error instanceof ApiError) || !error.problem?.errors) return {};
  return Object.fromEntries(error.problem.errors.map((e) => [e.field.replace(/^\//, ''), e.message]));
}
