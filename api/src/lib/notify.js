import { config } from '../config.js';

// Outbound SMS and email. Providers are plain HTTPS calls (no SDKs). Failures throw; callers decide
// whether that is fatal (OTP: yes, tell the user) or not (invite email: the admin can resend).
const post = async (url, headers, body, name) => {
  const r = await fetch(url, { method: 'POST', headers: { 'content-type': 'application/json', ...headers },
    body: JSON.stringify(body), signal: AbortSignal.timeout(8000) });
  if (!r.ok) throw new Error(`${name} ${r.status}`);
  return r.json().catch(() => ({}));
};

export async function sendSms(phone, text) {
  if (config.smsProvider === 'arkesel') {
    // https://developers.arkesel.com : v2 send. Recipients are digits only, no "+".
    const j = await post('https://sms.arkesel.com/api/v2/sms/send', { 'api-key': config.arkeselKey },
      { sender: config.smsSender, message: text, recipients: [phone.replace('+', '')] }, 'arkesel');
    if (j.status && j.status !== 'success') throw new Error(`arkesel ${j.message || j.status}`);
    return;
  }
  if (config.env !== 'production') console.log(`[sms:console] -> ${phone.slice(0, 7)}***: ${text}`);
}

export async function sendEmail(to, subject, text) {
  if (config.emailProvider === 'resend') {
    await post('https://api.resend.com/emails', { Authorization: `Bearer ${config.resendKey}` },
      { from: config.emailFrom, to: [to], subject, text }, 'resend');
    return;
  }
  if (config.env !== 'production') console.log(`[email:console] -> ${to}: ${subject}\n${text}`);
}
