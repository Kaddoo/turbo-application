import { PAGE_SIZE, sharedKeys, useAction, useCursorList } from '@/hooks';
import { vehicles } from '@/services/vehicles';
import type { Schemas } from '@/types';

export const vehicleKeys = { all: ['vehicles'] };

export function useVehicles() {
  return useCursorList(vehicleKeys.all, (cursor) => vehicles.list({ cursor, limit: PAGE_SIZE }));
}

/** Creates when `id` is null, otherwise updates. */
export function useSaveVehicle() {
  return useAction(
    ({ id, form }: { id: string | null; form: Schemas['VehicleWrite'] }) =>
      id ? vehicles.update(id, form) : vehicles.create(form),
    [vehicleKeys.all, sharedKeys.allVehicles],
  );
}
