import { useQuery } from '@tanstack/react-query';
import { drivers } from '@/services/drivers';
import { incidents } from '@/services/incidents';
import { liveRides } from '@/services/liveRides';
import { serviceArea } from '@/services/serviceArea';
import { support } from '@/services/support';
import { verifications } from '@/services/verifications';
import { settings } from '@/services/settings';
import { vehicles } from '@/services/vehicles';

/**
 * Queries that more than one feature (or the shell) reads. Features never
 * import each other, so the keys they invalidate in common live here.
 */
export const sharedKeys = {
  settings: ['settings'],
  serviceArea: ['service-area'],
  live: ['live'],
  allVehicles: ['vehicles-all'],
  allDrivers: ['drivers-all'],
  /** Every Overview card sits under this prefix. */
  overview: ['ov'],
  sosBanner: ['incidents', 'open-banner'],
  /** Counts on the menu badges. */
  navPending: ['verifications', 'nav-pending'],
  navTickets: ['tickets', 'nav-open'],
} as const;

/** Operating settings. super_admin only (x-roles), so pass `enabled` for other roles. */
export function useSettings(enabled = true) {
  return useQuery({ queryKey: sharedKeys.settings, queryFn: settings.get, enabled });
}

/** Boundary, pickup points and fare bands. */
export function useServiceArea(enabled = true) {
  return useQuery({ queryKey: sharedKeys.serviceArea, queryFn: serviceArea.get, enabled });
}

/** Active rides and on-duty drivers. */
export function useLiveRides({
  enabled = true,
  refetchInterval,
}: { enabled?: boolean; refetchInterval?: number | false } = {}) {
  return useQuery({ queryKey: sharedKeys.live, queryFn: liveRides.get, enabled, refetchInterval });
}

/** Up to 100 vehicles, for pickers. */
export function useAllVehicles() {
  return useQuery({ queryKey: sharedKeys.allVehicles, queryFn: () => vehicles.list({ limit: 100 }) });
}

/** Up to 100 drivers, for pickers and id-to-name lookups. */
export function useAllDrivers() {
  return useQuery({ queryKey: sharedKeys.allDrivers, queryFn: () => drivers.list({ limit: 100 }) });
}

/** Open SOS and safety incidents for the banner on every page. */
export function useSosBanner(enabled: boolean) {
  return useQuery({
    queryKey: sharedKeys.sosBanner,
    queryFn: () => incidents.list({ status: 'open', limit: 10 }),
    enabled,
    refetchInterval: 10_000,
  });
}

/** Pending verifications, for the menu badge. One page only: the badge shows "50+" past it. */
export function usePendingVerifications(enabled: boolean) {
  return useQuery({
    queryKey: sharedKeys.navPending,
    queryFn: () => verifications.list({ status: 'pending', limit: 50 }),
    enabled,
    refetchInterval: 60_000,
  });
}

/** Open support tickets, for the menu badge. */
export function useOpenTickets(enabled: boolean) {
  return useQuery({
    queryKey: sharedKeys.navTickets,
    queryFn: () => support.list({ status: 'open', limit: 50 }),
    enabled,
    refetchInterval: 60_000,
  });
}
