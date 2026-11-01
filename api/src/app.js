import express from 'express';
import helmet from 'helmet';
import compression from 'compression';
import crypto from 'node:crypto';
import pino from 'pino';
import { config } from './config.js';
import { q } from './db.js';
import { errorHandler, ApiError } from './lib/errors.js';
import { auth } from './routes/auth.js';
import { student, sessionRoutes, messages } from './routes/student.js';
import { walletRoutes, webhook } from './routes/wallet.js';
import { driver } from './routes/driver.js';
import { admin } from './routes/admin.js';
import { finance } from './routes/finance.js';
import { hr } from './routes/hr.js';
import { staff } from './routes/staff.js';
import { uploads } from './routes/uploads.js';
import { safety } from './routes/safety.js';
import { support } from './routes/support.js';
import { authenticate } from './lib/auth.js';
import { limit } from './lib/ratelimit.js';
import { sanitizeRequest } from './lib/sanitize.js';
import { contractRequest, contractResponse } from './lib/contract.js';
import { appVersion } from './lib/appversion.js';
import { trackRequest } from './lib/alerts.js';
import { shipRequest, shipLogLine } from './lib/logpulse.js';

export const log = pino({
  level: config.logLevel, redact: ['req.headers.authorization', 'body.code', 'body.refreshToken'],
  hooks: { logMethod(args, method, level) { if (level >= 40) shipLogLine(level, args); return method.apply(this, args); } },     // warn and error go to LogPulse too
});

export function buildApp() {
  const app = express();
  app.disable('x-powered-by');
  app.set('trust proxy', 1);                 // behind nginx: req.ip is the real client
  // This is a JSON API: nothing it returns should ever be rendered, framed or cached by a browser.
  app.use(helmet({
    contentSecurityPolicy: { directives: { defaultSrc: ["'none'"], frameAncestors: ["'none'"] } },
    crossOriginResourcePolicy: { policy: 'same-site' }, referrerPolicy: { policy: 'no-referrer' },
    hsts: { maxAge: 31536000, includeSubDomains: true },
  }));
  app.use((_req, res, next) => { res.set('cache-control', 'no-store'); next(); });
  app.use(compression({ threshold: 1024 }));

  app.use((req, res, next) => {              // request id + one JSON log line per request
    req.id = req.get('x-request-id') || crypto.randomUUID();
    res.set('x-request-id', req.id);
    const t = process.hrtime.bigint();
    res.on('finish', () => {
      if (req.path !== '/health') trackRequest(res.statusCode);          // feeds the 5xx-rate alert
      if (req.path === '/health' && res.statusCode < 400) return;
      const ms = Number(process.hrtime.bigint() - t) / 1e6 | 0;
      log.info({ reqId: req.id, method: req.method, path: req.route?.path || req.path, status: res.statusCode, ms }, 'req');
      shipRequest({ method: req.method, route: req.route?.path || req.path, status: res.statusCode, ms, reqId: req.id });
    });
    next();
  });

  // The contract's server URLs end in /v1 (https://api.turbo.invalid/v1), while the local mock serves the bare paths.
  // Accept both, so a client works whichever base URL it was configured with.
  app.use((req, _res, next) => { if (req.url === '/v1' || req.url.startsWith('/v1/') || req.url.startsWith('/v1?')) req.url = req.url.slice(3) || '/'; next(); });

  // CORS: browsers may call us only from origins we list (dashboard, student web). Mobile apps do not use CORS.
  // No wildcard and no credentials: tokens travel in the Authorization header, so there is no cookie to ride on.
  app.use((req, res, next) => {
    const origin = req.get('origin');
    if (origin && config.corsOrigins.includes(origin)) {
      // credentials: the web apps keep their refresh token in an httpOnly cookie (see lib/session.js)
      res.set({ 'access-control-allow-origin': origin, vary: 'Origin', 'access-control-allow-credentials': 'true', 'access-control-expose-headers': 'x-request-id, retry-after' });
      if (req.method === 'OPTIONS') {
        res.set({ 'access-control-allow-methods': 'GET, POST, PUT, PATCH, DELETE', 'access-control-max-age': '600',
          'access-control-allow-headers': 'authorization, content-type, idempotency-key, x-app-version, x-request-id' });
        return res.status(204).end();
      }
    } else if (req.method === 'OPTIONS') return res.status(204).end();
    next();
  });

  // Flood guard for requests that carry NO token (sign-in, public share links, junk). Signed-in traffic is limited per account in
  // lib/auth.js instead: campus Wi-Fi and mobile carriers put thousands of real users behind one IP, and a per-IP cap would lock them all out.
  app.use(limit('ip', config.rateIpPerMin, 60_000, (req) => (req.get('authorization') ? null : req.ip)));

  // Webhook first: it needs the RAW body, so it must be mounted before express.json().
  app.use(webhook);
  app.use(express.json({ limit: '100kb' }));
  app.use(sanitizeRequest);
  app.use(appVersion);
  app.use(contractRequest, contractResponse);

  app.use(auth, staff, uploads, safety, support, student, sessionRoutes, messages, walletRoutes, driver, admin, finance, hr);
  app.use((_req, _res, next) => next(new ApiError(404, 'not_found', 'No such route')));
  app.use(errorHandler(log));
  return app;
}
