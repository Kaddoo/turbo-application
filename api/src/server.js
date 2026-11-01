import cluster from 'node:cluster';
import os from 'node:os';
import { config } from './config.js';
import { buildApp, log } from './app.js';
import { pool } from './db.js';
import { announceAlerts, checkErrorRate } from './lib/alerts.js';

const workers = config.webConcurrency || os.availableParallelism();

// One API process per core. PM2 can do this instead (see deploy/); this makes `npm start` scale on its own.
if (cluster.isPrimary && workers > 1 && config.env === 'production') {
  log.info({ workers }, 'starting cluster');
  for (let i = 0; i < workers; i++) cluster.fork();
  cluster.on('exit', (w, code) => { log.error({ pid: w.process.pid, code }, 'worker died, restarting'); cluster.fork(); });
} else {
  const server = buildApp().listen(config.port, config.host, () => log.info({ host: config.host, port: config.port, pid: process.pid }, 'api listening'));
  announceAlerts(log);
  setInterval(() => checkErrorRate().catch(() => {}), 30_000).unref();      // 5xx over 2% for 5 minutes
  server.keepAliveTimeout = 65_000;          // longer than nginx upstream keepalive
  server.headersTimeout = 66_000;
  server.requestTimeout = 60_000;            // a full request (incl. a 10 MB photo on a slow phone) must arrive within a minute: slow-loris protection
  server.maxRequestsPerSocket = 1000;
  const stop = () => { server.close(async () => { await pool.end(); process.exit(0); }); setTimeout(() => process.exit(1), 10_000).unref(); };
  process.on('SIGTERM', stop); process.on('SIGINT', stop);
}
