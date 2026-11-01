import { useQuery } from '@tanstack/react-query';
import { PAGE_SIZE, sharedKeys, useAction, useCursorList } from '@/hooks';
import { rides } from '@/services/rides';
import type { Body, Schemas } from '@/types';

export const rideKeys = {
  all: ['rides'],
  list: (status: string, flag: string, from: string, to: string) => ['rides', status, flag, from, to],
  detail: (id: string) => ['ride', id],
};

/** Empty filter values mean "any"; dates are whole Accra (UTC) days. */
export function useRides(status: string, flag: string, from: string, to: string) {
  return useCursorList(rideKeys.list(status, flag, from, to), (cursor) =>
    rides.list({
      status: (status || undefined) as Schemas['RideStatus'] | undefined,
      flag: (flag || undefined) as Schemas['RideFlag'] | undefined,
      from: from ? new Date(`${from}T00:00:00Z`).toISOString() : undefined,
      to: to ? new Date(`${to}T23:59:59Z`).toISOString() : undefined,
      cursor,
      limit: PAGE_SIZE,
    }),
  );
}

export function useRide(id: string) {
  return useQuery({ queryKey: rideKeys.detail(id), queryFn: () => rides.get(id), refetchInterval: 10_000 });
}

/** Every ride action refreshes the ride, the list and the live map. */
const afterRideChange = (id: string) => [rideKeys.detail(id), rideKeys.all, sharedKeys.live];

export function useReassignRide(id: string) {
  return useAction((body: Body<'/admin/rides/{id}/reassign', 'post'>) => rides.reassign(id, body), afterRideChange(id));
}

export function useCancelRide(id: string) {
  return useAction((body: Body<'/admin/rides/{id}/cancel', 'post'>) => rides.cancel(id, body), afterRideChange(id));
}

export function useCompleteRide(id: string) {
  return useAction((body: Body<'/admin/rides/{id}/complete', 'post'>) => rides.complete(id, body), afterRideChange(id));
}

export function useRefundRide(id: string) {
  return useAction(
    ({ body, key }: { body: Body<'/admin/rides/{id}/refund', 'post'>; key: string }) => rides.refund(id, body, key),
    afterRideChange(id),
  );
}
