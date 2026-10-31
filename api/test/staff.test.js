// Pure unit checks for MFA primitives. The full staff lifecycle is exercised end to end in walk4.test.js.
import test from 'node:test';
import assert from 'node:assert/strict';
import { codeAt, stepNow, newSecret, verifyTotp } from '../src/lib/totp.js';
import { seal, open } from '../src/lib/secrets.js';

test('TOTP matches the RFC 6238 vector, rejects replay, and secrets round-trip sealed', () => {
  const rfc = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ';                       // ASCII "12345678901234567890"
  assert.equal(codeAt(rfc, 1), '287082');                               // t=59s, last 6 digits of 94287082
  const s = newSecret(), now = 1_700_000_000_000, step = stepNow(now);
  assert.equal(verifyTotp(s, codeAt(s, step), { now }), step);
  assert.equal(verifyTotp(s, codeAt(s, step), { now, lastStep: step }), null, 'same code twice');
  assert.equal(verifyTotp(s, codeAt(s, step + 5), { now }), null, 'outside the drift window');
  assert.equal(open(seal(s)), s);
});
