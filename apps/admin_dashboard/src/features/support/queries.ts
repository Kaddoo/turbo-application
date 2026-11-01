import { useQuery } from '@tanstack/react-query';
import { PAGE_SIZE, useAction, useCursorList } from '@/hooks';
import { support } from '@/services/support';
import type { Body, SupportTicket } from '@/types';

export const ticketKeys = {
  all: ['tickets'],
  list: (status: string, category: string) => ['tickets', status, category],
  detail: (id: string) => ['ticket', id],
};

/** Empty filter values mean "any". */
export function useTickets(status: string, category: string) {
  return useCursorList(ticketKeys.list(status, category), (cursor) =>
    support.list({
      status: (status || undefined) as SupportTicket['status'] | undefined,
      category: category || undefined,
      cursor,
      limit: PAGE_SIZE,
    }),
  );
}

export function useTicket(id: string) {
  return useQuery({ queryKey: ticketKeys.detail(id), queryFn: () => support.get(id) });
}

export function useReplyToTicket(id: string) {
  return useAction(
    (body: Body<'/admin/support/tickets/{id}/messages', 'post'>) => support.reply(id, body),
    [ticketKeys.detail(id)],
  );
}

export function useUpdateTicket(id: string) {
  return useAction(
    (body: Body<'/admin/support/tickets/{id}', 'patch'>) => support.update(id, body),
    [ticketKeys.detail(id), ticketKeys.all],
  );
}
