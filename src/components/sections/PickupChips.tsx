"use client";

import { Clock, MapPin } from "lucide-react";
import { getServiceArea, type ServiceArea } from "@/lib/api";
import { useApi } from "@/lib/useApi";

const hasPoints = (d: ServiceArea) => d.pickupPoints.length > 0;

export function PickupChips() {
  const state = useApi(getServiceArea, hasPoints);

  if (state.status === "error") {
    return <p className="mt-4 text-lg text-ink/70">Pickup points are listed in the app when you book.</p>;
  }
  if (state.status === "loading") {
    return (
      <div aria-hidden className="mt-4 flex flex-wrap gap-2.5">
        {[7, 9, 6, 8, 10].map((w, i) => (
          <span key={i} className="h-11 animate-pulse rounded-full bg-ink/[0.07]" style={{ width: `${w}rem` }} />
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
            className="inline-flex h-11 items-center gap-2 rounded-full border border-ink/15 bg-white px-4 text-[15px] transition-colors hover:border-ink hover:bg-turbo"
          >
            <MapPin className="size-4" aria-hidden />
            {p.name}
          </li>
        ))}
      </ul>
      {state.data.operatingHours && (
        <p className="mt-5 flex items-center gap-2 text-ink/70">
          <Clock className="size-4" aria-hidden /> Operating hours: {state.data.operatingHours}
        </p>
      )}
    </>
  );
}
