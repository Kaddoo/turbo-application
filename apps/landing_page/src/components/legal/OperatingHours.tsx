"use client";

import { serviceArea } from "@/lib/api";
import { formatHours } from "@/lib/hours";
import { useApi } from "@/lib/useApi";
import { LoadProblem } from "../ui/LoadProblem";

export function OperatingHours() {
  const state = useApi(serviceArea);
  const hours = state.status === "ok" ? formatHours(state.data.operatingHours) : null;
  if (hours) return <p>Rides run {hours}.</p>;
  return (
    <div aria-live="polite">
      <p>Current operating hours are shown in the app.</p>
      {state.status === "error" && <LoadProblem problem={state.problem} what="the operating hours" onRetry={state.retry} />}
    </div>
  );
}
