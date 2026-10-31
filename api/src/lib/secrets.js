import crypto from 'node:crypto';
import { config } from '../config.js';

// AES-256-GCM for secrets we must read back (MFA seeds). Key is separate from JWT_SECRET so
// rotating JWT_SECRET (which signs everyone out) never locks staff out of their authenticators.
const key = () => crypto.createHash('sha256').update(config.dataKey).digest();

export function seal(plain) {
  const iv = crypto.randomBytes(12), c = crypto.createCipheriv('aes-256-gcm', key(), iv);
  const enc = Buffer.concat([c.update(plain, 'utf8'), c.final()]);
  return `v1.${iv.toString('base64url')}.${enc.toString('base64url')}.${c.getAuthTag().toString('base64url')}`;
}
export function open(sealed) {
  const [v, iv, enc, tag] = String(sealed).split('.');
  if (v !== 'v1') throw new Error('unknown secret format');
  const d = crypto.createDecipheriv('aes-256-gcm', key(), Buffer.from(iv, 'base64url'));
  d.setAuthTag(Buffer.from(tag, 'base64url'));
  return Buffer.concat([d.update(Buffer.from(enc, 'base64url')), d.final()]).toString('utf8');
}

// Separate keys per purpose from the one master secret, so a signature made for one job can never be replayed for another.
export const derive = (label) => crypto.createHmac('sha256', config.dataKey).update(`turbo:${label}`).digest();
