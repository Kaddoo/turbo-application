import nodemailer from 'nodemailer';
import { config } from '../config.js';

// Outbound SMS and email. SMS is a plain HTTPS call (no SDK); email is SMTP via nodemailer. Failures throw; callers decide
// whether that is fatal (OTP: yes, tell the user) or not (invite email: the admin can resend).
const post = async (url, headers, body, name) => {
  const r = await fetch(url, { method: 'POST', headers: { 'content-type': 'application/json', ...headers },
    body: JSON.stringify(body), signal: AbortSignal.timeout(8000) });
  if (!r.ok) throw new Error(`${name} ${r.status}`);
  return r.json().catch(() => ({}));
};

export async function sendSms(phone, text) {
  if (config.smsProvider === 'texify') {
    // https://api.texify.org : POST /messages/send. Recipients are E.164 with "+". Invalid numbers come back in data.invalidPhones.
    const j = await post('https://api.texify.org/api/v1/messages/send', { 'X-API-Key': config.texifyKey },
      { message: text, recipients: [phone], senderId: config.smsSender }, 'texify');
    if (j.status !== 'success') throw new Error(`texify ${j.message || j.status}`);
    if (j.data?.invalidPhones?.length) throw new Error('texify invalid phone');
    return;
  }
  if (config.env !== 'production') console.log(`[sms:console] -> ${phone.slice(0, 7)}***: ${text}`);
}

let transport;
const mailer = () => transport ||= nodemailer.createTransport({
  host: config.smtpHost, port: config.smtpPort, secure: config.smtpPort === 465,   // 465 = implicit TLS; 587 upgrades with STARTTLS
  auth: config.smtpUser ? { user: config.smtpUser, pass: config.smtpPass } : undefined,
  connectionTimeout: 8000, greetingTimeout: 8000, socketTimeout: 8000,
});

export async function sendEmail(to, subject, text) {
  if (config.emailProvider === 'smtp') {
    await mailer().sendMail({ from: config.emailFrom, to, subject, text });
    return;
  }
  if (config.env !== 'production') console.log(`[email:console] -> ${to}: ${subject}\n${text}`);
}
