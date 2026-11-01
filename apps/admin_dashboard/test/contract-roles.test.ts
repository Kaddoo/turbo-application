import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { describe, expect, it } from 'vitest';
import { actions } from '@/utils/permissions';
import { areaReads, areaRoles } from '@/utils/roles';

/**
 * The role tables in the dashboard must say what the contract says. Reads
 * `x-roles` for every operation in api/contract/openapi.yaml and checks each action and
 * area against the operation behind it.
 */
const yaml = readFileSync(join(__dirname, '../../../api/contract/openapi.yaml'), 'utf8');

function contractRoles(): Map<string, string[]> {
  const out = new Map<string, string[]>();
  let path = '';
  let method = '';
  let collecting: string[] | null = null;
  for (const line of yaml.split('\n')) {
    const p = /^ {2}(\/\S+):$/.exec(line);
    if (p) path = p[1]!;
    const m = /^ {4}(get|post|put|patch|delete):$/.exec(line);
    if (m) method = m[1]!.toUpperCase();
    if (/^ {6}x-roles:/.test(line)) {
      collecting = [];
      out.set(`${method} ${path}`, collecting);
      continue;
    }
    const role = /^ {6}- (\S+)/.exec(line);
    if (collecting && role) collecting.push(role[1]!);
    else collecting = null;
  }
  return out;
}

const roles = contractRoles();
const expected = (role: string) => (role === 'any' ? 'admin:any' : `admin:${role}`);

describe('role tables match the contract x-roles', () => {
  it('found the operations', () => {
    expect(roles.size).toBeGreaterThan(50);
  });

  it.each(Object.entries(actions))('action %s', (_name, { role, op }) => {
    expect(roles.has(op), `${op} is not in the contract`).toBe(true);
    expect(roles.get(op)).toContain(expected(role));
  });

  it.each(Object.entries(areaReads))('area %s', (area, op) => {
    expect(roles.has(op), `${op} is not in the contract`).toBe(true);
    const needed: string | readonly string[] | null = areaRoles[area as keyof typeof areaReads];
    for (const role of Array.isArray(needed) ? needed : [needed])
      expect(roles.get(op)).toContain(expected(role as string));
  });
});
