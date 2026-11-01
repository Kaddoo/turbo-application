// Lists contract operations the API does not implement, and API routes the contract does not describe.
import fs from 'node:fs';
import YAML from 'yaml';
import { buildApp } from '../src/app.js';
const spec = YAML.parse(fs.readFileSync(new URL('../contract/openapi.yaml', import.meta.url), 'utf8'));
const norm = (p) => p.replace(/\{[^}]+\}/g, ':p').replace(/:[A-Za-z]+/g, ':p');
const contract = new Map();
for (const [path, ops] of Object.entries(spec.paths))
  for (const [m, o] of Object.entries(ops)) if (['get', 'post', 'put', 'patch', 'delete'].includes(m))
    contract.set(`${m.toUpperCase()} ${norm(path)}`, { path, id: o.operationId, tag: o.tags?.[0], release: o['x-release'], roles: o['x-roles'] });
const app = buildApp(); const impl = new Set();
const walk = (stack) => { for (const l of stack) { if (l.route) for (const m of Object.keys(l.route.methods)) impl.add(`${m.toUpperCase()} ${norm(l.route.path)}`); else if (l.handle?.stack) walk(l.handle.stack); } };
walk(app.router.stack);
const missing = [...contract].filter(([k]) => !impl.has(k)), extra = [...impl].filter((k) => !contract.has(k));
console.log(`contract ${contract.size} operations, implemented ${contract.size - missing.length}, missing ${missing.length}, undocumented routes ${extra.length}`);
console.log('\nMISSING (v1 first):');
for (const [k, v] of missing.sort((a, b) => (a[1].release === 'v1' ? 0 : 1) - (b[1].release === 'v1' ? 0 : 1) || a[1].tag?.localeCompare(b[1].tag))) console.log(`  ${v.release.padEnd(5)} ${v.tag?.padEnd(18)} ${k.replace(/:p/g, '{}')}  ${v.path}`);
console.log('\nUNDOCUMENTED:'); extra.forEach((k) => console.log('  ' + k));
process.exit(0);
