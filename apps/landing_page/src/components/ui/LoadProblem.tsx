"use client";

import { RotateCw } from "lucide-react";
import { cn } from "@/lib/cn";
import { isRetryable, problemText, type ApiProblem } from "@/lib/problems";

/**
 * Says why a section shows its fallback and offers the next step: "Try again"
 * when a retry can help, "Reload" when this build is too old. Renders nothing
 * when no API is configured, or the visitor cancelled by leaving.
 */
export function LoadProblem({ problem, what, onRetry, className }: { problem: ApiProblem; what: string; onRetry: () => void; className?: string }) {
  if (problem.kind === "not_configured" || problem.kind === "cancelled") return null;
  const action =
    problem.kind === "upgrade" ? (
      <button type="button" onClick={() => window.location.reload()} className="inline-flex min-h-11 items-center gap-1.5 font-medium underline underline-offset-4">
        <RotateCw className="size-3.5" aria-hidden /> Reload
      </button>
    ) : isRetryable(problem) ? (
      <button type="button" onClick={onRetry} className="inline-flex min-h-11 items-center gap-1.5 font-medium underline underline-offset-4">
        <RotateCw className="size-3.5" aria-hidden /> Try again
      </button>
    ) : null;
  return (
    <p className={cn("mt-2 flex flex-wrap items-center gap-x-3 text-sm opacity-80", className)}>
      <span>{problemText(problem, what)}</span>
      {action}
    </p>
  );
}
