import type { ComponentType } from 'react';
import type { Area } from '@/utils/roles';

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
  nav?: { group: string; label: string };
  /** Each page is its own chunk, loaded when first opened. */
  load: () => Promise<{ default: ComponentType }>;
}

export const signedInRoutes: PageRoute[] = [
  { path: '/', area: 'overview', nav: { group: '', label: 'Overview' }, load: () => import('@/pages/OverviewPage') },
  {
    path: '/verification',
    area: 'verification',
    nav: { group: 'People', label: 'Verification' },
    load: () => import('@/pages/VerificationQueuePage'),
  },
  { path: '/verification/:id', area: 'verification', load: () => import('@/pages/VerificationReviewPage') },
  {
    path: '/students',
    area: 'students',
    nav: { group: 'People', label: 'Students' },
    load: () => import('@/pages/StudentsPage'),
  },
  { path: '/students/:id', area: 'students', load: () => import('@/pages/StudentDetailPage') },
  {
    path: '/drivers',
    area: 'drivers',
    nav: { group: 'People', label: 'Drivers' },
    load: () => import('@/pages/DriversPage'),
  },
  { path: '/drivers/:id', area: 'drivers', load: () => import('@/pages/DriverDetailPage') },
  {
    path: '/vehicles',
    area: 'vehicles',
    nav: { group: 'People', label: 'Vehicles' },
    load: () => import('@/pages/VehiclesPage'),
  },
  {
    path: '/live',
    area: 'liveMap',
    nav: { group: 'Operations', label: 'Live map' },
    load: () => import('@/pages/LiveMapPage'),
  },
  {
    path: '/rides',
    area: 'rides',
    nav: { group: 'Operations', label: 'Rides' },
    load: () => import('@/pages/RidesPage'),
  },
  { path: '/rides/:id', area: 'rides', load: () => import('@/pages/RideDetailPage') },
  {
    path: '/announcements',
    area: 'announcements',
    nav: { group: 'Operations', label: 'Announcements' },
    load: () => import('@/pages/AnnouncementsPage'),
  },
  {
    path: '/finance/topups',
    area: 'finance',
    nav: { group: 'Finance', label: 'Top-ups' },
    load: () => import('@/pages/TopupsPage'),
  },
  {
    path: '/finance/adjustments',
    area: 'finance',
    nav: { group: 'Finance', label: 'Adjustments' },
    load: () => import('@/pages/AdjustmentsPage'),
  },
  {
    path: '/finance/reconciliation',
    area: 'finance',
    nav: { group: 'Finance', label: 'Reconciliation' },
    load: () => import('@/pages/ReconciliationPage'),
  },
  {
    path: '/support',
    area: 'support',
    nav: { group: 'Care', label: 'Support' },
    load: () => import('@/pages/SupportPage'),
  },
  { path: '/support/:id', area: 'support', load: () => import('@/pages/TicketPage') },
  {
    path: '/incidents',
    area: 'incidents',
    nav: { group: 'Care', label: 'Incidents' },
    load: () => import('@/pages/IncidentsPage'),
  },
  {
    path: '/salary/shifts',
    area: 'salary',
    nav: { group: 'Workforce', label: 'Shifts' },
    load: () => import('@/pages/ShiftsPage'),
  },
  {
    path: '/salary/attendance',
    area: 'salary',
    nav: { group: 'Workforce', label: 'Attendance' },
    load: () => import('@/pages/AttendancePage'),
  },
  {
    path: '/salary/payments',
    area: 'salary',
    nav: { group: 'Workforce', label: 'Salary payments' },
    load: () => import('@/pages/SalaryPaymentsPage'),
  },
  {
    path: '/configuration',
    area: 'configuration',
    nav: { group: 'Admin', label: 'Configuration' },
    load: () => import('@/pages/ConfigurationPage'),
  },
  { path: '/staff', area: 'staff', nav: { group: 'Admin', label: 'Staff' }, load: () => import('@/pages/StaffPage') },
  {
    path: '/audit-log',
    area: 'auditLog',
    nav: { group: 'Admin', label: 'Audit log' },
    load: () => import('@/pages/AuditLogPage'),
  },
  { path: '/account', load: () => import('@/pages/AccountPage') },
  { path: '*', load: () => import('@/pages/NotFoundPage') },
];

export interface NavItem {
  to: string;
  label: string;
  area: Area;
}

/** The left rail: groups in first-seen order, items in table order. */
export const navGroups: { group: string; items: NavItem[] }[] = signedInRoutes.reduce<
  { group: string; items: NavItem[] }[]
>((groups, r) => {
  if (!r.nav || !r.area) return groups;
  const item = { to: r.path, label: r.nav.label, area: r.area };
  const g = groups.find((x) => x.group === r.nav!.group);
  if (g) g.items.push(item);
  else groups.push({ group: r.nav.group, items: [item] });
  return groups;
}, []);
