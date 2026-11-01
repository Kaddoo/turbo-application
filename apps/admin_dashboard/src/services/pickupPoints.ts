import type { Body } from '@/types';
import { api, call } from './http';

export const pickupPoints = {
  create: (body: Body<'/admin/pickup-points', 'post'>) => call(api.POST('/admin/pickup-points', { body })),
  update: (id: string, body: Body<'/admin/pickup-points/{id}', 'patch'>) =>
    call(api.PATCH('/admin/pickup-points/{id}', { params: { path: { id } }, body })),
  remove: (id: string) => call(api.DELETE('/admin/pickup-points/{id}', { params: { path: { id } } })),
};
