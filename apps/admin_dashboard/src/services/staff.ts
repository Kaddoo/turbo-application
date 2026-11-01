import type { Body, Query } from '@/types';
import { api, call } from './http';

export const staff = {
  list: (query: Query<'/admin/staff', 'get'>) => call(api.GET('/admin/staff', { params: { query } })),
  invite: (body: Body<'/admin/staff', 'post'>) => call(api.POST('/admin/staff', { body })),
  update: (id: string, body: Body<'/admin/staff/{id}', 'patch'>) =>
    call(api.PATCH('/admin/staff/{id}', { params: { path: { id } }, body })),
  resendInvite: (id: string) => call(api.POST('/admin/staff/{id}/invite', { params: { path: { id } } })),
  signOutEverywhere: (id: string) => call(api.DELETE('/admin/staff/{id}/sessions', { params: { path: { id } } })),
};
