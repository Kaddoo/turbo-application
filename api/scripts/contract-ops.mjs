import fs from 'node:fs'; import YAML from 'yaml';
const spec = YAML.parse(fs.readFileSync(new URL('../contract/openapi.yaml', import.meta.url),'utf8'));
const ref = (o) => o?.$ref?.split('/').pop() ?? (o?.type === 'array' ? '[' + ref(o.items) + ']' : o?.type ?? '?');
for (const [path, ops] of Object.entries(spec.paths)) for (const [m, o] of Object.entries(ops)) {
  if (!['get','post','put','patch','delete'].includes(m)) continue;
  const rq = o.requestBody?.content?.['application/json']?.schema;
  const rs = Object.entries(o.responses).filter(([c]) => /^2/.test(c)).map(([c, r]) => c + ':' + (r.content ? ref(r.content['application/json']?.schema) : '-')).join(' ');
  console.log(`${m.toUpperCase().padEnd(6)} ${path.padEnd(42)} ${rq ? 'REQ ' + ref(rq) : ''}  ${rs}  ${(o.parameters||[]).filter(p=>p.in==='header').map(p=>p.name||p.$ref).join(',')}`);
}
