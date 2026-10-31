const e = process.env;
export const config = {
  // Fail closed: a deploy that forgets NODE_ENV runs the strict production checks, never the demo shortcuts.
  env: e.NODE_ENV || 'production',
  port: Number(e.PORT || 3000),
  databaseUrl: e.DATABASE_URL || 'postgres://localhost:5432/turbo',
  poolMax: Number(e.PG_POOL_MAX || 10),
  jwtSecret: e.JWT_SECRET || 'dev-secret-dev-secret-dev-secret-00',
  otpMode: e.OTP_MODE || (e.NODE_ENV === 'development' ? 'fixed' : 'sms'),
  paymentProvider: e.PAYMENT_PROVIDER || (e.NODE_ENV === 'development' ? 'fake' : 'payaza'),
  payazaSecret: e.PAYAZA_WEBHOOK_SECRET || 'dev-payaza-secret',
  googleKey: e.GOOGLE_MAPS_KEY || '',
  webConcurrency: Number(e.WEB_CONCURRENCY || 0),
  logLevel: e.LOG_LEVEL || 'info',
  dataKey: e.DATA_ENC_KEY || 'dev-data-key-dev-data-key-dev-0',
  staffMfa: e.STAFF_MFA || (e.NODE_ENV === 'production' ? 'required' : 'optional'),   // required | optional
  smsProvider: e.SMS_PROVIDER || 'console',
  texifyKey: e.TEXIFY_API_KEY || '',
  smsSender: e.SMS_SENDER || 'Turbo',
  emailProvider: e.EMAIL_PROVIDER || 'console',
  smtpHost: e.SMTP_HOST || '',
  smtpPort: Number(e.SMTP_PORT || 587),
  smtpUser: e.SMTP_USER || '',
  smtpPass: e.SMTP_PASS || '',
  emailFrom: e.EMAIL_FROM || 'Turbo <no-reply@localhost>',
  uploadDir: e.UPLOAD_DIR || './data/uploads',
  publicUrl: (e.PUBLIC_URL || `http://localhost:${e.PORT || 3000}`).replace(/\/$/, ''),
  shareBaseUrl: (e.SHARE_BASE_URL || `${(e.PUBLIC_URL || `http://localhost:${e.PORT || 3000}`).replace(/\/$/, '')}/t`).replace(/\/$/, ''),
  host: e.HOST || '127.0.0.1',                                   // nginx is the only thing that should reach the API
  corsOrigins: [e.ADMIN_URL || 'http://localhost:5173', ...(e.CORS_ORIGINS || '').split(',')].map((x) => (x || '').trim().replace(/\/$/, '')).filter(Boolean),
  rateUserPerMin: Number(e.RATE_LIMIT_PER_MIN || 300),
  rateIpPerMin: Number(e.RATE_LIMIT_IP_PER_MIN || 3000),    // high on purpose: campus Wi-Fi and mobile carriers put thousands of people behind one IP
  otpGlobalPerHour: Number(e.OTP_GLOBAL_PER_HOUR || 3000),   // hard ceiling on SMS spend if someone tries to pump codes
  termsVersion: e.TERMS_VERSION || '1.0',
  privacyVersion: e.PRIVACY_VERSION || '1.0',
  termsUrl: e.TERMS_URL || 'https://turbo.example/terms',
  privacyUrl: e.PRIVACY_URL || 'https://turbo.example/privacy',
  locationNoticeUrl: e.LOCATION_NOTICE_URL || '',
  minVersion: { ios: e.MIN_APP_VERSION_IOS || e.MIN_APP_VERSION || '0.0.0', android: e.MIN_APP_VERSION_ANDROID || e.MIN_APP_VERSION || '0.0.0', web: e.MIN_APP_VERSION_WEB || e.MIN_APP_VERSION || '0.0.0' },
  maintenance: e.MAINTENANCE === 'true', maintenanceMessage: e.MAINTENANCE_MESSAGE || '',
  // Push: 'fcm' (Firebase Cloud Messaging, production), 'console' (development: logs instead of sending), 'off'.
  pushProvider: e.FCM_PROVIDER || (e.NODE_ENV === 'development' ? 'console' : 'fcm'),
  fcmServiceAccount: e.FCM_SERVICE_ACCOUNT || '',          // path to the service-account JSON, or the JSON itself
  adminUrl: e.ADMIN_URL || 'http://localhost:5173',
};
if (config.env === 'production') {
  if (config.jwtSecret.length < 32 || config.jwtSecret.startsWith('dev-')) throw new Error('JWT_SECRET must be set to a strong value in production');
  if (config.otpMode === 'fixed') throw new Error('OTP_MODE=fixed is not allowed in production');
  if (config.dataKey.length < 32 || config.dataKey.startsWith('dev-')) throw new Error('DATA_ENC_KEY must be set (32+ chars) in production');
  if (config.staffMfa !== 'required') throw new Error('STAFF_MFA must be "required" in production');
  if (config.otpMode === 'sms' && config.smsProvider === 'console') throw new Error('OTP_MODE=sms needs SMS_PROVIDER=texify (console would send nothing)');
  if (config.smsProvider === 'texify' && !config.texifyKey) throw new Error('TEXIFY_API_KEY missing');
  if (config.emailProvider === 'smtp' && !config.smtpHost) throw new Error('SMTP_HOST missing');
  if (config.emailProvider === 'console') throw new Error('EMAIL_PROVIDER=smtp is required in production: staff invites and resets are sent by email');
  if (config.paymentProvider === 'payaza' && (config.payazaSecret.startsWith('dev-') || !process.env.PAYAZA_PUBLIC_KEY_B64))
    throw new Error('PAYAZA_WEBHOOK_SECRET and PAYAZA_PUBLIC_KEY_B64 must be set when PAYMENT_PROVIDER=payaza');
  if (config.dataKey === config.jwtSecret) throw new Error('DATA_ENC_KEY must differ from JWT_SECRET');
  if (!config.publicUrl.startsWith('https://')) throw new Error('PUBLIC_URL must be the https address of the API (signed upload links use it)');
  if (!config.shareBaseUrl.startsWith('https://')) throw new Error('SHARE_BASE_URL must be https');
  if (config.corsOrigins.some((o) => o === '*' || o.startsWith('http://'))) throw new Error('CORS origins must be explicit https origins');
  if (!/^https:\/\//.test(config.termsUrl) || !/^https:\/\//.test(config.privacyUrl) || /turbo\.example/.test(config.termsUrl + config.privacyUrl)) throw new Error('TERMS_URL and PRIVACY_URL must be the real https pages (the apps show them to students)');
  if (config.pushProvider === 'console') throw new Error('FCM_PROVIDER=console is development only; use fcm (or off to disable push)');
  if (config.pushProvider === 'fcm' && !config.fcmServiceAccount) throw new Error('FCM_SERVICE_ACCOUNT missing (path to the Firebase service-account JSON)');
  if (config.paymentProvider === 'fake') throw new Error('PAYMENT_PROVIDER=fake is not allowed in production');
}
