#!/usr/bin/env node
// Contract guard. Fails when:
//   1. a second OpenAPI file exists anywhere in the repo (the one source is api/contract/openapi.yaml), or
//   2. a generated client was built from a different version of the contract than the one in the repo.
// Each generator writes the sha256 of the contract it used next to its output (see packages/turbo_api/tool/generate.sh and
// the dashboard's `gen:api`); this compares them. Run: node tools/check-contract.mjs (also wired into .github/workflows/contract.yml).
import { createHash } from 'node:crypto';
import { readFileSync, existsSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(fileURLToPath(import.meta.url), '../..');
const SOURCE = 'api/contract/openapi.yaml';
const sha = (p) => createHash('sha256').update(readFileSync(join(root, p))).digest('hex');
const problems = [];

// Tracked files only: a local scratch copy (git-ignored) is not a second source.
const tracked = execFileSync('git', ['ls-files'], { cwd: root, encoding: 'utf8', maxBuffer: 64 * 1024 * 1024 }).split('\n');
for (const f of tracked) if (/(^|\/)openapi[^/]*\.ya?ml$/i.test(f) && f !== SOURCE) problems.push(`second contract file: ${f} (the only source is ${SOURCE})`);

if (!existsSync(join(root, SOURCE))) problems.push(`${SOURCE} is missing`);
else {
  const want = sha(SOURCE);
  const version = /^\s{2}version:\s*(\S+)/m.exec(readFileSync(join(root, SOURCE), 'utf8'))?.[1];
  for (const [label, stamp] of [['Dart client', 'packages/turbo_api/generated/.contract-sha256'], ['dashboard schema', 'apps/admin_dashboard/src/types/.contract-sha256']]) {
    if (!existsSync(join(root, stamp))) { problems.push(`${label}: ${stamp} is missing (regenerate it)`); continue; }
    const got = readFileSync(join(root, stamp), 'utf8').trim();
    if (got !== want) problems.push(`${label} was generated from a different contract (stamp ${got.slice(0, 8)}, contract ${want.slice(0, 8)}, version ${version}). Regenerate it.`);
  }
}

if (problems.length) { console.error('Contract check failed:\n - ' + problems.join('\n - ')); process.exit(1); }
console.log('Contract check passed: one contract file, generated clients match it.');
