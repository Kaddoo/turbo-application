import { useAction, useCursorList } from '@/hooks';
import { staff } from '@/services/staff';
import type { Body } from '@/types';

export const staffKeys = { all: ['staff'] };

export function useStaff() {
  return useCursorList(staffKeys.all, (cursor) => staff.list({ cursor, limit: 50 }));
}

export function useInviteStaff() {
  return useAction((body: Body<'/admin/staff', 'post'>) => staff.invite(body), [staffKeys.all]);
}

export function useUpdateStaff() {
  return useAction(({ id, body }: { id: string; body: Body<'/admin/staff/{id}', 'patch'> }) => staff.update(id, body), [staffKeys.all]);
}

export function useResendInvite() {
  return useAction((id: string) => staff.resendInvite(id));
}

export function useSignOutStaff() {
  return useAction((id: string) => staff.signOutEverywhere(id));
}
