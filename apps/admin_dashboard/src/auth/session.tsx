import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState, type ReactNode } from 'react';
import { api, call, restoreSession, setAccessToken, type Schemas } from '../api/client';

type StaffUser = Schemas['StaffUser'];

type Status = 'checking' | 'signedOut' | 'signedIn';

interface Session {
  status: Status;
  me: StaffUser | null;
  signIn: (body: Schemas['AdminLogin']) => Promise<void>;
  completeSignIn: (tokens: Schemas['AuthTokens']) => Promise<void>;
  signOut: (reason?: 'idle') => Promise<void>;
  signedOutReason: 'idle' | null;
}

const SessionContext = createContext<Session | null>(null);

/**
 * A non-secret marker so a page load only tries the refresh cookie when a
 * session probably exists. The refresh token itself is httpOnly and never
 * readable here; the access token lives in memory only.
 */
const MARKER = 'admin.session';
const marker = {
  get: () => { try { return sessionStorage.getItem(MARKER) === '1'; } catch { return false; } },
  set: (on: boolean) => { try { if (on) sessionStorage.setItem(MARKER, '1'); else sessionStorage.removeItem(MARKER); } catch { /* storage blocked */ } },
};

export function SessionProvider({ children }: { children: ReactNode }) {
  const [status, setStatus] = useState<Status>('checking');
  const [me, setMe] = useState<StaffUser | null>(null);
  const [signedOutReason, setReason] = useState<'idle' | null>(null);
  const started = useRef(false);

  const loadMe = useCallback(async () => {
    const user = await call(api.GET('/admin/me'));
    setMe(user);
    setStatus('signedIn');
    marker.set(true);
  }, []);

  useEffect(() => {
    if (started.current) return;
    started.current = true;
    (async () => {
      if (marker.get() && (await restoreSession())) {
        try { await loadMe(); return; } catch { /* fall through */ }
      }
      setStatus('signedOut');
    })();
  }, [loadMe]);

  const completeSignIn = useCallback(async (tokens: Schemas['AuthTokens']) => {
    setAccessToken(tokens.accessToken);
    setReason(null);
    await loadMe();
  }, [loadMe]);

  const signIn = useCallback(async (body: Schemas['AdminLogin']) => {
    const tokens = await call(api.POST('/auth/admin/login', { body }));
    await completeSignIn(tokens);
  }, [completeSignIn]);

  const signOut = useCallback(async (reason?: 'idle') => {
    try { await api.POST('/auth/logout'); } catch { /* signing out locally regardless */ }
    setAccessToken(null);
    marker.set(false);
    setMe(null);
    setReason(reason ?? null);
    setStatus('signedOut');
  }, []);

  const value = useMemo(() => ({ status, me, signIn, completeSignIn, signOut, signedOutReason }), [status, me, signIn, completeSignIn, signOut, signedOutReason]);
  return <SessionContext.Provider value={value}>{children}</SessionContext.Provider>;
}

export function useSession(): Session {
  const s = useContext(SessionContext);
  if (!s) throw new Error('useSession outside SessionProvider');
  return s;
}

/** Idle sign-out after 15 minutes, with a warning at 14 (prompts/02). */
export function useIdleTimer(onIdle: () => void, idleMs = 15 * 60_000, warnMs = 14 * 60_000) {
  const [warning, setWarning] = useState(false);
  const last = useRef(Date.now());
  useEffect(() => {
    const bump = () => { last.current = Date.now(); setWarning(false); };
    const events = ['mousemove', 'keydown', 'pointerdown', 'scroll'] as const;
    events.forEach((e) => window.addEventListener(e, bump, { passive: true }));
    const timer = setInterval(() => {
      const idle = Date.now() - last.current;
      if (idle >= idleMs) onIdle();
      else if (idle >= warnMs) setWarning(true);
    }, 5_000);
    return () => { events.forEach((e) => window.removeEventListener(e, bump)); clearInterval(timer); };
  }, [onIdle, idleMs, warnMs]);
  return { warning, stayActive: () => { last.current = Date.now(); setWarning(false); } };
}
