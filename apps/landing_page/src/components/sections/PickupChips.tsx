"use client";

import { serviceArea } from "@/lib/api";
import { formatHours } from "@/lib/hours";
import { useApi } from "@/lib/useApi";
import { LoadProblem } from "../ui/LoadProblem";
import { Icon3d } from "../ui/Icon3d";

export function PickupChips() {
  const state = useApi(serviceArea);

  if (state.status === "loading") {
    return (
      <div aria-hidden className="mt-3 flex flex-wrap gap-2">
        {[7, 9, 6, 8, 10].map((w, i) => (
          <span key={i} className="h-9 animate-pulse rounded-full bg-ink/[0.07]" style={{ width: `${w}rem` }} />
        ))}
      </div>
    );
  }

  // Closed pickup points are not offered in the app, so they are not shown here either.
  const points = state.status === "ok" ? state.data.pickupPoints.filter((p) => p.isActive) : [];
  const hours = state.status === "ok" ? formatHours(state.data.operatingHours) : null;

  if (!points.length) {
    return (
      <div aria-live="polite">
        <p className="mt-3 text-[15px] text-ink/70">Pickup points are listed in the app when you book.</p>
        {state.status === "error" && <LoadProblem problem={state.problem} what="the pickup points" onRetry={state.retry} className="text-ink" />}
      </div>
    );
  }
  return (
    <>
      <ul className="mt-4 flex flex-wrap gap-2.5">
        {points.map((p) => (
          <li
            key={p.id}
            className="inline-flex h-10 items-center gap-1.5 rounded-full bg-ink/6 pl-2 pr-3.5 text-sm text-ink transition-colors hover:bg-turbo hover:text-ink"
          >
            <Icon3d name="round-pushpin" className="size-6" />
            {p.name}
          </li>
        ))}
      </ul>
      {hours && (
        <p className="mt-4 flex items-center gap-3 text-base text-ink/70 lg:text-sm">
          <Icon3d name="alarm-clock" className="size-9" /> Operating hours: {hours}
        </p>
      )}
    </>
  );
}
