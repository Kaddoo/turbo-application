import type { Body, Query } from '@/types';
import { api, call } from './http';

export const incidents = {
  list: (query: Query<'/admin/incidents', 'get'>) => call(api.GET('/admin/incidents', { params: { query } })),
  update: (id: string, body: Body<'/admin/incidents/{id}', 'patch'>) =>
    call(api.PATCH('/admin/incidents/{id}', { params: { path: { id } }, body })),
};
