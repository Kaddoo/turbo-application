import { sharedKeys, useAction } from '@/hooks';
import { fareBands } from '@/services/fareBands';
import { pickupPoints } from '@/services/pickupPoints';
import { serviceArea } from '@/services/serviceArea';
import { settings } from '@/services/settings';
import type { Body } from '@/types';

export function useSaveBoundary() {
  return useAction((body: Body<'/admin/service-area', 'put'>) => serviceArea.saveBoundary(body), [sharedKeys.serviceArea]);
}

/** Creates when `id` is null, otherwise updates. */
export function useSavePickupPoint() {
  return useAction(
    ({ id, body }: { id: string | null; body: Body<'/admin/pickup-points', 'post'> }) =>
      id ? pickupPoints.update(id, body) : pickupPoints.create(body),
    [sharedKeys.serviceArea],
  );
}

export function useRemovePickupPoint() {
  return useAction((id: string) => pickupPoints.remove(id), [sharedKeys.serviceArea]);
}

export function useSaveFareBands() {
  return useAction((body: Body<'/admin/fare-bands', 'put'>) => fareBands.save(body), [sharedKeys.serviceArea]);
}

export function useSaveSettings() {
  return useAction((body: Body<'/admin/settings', 'put'>) => settings.save(body), [sharedKeys.settings]);
}
