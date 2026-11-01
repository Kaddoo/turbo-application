// @vitest-environment jsdom
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { act, cleanup, render, screen, waitFor } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';

/**
 * Signs in through the demo server and visits every screen. A screen passes
 * when it settles (no loading skeletons) without an error state. Catches
 * screens that call an endpoint the demo lacks or crash on real-shaped data.
 */

// Leaflet needs a real layout engine; the map itself is not under test here.
vi.mock('@/components/MapView', () => ({ MapView: () => <div aria-label="Map" /> }));

// Node's Request rejects relative URLs, so give the client an absolute base.
vi.stubEnv('VITE_API_BASE_URL', `${window.location.origin}/api`);

const { setDemoTransport } = await import('@/services/http');
const { demoFetch } = await import('@/demo/server');
const db = await import('@/demo/data');

const unrouted: string[] = [];
setDemoTransport(async (input, init) => {
  const res = await demoFetch(input, init);
  if (res.status === 404) {
    const body = await res
      .clone()
      .json()
      .catch(() => null);
    if (body?.title?.startsWith('Demo has no')) unrouted.push(body.title);
  }
  return res;
});

const { SessionProvider } = await import('@/state/session');
const { ToastProvider } = await import('@/components');
const { App } = await import('@/app/App');

const routes = [
  '/',
  '/verification',
  `/verification/${db.verifications[0]!.id}`,
  '/students',
  `/students/${db.students[0]!.id}`,
  '/drivers',
  `/drivers/${db.drivers[0]!.id}`,
  '/vehicles',
  '/live',
  '/rides',
  `/rides/${db.rides[0]!.ride.id}`,
  '/announcements',
  '/finance/topups',
  '/finance/adjustments',
  '/finance/reconciliation',
  '/support',
  `/support/${db.tickets[0]!.id}`,
  '/incidents',
  '/salary/shifts',
  '/salary/attendance',
  '/salary/payments',
  '/configuration',
  '/staff',
  '/audit-log',
  '/account',
];

function go(path: string) {
  window.history.pushState({}, '', path);
  window.dispatchEvent(new PopStateEvent('popstate'));
}

describe('every screen renders against the demo server', () => {
  // Pages load lazily; a heading that changes from one route to the next proves the new page really rendered.
  let previousHeading: string | null | undefined;
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
    localStorage.setItem('admin.session', '1');
    sessionStorage.setItem('demo.role', 'super_admin');
    window.history.replaceState({}, '', '/');
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
    await screen.findByRole('navigation', { name: 'Main navigation' }, { timeout: 5000 });
  });
  afterAll(cleanup);

  it.each(routes)(
    '%s',
    async (path) => {
      unrouted.length = 0;
      await act(async () => go(path));
      await waitFor(
        () => {
          expect(document.querySelector('[aria-busy="true"]')).toBeNull();
          expect(document.querySelector('main [class*="skeleton"]')).toBeNull();
        },
        { timeout: 5000 },
      );
      expect(screen.queryByText('Page not found')).toBeNull();
      const heading = document.querySelector('main h1')?.textContent;
      expect(heading).toBeTruthy();
      expect(heading).not.toBe(previousHeading);
      previousHeading = heading;
      // ErrorState blocks only; the urgent SOS banner is also an alert, on purpose.
      const errors = [...document.querySelectorAll('main [role="alert"][class*="state"]')].map((a) => a.textContent);
      expect(errors).toEqual([]);
      expect(unrouted).toEqual([]);
    },
    10_000,
  );

  it('accepts a CSV statement upload end to end', async () => {
    unrouted.length = 0;
    const { uploadFile } = await import('@/services/uploads');
    const id = await uploadFile('provider_statement', new File(['date,amount\n2026-10-01,3500'], 'statement.csv'));
    expect(id).toBeTruthy();
    expect(unrouted).toEqual([]);
  });
});
