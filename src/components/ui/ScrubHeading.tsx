import { Fragment } from "react";

/** Headline whose words brighten one by one as it scrolls through the viewport (see Motion.tsx). */
export function ScrubHeading({
  as: Tag = "h2",
  children,
  className,
  id,
}: {
  as?: "h1" | "h2" | "h3";
  children: string;
  className?: string;
  id?: string;
}) {
  const words = children.split(" ");
  return (
    <Tag id={id} className={className} data-scrub aria-label={children}>
      {words.map((w, i) => (
        <Fragment key={i}>
          <span aria-hidden className="sw">
            {w}
          </span>
          {i < words.length - 1 ? " " : null}
        </Fragment>
      ))}
    </Tag>
  );
}
