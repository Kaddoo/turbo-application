import { useQuery } from '@tanstack/react-query';
import { PAGE_SIZE, useAction, useCursorList } from '@/hooks';
import { students } from '@/services/students';
import type { AccountStatus, Body, VerificationStatus } from '@/types';

export const studentKeys = {
  all: ['students'],
  list: (search: string, verificationStatus: string, accountStatus: string) => ['students', search, verificationStatus, accountStatus],
  detail: (id: string) => ['student', id],
};

/** Empty filter values mean "any". */
export function useStudents(search: string, verificationStatus: string, accountStatus: string) {
  return useCursorList(studentKeys.list(search, verificationStatus, accountStatus), (cursor) =>
    students.list({
      q: search || undefined,
      verificationStatus: (verificationStatus || undefined) as VerificationStatus | undefined,
      accountStatus: (accountStatus || undefined) as AccountStatus | undefined,
      cursor,
      limit: PAGE_SIZE,
    }),
  );
}

export function useStudent(id: string) {
  return useQuery({ queryKey: studentKeys.detail(id), queryFn: () => students.get(id) });
}

export function useSetStudentStatus(id: string) {
  return useAction((body: Body<'/admin/students/{id}', 'patch'>) => students.update(id, body), [
    studentKeys.detail(id),
    studentKeys.all,
  ]);
}

export function useChangeStudentPhone(id: string) {
  return useAction((body: Body<'/admin/students/{id}/phone', 'put'>) => students.changePhone(id, body), [studentKeys.detail(id)]);
}

export function useSignOutStudent(id: string) {
  return useAction(() => students.signOutEverywhere(id));
}
