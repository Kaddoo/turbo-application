import { useAction } from '@/hooks';
import { announcements } from '@/services/announcements';
import type { Body } from '@/types';

export function useSendAnnouncement() {
  return useAction((body: Body<'/admin/announcements', 'post'>) => announcements.send(body));
}
