import { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState, type ReactNode } from 'react';
import { useQueryClient } from '@tanstack/react-query';
import { auth } from '@/services/auth';
import { onSessionExpired, restoreSession, setAccessToken } from '@/services/http';
import { me as meService } from '@/services/me';
import type { AdminLogin, AuthTokens, StaffUser } from '@/types';

type Status = 'checking' | 'signedOut' | 'signedIn';

/** Why the user is on the sign-in page, for the message there. */
export type SignedOutReason = 'idle' | 'expired' | 'elsewhere' | 'signedOut';

interface Session {
  status: Status;
  me: StaffUser | null;
  signIn: (body: AdminLogin) => Promise<void>;
  completeSignIn: (tokens: AuthTokens) => Promise<void>;
  signOut: (reason?: 'idle') => Promise<void>;
  signedOutReason: SignedOutReason | null;
}

const SessionContext = createContext<Session | null>(null);

/**
 * Token storage (prompts/02, docs/02):
 * - Access token: memory only (`services/http`). A script injected into the
 *   page could use it while the tab is open but cannot carry it away for later,
 *   and it is gone on reload.
 * - Refresh token: the httpOnly, Secure cookie the API sets. Scripts cannot
 *   read it at all; the browser sends it to `/auth/refresh` only.
 * - Nothing secret in localStorage or sessionStorage. The one value kept there
 *   is this marker, which says a session probably exists so a page load (or a
 *   new tab) knows to try the cookie.
 */
const MARKER = 'admin.session';
const marker = {
  get: () => {
    try {
      return localStorage.getItem(MARKER) === '1';
    } catch {
      return false;
    }
  },
  set: (on: boolean) => {
    try {
      if (on) localStorage.setItem(MARKER, '1');
      else localStorage.removeItem(MARKER);
    } catch {
      /* storage blocked: every load then starts signed out */
    }
  },
};

/** Tabs tell each other about sign-in and sign-out. Messages carry no tokens. */
type TabMessage = { type: 'signedIn' } | { type: 'signedOut' };
function openChannel(): BroadcastChannel | null {
  try {
    return typeof BroadcastChannel === 'undefined' ? null : new BroadcastChannel('turbo-admin-auth');
  } catch {
    return null;
  }
}

export function SessionProvider({ children }: { children: ReactNode }) {
  const queryClient = useQueryClient();
  const [status, setStatus] = useState<Status>('checking');
  const [me, setMe] = useState<StaffUser | null>(null);
  const [signedOutReason, setReason] = useState<SignedOutReason | null>(null);
  const started = useRef(false);
  const channel = useRef<BroadcastChannel | null>(null);
  const statusRef = useRef(status);
  statusRef.current = status;

  const loadMe = useCallback(async () => {
    const user = await meService.get();
    setMe(user);
    setStatus('signedIn');
    marker.set(true);
  }, []);

  /** Forget everything this tab holds about the session, including cached data from the last user. */
  const clearLocal = useCallback(
    (reason: SignedOutReason) => {
      setAccessToken(null);
      marker.set(false);
      void queryClient.cancelQueries();
      queryClient.clear();
      setMe(null);
      setReason(reason);
      setStatus('signedOut');
    },
    [queryClient],
  );

  useEffect(() => {
    if (started.current) return;
    started.current = true;
    (async () => {
      if (marker.get() && (await restoreSession())) {
        try {
          await loadMe();
          return;
        } catch {
          /* fall through */
        }
      }
      setStatus('signedOut');
    })();
  }, [loadMe]);

  // The API refused the refresh cookie mid-session.
  useEffect(
    () =>
      onSessionExpired(() => {
        if (statusRef.current === 'signedIn') clearLocal('expired');
      }),
    [clearLocal],
  );

  // Other tabs: follow their sign-out at once; pick up their sign-in from the shared cookie.
  useEffect(() => {
    const ch = openChannel();
    channel.current = ch;
    if (!ch) return;
    ch.onmessage = (e: MessageEvent<TabMessage>) => {
      if (e.data?.type === 'signedOut' && statusRef.current === 'signedIn') clearLocal('elsewhere');
      if (e.data?.type === 'signedIn' && statusRef.current === 'signedOut') {
        void (async () => {
          if (await restoreSession()) {
            setReason(null);
            await loadMe().catch(() => undefined);
          }
        })();
      }
    };
    return () => {
      ch.close();
      channel.current = null;
    };
  }, [clearLocal, loadMe]);

  const completeSignIn = useCallback(
    async (tokens: AuthTokens) => {
      setAccessToken(tokens.accessToken);
      setReason(null);
      await loadMe();
      channel.current?.postMessage({ type: 'signedIn' } satisfies TabMessage);
    },
    [loadMe],
  );

  const signIn = useCallback(
    async (body: AdminLogin) => {
      const tokens = await auth.login(body);
      await completeSignIn(tokens);
    },
    [completeSignIn],
  );

  const signOut = useCallback(
    async (reason?: 'idle') => {
      try {
        await auth.logout();
      } catch {
        /* signing out locally regardless */
      }
      clearLocal(reason ?? 'signedOut');
      channel.current?.postMessage({ type: 'signedOut' } satisfies TabMessage);
    },
    [clearLocal],
  );

  const value = useMemo(
    () => ({ status, me, signIn, completeSignIn, signOut, signedOutReason }),
    [status, me, signIn, completeSignIn, signOut, signedOutReason],
  );
  return <SessionContext.Provider value={value}>{children}</SessionContext.Provider>;
}

export function useSession(): Session {
  const s = useContext(SessionContext);
  if (!s) throw new Error('useSession outside SessionProvider');
  return s;
}
