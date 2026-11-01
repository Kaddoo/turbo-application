import type { Body } from '@/types';
import { api, call } from './http';

export const fareBands = {
  /** Changes only affect new quotes. */
  save: (body: Body<'/admin/fare-bands', 'put'>) => call(api.PUT('/admin/fare-bands', { body })),
};
