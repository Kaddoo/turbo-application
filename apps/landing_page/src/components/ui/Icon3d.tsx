import { cn } from "@/lib/cn";
/** The files in public/icons3d (list written to icons3d.json by `npm run images`). */
export type Icon3dName =
  | "alarm-clock"
  | "automobile"
  | "bell"
  | "books"
  | "busts-in-silhouette"
  | "calendar"
  | "camera"
  | "check-mark-button"
  | "coin"
  | "credit-card"
  | "graduation-cap"
  | "hourglass-not-done"
  | "house"
  | "identification-card"
  | "key"
  | "locked"
  | "mobile-phone"
  | "money-bag"
  | "motorway"
  | "oncoming-taxi"
  | "party-popper"
  | "round-pushpin"
  | "school"
  | "shield"
  | "speech-balloon"
  | "telephone-receiver"
  | "warning"
  | "wrench";

/**
 * Silver-and-lime 3D icon from the design kit (exported by `npm run images`).
 * Decorative: the text beside it carries the meaning, so alt is empty.
 * Size it with a `size-*` class; the 128 px file covers up to 64 px at 2x.
 */
export function Icon3d({ name, className, eager }: { name: Icon3dName; className?: string; eager?: boolean }) {
  return (
    // eslint-disable-next-line @next/next/no-img-element
    <img
      src={`/icons3d/${name}-128.webp`}
      srcSet={`/icons3d/${name}-64.webp 64w, /icons3d/${name}-128.webp 128w`}
      sizes="64px"
      width={128}
      height={128}
      alt=""
      aria-hidden
      loading={eager ? "eager" : "lazy"}
      decoding="async"
      draggable={false}
      className={cn("size-12 shrink-0 select-none object-contain", className)}
    />
  );
}
