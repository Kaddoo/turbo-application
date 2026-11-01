import crypto from 'node:crypto';
import { config } from '../config.js';
import { tx, q } from '../db.js';
import { ApiError } from './errors.js';
import { signAccess, issueRefresh, termsStamp } from './auth.js';

// Builds the contract's AuthTokens. Mobile apps get the refresh token in the body. Browsers get it in an httpOnly cookie and NOT in the
// body, so page scripts (and any script injected into the page) can never read it.
export const COOKIE = 'turbo_rt';
export const fromBrowser = (req) => { const o = req.get('origin'); return !!o && config.corsOrigins.includes(o); };
export const readCookie = (req, name = COOKIE) => {
  const m = (req.get('cookie') || '').split(/;\s*/).find((c) => c.startsWith(name + '='));
  return m ? decodeURIComponent(m.slice(name.length + 1)) : undefined;
};
// The cookie is HttpOnly (scripts cannot read it), SameSite=Strict (the dashboard at admin.<domain> and the API at api.<domain> are the same site, so
// Strict is enough and Lax is not needed), Secure from config, and limited to the auth routes with Path (config.cookiePath, /v1/auth by default).
// Older builds set it with Path=/. Whenever we set or clear the cookie we also expire that old one, so a browser never holds two.
const attrs = (path) => `HttpOnly; SameSite=Strict; Path=${path}${config.cookieSecure ? '; Secure' : ''}`;
const expireOld = (res) => { if (config.cookiePath !== '/') res.append('set-cookie', `${COOKIE}=; ${attrs('/')}; Max-Age=0`); };
// The old cookie is expired FIRST and the new one set last. A proxy that rewrites every cookie to one path (the dashboard's dev server does) then still ends with
// the new cookie in place, because the last Set-Cookie for a name and path wins.
export const setRefreshCookie = (res, token) => {
  expireOld(res);
  res.append('set-cookie', `${COOKIE}=${encodeURIComponent(token)}; ${attrs(config.cookiePath)}; Max-Age=${30 * 86400}`);
};
export const clearRefreshCookie = (res) => {
  res.append('set-cookie', `${COOKIE}=; ${attrs(config.cookiePath)}; Max-Age=0`);
  expireOld(res);
};

// A cookie is sent by the browser automatically, so a request that relies on it must prove it came from our own web app.
export function requireTrustedOrigin(req) {
  if (!fromBrowser(req)) throw new ApiError(403, 'forbidden', 'Cross-site request refused');
}

export const sessionUser = (u) => ({ id: u.id, role: u.role, ...(u.staffRole && { staffRole: u.staffRole }), ...(u.displayName && { displayName: u.displayName }) });

const platformOf = (req) => (/^(ios|android|web)\//.exec(req.get('x-app-version') || '') || [])[1] ?? null;

// u: { id, role, staffRole?, displayName? }. subjectType 'user' | 'staff'. web: put the refresh token in a cookie.
export async function startSession(req, res, u, { subjectType = 'user', web = false, deviceName = null } = {}) {
  const family = crypto.randomUUID();
  const refresh = await tx((c) => issueRefresh(c, u.id, subjectType, family, { platform: web ? 'web' : platformOf(req), deviceName, clientType: web ? 'web' : 'mobile' }));
  return tokens(res, u, family, refresh, web);
}
export function tokens(res, u, family, refresh, web) {
  const access = signAccess(u.id, u.role, { sid: family, ...(u.staffRole && { staffRole: u.staffRole }), ...(u.termsOk && { tv: termsStamp() }) });
  if (web) setRefreshCookie(res, refresh);
  return { accessToken: access, expiresInSeconds: 900, ...(web ? {} : { refreshToken: refresh }), user: sessionUser(u) };
}
