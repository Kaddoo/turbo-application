import type { Body, Query } from '@/types';
import { api, call } from './http';

export const drivers = {
  list: (query: Query<'/admin/drivers', 'get'>) => call(api.GET('/admin/drivers', { params: { query } })),
  get: (id: string) => call(api.GET('/admin/drivers/{id}', { params: { path: { id } } })),
  /** Texts the driver an invite. */
  create: (body: Body<'/admin/drivers', 'post'>, idempotencyKey: string) =>
    call(api.POST('/admin/drivers', { params: { header: { 'Idempotency-Key': idempotencyKey } }, body })),
  update: (id: string, body: Body<'/admin/drivers/{id}', 'patch'>) =>
    call(api.PATCH('/admin/drivers/{id}', { params: { path: { id } }, body })),
  addDocument: (id: string, body: Body<'/admin/drivers/{id}/documents', 'post'>) =>
    call(api.POST('/admin/drivers/{id}/documents', { params: { path: { id } }, body })),
  salaryProfile: (id: string) => call(api.GET('/admin/drivers/{id}/salary-profile', { params: { path: { id } } })),
  setSalaryProfile: (id: string, body: Body<'/admin/drivers/{id}/salary-profile', 'put'>) =>
    call(api.PUT('/admin/drivers/{id}/salary-profile', { params: { path: { id } }, body })),
};
