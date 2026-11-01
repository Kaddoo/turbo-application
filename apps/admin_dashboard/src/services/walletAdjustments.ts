import type { Body, Query } from '@/types';
import { api, call } from './http';

export const walletAdjustments = {
  list: (query: Query<'/admin/wallet-adjustments', 'get'>) =>
    call(api.GET('/admin/wallet-adjustments', { params: { query } })),
  approve: (id: string, body: Body<'/admin/wallet-adjustments/{id}/approve', 'post'>, idempotencyKey: string) =>
    call(
      api.POST('/admin/wallet-adjustments/{id}/approve', {
        params: { path: { id }, header: { 'Idempotency-Key': idempotencyKey } },
        body,
      }),
    ),
  reject: (id: string, body: Body<'/admin/wallet-adjustments/{id}/reject', 'post'>, idempotencyKey: string) =>
    call(
      api.POST('/admin/wallet-adjustments/{id}/reject', {
        params: { path: { id }, header: { 'Idempotency-Key': idempotencyKey } },
        body,
      }),
    ),
};
