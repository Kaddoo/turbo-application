// Prints every component schema as a compact TypeScript-like signature (for humans comparing code to contract).
import fs from 'node:fs'; import YAML from 'yaml';
const spec = YAML.parse(fs.readFileSync(new URL('../../Docs/api/openapi.yaml', import.meta.url), 'utf8'));
const ts = (s, d = 0) => {
  if (!s) return 'any';
  if (s.$ref) return s.$ref.split('/').pop();
  if (s.oneOf) return s.oneOf.map((x) => ts(x, d)).join(' | ');
  if (s.enum) return s.enum.map((x) => JSON.stringify(x)).join('|');
  if (Array.isArray(s.type)) return s.type.map((t) => ts({ ...s, type: t }, d)).join('|');
  if (s.type === 'array') return `${ts(s.items, d)}[]`;
  if (s.type === 'object' || s.properties) {
    const req = new Set(s.required || []);
    const props = Object.entries(s.properties || {}).map(([k, v]) => `${k}${req.has(k) ? '' : '?'}: ${ts(v, d + 1)}`);
    return `{ ${props.join('; ')} }`;
  }
  if (s.type === 'string' && s.format) return `string(${s.format})`;
  if (s.type === 'string' && s.pattern) return `string(${s.pattern})`;
  return s.type || 'any';
};
for (const [n, s] of Object.entries(spec.components.schemas)) console.log(`${n} = ${ts(s)}`);
