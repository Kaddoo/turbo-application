import type { Body } from '@/types';
import { api, call } from './http';

export const me = {
  get: () => call(api.GET('/admin/me')),
  changePassword: (body: Body<'/admin/me/password', 'post'>) => call(api.POST('/admin/me/password', { body })),
};
