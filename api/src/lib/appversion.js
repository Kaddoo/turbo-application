import { config } from '../config.js';
import { ApiError } from './errors.js';

// X-App-Version: ios/1.2.0 (or android/, web/). Older than the minimum -> 426 upgrade_required so the app can show its update screen.
// A missing or unparseable header is allowed (curl, tests, the landing page); only a *known-too-old* app is stopped.
const parts = (v) => String(v).split('.').map((n) => parseInt(n, 10) || 0);
const older = (a, b) => { const x = parts(a), y = parts(b); for (let i = 0; i < 3; i++) { if ((x[i] || 0) !== (y[i] || 0)) return (x[i] || 0) < (y[i] || 0); } return false; };

export function appVersion(req, _res, next) {
  const h = req.get('x-app-version');
  if (!h || req.path === '/app-config' || req.path === '/health') return next();
  const m = /^(ios|android|web)\/(\d+(?:\.\d+){0,2})/.exec(h);
  if (m && older(m[2], config.minVersion[m[1]])) return next(new ApiError(426, 'upgrade_required', 'Please update the app to continue'));
  next();
}
