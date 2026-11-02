import { cn } from "@/lib/cn";

/** Placeholder text wordmark until Turbo supplies a logo. */
export function Wordmark({ className }: { className?: string }) {
  return (
    <span className={cn("inline-flex items-center gap-1.5 font-semibold tracking-tight", className)}>
      <span aria-hidden className="relative inline-flex size-[0.55em] items-center justify-center">
        <span className="absolute inset-0 rounded-full bg-turbo" />
      </span>
      Turbo
    </span>
  );
}
