import type { Body, Query } from '@/types';
import { api, call } from './http';

export const vehicles = {
  list: (query: Query<'/admin/vehicles', 'get'>) => call(api.GET('/admin/vehicles', { params: { query } })),
  create: (body: Body<'/admin/vehicles', 'post'>) => call(api.POST('/admin/vehicles', { body })),
  update: (id: string, body: Body<'/admin/vehicles/{id}', 'patch'>) =>
    call(api.PATCH('/admin/vehicles/{id}', { params: { path: { id } }, body })),
};
