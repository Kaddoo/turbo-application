import { useCallback, useEffect, useState } from 'react';
import { NavLink, Outlet, useNavigate } from 'react-router';
import { useQuery } from '@tanstack/react-query';
import { api, call, onUpgradeRequired } from '@/services/http';
import { canUse, roleLabels, type Area } from '@/utils/roles';
import { useIdleTimer } from '@/hooks';
import { useSession } from '@/state/session';
import { Banner, Button, Dialog, DialogActions } from '@/components';
import { formatRelative } from '@/utils/format';
import { appEnv, showEnvBadge } from '@/app/env';
import { strings } from '@/app/strings';
import l from '@/app/layout.module.css';

interface NavItem { to: string; label: string; area: Area }
const nav: { group: string; items: NavItem[] }[] = [
  { group: '', items: [{ to: '/', label: 'Overview', area: 'overview' }] },
  { group: 'People', items: [
    { to: '/verification', label: 'Verification', area: 'verification' },
    { to: '/students', label: 'Students', area: 'students' },
    { to: '/drivers', label: 'Drivers', area: 'drivers' },
    { to: '/vehicles', label: 'Vehicles', area: 'vehicles' },
  ] },
  { group: 'Operations', items: [
    { to: '/live', label: 'Live map', area: 'liveMap' },
    { to: '/rides', label: 'Rides', area: 'rides' },
    { to: '/announcements', label: 'Announcements', area: 'announcements' },
  ] },
  { group: 'Finance', items: [
    { to: '/finance/topups', label: 'Top-ups', area: 'finance' },
    { to: '/finance/adjustments', label: 'Adjustments', area: 'finance' },
    { to: '/finance/reconciliation', label: 'Reconciliation', area: 'finance' },
  ] },
  { group: 'Care', items: [
    { to: '/support', label: 'Support', area: 'support' },
    { to: '/incidents', label: 'Incidents', area: 'incidents' },
  ] },
  { group: 'Workforce', items: [
    { to: '/salary/shifts', label: 'Shifts', area: 'salary' },
    { to: '/salary/attendance', label: 'Attendance', area: 'salary' },
    { to: '/salary/payments', label: 'Salary payments', area: 'salary' },
  ] },
  { group: 'Admin', items: [
    { to: '/configuration', label: 'Configuration', area: 'configuration' },
    { to: '/staff', label: 'Staff', area: 'staff' },
    { to: '/audit-log', label: 'Audit log', area: 'auditLog' },
  ] },
];

export function Layout() {
  const { me, signOut } = useSession();
  const navigate = useNavigate();
  const role = me?.staffRole;
  const onIdle = useCallback(() => void signOut('idle'), [signOut]);
  const idle = useIdleTimer(onIdle);
  const [outdated, setOutdated] = useState(false);
  useEffect(() => onUpgradeRequired(() => setOutdated(true)), []);

  // SOS banner: polls open incidents for roles the contract lets read them (x-roles: support).
  const sos = useQuery({
    queryKey: ['incidents', 'open-banner'],
    queryFn: () => call(api.GET('/admin/incidents', { params: { query: { status: 'open', limit: 10 } } })),
    enabled: canUse(role, 'incidents'),
    refetchInterval: 10_000,
  });
  const open = sos.data?.data ?? [];
  const oldest = open.reduce<string | null>((o, i) => (!o || i.createdAt < o ? i.createdAt : o), null);
  const overdue = oldest ? Date.now() - new Date(oldest).getTime() > 120_000 : false;

  // Pilot gate: no approved boundary yet (D1). Pause state from settings.
  const area = useQuery({ queryKey: ['service-area'], queryFn: () => call(api.GET('/service-area')), enabled: !!role });
  const settings = useQuery({
    queryKey: ['settings'], queryFn: () => call(api.GET('/admin/settings')), enabled: canUse(role, 'configuration'),
  });

  return (
    <div className={l.shell}>
      <header className={l.topBar}>
        <NavLink to="/" className={l.wordmark}>{strings.appName}</NavLink>
        {showEnvBadge && <span className={l.badge} aria-label={strings.environment(appEnv)}>{appEnv}</span>}
        <span className={l.spacer} />
        {me && (
          <span className={l.who}>
            <span className={l.whoName}>{me.fullName}</span>
            <span className={l.whoRole}>{roleLabels[me.staffRole]}</span>
          </span>
        )}
        <Button small variant="ghost" onClick={() => navigate('/account')}>Account</Button>
        <Button small onClick={() => void signOut()}>Sign out</Button>
      </header>
      <nav className={l.rail} aria-label={strings.navLabel}>
        {nav.map((g) => {
          const items = g.items.filter((i) => canUse(role, i.area));
          if (!items.length) return null;
          return (
            <div key={g.group || 'top'} style={{ display: 'contents' }}>
              {g.group && <span className={l.group}>{g.group}</span>}
              {items.map((i) => (
                <NavLink key={i.to} to={i.to} end={i.to === '/'} className={({ isActive }) => `${l.link} ${isActive ? l.active : ''}`}>
                  {i.label}
                </NavLink>
              ))}
            </div>
          );
        })}
      </nav>
      <main className={l.main} id="main">
        <div className={l.banners}>
          {outdated && (
            <Banner tone="warning" action={<Button small variant="primary" onClick={() => window.location.reload()}>Reload</Button>}>
              A newer version of the dashboard is out. Reload to keep working.
            </Banner>
          )}
          {open.length > 0 && (
            <Banner tone="danger" action={<Button small variant="danger" onClick={() => navigate('/incidents')}>Open incidents</Button>}>
              {open.length === 1 ? '1 open SOS or safety incident' : `${open.length} open SOS or safety incidents`}
              {oldest && `, oldest raised ${formatRelative(oldest)}`}
              {overdue && '. Not acknowledged for over 2 minutes: act now.'}
            </Banner>
          )}
          {settings.data?.bookingsPaused && (
            <Banner tone="danger" action={<Button small onClick={() => navigate('/configuration')}>Settings</Button>}>
              New bookings are paused. Students see: “{settings.data.pauseMessage ?? 'Bookings are paused.'}”
            </Banner>
          )}
          {area.data && area.data.boundary === null && (
            <Banner tone="warning">
              No service boundary is approved yet, so the pilot is blocked. A super admin draws it under Configuration once Turbo approves it.
            </Banner>
          )}
        </div>
        <Outlet />
      </main>
      <Dialog open={idle.warning} onClose={idle.stayActive} title="Still there?">
        <p style={{ margin: 0 }}>You will be signed out in about a minute because there has been no activity.</p>
        <DialogActions>
          <Button variant="ghost" onClick={() => void signOut()}>Sign out now</Button>
          <Button variant="primary" onClick={idle.stayActive}>Stay signed in</Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}

/** Route guard: hides what a role cannot use. The API still refuses with 403. */
export function RequireArea({ area, children }: { area: Area; children: React.ReactNode }) {
  const { me } = useSession();
  if (!canUse(me?.staffRole, area)) {
    return <Banner tone="warning">You do not have access to this.</Banner>;
  }
  return <>{children}</>;
}
