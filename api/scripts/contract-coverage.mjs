// Which contract operations did the server actually answer (2xx) since its log started? Reads pino JSON lines.
import fs from 'node:fs'; import { spec } from '../src/lib/contract.js';
const log = fs.readFileSync(process.argv[2], 'utf8').split('\n').filter((l) => l.startsWith('{'));
const norm = (p) => p.replace(/\{[^}]+\}/g, ':p').replace(/:[A-Za-z]+/g, ':p');
const hit = new Map();
for (const l of log) { try { const j = JSON.parse(l); if (j.msg === 'req' && j.status < 300) hit.set(`${j.method} ${norm(j.path.replace(/^\/v1/, ''))}`, (hit.get(`${j.method} ${norm(j.path)}`) || 0) + 1); } catch { /* skip */ } }
const missing = [];
let total = 0;
for (const [path, item] of Object.entries(spec.paths)) for (const [m, o] of Object.entries(item)) {
  if (!['get', 'post', 'put', 'patch', 'delete'].includes(m) || o['x-release'] === 'v1.1') continue;
  total++; if (!hit.has(`${m.toUpperCase()} ${norm(path)}`)) missing.push(`${m.toUpperCase()} ${path}`);
}
console.log(`exercised with a 2xx answer: ${total - missing.length} of ${total} v1 operations`);
if (missing.length) console.log('NOT YET EXERCISED:\n  ' + missing.join('\n  '));
