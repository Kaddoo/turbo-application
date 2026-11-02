import { cn } from "@/lib/cn";
import { Icon3d, type Icon3dName } from "./Icon3d";

/**
 * Small pill label. `dot` is the lime eyebrow above section titles; `chip` is
 * the grey tag that floats beside headlines and sits above feature copy, with
 * a small 3D icon. Both adapt when placed inside an `.on-light` section.
 * Inside a data-words heading the pill opens out of a thin line (Motion.tsx).
 */
export function Tag({
  children,
  tone = "chip",
  icon,
  className,
}: {
  children: React.ReactNode;
  tone?: "dot" | "chip";
  icon?: Icon3dName;
  className?: string;
}) {
  return (
    <span
      data-pop
      className={cn(
        "inline-flex h-7 shrink-0 items-center gap-1.5 rounded-full px-3 align-middle text-xs font-medium tracking-normal whitespace-nowrap",
        icon && "pl-1.5",
        tone === "dot"
          ? "bg-turbo/15 text-turbo in-[.on-light]:bg-ink in-[.on-light]:text-turbo"
          : "bg-ink-3 text-paper/80 in-[.on-light]:bg-ink/[0.06] in-[.on-light]:text-ink/75",
        className,
      )}
    >
      {tone === "dot" && <span aria-hidden className="size-1.5 rounded-full bg-turbo" />}
      {icon && <Icon3d name={icon} className="size-5" />}
      <span data-pop-text>{children}</span>
    </span>
  );
}
