"use client";

import { TriangleAlert } from "lucide-react";
import { appConfig } from "@/lib/api";
import { useApi } from "@/lib/useApi";

/**
 * Maintenance and paused bookings from GET /app-config, checked again every
 * minute while the page is open (the API caches it for 60 s). If the call
 * fails there is nothing to announce, so the banner stays hidden.
 */
export function MaintenanceBanner() {
  const state = useApi(appConfig, { refreshEveryMs: 60_000 });
  if (state.status !== "ok") return null;
  const { maintenance, bookingsPaused, pauseMessage } = state.data;
  const text = maintenance.active
    ? (maintenance.message ?? "Turbo is down for maintenance. Booking will be back shortly.")
    : bookingsPaused
      ? (pauseMessage ?? "Booking is paused right now. It will be back shortly.")
      : null;
  if (!text) return null;
  return (
    <div role="status" className="relative z-60 bg-turbo line-clamp-2 px-4 py-2.5 text-center text-xs font-medium text-ink sm:text-sm">
      <TriangleAlert className="mr-2 inline size-4 align-[-3px]" aria-hidden />
      {text}
    </div>
  );
}
