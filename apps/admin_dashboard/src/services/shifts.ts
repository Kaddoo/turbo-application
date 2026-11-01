import type { Body, Query } from '@/types';
import { api, call } from './http';

export const shifts = {
  list: (query: Query<'/admin/shifts', 'get'>) => call(api.GET('/admin/shifts', { params: { query } })),
  create: (body: Body<'/admin/shifts', 'post'>) => call(api.POST('/admin/shifts', { body })),
  remove: (id: string) => call(api.DELETE('/admin/shifts/{id}', { params: { path: { id } } })),
};
