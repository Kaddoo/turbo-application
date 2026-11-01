import { useQuery } from '@tanstack/react-query';
import { PAGE_SIZE, sharedKeys, useAction, useCursorList } from '@/hooks';
import { verifications } from '@/services/verifications';
import type { Body, VerificationStatus } from '@/types';

export const verificationKeys = {
  all: ['verifications'],
  list: (status: VerificationStatus) => ['verifications', status],
  detail: (id: string) => ['verification', id],
};

export function useVerificationQueue(status: VerificationStatus) {
  return useCursorList(verificationKeys.list(status), (cursor) =>
    verifications.list({ status, cursor, limit: PAGE_SIZE }),
  );
}

export function useVerification(id: string) {
  return useQuery({ queryKey: verificationKeys.detail(id), queryFn: () => verifications.get(id) });
}

export function useClaimVerification() {
  return useAction((id: string) => verifications.claim(id), [verificationKeys.all]);
}

export function useDecideVerification(id: string) {
  return useAction(
    (body: Body<'/admin/verifications/{id}/decision', 'post'>) => verifications.decide(id, body),
    [verificationKeys.all, verificationKeys.detail(id), sharedKeys.overview],
  );
}
