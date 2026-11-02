"use client";

import { getServiceArea } from "@/lib/api";
import { useApi } from "@/lib/useApi";

export function OperatingHours() {
  const state = useApi(getServiceArea, (d) => !!d.operatingHours);
  if (state.status === "ok") return <p>Rides run {state.data.operatingHours}, every day the service is open.</p>;
  return <p>Current operating hours are shown in the app.</p>;
}
