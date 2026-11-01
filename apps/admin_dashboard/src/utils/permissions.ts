import type { StaffRole } from './roles';

/**
 * Actions on the dashboard and the staff role allowed to perform each, from
 * the contract's `x-roles` on the operation behind it (`op`). Super admin may
 * do everything. A test checks every entry against api/contract/openapi.yaml, so the
 * table cannot drift from the contract.
 *
 * This is for the interface only: hiding a button is a convenience, never the
 * security boundary. The API checks the role on every call and answers 403.
 *
 * Rule for screens: an action the role never has is hidden; an action the
 * role has but the record's state blocks is shown disabled with the reason.
 */
export const actions = {
  'verification.claim': { role: 'verifier', op: 'POST /admin/verifications/{id}/claim' },
  'verification.decide': { role: 'verifier', op: 'POST /admin/verifications/{id}/decision' },
  'student.edit': { role: 'verifier', op: 'PATCH /admin/students/{id}' },
  'student.changePhone': { role: 'verifier', op: 'PUT /admin/students/{id}/phone' },
  'student.viewWallet': { role: 'finance', op: 'GET /admin/students/{id}/wallet' },
  'student.adjustWallet': { role: 'finance', op: 'POST /admin/students/{id}/wallet/adjustments' },
  'student.signOutEverywhere': { role: 'support', op: 'DELETE /admin/students/{id}/sessions' },
  'driver.create': { role: 'hr', op: 'POST /admin/drivers' },
  'driver.edit': { role: 'hr', op: 'PATCH /admin/drivers/{id}' },
  'driver.uploadDocument': { role: 'hr', op: 'POST /admin/drivers/{id}/documents' },
  'driver.editSalaryProfile': { role: 'hr', op: 'PUT /admin/drivers/{id}/salary-profile' },
  'vehicle.create': { role: 'hr', op: 'POST /admin/vehicles' },
  'vehicle.edit': { role: 'hr', op: 'PATCH /admin/vehicles/{id}' },
  'ride.reassign': { role: 'dispatcher', op: 'POST /admin/rides/{id}/reassign' },
  'ride.cancel': { role: 'dispatcher', op: 'POST /admin/rides/{id}/cancel' },
  'ride.complete': { role: 'dispatcher', op: 'POST /admin/rides/{id}/complete' },
  'ride.refund': { role: 'finance', op: 'POST /admin/rides/{id}/refund' },
  'announcement.send': { role: 'dispatcher', op: 'POST /admin/announcements' },
  'topup.resolve': { role: 'finance', op: 'POST /admin/topups/{id}/resolve' },
  'adjustment.approve': { role: 'finance', op: 'POST /admin/wallet-adjustments/{id}/approve' },
  'adjustment.reject': { role: 'finance', op: 'POST /admin/wallet-adjustments/{id}/reject' },
  'reconciliation.create': { role: 'finance', op: 'POST /admin/reconciliation/reports' },
  'ticket.update': { role: 'support', op: 'PATCH /admin/support/tickets/{id}' },
  'ticket.reply': { role: 'support', op: 'POST /admin/support/tickets/{id}/messages' },
  'incident.update': { role: 'support', op: 'PATCH /admin/incidents/{id}' },
  'shift.create': { role: 'hr', op: 'POST /admin/shifts' },
  'shift.delete': { role: 'hr', op: 'DELETE /admin/shifts/{id}' },
  'attendance.edit': { role: 'hr', op: 'PATCH /admin/attendance/{id}' },
  'salary.pay': { role: 'hr', op: 'POST /admin/salary-payments' },
  'config.serviceArea': { role: 'super_admin', op: 'PUT /admin/service-area' },
  'config.pickupPoints': { role: 'super_admin', op: 'POST /admin/pickup-points' },
  'config.fareBands': { role: 'super_admin', op: 'PUT /admin/fare-bands' },
  'config.settings': { role: 'super_admin', op: 'PUT /admin/settings' },
  'config.viewSettings': { role: 'super_admin', op: 'GET /admin/settings' },
  'staff.create': { role: 'super_admin', op: 'POST /admin/staff' },
  'staff.edit': { role: 'super_admin', op: 'PATCH /admin/staff/{id}' },
  'staff.invite': { role: 'super_admin', op: 'POST /admin/staff/{id}/invite' },
  'staff.signOutEverywhere': { role: 'super_admin', op: 'DELETE /admin/staff/{id}/sessions' },
  'account.changePassword': { role: 'any', op: 'POST /admin/me/password' },
} as const satisfies Record<string, { role: StaffRole | 'any'; op: string }>;

export type Action = keyof typeof actions;

export function canDo(role: StaffRole | null | undefined, action: Action): boolean {
  if (!role) return false;
  const needed: StaffRole | 'any' = actions[action].role;
  return needed === 'any' || role === 'super_admin' || role === needed;
}
