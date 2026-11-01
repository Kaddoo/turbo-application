import { PAGE_SIZE, useAction, useCursorList } from '@/hooks';
import { attendance } from '@/services/attendance';
import { salary } from '@/services/salary';
import { shifts } from '@/services/shifts';
import type { Body } from '@/types';

export const workforceKeys = {
  shifts: ['shifts'],
  shiftList: (driverId: string) => ['shifts', driverId],
  attendance: ['attendance'],
  attendanceList: (driverId: string) => ['attendance', driverId],
  salaryPayments: ['salary-payments'],
  salaryPaymentList: (driverId: string) => ['salary-payments', driverId],
};

/** Empty driverId means every driver. */
export function useShifts(driverId: string) {
  return useCursorList(workforceKeys.shiftList(driverId), (cursor) => shifts.list({ driverId: driverId || undefined, cursor, limit: 50 }));
}

export function useCreateShift() {
  return useAction((body: Body<'/admin/shifts', 'post'>) => shifts.create(body), [workforceKeys.shifts]);
}

export function useCancelShift() {
  return useAction((id: string) => shifts.remove(id), [workforceKeys.shifts]);
}

export function useAttendance(driverId: string) {
  return useCursorList(workforceKeys.attendanceList(driverId), (cursor) =>
    attendance.list({ driverId: driverId || undefined, cursor, limit: PAGE_SIZE }),
  );
}

export function useCorrectAttendance() {
  return useAction(
    ({ id, body }: { id: string; body: Body<'/admin/attendance/{id}', 'patch'> }) => attendance.correct(id, body),
    [workforceKeys.attendance],
  );
}

export function useSalaryPayments(driverId: string) {
  return useCursorList(workforceKeys.salaryPaymentList(driverId), (cursor) =>
    salary.payments({ driverId: driverId || undefined, cursor, limit: PAGE_SIZE }),
  );
}

export function useRecordSalaryPayment() {
  return useAction(
    ({ body, key }: { body: Body<'/admin/salary-payments', 'post'>; key: string }) => salary.recordPayment(body, key),
    [workforceKeys.salaryPayments],
  );
}
