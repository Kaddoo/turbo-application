import { useQuery } from '@tanstack/react-query';
import { useServiceArea, useSettings } from '@/hooks';
import { drivers } from '@/services/drivers';
import { shifts } from '@/services/shifts';
import { staff } from '@/services/staff';
import type { StaffRole } from '@/utils/roles';
import { hrSteps, superAdminSteps, type SetupStep } from '@/utils/onboarding';

/**
 * The live data behind the setup checklists. Keys sit under each area's own
 * prefix (`drivers`, `staff`, `shifts`), so saving a driver, an invite or a
 * shift elsewhere refreshes the ticks here. One page of 100 is plenty for a
 * pilot; the checks only need "is there at least one" and "who is missing".
 */
const DAY = 86_400_000;

export interface Setup {
  steps: SetupStep[] | null;
  loading: boolean;
  error: unknown;
  retry: () => void;
}

export function useSetup(role: StaffRole | undefined): Setup {
  const admin = role === 'super_admin';
  const hr = role === 'hr';
  const area = useServiceArea(admin);
  const config = useSettings(admin);
  const team = useQuery({
    queryKey: ['staff', 'onboarding'],
    queryFn: () => staff.list({ limit: 100 }),
    enabled: admin,
  });
  const people = useQuery({
    queryKey: ['drivers', 'onboarding'],
    queryFn: () => drivers.list({ limit: 100 }),
    enabled: admin || hr,
  });
  const week = useQuery({
    queryKey: ['shifts', 'onboarding'],
    queryFn: () => {
      const now = Date.now();
      return shifts.list({ from: new Date(now).toISOString(), to: new Date(now + 7 * DAY).toISOString(), limit: 100 });
    },
    enabled: hr,
  });

  const parts = admin ? [area, config, team, people] : hr ? [people, week] : [];
  const error = parts.find((q) => q.error)?.error ?? null;
  const loading = parts.some((q) => q.isPending);
  const retry = () => parts.filter((q) => q.error).forEach((q) => void q.refetch());

  let steps: SetupStep[] | null = null;
  if (admin && area.data && config.data && team.data && people.data) {
    steps = superAdminSteps({
      serviceArea: area.data,
      settings: config.data,
      staff: team.data.data,
      drivers: people.data.data,
    });
  } else if (hr && people.data && week.data) {
    steps = hrSteps({ drivers: people.data.data, shiftsThisWeek: week.data.data });
  }
  return { steps, loading: loading && !steps, error: steps ? null : error, retry };
}
