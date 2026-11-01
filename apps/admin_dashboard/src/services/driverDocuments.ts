import type { Query } from '@/types';
import { api, call } from './http';

export const driverDocuments = {
  expiring: (query: Query<'/admin/driver-documents/expiring', 'get'>) =>
    call(api.GET('/admin/driver-documents/expiring', { params: { query } })),
};
