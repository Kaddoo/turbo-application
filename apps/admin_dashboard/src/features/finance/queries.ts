import { useQuery } from '@tanstack/react-query';
import { PAGE_SIZE, sharedKeys, useAction, useCursorList } from '@/hooks';
import { reconciliation } from '@/services/reconciliation';
import { students } from '@/services/students';
import { topups } from '@/services/topups';
import { uploadFile } from '@/services/uploads';
import { walletAdjustments } from '@/services/walletAdjustments';
import type { Body, Schemas, Topup } from '@/types';

export const financeKeys = {
  topups: ['topups'],
  topupList: (flaggedOnly: boolean, status: string) => ['topups', flaggedOnly, status],
  wallet: (studentId: string) => ['wallet', studentId],
  walletTx: (studentId: string) => ['wallet-tx', studentId],
  adjustments: ['adjustments'],
  adjustmentList: (status: string) => ['adjustments', status],
  reconciliation: ['recon'],
};

/** Empty status means "any". */
export function useTopups(flaggedOnly: boolean, status: string) {
  return useCursorList(financeKeys.topupList(flaggedOnly, status), (cursor) =>
    topups.list({
      flagged: flaggedOnly || undefined,
      status: (status || undefined) as Topup['status'] | undefined,
      cursor,
      limit: PAGE_SIZE,
    }),
  );
}

export function useResolveTopup() {
  return useAction(
    ({ id, body }: { id: string; body: Body<'/admin/topups/{id}/resolve', 'post'> }) => topups.resolve(id, body),
    [financeKeys.topups, sharedKeys.overview],
  );
}

export function useStudentWallet(studentId: string) {
  return useQuery({
    queryKey: financeKeys.wallet(studentId),
    enabled: !!studentId,
    queryFn: () => students.wallet(studentId),
  });
}

export function useWalletTransactions(studentId: string) {
  return useCursorList(
    financeKeys.walletTx(studentId),
    (cursor) => students.walletTransactions(studentId, { cursor, limit: PAGE_SIZE }),
    !!studentId,
  );
}

/** Resolves to `{ pending: true }` when the API sent it for approval (202). */
export function useAdjustWallet(studentId: string) {
  return useAction(
    ({ body, key }: { body: Body<'/admin/students/{id}/wallet/adjustments', 'post'>; key: string }) =>
      students.adjustWallet(studentId, body, key),
    [financeKeys.wallet(studentId), financeKeys.walletTx(studentId), financeKeys.adjustments],
  );
}

export function useAdjustmentRequests(status: Schemas['AdjustmentRequest']['status']) {
  return useCursorList(financeKeys.adjustmentList(status), (cursor) =>
    walletAdjustments.list({ status, cursor, limit: PAGE_SIZE }),
  );
}

export function useDecideAdjustment() {
  return useAction(
    ({ id, approve, note, key }: { id: string; approve: boolean; note: string; key: string }) =>
      approve
        ? walletAdjustments.approve(id, note ? { note } : {}, key)
        : walletAdjustments.reject(id, note ? { note } : {}, key),
    [financeKeys.adjustments, sharedKeys.overview],
  );
}

export function useReconciliationReports() {
  return useCursorList(financeKeys.reconciliation, (cursor) => reconciliation.list({ cursor, limit: 10 }));
}

/** Uploads the provider statement, then runs the report. */
export function useRunReconciliation() {
  return useAction(
    async ({ file, from, to }: { file: File; from: string; to: string }) => {
      const statementUploadId = await uploadFile('provider_statement', file);
      return reconciliation.run({ statementUploadId, periodFrom: from, periodTo: to });
    },
    [financeKeys.reconciliation],
  );
}
