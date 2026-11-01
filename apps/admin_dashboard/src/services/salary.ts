import type { Body, Query } from '@/types';
import { api, call } from './http';

/** Records salary paid outside the system. Nothing here sends money. */
export const salary = {
  payments: (query: Query<'/admin/salary-payments', 'get'>) =>
    call(api.GET('/admin/salary-payments', { params: { query } })),
  recordPayment: (body: Body<'/admin/salary-payments', 'post'>, idempotencyKey: string) =>
    call(api.POST('/admin/salary-payments', { params: { header: { 'Idempotency-Key': idempotencyKey } }, body })),
};
