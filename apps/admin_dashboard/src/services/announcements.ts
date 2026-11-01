import type { Body } from '@/types';
import { api, call } from './http';

export const announcements = {
  send: (body: Body<'/admin/announcements', 'post'>) => call(api.POST('/admin/announcements', { body })),
};
