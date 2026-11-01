import { createHmac } from 'node:crypto';
import { readFileSync, writeFileSync } from 'node:fs';
import { afterAll, describe, expect, it, vi } from 'vitest';

/**
 * Does the API itself refuse what the dashboard hides? Signs in as each staff
 * role and calls every admin list read (GET, no path parameters, so nothing
 * changes) that role is NOT allowed by the contract's x-roles. Each must come
 * back 403. The ones it is allowed must not.
 *
 * Read-only. Never part of `npm test`. Run with:
 *   LIVE_API_URL=https://api.example/v1 \
 *   LIVE_ROLE_ACCOUNTS="verifier=verifier@x,dispatcher=dispatch@x,finance=finance@x,support=support@x,hr=hr@x" \
 *   LIVE_PASSWORD=… [LIVE_TOTP_SECRETS="verifier=BASE32,…"] npm run test:live -- roles
 * Staging enforces MFA, so each account needs its authenticator secret (the
 * setup key shown when the invite was accepted) to make a code here. Secrets
 * and tokens are never printed; results go to test/live/roles-results.json.
 */
const base = process.env.LIVE_API_URL;
if (!base) throw new Error('Set LIVE_API_URL');
vi.stubEnv('VITE_API_BASE_URL', base);

const { api, call, setAccessToken } = await import('@/services/http');
const { ApiError } = await import('@/utils/problems');

const pairs = (raw: string | undefined) =>
  new Map((raw ?? '').split(',').flatMap((p) => (p.includes('=') ? [p.split('=', 2) as [string, string]] : [])));
const accounts = pairs(process.env.LIVE_ROLE_ACCOUNTS);
const secrets = pairs(process.env.LIVE_TOTP_SECRETS);
const password = process.env.LIVE_PASSWORD ?? '';

/** RFC 6238 code from a base32 setup key. */
function totp(secret: string, at = Date.now()): string {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  let bits = '';
  for (const ch of secret.replace(/=+$/, '').toUpperCase()) bits += alphabet.indexOf(ch).toString(2).padStart(5, '0');
  const key = Buffer.from(bits.match(/.{8}/g)!.map((b) => parseInt(b, 2)));
  const counter = Buffer.alloc(8);
  counter.writeBigUInt64BE(BigInt(Math.floor(at / 30_000)));
  const h = createHmac('sha1', key).update(counter).digest();
  const o = h[h.length - 1]! & 0xf;
  return String((h.readUInt32BE(o) & 0x7fffffff) % 1_000_000).padStart(6, '0');
}

/** GET /admin/* list reads without path parameters, with their x-roles. */
function listReads(): [string, string[]][] {
  const yaml = readFileSync(new URL('../../../../api/contract/openapi.yaml', import.meta.url), 'utf8');
  const out: [string, string[]][] = [];
  let path = '';
  let method = '';
  let roles: string[] | null = null;
  for (const line of yaml.split('\n')) {
    const p = /^ {2}(\/\S+):$/.exec(line);
    if (p) path = p[1]!;
    const m = /^ {4}(get|post|put|patch|delete):$/.exec(line);
    if (m) method = m[1]!;
    if (/^ {6}x-roles:/.test(line)) {
      roles = [];
      if (method === 'get' && path.startsWith('/admin/') && !path.includes('{')) out.push([path, roles]);
      continue;
    }
    const r = /^ {6}- (\S+)/.exec(line);
    if (roles && r) roles.push(r[1]!);
    else roles = null;
  }
  return out;
}

type Result = { role: string; endpoint: string; allowed: boolean; status: number; ok: boolean };
const results: Result[] = [];
afterAll(() =>
  writeFileSync(
    new URL('./roles-results.json', import.meta.url),
    JSON.stringify({ base, at: new Date().toISOString(), results }, null, 2),
  ),
);

const reads = listReads();

describe.skipIf(accounts.size === 0)(`role enforcement on ${base}`, () => {
  for (const [role, email] of accounts) {
    it(`${role}: refused everywhere the contract says no`, async () => {
      setAccessToken(null);
      const secret = secrets.get(role);
      const t = await call(
        api.POST('/auth/admin/login', { body: { email, password, ...(secret ? { totpCode: totp(secret) } : {}) } }),
      );
      expect(t.user.staffRole).toBe(role);
      setAccessToken(t.accessToken);
      const wrong: string[] = [];
      for (const [path, xRoles] of reads) {
        // Super admin may use every admin operation (contract convention), so it is never expected to be refused.
        const allowed = role === 'super_admin' || xRoles.includes('admin:any') || xRoles.includes(`admin:${role}`);
        // Typed paths are checked at compile time elsewhere; here the path comes from the contract file.
        const status = await call(api.GET(path as never))
          .then(() => 200)
          .catch((e: unknown) => (e instanceof ApiError ? e.status : -1));
        const ok = allowed ? status !== 403 : status === 403;
        results.push({ role, endpoint: `GET ${path}`, allowed, status, ok });
        if (!ok) wrong.push(`GET ${path} → ${status} (${allowed ? 'should be allowed' : 'should be 403'})`);
      }
      setAccessToken(null);
      expect(wrong).toEqual([]);
    });
  }
});

it.skipIf(accounts.size > 0)('needs LIVE_ROLE_ACCOUNTS to run', () => undefined);
