import { PAGE_SIZE, sharedKeys, useAction, useCursorList } from '@/hooks';
import { incidents } from '@/services/incidents';
import type { Body, Incident } from '@/types';

/** The prefix also covers the SOS banner's query. */
export const incidentKeys = { all: ['incidents'], list: (status: string) => ['incidents', status] };

/** Empty status means "any". */
export function useIncidents(status: string) {
  return useCursorList(incidentKeys.list(status), (cursor) =>
    incidents.list({ status: (status || undefined) as Incident['status'] | undefined, cursor, limit: PAGE_SIZE }),
  );
}

export function useUpdateIncident() {
  return useAction(
    ({ id, body }: { id: string; body: Body<'/admin/incidents/{id}', 'patch'> }) => incidents.update(id, body),
    [incidentKeys.all, sharedKeys.overview],
  );
}
