import type { Body } from '@/types';
import { api, call } from './http';

export const serviceArea = {
  /** Public: boundary, pickup points, trip limit and fare bands. */
  get: () => call(api.GET('/service-area')),
  saveBoundary: (body: Body<'/admin/service-area', 'put'>) => call(api.PUT('/admin/service-area', { body })),
};
