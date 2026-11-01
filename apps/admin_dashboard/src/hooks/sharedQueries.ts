import { useQuery } from '@tanstack/react-query';
import { drivers } from '@/services/drivers';
import { incidents } from '@/services/incidents';
import { liveRides } from '@/services/liveRides';
import { serviceArea } from '@/services/serviceArea';
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
export function useLiveRides({ enabled = true, refetchInterval }: { enabled?: boolean; refetchInterval?: number | false } = {}) {
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
