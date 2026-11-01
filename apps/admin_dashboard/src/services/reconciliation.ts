import type { Body, Query } from '@/types';
import { api, call } from './http';

export const reconciliation = {
  list: (query: Query<'/admin/reconciliation/reports', 'get'>) =>
    call(api.GET('/admin/reconciliation/reports', { params: { query } })),
  run: (body: Body<'/admin/reconciliation/reports', 'post'>) => call(api.POST('/admin/reconciliation/reports', { body })),
};
