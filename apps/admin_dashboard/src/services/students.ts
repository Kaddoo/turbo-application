import type { Body, Query } from '@/types';
import { api, call, callWithStatus } from './http';

export const students = {
  list: (query: Query<'/admin/students', 'get'>) => call(api.GET('/admin/students', { params: { query } })),
  get: (id: string) => call(api.GET('/admin/students/{id}', { params: { path: { id } } })),
  update: (id: string, body: Body<'/admin/students/{id}', 'patch'>) =>
    call(api.PATCH('/admin/students/{id}', { params: { path: { id } }, body })),
  /** Signs the student out everywhere. */
  changePhone: (id: string, body: Body<'/admin/students/{id}/phone', 'put'>) =>
    call(api.PUT('/admin/students/{id}/phone', { params: { path: { id } }, body })),
  signOutEverywhere: (id: string) => call(api.DELETE('/admin/students/{id}/sessions', { params: { path: { id } } })),
  wallet: (id: string) => call(api.GET('/admin/students/{id}/wallet', { params: { path: { id } } })),
  walletTransactions: (id: string, query: Query<'/admin/students/{id}/wallet/transactions', 'get'>) =>
    call(api.GET('/admin/students/{id}/wallet/transactions', { params: { path: { id }, query } })),
  /** 200 applied at once; 202 sent for a second finance user's approval. */
  adjustWallet: async (id: string, body: Body<'/admin/students/{id}/wallet/adjustments', 'post'>, idempotencyKey: string) => {
    const { data, status } = await callWithStatus(
      api.POST('/admin/students/{id}/wallet/adjustments', {
        params: { path: { id }, header: { 'Idempotency-Key': idempotencyKey } },
        body,
      }),
    );
    return { pending: status === 202, data };
  },
};
