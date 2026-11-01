import type { ComponentType } from 'react';
import type { IconName } from '@/components';
import type { Area, StaffRole } from '@/utils/roles';

/**
 * Every signed-in screen, in menu order. The left rail is built from this
 * table and the same `area` guards the route, so the menu never lists a page
 * the role check refuses. The API still refuses on its own (403).
 */
export interface PageRoute {
  path: string;
  /** Role area from the contract's x-roles. Omitted: every signed-in staff member. */
  area?: Area;
  /** Shown in the left rail when set. */
  nav?: { group: string; label: string; icon: IconName };
  /** Each page is its own chunk, loaded when first opened. */
  load: () => Promise<{ default: ComponentType }>;
}

export const signedInRoutes: PageRoute[] = [
  {
    path: '/',
    area: 'overview',
    nav: { group: '', label: 'Overview', icon: 'overview' },
    load: () => import('@/pages/OverviewPage'),
  },
  {
    path: '/verification',
    area: 'verification',
    nav: { group: 'People', label: 'Verification', icon: 'verification' },
    load: () => import('@/pages/VerificationQueuePage'),
  },
  { path: '/verification/:id', area: 'verification', load: () => import('@/pages/VerificationReviewPage') },
  {
    path: '/students',
    area: 'students',
    nav: { group: 'People', label: 'Students', icon: 'students' },
    load: () => import('@/pages/StudentsPage'),
  },
  { path: '/students/:id', area: 'studentDetail', load: () => import('@/pages/StudentDetailPage') },
  {
    path: '/drivers',
    area: 'drivers',
    nav: { group: 'People', label: 'Drivers', icon: 'drivers' },
    load: () => import('@/pages/DriversPage'),
  },
  { path: '/drivers/:id', area: 'drivers', load: () => import('@/pages/DriverDetailPage') },
  {
    path: '/vehicles',
    area: 'vehicles',
    nav: { group: 'People', label: 'Vehicles', icon: 'vehicles' },
    load: () => import('@/pages/VehiclesPage'),
  },
  {
    path: '/live',
    area: 'liveMap',
    nav: { group: 'Operations', label: 'Live map', icon: 'liveMap' },
    load: () => import('@/pages/LiveMapPage'),
  },
  {
    path: '/rides',
    area: 'rides',
    nav: { group: 'Operations', label: 'Rides', icon: 'rides' },
    load: () => import('@/pages/RidesPage'),
  },
  { path: '/rides/:id', area: 'rideDetail', load: () => import('@/pages/RideDetailPage') },
  {
    path: '/announcements',
    area: 'announcements',
    nav: { group: 'Operations', label: 'Announcements', icon: 'announcements' },
    load: () => import('@/pages/AnnouncementsPage'),
  },
  {
    path: '/finance/topups',
    area: 'finance',
    nav: { group: 'Finance', label: 'Top-ups', icon: 'topups' },
    load: () => import('@/pages/TopupsPage'),
  },
  {
    path: '/finance/adjustments',
    area: 'finance',
    nav: { group: 'Finance', label: 'Adjustments', icon: 'adjustments' },
    load: () => import('@/pages/AdjustmentsPage'),
  },
  {
    path: '/finance/reconciliation',
    area: 'finance',
    nav: { group: 'Finance', label: 'Reconciliation', icon: 'reconciliation' },
    load: () => import('@/pages/ReconciliationPage'),
  },
  {
    path: '/support',
    area: 'support',
    nav: { group: 'Care', label: 'Support', icon: 'support' },
    load: () => import('@/pages/SupportPage'),
  },
  { path: '/support/:id', area: 'support', load: () => import('@/pages/TicketPage') },
  {
    path: '/incidents',
    area: 'incidents',
    nav: { group: 'Care', label: 'Incidents', icon: 'incidents' },
    load: () => import('@/pages/IncidentsPage'),
  },
  {
    path: '/salary/shifts',
    area: 'salary',
    nav: { group: 'Workforce', label: 'Shifts', icon: 'shifts' },
    load: () => import('@/pages/ShiftsPage'),
  },
  {
    path: '/salary/attendance',
    area: 'salary',
    nav: { group: 'Workforce', label: 'Attendance', icon: 'attendance' },
    load: () => import('@/pages/AttendancePage'),
  },
  {
    path: '/salary/payments',
    area: 'salary',
    nav: { group: 'Workforce', label: 'Salary payments', icon: 'salary' },
    load: () => import('@/pages/SalaryPaymentsPage'),
  },
  {
    path: '/configuration',
    area: 'configuration',
    nav: { group: 'Admin', label: 'Configuration', icon: 'configuration' },
    load: () => import('@/pages/ConfigurationPage'),
  },
  {
    path: '/staff',
    area: 'staff',
    nav: { group: 'Admin', label: 'Staff', icon: 'staff' },
    load: () => import('@/pages/StaffPage'),
  },
  {
    path: '/audit-log',
    area: 'auditLog',
    nav: { group: 'Admin', label: 'Audit log', icon: 'auditLog' },
    load: () => import('@/pages/AuditLogPage'),
  },
  { path: '/account', load: () => import('@/pages/AccountPage') },
  // Component gallery for review; left out of production builds.
  ...(import.meta.env.DEV || import.meta.env.VITE_APP_ENV === 'demo'
    ? [{ path: '/ui-kit', load: () => import('@/pages/UiKitPage') }]
    : []),
  { path: '*', load: () => import('@/pages/NotFoundPage') },
];

export interface NavItem {
  to: string;
  label: string;
  area: Area;
  icon: IconName;
  group: string;
}

/** The left rail: groups in first-seen order, items in table order. */
export const navGroups: { group: string; items: NavItem[] }[] = signedInRoutes.reduce<
  { group: string; items: NavItem[] }[]
>((groups, r) => {
  if (!r.nav || !r.area) return groups;
  const item = { to: r.path, label: r.nav.label, area: r.area, icon: r.nav.icon, group: r.nav.group };
  const g = groups.find((x) => x.group === r.nav!.group);
  if (g) g.items.push(item);
  else groups.push({ group: r.nav.group, items: [item] });
  return groups;
}, []);

/** The menu's two halves (the toggle at the top of the sidebar). Overview sits in both. */
export type NavSide = 'operations' | 'backOffice';
export const navSides: Record<NavSide, { label: string; groups: string[] }> = {
  operations: { label: 'Operations', groups: ['', 'People', 'Operations', 'Care'] },
  backOffice: { label: 'Back office', groups: ['', 'Finance', 'Workforce', 'Admin'] },
};

/** Phone tab bar: the first four of these a role can use, then "More". */
export const mobileTabOrder = [
  '/',
  '/verification',
  '/live',
  '/incidents',
  '/rides',
  '/finance/topups',
  '/finance/adjustments',
  '/support',
  '/drivers',
  '/salary/shifts',
  '/configuration',
];

/** The top bar's main button, per role: where that person's work starts. */
export const primaryAction: Record<StaffRole, { label: string; to: string; icon: IconName }> = {
  super_admin: { label: 'Live map', to: '/live', icon: 'liveMap' },
  verifier: { label: 'Review queue', to: '/verification', icon: 'verification' },
  dispatcher: { label: 'Live map', to: '/live', icon: 'liveMap' },
  finance: { label: 'Approvals', to: '/finance/adjustments?tab=approvals', icon: 'adjustments' },
  support: { label: 'Open tickets', to: '/support', icon: 'support' },
  hr: { label: 'Shifts', to: '/salary/shifts', icon: 'shifts' },
};
