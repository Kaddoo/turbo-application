import type { Body } from '@/types';
import { api, call } from './http';

export const settings = {
  get: () => call(api.GET('/admin/settings')),
  save: (body: Body<'/admin/settings', 'put'>) => call(api.PUT('/admin/settings', { body })),
};
