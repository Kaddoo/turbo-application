import type { LucideIcon } from "lucide-react";
import { cn } from "@/lib/cn";

/**
 * Small pill label. `dot` is the lime eyebrow above section titles; `chip` is
 * the grey tag that floats beside headlines and sits above feature copy.
 */
export function Tag({
  children,
  tone = "chip",
  icon: Icon,
  className,
}: {
  children: React.ReactNode;
  tone?: "dot" | "chip";
  icon?: LucideIcon;
  className?: string;
}) {
  return (
    <span
      className={cn(
        "inline-flex h-7 shrink-0 items-center gap-1.5 rounded-full px-3 text-xs font-medium tracking-normal whitespace-nowrap",
        tone === "dot" ? "bg-turbo/15 text-turbo" : "bg-white/[0.08] text-paper/80",
        className,
      )}
    >
      {tone === "dot" && <span aria-hidden className="size-1.5 rounded-full bg-turbo" />}
      {Icon && <Icon aria-hidden className="size-3.5 text-turbo" />}
      {children}
    </span>
  );
}
