import type { Body, Query } from '@/types';
import { api, call } from './http';

export const verifications = {
  list: (query: Query<'/admin/verifications', 'get'>) => call(api.GET('/admin/verifications', { params: { query } })),
  get: (id: string) => call(api.GET('/admin/verifications/{id}', { params: { path: { id } } })),
  /** 15-minute lock; 409 `verification_claimed` when another reviewer holds it. */
  claim: (id: string) => call(api.POST('/admin/verifications/{id}/claim', { params: { path: { id } } })),
  decide: (id: string, body: Body<'/admin/verifications/{id}/decision', 'post'>) =>
    call(api.POST('/admin/verifications/{id}/decision', { params: { path: { id } }, body })),
};
