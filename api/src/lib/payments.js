import crypto from 'node:crypto';
import { config } from '../config.js';

// Provider adapter. The fake provider lets the demo and tests run with no Payaza account.
// The Payaza adapter is the production shape from docs/08; keys arrive after Turbo's KYB.
export const sign = (rawBody, secret = config.payazaSecret) =>
  crypto.createHmac('sha512', secret).update(rawBody).digest('base64');

export function verifyWebhook(rawBody, header) {
  if (!header || !Buffer.isBuffer(rawBody)) return false;
  const a = Buffer.from(sign(rawBody)), b = Buffer.from(header);
  return a.length === b.length && crypto.timingSafeEqual(a, b);
}

const fake = {
  async createCollection({ reference }) { return { providerRef: reference, status: 'pending' }; },
  async checkStatus() { return { status: 'pending' }; },
};

const payaza = {
  async createCollection({ reference, amountPesewas, phone, network }) {
    // Integer maths only: pesewas -> "12.50"
    const amount = `${Math.floor(amountPesewas / 100)}.${String(amountPesewas % 100).padStart(2, '0')}`;
    const key = process.env.PAYAZA_PUBLIC_KEY_B64;
    const r = await fetch('https://api.payaza.africa/live/subsidiary/collections/v1/process-collection', {
      method: 'POST',
      headers: { 'content-type': 'application/json', Authorization: `Payaza ${key}`, 'X-TenantID': process.env.PAYAZA_TENANT || 'test' },
      body: JSON.stringify({ transaction_reference: reference, amount, currency: 'GHS', country_code: 'GH',
        customer_phone: phone.replace('+', ''), customer_bank_code: network }),
      signal: AbortSignal.timeout(8000),
    });
    if (!r.ok) throw new Error(`payaza ${r.status}`);
    return { providerRef: reference, status: 'pending' };
  },
  // Returns { status: 'success'|'failed'|'pending'|'unknown', amountReceived? (cedis string) }.
  // Codes per docs/08: 00 success, 06/96 failed, 09 pending. The response field names below are read defensively:
  // CONFIRM THEM against a real sandbox response before go-live (spec/04 launch checklist).
  async checkStatus({ reference }) {
    const key = process.env.PAYAZA_PUBLIC_KEY_B64;
    const r = await fetch(`https://api.payaza.africa/live/subsidiary/collections/v1/check-status?transaction_reference=${encodeURIComponent(reference)}&country_code=GH`, {
      headers: { Authorization: `Payaza ${key}`, 'X-TenantID': process.env.PAYAZA_TENANT || 'test' }, signal: AbortSignal.timeout(8000) });
    if (r.status === 404) return { status: 'unknown' };
    if (!r.ok) throw new Error(`payaza check-status ${r.status}`);
    const j = await r.json();
    const d = j.data ?? j;
    const code = String(d.response_code ?? d.status_code ?? j.response_code ?? '');
    const text = String(d.transaction_status ?? d.status ?? '');
    const amountReceived = d.amount_received ?? d.amount ?? null;
    if (code === '00' || text === 'Funds Received') return { status: 'success', amountReceived };
    if (code === '06' || code === '96' || text === 'Transaction Failed') return { status: 'failed' };
    if (code === '09') return { status: 'pending' };
    return { status: 'unknown' };
  },
};

export const provider = () => (config.paymentProvider === 'payaza' ? payaza : fake);
