// @vitest-environment jsdom
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { act, cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

/**
 * The whole app against the demo server: a typed URL while signed out goes to
 * sign-in and comes back after it; a role that cannot use a page sees the
 * access screen and the page's data is never requested; an ended session
 * returns to sign-in with the page kept and a plain message.
 */
vi.mock('@/components/MapView', () => ({ MapView: () => <div aria-label="Map" /> }));
vi.stubEnv('VITE_API_BASE_URL', `${window.location.origin}/api`);

const { setDemoTransport } = await import('@/services/http');
const { demoFetch } = await import('@/demo/server');

let paths: string[] = [];
/** When set, the API refuses every token and every refresh: the session is over. */
let sessionOver = false;
setDemoTransport(async (input, init) => {
  const r = input instanceof Request ? input : new Request(input, init);
  const path = new URL(r.url).pathname.replace(/^\/api/, '');
  paths.push(`${r.method} ${path}`);
  if (sessionOver && !path.startsWith('/auth/admin/')) {
    return new Response(JSON.stringify({ type: 'about:blank', title: 'x', status: 401, code: 'unauthenticated' }), {
      status: 401,
      headers: { 'Content-Type': 'application/problem+json' },
    });
  }
  return demoFetch(input, init);
});

const { SessionProvider } = await import('@/state/session');
const { ToastProvider } = await import('@/components');

const here = () => `${window.location.pathname}${window.location.search}`;
function go(path: string) {
  window.history.pushState({}, '', path);
  window.dispatchEvent(new PopStateEvent('popstate'));
}

async function signIn(email: string) {
  fireEvent.change(await screen.findByLabelText('Email'), { target: { value: email } });
  fireEvent.change(screen.getByLabelText('Password'), { target: { value: 'long-enough-1' } });
  fireEvent.click(screen.getByRole('button', { name: 'Continue' }));
  fireEvent.change(await screen.findByLabelText('Authenticator code'), { target: { value: '123456' } });
  fireEvent.click(screen.getByRole('button', { name: 'Sign in' }));
}

describe('protected routes', () => {
  beforeAll(async () => {
    window.matchMedia ??= ((q: string) => ({
      matches: false,
      media: q,
      addEventListener() {},
      removeEventListener() {},
      onchange: null,
      addListener() {},
      removeListener() {},
      dispatchEvent: () => false,
    })) as typeof window.matchMedia;
    window.scrollTo = () => {};
    localStorage.clear();
    sessionStorage.clear();
    // The router reads the address when the app module loads.
    window.history.replaceState({}, '', '/staff?status=active');
    const { App } = await import('@/app/App');
    const qc = new QueryClient({ defaultOptions: { queries: { retry: false } } });
    render(
      <QueryClientProvider client={qc}>
        <SessionProvider>
          <ToastProvider>
            <App />
          </ToastProvider>
        </SessionProvider>
      </QueryClientProvider>,
    );
  });
  afterAll(cleanup);

  it('sends a signed-out visitor to sign-in, keeping the page they asked for', async () => {
    await waitFor(() => expect(here()).toBe('/sign-in?next=%2Fstaff%3Fstatus%3Dactive'));
    expect(await screen.findByText('Sign in to open that page.')).toBeTruthy();
  });

  it('brings them back after sign-in, and blocks a page their role cannot use without loading its data', async () => {
    paths = [];
    await signIn('verifier@turbo.example');
    await waitFor(() => expect(here()).toBe('/staff?status=active'), { timeout: 5000 });
    expect(await screen.findByText("You don't have access to staff")).toBeTruthy();
    expect(screen.getByText(/Your role is Verifier/)).toBeTruthy();
    expect(paths.filter((p) => p.startsWith('GET /admin/staff'))).toEqual([]);
  });

  it('hides menu entries the role cannot open', async () => {
    const nav = await screen.findByRole('navigation', { name: 'Main navigation' });
    expect(nav.textContent).toContain('Verification');
    expect(nav.textContent).not.toContain('Audit log');
    expect(nav.textContent).not.toContain('Configuration');
  });

  it('returns to sign-in with the page kept and a clear message when the session ends', async () => {
    await act(async () => go('/students?q=ama'));
    await screen.findByRole('heading', { level: 1, name: 'Students' }, { timeout: 5000 });
    sessionOver = true;
    await act(async () => go('/verification'));
    await waitFor(() => expect(here()).toBe('/sign-in?next=%2Fverification'), { timeout: 5000 });
    expect(await screen.findByText(/Your session ended\. Sign in again to carry on\./)).toBeTruthy();
    expect(localStorage.getItem('admin.session')).toBeNull();
    sessionOver = false;
  });
});
