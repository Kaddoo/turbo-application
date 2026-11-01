import type { Schemas } from '../api/client';

export type StaffRole = Schemas['StaffRole'];

/**
 * Areas of the dashboard and the staff role that may use them, straight from
 * `x-roles` in the contract. `super_admin` can use everything.
 */
export const areaRoles = {
  overview: null,
  verification: 'verifier',
  students: 'verifier',
  // Support may open one student and finance may open one ride (a reduced view, audited); the lists stay with the owner roles.
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
