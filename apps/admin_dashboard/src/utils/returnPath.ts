/**
 * Where to go after signing in. The page someone asked for travels in the
 * `next` query parameter (it survives a reload, unlike router state). Only a
 * path inside this app is accepted, so a crafted sign-in link cannot send a
 * user to another site ("//evil.test", "https://…", "/\evil.test").
 */
const SIGNED_OUT_PAGES = ['/sign-in', '/forgot-password', '/reset-password', '/invite', '/accept-invite'];

export function safeReturnPath(raw: string | null | undefined): string {
  if (!raw || !raw.startsWith('/') || raw.startsWith('//') || raw.startsWith('/\\')) return '/';
  try {
    // Resolving against a fixed origin must keep that origin.
    const url = new URL(raw, 'https://app.invalid');
    if (url.origin !== 'https://app.invalid') return '/';
    if (SIGNED_OUT_PAGES.includes(url.pathname)) return '/';
    return `${url.pathname}${url.search}${url.hash}`;
  } catch {
    return '/';
  }
}

/** The sign-in URL that brings the user back to `path` afterwards. */
export function signInPath(path: string): string {
  const next = safeReturnPath(path);
  return next === '/' ? '/sign-in' : `/sign-in?next=${encodeURIComponent(next)}`;
}
