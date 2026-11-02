import photos from "./photos.json";

type Name = keyof typeof photos;

/**
 * A photo from public/photos/ served as AVIF or WebP at the width the layout
 * needs (variants made by `npm run images`), with the JPEG as the fallback.
 * Width and height are set so the browser reserves the space before it loads.
 * `sizes` must describe the rendered width, e.g. "(min-width: 640px) 17rem, 15rem".
 */
export function Photo({ name, sizes, className, eager }: { name: Name; sizes: string; className?: string; eager?: boolean }) {
  const p = photos[name];
  const set = (ext: string) => p.widths.map((w) => `/img/${name}-${w}.${ext} ${w}w`).join(", ");
  return (
    <picture className="contents">
      <source type="image/avif" srcSet={set("avif")} sizes={sizes} />
      <source type="image/webp" srcSet={set("webp")} sizes={sizes} />
      {/* eslint-disable-next-line @next/next/no-img-element -- static export */}
      <img
        src={`/photos/${name}.jpg`}
        width={p.width}
        height={p.height}
        alt=""
        loading={eager ? "eager" : "lazy"}
        decoding="async"
        className={className}
      />
    </picture>
  );
}
