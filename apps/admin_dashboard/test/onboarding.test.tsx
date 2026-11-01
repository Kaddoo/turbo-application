// @vitest-environment jsdom
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';
import { act, cleanup, fireEvent, render, screen, waitFor, within } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import type { Schemas } from '@/types';

/**
 * Onboarding: the checklist rules (unit), then the whole app on a fresh demo:
 * an HR invite from the email link to the first-run checklist, hiding and
 * resuming it, a verifier's one-card welcome that never returns once put
 * away, and the super admin's pilot setup.
 */
vi.mock('@/components/MapView', () => ({ MapView: () => <div aria-label="Map" /> }));
vi.stubEnv('VITE_API_BASE_URL', `${window.location.origin}/api`);

const { superAdminSteps, hrSteps, isComplete, driverReady } = await import('@/utils/onboarding');

type Driver = Schemas['DriverDetail'];
const driver = (over: Partial<Driver> = {}): Driver =>
  ({
    id: 'd1',
    fullName: 'Kofi Mensah',
    phone: '+233200000000',
    status: 'active',
    dutyStatus: 'off_duty',
    vehicle: { id: 'v1', plateNumber: 'GR 1-26', make: 'Toyota', model: 'Corolla', status: 'active' },
    documents: [
      { id: 'a', type: 'drivers_licence', uploadId: 'u1', expiresOn: null },
      { id: 'b', type: 'insurance', uploadId: 'u2', expiresOn: null },
      { id: 'c', type: 'roadworthy', uploadId: 'u3', expiresOn: null },
    ],
    createdAt: '2026-10-01T00:00:00Z',
    ...over,
  }) as Driver;
const member = (staffRole: Schemas['StaffRole']) =>
  ({ id: staffRole, email: `${staffRole}@x`, fullName: staffRole, staffRole, isActive: true }) as Schemas['StaffUser'];

describe('checklist rules', () => {
  const area = (over: Partial<Schemas['ServiceArea']> = {}) =>
    ({
      version: 1,
      boundary: null,
      pickupPoints: [],
      maxTripDistanceMeters: 18000,
      fareBands: [{ upToMeters: 3000, farePesewas: 1000 }],
      operatingHours: null,
      ...over,
    }) as Schemas['ServiceArea'];

  it('starts the pilot setup with only the seeded fares ticked', () => {
    const steps = superAdminSteps({
      serviceArea: area(),
      settings: { operatingHours: null } as Schemas['Settings'],
      staff: [member('super_admin')],
      drivers: [],
    });
    expect(steps.filter((s) => s.state === 'done').map((s) => s.id)).toEqual(['fares']);
    expect(steps.find((s) => s.id === 'team')!.body).toBe(
      'Still to invite: verifier, dispatcher, finance, support and HR.',
    );
    expect(isComplete(steps)).toBe(false);
  });

  it('completes when everything exists, whoever did it', () => {
    const steps = superAdminSteps({
      serviceArea: area({
        boundary: { type: 'Polygon', coordinates: [] } as unknown as Schemas['ServiceArea']['boundary'],
        pickupPoints: [{ id: 'p', name: 'Main gate', point: { lat: 5.8, lng: 0.1 }, isActive: true }],
      }),
      settings: { operatingHours: { open: '06:00', close: '22:00' } } as unknown as Schemas['Settings'],
      staff: ['verifier', 'dispatcher', 'finance', 'support', 'hr'].map((r) => member(r as Schemas['StaffRole'])),
      drivers: [driver()],
    });
    expect(steps.every((s) => s.state === 'done')).toBe(true);
    expect(isComplete(steps)).toBe(true);
  });

  it('does not count an inactive pickup point or a deactivated colleague', () => {
    const steps = superAdminSteps({
      serviceArea: area({ pickupPoints: [{ id: 'p', name: 'Gate', point: { lat: 0, lng: 0 }, isActive: false }] }),
      settings: { operatingHours: null } as Schemas['Settings'],
      staff: [{ ...member('hr'), isActive: false }],
      drivers: [],
    });
    expect(steps.find((s) => s.id === 'pickupPoints')!.state).toBe('todo');
    expect(steps.find((s) => s.id === 'team')!.body).toContain('HR');
  });

  it('needs a vehicle and all three documents for a driver to be ready', () => {
    expect(driverReady(driver())).toBe(true);
    expect(driverReady(driver({ vehicle: null }))).toBe(false);
    expect(driverReady(driver({ documents: (driver().documents ?? []).slice(0, 2) }))).toBe(false);
  });

  it('ticks HR steps from drivers and shifts, and leaves salary for later', () => {
    const empty = hrSteps({ drivers: [], shiftsThisWeek: [] });
    expect(empty.filter((s) => s.state === 'done')).toEqual([]);
    expect(empty.find((s) => s.id === 'salary')!.state).toBe('later');
    const missing = hrSteps({
      drivers: [driver(), driver({ id: 'd2', vehicle: null, documents: [] })],
      shiftsThisWeek: [],
    });
    expect(missing.find((s) => s.id === 'vehicle')!.body).toBe('1 driver has no vehicle.');
    expect(missing.find((s) => s.id === 'documents')!.body).toContain('1 driver is missing');
    const ready = hrSteps({ drivers: [driver()], shiftsThisWeek: [{ id: 's' } as Schemas['Shift']] });
    expect(isComplete(ready)).toBe(true);
  });
});

