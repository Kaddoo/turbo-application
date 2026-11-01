import type { Body, Query } from '@/types';
import { api, call } from './http';

export const rides = {
  list: (query: Query<'/admin/rides', 'get'>) => call(api.GET('/admin/rides', { params: { query } })),
  get: (id: string) => call(api.GET('/admin/rides/{id}', { params: { path: { id } } })),
  reassign: (id: string, body: Body<'/admin/rides/{id}/reassign', 'post'>) =>
    call(api.POST('/admin/rides/{id}/reassign', { params: { path: { id } }, body })),
  cancel: (id: string, body: Body<'/admin/rides/{id}/cancel', 'post'>) =>
    call(api.POST('/admin/rides/{id}/cancel', { params: { path: { id } }, body })),
  /** Force-complete a stuck ride; the fare is charged. */
  complete: (id: string, body: Body<'/admin/rides/{id}/complete', 'post'>) =>
    call(api.POST('/admin/rides/{id}/complete', { params: { path: { id } }, body })),
  refund: (id: string, body: Body<'/admin/rides/{id}/refund', 'post'>, idempotencyKey: string) =>
    call(
      api.POST('/admin/rides/{id}/refund', {
        params: { path: { id }, header: { 'Idempotency-Key': idempotencyKey } },
        body,
      }),
    ),
};
