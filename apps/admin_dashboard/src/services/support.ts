import type { Body, Query } from '@/types';
import { api, call } from './http';

export const support = {
  list: (query: Query<'/admin/support/tickets', 'get'>) =>
    call(api.GET('/admin/support/tickets', { params: { query } })),
  get: (id: string) => call(api.GET('/admin/support/tickets/{id}', { params: { path: { id } } })),
  reply: (id: string, body: Body<'/admin/support/tickets/{id}/messages', 'post'>) =>
    call(api.POST('/admin/support/tickets/{id}/messages', { params: { path: { id } }, body })),
  update: (id: string, body: Body<'/admin/support/tickets/{id}', 'patch'>) =>
    call(api.PATCH('/admin/support/tickets/{id}', { params: { path: { id } }, body })),
};
