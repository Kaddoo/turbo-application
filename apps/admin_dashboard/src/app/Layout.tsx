import { useCallback, useEffect, useMemo, useState } from 'react';
import { NavLink, Outlet, useLocation, useNavigate, useNavigation } from 'react-router';
import { onUpgradeRequired } from '@/services/http';
import { canUse, roleLabels, type Area } from '@/utils/roles';
import {
  useIdleTimer,
  useLiveRides,
  useMediaQuery,
  useOpenTickets,
  usePendingVerifications,
  useServiceArea,
  useSettings,
  useSosBanner,
} from '@/hooks';
import { useSession } from '@/state/session';
import { Banner, Button, Dialog, DialogActions, Drawer, IconButton, type Tone } from '@/components';
import { formatRelative } from '@/utils/format';
import { appEnv, showEnvBadge } from './env';
import { mobileTabOrder, navGroups, navSides, primaryAction, type NavSide } from './routes';
import { BottomNav } from './shell/BottomNav';
import { GlobalSearch } from './shell/GlobalSearch';
import { NotificationBell, type Notice } from './shell/Notifications';
import { Sidebar, type SidebarNotice } from './shell/Sidebar';
import { UserMenu } from './shell/UserMenu';
import { strings } from './strings';
import sh from './shell/shell.module.css';

const COLLAPSE_KEY = 'admin.sidebarCollapsed';
const readCollapsed = () => {
  try {
    return localStorage.getItem(COLLAPSE_KEY) === '1';
  } catch {
    return false;
  }
};

/** "50+" when the list had more than one page; the contract returns no totals (A5). */
const countOf = (rows: unknown[] | undefined, hasMore?: boolean) => ({
  count: rows?.length ?? 0,
  text: rows ? (hasMore ? `${rows.length}+` : String(rows.length)) : '',
});

