"use client";

import { Clock, MapPin } from "lucide-react";
import { getServiceArea, type ServiceArea } from "@/lib/api";
import { useApi } from "@/lib/useApi";

const hasPoints = (d: ServiceArea) => d.pickupPoints.length > 0;

export function PickupChips() {
  const state = useApi(getServiceArea, hasPoints);

  if (state.status === "error") {
    return <p className="mt-3 text-[15px] text-paper/60">Pickup points are listed in the app when you book.</p>;
  }
  if (state.status === "loading") {
    return (
      <div aria-hidden className="mt-3 flex flex-wrap gap-2">
        {[7, 9, 6, 8, 10].map((w, i) => (
          <span key={i} className="h-9 animate-pulse rounded-full bg-white/[0.07]" style={{ width: `${w}rem` }} />
        ))}
      </div>
    );
  }
  return (
    <>
      <ul className="mt-4 flex flex-wrap gap-2.5">
        {state.data.pickupPoints.map((p) => (
          <li
            key={p.id}
            className="inline-flex h-9 items-center gap-1.5 rounded-full bg-white/[0.08] px-3.5 text-sm text-paper/85 transition-colors hover:bg-turbo hover:text-ink"
          >
            <MapPin className="size-4" aria-hidden />
            {p.name}
          </li>
        ))}
      </ul>
      {state.data.operatingHours && (
        <p className="mt-4 flex items-center gap-2 text-sm text-paper/60">
          <Clock className="size-4" aria-hidden /> Operating hours: {state.data.operatingHours}
        </p>
      )}
    </>
  );
}
