import { cn } from "@/lib/cn";
import { Icon3d, type Icon3dName } from "./Icon3d";

export type Floater = {
  icon: Icon3dName;
  /** Position and size, e.g. "right-[4%] top-24 size-24 hidden lg:block". */
  className: string;
  /** How far it drifts against the scroll (1 = about 140 px each way). */
  speed?: number;
  /** Degrees it turns either side while the section passes. */
  spin?: number;
};

/**
 * Decorative 3D objects that float at a section's edges, behind its content,
 * and drift and turn as the section scrolls past (data-float in Motion.tsx).
 * The section needs `relative isolate` so they stay behind its text.
 */
export function Floaters({ items }: { items: Floater[] }) {
  return (
    <div aria-hidden className="pointer-events-none absolute inset-0 -z-10">
      {items.map((f, i) => (
        <div key={i} data-float={f.speed ?? 1} data-spin={f.spin ?? 18} className={cn("absolute", f.className)}>
          <Icon3d name={f.icon} className="size-full drop-shadow-[0_18px_24px_rgba(0,0,0,0.35)]" />
        </div>
      ))}
    </div>
  );
}
