// A mock that remembers one thing: the student's verification status.
// Prism (the contract mock) runs on port 4011 and answers everything; this
// small proxy on 4010 changes only the verification fields in GET /me and
// GET /me/verification, and moves the status when the app acts:
//   POST /me/verification  -> pending
// For demos, open http://<host>:4010/mock/state/<status> to set it by hand
// (not_submitted, pending, needs_attention, rejected, approved).
// Set MOCK_BIND=0.0.0.0 to reach it from a phone.
import { spawn } from 'node:child_process';
import http from 'node:http';

const bind = process.env.MOCK_BIND ?? '127.0.0.1';
const upstreamPort = 4011;
let status = process.env.MOCK_VERIFICATION ?? 'not_submitted';

await new Promise((resolve, reject) => {
  const make = spawn('node', ['tools/make-mock-spec.mjs'], { stdio: 'inherit' });
  make.on('exit', (c) => (c === 0 ? resolve() : reject(new Error('spec build failed'))));
});

const prism = spawn(
  'node_modules/.bin/prism',
  ['mock', '.mock/openapi.mock.yaml', '-h', '127.0.0.1', '-p', String(upstreamPort)],
  { stdio: ['ignore', 'inherit', 'inherit'] },
);
prism.on('exit', (c) => process.exit(c ?? 1));
for (const sig of ['SIGINT', 'SIGTERM']) process.on(sig, () => { prism.kill(); process.exit(0); });

const messages = { needs_attention: 'The back of your card is blurry.', rejected: 'The names did not match.' };

function patch(path, text) {
  try {
    const body = JSON.parse(text);
    if (path === '/me' && body.verificationStatus !== undefined) body.verificationStatus = status;
    if (path === '/me/verification' && body.status !== undefined) {
      body.status = status;
      body.message = messages[status] ?? null;
      body.canResubmit = status === 'needs_attention' || status === 'not_submitted';
    }
    return JSON.stringify(body);
  } catch {
    return text;
  }
}

http
  .createServer((req, res) => {
    const path = new URL(req.url, 'http://x').pathname;
    const set = path.match(/^\/mock\/state\/(\w+)$/);
    if (set) {
      status = set[1];
      res.end(`verification status is now ${status}\n`);
      return;
    }
    const up = http.request(
      { host: '127.0.0.1', port: upstreamPort, method: req.method, path: req.url, headers: req.headers },
      (r) => {
        const watched = req.method === 'GET' && (path === '/me' || path === '/me/verification');
        if (req.method === 'POST' && path === '/me/verification' && r.statusCode < 300) status = 'pending';
        if (!watched) {
          res.writeHead(r.statusCode, r.headers);
          r.pipe(res);
          return;
        }
        const chunks = [];
        r.on('data', (c) => chunks.push(c));
        r.on('end', () => {
          const out = patch(path, Buffer.concat(chunks).toString('utf8'));
          const headers = { ...r.headers, 'content-length': Buffer.byteLength(out) };
          res.writeHead(r.statusCode, headers);
          res.end(out);
        });
      },
    );
    up.on('error', () => { res.statusCode = 502; res.end(); });
    req.pipe(up);
  })
  .listen(4010, bind, () => console.log(`mock on http://${bind}:4010 (verification: ${status})`));
