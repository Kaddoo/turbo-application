import crypto from 'node:crypto';
import fs from 'node:fs/promises';
import path from 'node:path';
import { config } from '../config.js';
import { derive } from './secrets.js';

// Private object storage. The "local" driver keeps files in a directory that nginx never serves;
// the only way to read or write is a URL signed by us that expires in minutes. An S3-compatible driver
// can replace this file without touching the routes: the contract only sees signed URLs.
const root = path.resolve(config.uploadDir);
const sig = (method, id, exp) => crypto.createHmac('sha256', derive('upload-url')).update(`${method}:${id}:${exp}`).digest('base64url');

export function signedUrl(method, id, ttlSeconds) {
  const exp = Math.floor(Date.now() / 1000) + ttlSeconds;
  const kind = method === 'PUT' ? 'content' : 'file';
  const base = method === 'PUT' ? '/uploads' : '/files';
  return { url: `${config.publicUrl}${base}/${id}/${kind}?exp=${exp}&sig=${sig(method, id, exp)}`, expiresAt: new Date(exp * 1000) };
}

export function checkSignature(method, id, exp, s) {
  const e = Number(exp);
  if (!Number.isInteger(e) || e < Date.now() / 1000 || typeof s !== 'string') return false;
  const want = Buffer.from(sig(method, id, e)), got = Buffer.from(s);
  return want.length === got.length && crypto.timingSafeEqual(want, got);
}

const file = (key) => {
  const p = path.join(root, key);
  if (!p.startsWith(root + path.sep)) throw new Error('bad storage key');
  return p;
};
export const newKey = (id) => `${new Date().toISOString().slice(0, 7)}/${id}`;
export async function put(key, buf) { const p = file(key); await fs.mkdir(path.dirname(p), { recursive: true }); await fs.writeFile(p, buf, { mode: 0o600 }); }
export const get = (key) => fs.readFile(file(key));
export const remove = (key) => fs.rm(file(key), { force: true });

// Declared type must match the first bytes, so a PDF cannot be uploaded as "image/png".
export function sniff(buf, declared) {
  // A CSV has no magic bytes: it must be valid UTF-8 text with no NUL or control bytes (so a binary cannot hide behind text/csv).
  if (declared === 'text/csv') return buf.length < 5_000_000 && !/[\u0000-\u0008\u000b\u000c\u000e-\u001f]/.test(buf.toString('utf8')) && !buf.toString('utf8').includes('\ufffd') ? 'text/csv' : null;
  if (buf.length > 3 && buf[0] === 0xff && buf[1] === 0xd8 && buf[2] === 0xff) return 'image/jpeg';
  if (buf.length > 8 && buf.subarray(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]))) return 'image/png';
  if (buf.length > 5 && buf.subarray(0, 5).toString('latin1') === '%PDF-') return 'application/pdf';
  return null;
}
