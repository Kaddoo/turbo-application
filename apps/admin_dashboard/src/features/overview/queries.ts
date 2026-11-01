import { useQuery } from '@tanstack/react-query';
import { sharedKeys } from '@/hooks';
import { driverDocuments } from '@/services/driverDocuments';
import { incidents } from '@/services/incidents';
import { liveRides } from '@/services/liveRides';
import { rides } from '@/services/rides';
import { topups } from '@/services/topups';
import { verifications } from '@/services/verifications';
import { walletAdjustments } from '@/services/walletAdjustments';
import type { Area } from '@/utils/roles';

const LIMIT = 50;
const key = (card: string) => [...sharedKeys.overview, card];

/** One query per Overview card, each enabled only for roles that can read it. */
export function useOverviewCounts(can: (a: Area) => boolean) {
  return {
    sos: useQuery({ queryKey: key('sos'), enabled: can('incidents'), refetchInterval: 15_000,
      queryFn: () => incidents.list({ status: 'open', limit: LIMIT }) }),
    verif: useQuery({ queryKey: key('verif'), enabled: can('verification'),
      queryFn: () => verifications.list({ status: 'pending', limit: LIMIT }) }),
    unreachable: useQuery({ queryKey: key('unreachable'), enabled: can('rides'),
      queryFn: () => rides.list({ flag: 'driver_unreachable', limit: LIMIT }) }),
    overdue: useQuery({ queryKey: key('overdue'), enabled: can('rides'),
      queryFn: () => rides.list({ flag: 'overdue', limit: LIMIT }) }),
    live: useQuery({ queryKey: key('live'), enabled: can('liveMap'), refetchInterval: 15_000, queryFn: liveRides.get }),
    topups: useQuery({ queryKey: key('topups'), enabled: can('finance'),
      queryFn: () => topups.list({ flagged: true, limit: LIMIT }) }),
    approvals: useQuery({ queryKey: key('approvals'), enabled: can('finance'),
      queryFn: () => walletAdjustments.list({ status: 'pending', limit: LIMIT }) }),
    docs: useQuery({ queryKey: key('docs'), enabled: can('drivers'),
      queryFn: () => driverDocuments.expiring({ withinDays: 30 }) }),
  };
}
