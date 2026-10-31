"use client";

import { TriangleAlert } from "lucide-react";
import { getAppConfig } from "@/lib/api";
import { useApi } from "@/lib/useApi";

export function MaintenanceBanner() {
  const state = useApi(getAppConfig);
  if (state.status !== "ok" || !state.data.maintenance) return null;
  return (
    <div role="status" className="relative z-[60] bg-turbo px-4 py-2.5 text-center text-sm font-medium text-ink">
      <TriangleAlert className="mr-2 inline size-4 align-[-3px]" aria-hidden />
      {state.data.maintenanceMessage ?? "Turbo is down for maintenance. Booking will be back shortly."}
    </div>
  );
}
