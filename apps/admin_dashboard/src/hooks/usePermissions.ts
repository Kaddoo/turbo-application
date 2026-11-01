import { useCallback } from 'react';
import { useSession } from '@/state/session';
import { canDo, type Action } from '@/utils/permissions';
import { canUse, type Area } from '@/utils/roles';

/**
 * What the signed-in role may open (`canOpen`) and do (`can`). For hiding and
 * disabling only: the API is the security boundary and refuses with 403.
 */
export function usePermissions() {
  const role = useSession().me?.staffRole;
  const can = useCallback((action: Action) => canDo(role, action), [role]);
  const canOpen = useCallback((area: Area) => canUse(role, area), [role]);
  return { role, can, canOpen };
}
