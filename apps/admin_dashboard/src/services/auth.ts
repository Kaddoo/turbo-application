import type { Body } from '@/types';
import { api, call } from './http';

/** Staff sign-in, invites, MFA and password reset. Session state lives in `@/state/session`. */
export const auth = {
  login: (body: Body<'/auth/admin/login', 'post'>) => call(api.POST('/auth/admin/login', { body })),
  /** Revokes the session on the API. Callers sign out locally whatever happens. */
  logout: () => api.POST('/auth/logout'),
  forgotPassword: (body: Body<'/auth/admin/password/forgot', 'post'>) =>
    call(api.POST('/auth/admin/password/forgot', { body })),
  resetPassword: (body: Body<'/auth/admin/password/reset', 'post'>) =>
    call(api.POST('/auth/admin/password/reset', { body })),
  acceptInvite: (body: Body<'/auth/admin/invite/accept', 'post'>) =>
    call(api.POST('/auth/admin/invite/accept', { body })),
  confirmMfa: (body: Body<'/auth/admin/mfa/confirm', 'post'>) => call(api.POST('/auth/admin/mfa/confirm', { body })),
};