describe('first run on a fresh demo', () => {
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
    // `?demo=fresh` empties the demo before anything loads; the invite link names the role.
    window.history.replaceState({}, '', '/invite?token=demo-hr&demo=fresh');
    const { setDemoTransport } = await import('@/services/http');
    const { demoFetch } = await import('@/demo/server');
    setDemoTransport(demoFetch);
    const { SessionProvider } = await import('@/state/session');
    const { ToastProvider } = await import('@/components');
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

  const signOut = async (role: string) => {
    fireEvent.click((await screen.findAllByRole('button', { name: new RegExp(`, ${role}$`) }))[0]!);
    fireEvent.click(await screen.findByRole('menuitem', { name: 'Sign out' }));
    await screen.findByRole('button', { name: 'Continue' }, { timeout: 5000 });
  };
  const signIn = async (email: string) => {
    fireEvent.change(await screen.findByLabelText('Email'), { target: { value: email } });
    fireEvent.change(screen.getByLabelText('Password'), { target: { value: 'long-enough-1' } });
    fireEvent.click(screen.getByRole('button', { name: 'Continue' }));
    fireEvent.change(await screen.findByLabelText('Authenticator code'), { target: { value: '123456' } });
    fireEvent.click(screen.getByRole('button', { name: 'Sign in' }));
  };

  it('takes the token out of the address bar', () => {
    expect(window.location.search).toBe('');
  });

  it('runs an HR invite from the email link to the first-run checklist', async () => {
    fireEvent.change(await screen.findByLabelText('Password'), { target: { value: 'long-enough-1' } });
    fireEvent.click(screen.getByRole('button', { name: 'Continue' }));
    expect(await screen.findByText(/Keep this page open/)).toBeTruthy();
    fireEvent.change(screen.getByLabelText('Authenticator code'), { target: { value: '123456' } });
    fireEvent.click(screen.getByRole('button', { name: 'Confirm and sign in' }));
    const card = await screen.findByRole('region', { name: 'Welcome, Kojo' }, { timeout: 5000 });
    await waitFor(() => expect(within(card).getByText('0 of 4 done')).toBeTruthy(), { timeout: 5000 });
    expect(within(card).getByText('Add your first driver')).toBeTruthy();
    expect(within(card).getByText('Can wait')).toBeTruthy();
  });

  it('hides the checklist to a one-line bar and brings it back', async () => {
    fireEvent.click(screen.getByRole('button', { name: 'Hide for now' }));
    const bar = await screen.findByRole('region', { name: 'Driver setup' });
    expect(bar.textContent).toContain('0 of 4 done');
    fireEvent.click(within(bar).getByRole('button', { name: 'Continue setup' }));
    // Same visit, so it still greets; the list is back.
    const card = await screen.findByRole('region', { name: 'Welcome, Kojo' });
    expect(within(card).getByText('Add your first driver')).toBeTruthy();
  });

  it('gives a verifier one card, and never shows it again once put away', async () => {
    await signOut('HR');
    await signIn('verifier@turbo.example');
    const card = await screen.findByRole('region', { name: 'Welcome, Kwame' }, { timeout: 5000 });
    expect(within(card).getByRole('button', { name: 'Open the review queue' })).toBeTruthy();
    fireEvent.click(within(card).getByRole('button', { name: 'Got it' }));
    await waitFor(() => expect(screen.queryByRole('region', { name: 'Welcome, Kwame' })).toBeNull());
    await act(async () => {
      window.history.pushState({}, '', '/verification');
      window.dispatchEvent(new PopStateEvent('popstate'));
    });
    await act(async () => {
      window.history.pushState({}, '', '/');
      window.dispatchEvent(new PopStateEvent('popstate'));
    });
    await screen.findByRole('heading', { level: 1 }, { timeout: 5000 });
    expect(screen.queryByRole('region', { name: /Welcome|Your job here/ })).toBeNull();
  });

  it('shows the super admin the pilot setup with what is missing', async () => {
    await signOut('Verifier');
    await signIn('admin@turbo.example');
    const card = await screen.findByRole('region', { name: 'Welcome, Abena' }, { timeout: 5000 });
    await waitFor(() => expect(within(card).getByText('1 of 6 done')).toBeTruthy(), { timeout: 5000 });
    expect(within(card).getByText('Still to invite: verifier, dispatcher, finance, support and HR.')).toBeTruthy();
    expect(within(card).getByRole('button', { name: 'Draw boundary' })).toBeTruthy();
  });
});
