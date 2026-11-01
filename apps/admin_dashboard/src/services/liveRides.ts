import { api, call } from './http';

/** Active rides and on-duty drivers for the live map and the overview. */
export const liveRides = {
  get: () => call(api.GET('/admin/rides/live')),
};
