import { spec } from '../src/lib/contract.js';
const want = process.argv.slice(2);
for (const [p, item] of Object.entries(spec.paths)) for (const [m, o] of Object.entries(item)) {
  if (!['get','post','put','patch','delete'].includes(m)) continue;
  if (want.length && !want.some((w) => p.startsWith(w))) continue;
  const errs = Object.keys(o.responses).filter((c) => +c >= 400 && !['401','429'].includes(c)).join(',');
  const d = (o.description || '').replace(/\*\*Access:\*\*[^\n]*\n*/, '').replace(/\n+/g, ' ').slice(0, 230);
  console.log(`${m.toUpperCase().padEnd(6)} ${p.padEnd(40)} ${(o['x-roles']||[]).join('|').padEnd(14)} ${errs.padEnd(12)} ${((o.parameters||[]).filter(x=>x.name).map(x=>x.name+(x.required?'*':'')).join(','))} ${d}`);
}
