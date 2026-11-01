import type { Schemas } from '@/types';

export type StaffRole = Schemas['StaffRole'];

/**
 * Areas of the dashboard and the staff role that may use them, straight from
 * `x-roles` in the contract. `super_admin` can use everything.
 */
export const areaRoles = {
  overview: null,
  verification: 'verifier',
  students: 'verifier',
  // Support may open one student, and support and finance one ride, as a reduced and audited view. The lists stay with the owner roles.
  studentDetail: ['verifier', 'support'],
  rideDetail: ['dispatcher', 'support', 'finance'],
  drivers: 'hr',
  vehicles: 'hr',
  liveMap: 'dispatcher',
  rides: 'dispatcher',
  announcements: 'dispatcher',
  finance: 'finance',
  support: 'support',
  incidents: 'support',
  salary: 'hr',
  configuration: 'super_admin',
  staff: 'super_admin',
  auditLog: 'super_admin',
} as const satisfies Record<string, StaffRole | readonly StaffRole[] | null>;

export type Area = keyof typeof areaRoles;

/** The read each area opens with; a test checks its `x-roles` matches `areaRoles`. */
export const areaReads: Record<Exclude<Area, 'overview'>, string> = {
  verification: 'GET /admin/verifications',
  students: 'GET /admin/students',
  studentDetail: 'GET /admin/students/{id}',
  rideDetail: 'GET /admin/rides/{id}',
  drivers: 'GET /admin/drivers',
  vehicles: 'GET /admin/vehicles',
  liveMap: 'GET /admin/rides/live',
  rides: 'GET /admin/rides',
  announcements: 'POST /admin/announcements',
  finance: 'GET /admin/topups',
  support: 'GET /admin/support/tickets',
  incidents: 'GET /admin/incidents',
  salary: 'GET /admin/salary-payments',
  configuration: 'GET /admin/settings',
  staff: 'GET /admin/staff',
  auditLog: 'GET /admin/audit-log',
};

/** Plain names for the access-denied screen. */
export const areaLabels: Record<Area, string> = {
  overview: 'the overview',
  verification: 'verification',
  students: 'students',
  studentDetail: 'a student',
  rideDetail: 'a ride',
  drivers: 'drivers',
  vehicles: 'vehicles',
  liveMap: 'the live map',
  rides: 'rides',
  announcements: 'announcements',
  finance: 'finance',
  support: 'support',
  incidents: 'incidents',
  salary: 'shifts, attendance and salary',
  configuration: 'configuration',
  staff: 'staff',
  auditLog: 'the audit log',
};

export function canUse(role: StaffRole | null | undefined, area: Area): boolean {
  if (!role) return false;
  const needed: StaffRole | readonly StaffRole[] | null = areaRoles[area];
  if (needed === null || role === 'super_admin') return true;
  return Array.isArray(needed) ? needed.includes(role) : role === needed;
}

export const roleLabels: Record<StaffRole, string> = {
  super_admin: 'Super admin',
  verifier: 'Verifier',
  dispatcher: 'Dispatcher',
  finance: 'Finance',
  support: 'Support',
  hr: 'HR',
};
