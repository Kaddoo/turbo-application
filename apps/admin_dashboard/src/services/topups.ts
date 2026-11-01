import type { Body, Query } from '@/types';
import { api, call } from './http';

export const topups = {
  list: (query: Query<'/admin/topups', 'get'>) => call(api.GET('/admin/topups', { params: { query } })),
  resolve: (id: string, body: Body<'/admin/topups/{id}/resolve', 'post'>, idempotencyKey: string) =>
    call(
      api.POST('/admin/topups/{id}/resolve', {
        params: { path: { id }, header: { 'Idempotency-Key': idempotencyKey } },
        body,
      }),
    ),
};
