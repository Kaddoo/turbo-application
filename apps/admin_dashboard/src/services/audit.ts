import type { Query } from '@/types';
import { api, call } from './http';

export const audit = {
  list: (query: Query<'/admin/audit-log', 'get'>) => call(api.GET('/admin/audit-log', { params: { query } })),
};
