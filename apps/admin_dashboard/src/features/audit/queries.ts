import { useCursorList } from '@/hooks';
import { audit } from '@/services/audit';

export interface AuditFilter {
  entityType: string;
  entityId: string;
  actor: string;
}

/** Empty filter values mean "any". */
export function useAuditLog(filter: AuditFilter) {
  return useCursorList(['audit', filter], (cursor) =>
    audit.list({
      entityType: filter.entityType || undefined,
      entityId: filter.entityId || undefined,
      actorStaffId: filter.actor || undefined,
      cursor,
      limit: 50,
    }),
  );
}
