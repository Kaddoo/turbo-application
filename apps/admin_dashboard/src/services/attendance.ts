import type { Body, Query } from '@/types';
import { api, call } from './http';

export const attendance = {
  list: (query: Query<'/admin/attendance', 'get'>) => call(api.GET('/admin/attendance', { params: { query } })),
  /** The original record is kept in the audit log. */
  correct: (id: string, body: Body<'/admin/attendance/{id}', 'patch'>) =>
    call(api.PATCH('/admin/attendance/{id}', { params: { path: { id } }, body })),
};