export function Layout() {
  const { me, signOut } = useSession();
  const navigate = useNavigate();
  const { pathname } = useLocation();
  // A page chunk is loading: the main area reports busy until it arrives.
  const loadingPage = useNavigation().state === 'loading';
  const role = me?.staffRole;
  const can = useCallback((a: Area) => canUse(role, a), [role]);
  const onIdle = useCallback(() => void signOut('idle'), [signOut]);
  const idle = useIdleTimer(onIdle);
  const [outdated, setOutdated] = useState(false);
  useEffect(() => onUpgradeRequired(() => setOutdated(true)), []);

  // Shell state: drawer (phones), search sheet (phones), collapsed rail (desktop; always on tablets).
  const [menuOpen, setMenuOpen] = useState(false);
  const [searchOpen, setSearchOpen] = useState(false);
  const [userCollapsed, setUserCollapsed] = useState(readCollapsed);
  const tablet = useMediaQuery('(max-width: 1024px)');
  const collapsed = userCollapsed || tablet;
  const toggleCollapsed = () =>
    setUserCollapsed((c) => {
      try {
        localStorage.setItem(COLLAPSE_KEY, c ? '0' : '1');
      } catch {
        /* storage blocked: the choice lasts until reload */
      }
      return !c;
    });
  useEffect(() => {
    setMenuOpen(false);
    setSearchOpen(false);
  }, [pathname]);

  // SOS: polls open incidents for roles the contract lets read them (x-roles: support).
  const sos = useSosBanner(can('incidents'));
  const open = useMemo(() => sos.data?.data ?? [], [sos.data]);
  const oldest = open.reduce<string | null>((o, i) => (!o || i.createdAt < o ? i.createdAt : o), null);
  const overdue = oldest ? Date.now() - new Date(oldest).getTime() > 120_000 : false;

  // Pilot gate: no approved boundary yet (D1). Pause state from settings.
  const area = useServiceArea(!!role);
  const settings = useSettings(can('configuration'));
  const pending = usePendingVerifications(can('verification'));
  const tickets = useOpenTickets(can('support'));
  const live = useLiveRides({ enabled: !can('incidents') && can('liveMap'), refetchInterval: 30_000 });

  // Menu: items the role can use, split into the two halves.
  const allItems = useMemo(() => navGroups.flatMap((g) => g.items).filter((i) => can(i.area)), [can]);
  const sideOf = (path: string): NavSide => {
    const group = allItems.find((i) => i.to !== '/' && path.startsWith(i.to))?.group;
    return group && navSides.backOffice.groups.includes(group) ? 'backOffice' : 'operations';
  };
  const hasBoth =
    allItems.some((i) => i.group && navSides.operations.groups.includes(i.group)) &&
    allItems.some((i) => i.group && navSides.backOffice.groups.includes(i.group));
  const [side, setSide] = useState<NavSide>(() => sideOf(pathname));
  useEffect(() => {
    if (pathname !== '/') setSide(sideOf(pathname));
    // Follow the page; `sideOf` only reads the role's items.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [pathname]);
  const menuItems = hasBoth ? allItems.filter((i) => navSides[side].groups.includes(i.group)) : allItems;

  const pendingCount = countOf(pending.data?.data, pending.data?.page.hasMore);
  const ticketCount = countOf(tickets.data?.data, tickets.data?.page.hasMore);
  const sosCount = countOf(open, sos.data?.page.hasMore);
  const badges: Partial<Record<string, { count: number; tone: Tone; label: string }>> = {
    '/verification': { count: pendingCount.count, tone: 'accent', label: `${pendingCount.text} waiting` },
    '/support': { count: ticketCount.count, tone: 'accent', label: `${ticketCount.text} open` },
    '/incidents': { count: sosCount.count, tone: 'danger', label: `${sosCount.text} open` },
  };

  // Sidebar live list: open SOS for support, else active rides for dispatch.
  const list = can('incidents')
    ? {
        title: 'Open SOS',
        loading: sos.isPending,
        empty: 'No open SOS or safety reports.',
        onViewAll: () => navigate('/incidents'),
        items: open.map((i) => ({
          id: i.id,
          name: i.type === 'sos' ? 'SOS alert' : 'Safety report',
          label: i.type === 'sos' ? 'SOS alert' : 'Safety report',
          meta: formatRelative(i.createdAt),
          tone: 'danger' as const,
          onSelect: () => navigate('/incidents'),
        })),
      }
    : can('liveMap')
      ? {
          title: 'Active rides',
          loading: live.isPending,
          empty: 'No rides on the road.',
          onViewAll: () => navigate('/live'),
          items: (live.data?.rides ?? []).map(({ ride }) => ({
            id: ride.id,
            name: ride.studentName ?? 'Student',
            label: ride.studentName ?? 'Student',
            meta: `${ride.driverName ?? 'No driver yet'} · ${formatRelative(ride.requestedAt)}`,
            tone: 'neutral' as const,
            onSelect: () => navigate(`/rides/${ride.id}`),
          })),
        }
      : undefined;

  const notice: SidebarNotice | null = showEnvBadge
    ? {
        icon: 'info',
        tone: 'warning',
        title: strings.environment(appEnv),
        body:
          appEnv === 'demo'
            ? 'Sample data in your browser. Nothing here is real.'
            : 'For testing. Check before you send texts or move money.',
      }
    : null;

  // Bell: everything on the banners, as a list.
  const notices: Notice[] = [
    ...(outdated
      ? [
          {
            id: 'outdated',
            tone: 'warning' as const,
            title: 'Newer version available',
            body: 'Reload to keep working.',
            onSelect: () => window.location.reload(),
          },
        ]
      : []),
    ...open.map((i) => ({
      id: `sos-${i.id}`,
      tone: 'danger' as const,
      title: i.type === 'sos' ? 'SOS alert' : 'Safety report',
      body: i.status === 'open' ? 'Not acknowledged yet' : undefined,
      time: formatRelative(i.createdAt),
      onSelect: () => navigate('/incidents'),
    })),
    ...(settings.data?.bookingsPaused
      ? [
          {
            id: 'paused',
            tone: 'danger' as const,
            title: 'New bookings are paused',
            onSelect: () => navigate('/configuration'),
          },
        ]
      : []),
    ...(area.data && area.data.boundary === null
      ? [{ id: 'boundary', tone: 'warning' as const, title: 'No service boundary approved yet' }]
      : []),
  ];

  const brand = {
    mark: strings.appName.slice(0, 1),
    name: strings.appName,
    subtitle: 'Admin dashboard',
  };
  const action = role ? primaryAction[role] : null;
  const openSettings = () => navigate(can('configuration') ? '/configuration' : '/account');
  const roleLabel = role ? roleLabels[role] : '';
  const tabs = mobileTabOrder
    .map((to) => allItems.find((i) => i.to === to))
    .filter((i): i is NonNullable<typeof i> => !!i)
    .slice(0, 4);
  const searchTargets = [
    ...allItems,
    { to: '/account', label: 'Account and security', group: '', icon: 'account' as const },
  ];

  const sidebarProps = {
    brand,
    badges,
    side,
    onSideChange: setSide,
    showSideToggle: hasBoth,
    list,
    notice,
    navLabel: strings.navLabel,
  };

  return (
    <div className={sh.shell} data-collapsed={collapsed || undefined}>
      <a href="#main" className={sh.skip}>
        Skip to content
      </a>
      <aside className={sh.sidebar}>
        <Sidebar
          {...sidebarProps}
          items={collapsed ? allItems : menuItems}
          collapsed={collapsed}
          onToggleCollapsed={tablet ? undefined : toggleCollapsed}
        />
      </aside>

      <div className={sh.column}>
        <header className={sh.topBar}>
          <IconButton
            icon="menu"
            label="Open menu"
            variant="ghost"
            className={sh.mobileOnly}
            aria-expanded={menuOpen}
            onClick={() => setMenuOpen(true)}
          />
          <NavLink to="/" className={sh.mobileBrand} aria-label={`${strings.appName} overview`}>
            <span className={sh.brandMark} aria-hidden="true">
              {brand.mark}
            </span>
            {showEnvBadge && (
              <span className={sh.envBadge} aria-label={strings.environment(appEnv)}>
                {appEnv}
              </span>
            )}
          </NavLink>
          {me && (
            <span className={sh.desktopOnly}>
              <UserMenu
                name={me.fullName}
                email={me.email}
                role={roleLabel}
                onAccount={() => navigate('/account')}
                onSignOut={() => void signOut()}
              />
            </span>
          )}
          {action && (
            <Button variant="primary" className={sh.desktopOnly} onClick={() => navigate(action.to)}>
              {action.label}
            </Button>
          )}
          <span className={sh.spacer} />
          <NotificationBell items={notices} loading={sos.isPending && can('incidents')} />
          <span className={sh.wideOnly}>
            <GlobalSearch targets={searchTargets} onOpen={navigate} />
          </span>
          <IconButton
            icon="search"
            label="Search pages"
            className={sh.narrowOnly}
            onClick={() => setSearchOpen(true)}
          />
          <Button icon="configuration" className={sh.wideOnly} onClick={openSettings}>
            Settings
          </Button>
          <IconButton icon="configuration" label="Settings" className={sh.tabletOnly} onClick={openSettings} />
          {me && (
            <span className={sh.mobileOnly}>
              <UserMenu
                compact
                name={me.fullName}
                email={me.email}
                role={roleLabel}
                onAccount={() => navigate('/account')}
                onSignOut={() => void signOut()}
              />
            </span>
          )}
        </header>

        <main className={sh.main} id="main" tabIndex={-1} aria-busy={loadingPage || undefined}>
          <div className={sh.banners}>
            {outdated && (
              <Banner
                tone="warning"
                action={
                  <Button small variant="primary" onClick={() => window.location.reload()}>
                    Reload
                  </Button>
                }
              >
                A newer version of the dashboard is out. Reload to keep working.
              </Banner>
            )}
            {open.length > 0 && (
              <Banner
                tone="danger"
                action={
                  <Button small variant="danger" onClick={() => navigate('/incidents')}>
                    Open incidents
                  </Button>
                }
              >
                {open.length === 1 ? '1 open SOS or safety incident' : `${open.length} open SOS or safety incidents`}
                {oldest && `, oldest raised ${formatRelative(oldest)}`}
                {overdue && '. Not acknowledged for over 2 minutes: act now.'}
              </Banner>
            )}
            {settings.data?.bookingsPaused && (
              <Banner
                tone="danger"
                action={
                  <Button small onClick={() => navigate('/configuration')}>
                    Settings
                  </Button>
                }
              >
                New bookings are paused. Students see: “{settings.data.pauseMessage ?? 'Bookings are paused.'}”
              </Banner>
            )}
            {area.data && area.data.boundary === null && (
              <Banner tone="warning">
                No service boundary is approved yet, so the pilot is blocked. A super admin draws it under Configuration
                once {strings.appName} approves it.
              </Banner>
            )}
          </div>
          <Outlet />
        </main>
      </div>

      <BottomNav tabs={tabs} badges={badges} moreOpen={menuOpen} onMore={() => setMenuOpen(true)} />

      <Drawer open={menuOpen} onClose={() => setMenuOpen(false)} label="Menu">
        <Sidebar {...sidebarProps} items={menuItems} onClose={() => setMenuOpen(false)} />
      </Drawer>

      <Dialog open={searchOpen} onClose={() => setSearchOpen(false)} title="Search" size="sm">
        <GlobalSearch targets={searchTargets} onOpen={navigate} autoFocus shortcut={false} />
      </Dialog>

      <Dialog open={idle.warning} onClose={idle.stayActive} title="Still there?" size="sm">
        <p className={sh.dialogText}>You will be signed out in about a minute because there has been no activity.</p>
        <DialogActions>
          <Button variant="ghost" onClick={() => void signOut()}>
            Sign out now
          </Button>
          <Button variant="primary" onClick={idle.stayActive}>
            Stay signed in
          </Button>
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
