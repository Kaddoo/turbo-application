import { useEffect, useState, type FormEvent } from 'react';
import QRCode from 'qrcode';
import { Link, useNavigate, useSearchParams } from 'react-router';
import { api, call, isDemo } from '@/services/http';
import type { Schemas } from '@/types';
import { useSession } from '@/state/session';
import { strings } from '@/app/strings';
import { Banner, Button, TextField } from '@/components';
import { ApiError, problemMessage } from '@/utils/problems';
import a from '@/pages/auth.module.css';

/** Email and password, then the 6-digit authenticator code (contract: adminLogin). */
export function SignInPage() {
  const { signIn, signedOutReason } = useSession();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [code, setCode] = useState('');
  const [step, setStep] = useState<'password' | 'mfa'>('password');
  const [error, setError] = useState<unknown>(null);
  const [busy, setBusy] = useState(false);

  async function submit(e: FormEvent) {
    e.preventDefault();
    setBusy(true);
    setError(null);
    try {
      await signIn({ email, password, ...(step === 'mfa' ? { totpCode: code } : {}) });
      navigate('/', { replace: true });
    } catch (err) {
      if (err instanceof ApiError && err.code === 'mfa_required' && step === 'password') {
        setStep('mfa');
      } else {
        setError(err);
        if (step === 'mfa') setCode('');
      }
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className={a.wrap}>
      <form className={a.panel} onSubmit={submit} noValidate>
        <span className={a.brand}>{strings.appName}</span>
        <div>
          <h1 className={a.title}>{step === 'password' ? 'Staff sign in' : 'Enter your code'}</h1>
          <p className={a.text}>
            {step === 'password'
              ? 'Use the email your administrator invited.'
              : 'Open your authenticator app and enter the 6-digit code.'}
          </p>
        </div>
        {signedOutReason === 'idle' && <Banner tone="warning">You were signed out after 15 minutes without activity.</Banner>}
        {step === 'password' ? (
          <>
            <TextField label="Email" type="email" autoComplete="username" value={email} onChange={(e) => setEmail(e.target.value)} required />
            <TextField label="Password" type="password" autoComplete="current-password" value={password} onChange={(e) => setPassword(e.target.value)} required minLength={10} />
          </>
        ) : (
          <TextField label="Authenticator code" inputMode="numeric" autoComplete="one-time-code" pattern="[0-9]{6}" maxLength={6}
            value={code} onChange={(e) => setCode(e.target.value.replace(/\D/g, ''))} autoFocus required />
        )}
        {error ? <p role="alert" style={{ margin: 0 }} className={a.text}>{problemMessage(error)}</p> : null}
        <Button variant="primary" type="submit" busy={busy} disabled={step === 'password' ? !email || password.length < 10 : code.length !== 6}>
          {step === 'password' ? 'Continue' : 'Sign in'}
        </Button>
        <div className={a.links}>
          {step === 'mfa'
            ? <button type="button" className={a.link} onClick={() => { setStep('password'); setCode(''); setError(null); }}>Use a different account</button>
            : <Link to="/forgot-password">Forgot password?</Link>}
        </div>
        {isDemo && (
          <p className={a.notice}>
            Demo data. Any email and a 10-character password work, and any 6-digit code. Start the email with a role
            (verifier@, dispatch@, finance@, support@, hr@) to see that role’s view.
          </p>
        )}
      </form>
    </div>
  );
}

export function ForgotPasswordPage() {
  const [email, setEmail] = useState('');
  const [sent, setSent] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<unknown>(null);
  async function submit(e: FormEvent) {
    e.preventDefault();
    setBusy(true); setError(null);
    try { await call(api.POST('/auth/admin/password/forgot', { body: { email } })); setSent(true); }
    catch (err) { setError(err); } finally { setBusy(false); }
  }
  return (
    <div className={a.wrap}>
      <form className={a.panel} onSubmit={submit}>
        <span className={a.brand}>{strings.appName}</span>
        <h1 className={a.title}>Reset your password</h1>
        {sent ? (
          <p className={a.text}>If that email belongs to a staff account, a reset link is on its way. It expires soon, so use it today.</p>
        ) : (
          <>
            <p className={a.text}>We will email you a link to set a new password.</p>
            <TextField label="Email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
            {error ? <p role="alert" className={a.text}>{problemMessage(error)}</p> : null}
            <Button variant="primary" type="submit" busy={busy} disabled={!email}>Send reset link</Button>
          </>
        )}
        <div className={a.links}><Link to="/sign-in">Back to sign in</Link></div>
      </form>
    </div>
  );
}

export function ResetPasswordPage() {
  const [params] = useSearchParams();
  const token = params.get('token') ?? '';
  const [password, setPassword] = useState('');
  const [done, setDone] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<unknown>(null);
  async function submit(e: FormEvent) {
    e.preventDefault();
    setBusy(true); setError(null);
    try { await call(api.POST('/auth/admin/password/reset', { body: { token, password } })); setDone(true); }
    catch (err) { setError(err); } finally { setBusy(false); }
  }
  return (
    <div className={a.wrap}>
      <form className={a.panel} onSubmit={submit}>
        <span className={a.brand}>{strings.appName}</span>
        <h1 className={a.title}>Choose a new password</h1>
        {done ? <p className={a.text}>Your password is changed. Sign in with it now.</p> : (
          <>
            {!token && <Banner tone="warning">This link is missing its token. Open the link from your email again.</Banner>}
            <TextField label="New password" type="password" autoComplete="new-password" hint="At least 10 characters."
              value={password} onChange={(e) => setPassword(e.target.value)} minLength={10} required />
            {error ? <p role="alert" className={a.text}>{problemMessage(error)}</p> : null}
            <Button variant="primary" type="submit" busy={busy} disabled={!token || password.length < 10}>Set password</Button>
          </>
        )}
        <div className={a.links}><Link to="/sign-in">Back to sign in</Link></div>
      </form>
    </div>
  );
}

/** Invite link: set a password, add the authenticator, confirm with a code. */
export function AcceptInvitePage() {
  const [params] = useSearchParams();
  const token = params.get('token') ?? '';
  const { completeSignIn } = useSession();
  const navigate = useNavigate();
  const [password, setPassword] = useState('');
  const [enrolment, setEnrolment] = useState<Schemas['MfaEnrollment'] | null>(null);
  const [code, setCode] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<unknown>(null);

  async function setPw(e: FormEvent) {
    e.preventDefault();
    setBusy(true); setError(null);
    try { setEnrolment(await call(api.POST('/auth/admin/invite/accept', { body: { token, password } }))); }
    catch (err) { setError(err); } finally { setBusy(false); }
  }
  async function confirm(e: FormEvent) {
    e.preventDefault();
    if (!enrolment) return;
    setBusy(true); setError(null);
    try {
      const tokens = await call(api.POST('/auth/admin/mfa/confirm', { body: { enrollmentToken: enrolment.enrollmentToken, totpCode: code } }));
      await completeSignIn(tokens);
      navigate('/', { replace: true });
    } catch (err) { setError(err); setCode(''); } finally { setBusy(false); }
  }

  return (
    <div className={a.wrap}>
      {!enrolment ? (
        <form className={a.panel} onSubmit={setPw}>
          <span className={a.brand}>{strings.appName}</span>
          <h1 className={a.title}>Set up your account</h1>
          <p className={a.text}>Step 1 of 2. Choose a password. Next you will add an authenticator app, which every staff account needs.</p>
          {!token && <Banner tone="warning">This invite link is missing its token. Open the link from your email again.</Banner>}
          <TextField label="Password" type="password" autoComplete="new-password" hint="At least 10 characters."
            value={password} onChange={(e) => setPassword(e.target.value)} minLength={10} required />
          {error ? <p role="alert" className={a.text}>{problemMessage(error)}</p> : null}
          <Button variant="primary" type="submit" busy={busy} disabled={!token || password.length < 10}>Continue</Button>
        </form>
      ) : (
        <form className={a.panel} onSubmit={confirm}>
          <span className={a.brand}>{strings.appName}</span>
          <h1 className={a.title}>Add your authenticator</h1>
          <p className={a.text}>
            Step 2 of 2. Add this account to Google Authenticator, Microsoft Authenticator or 1Password, then enter the code it shows.
          </p>
          <div className={a.secret} aria-label="Setup key">{enrolment.secret}</div>
          <QrCode value={enrolment.otpauthUri} />
          <p className={a.notice}>
            Scan the code, or type the setup key below. On a phone you can <a href={enrolment.otpauthUri}>open it in your authenticator</a>.
          </p>
          <TextField label="Authenticator code" inputMode="numeric" autoComplete="one-time-code" maxLength={6}
            value={code} onChange={(e) => setCode(e.target.value.replace(/\D/g, ''))} required />
          {error ? <p role="alert" className={a.text}>{problemMessage(error)}</p> : null}
          <Button variant="primary" type="submit" busy={busy} disabled={code.length !== 6}>Confirm and sign in</Button>
        </form>
      )}
    </div>
  );
}

/** QR rendered locally from the otpauth URI; the secret never leaves the browser. */
function QrCode({ value }: { value: string }) {
  const [src, setSrc] = useState<string | null>(null);
  useEffect(() => {
    let live = true;
    QRCode.toDataURL(value, { margin: 1, width: 220 }).then((url) => { if (live) setSrc(url); }).catch(() => setSrc(null));
    return () => { live = false; };
  }, [value]);
  return src ? <img src={src} width={220} height={220} alt="QR code for your authenticator app" style={{ justifySelf: 'center' }} /> : null;
}
