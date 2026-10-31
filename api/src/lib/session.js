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
export const setRefreshCookie = (res, token) => res.append('set-cookie',
  `${COOKIE}=${encodeURIComponent(token)}; HttpOnly; SameSite=Strict; Path=/; Max-Age=${30 * 86400}${config.env === 'production' ? '; Secure' : ''}`);
export const clearRefreshCookie = (res) => res.append('set-cookie', `${COOKIE}=; HttpOnly; SameSite=Strict; Path=/; Max-Age=0${config.env === 'production' ? '; Secure' : ''}`);

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
