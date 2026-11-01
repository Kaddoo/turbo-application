import { useAction } from '@/hooks';
import { me } from '@/services/me';
import type { Body } from '@/types';

export function useChangePassword() {
  return useAction((body: Body<'/admin/me/password', 'post'>) => me.changePassword(body));
}
