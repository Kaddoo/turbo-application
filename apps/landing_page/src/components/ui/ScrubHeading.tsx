import { Fragment } from "react";

function split(text: string, cls: string) {
  const words = text.split(" ");
  // Rising words sit in a clipping mask (.rw) and slide up out of it (the inner span).
  return words.map((w, i) => (
    <Fragment key={i}>
      <span aria-hidden className={cls}>
        {cls === "rw" ? <span>{w}</span> : w}
      </span>
      {i < words.length - 1 ? " " : null}
    </Fragment>
  ));
}

/** Text whose words brighten one by one as it scrolls through the viewport (data-scrub in Motion.tsx). */
export function ScrubHeading({
  as: Tag = "h2",
  children,
  className,
  id,
}: {
  as?: "h1" | "h2" | "h3" | "p";
  children: string;
  className?: string;
  id?: string;
}) {
  return (
    <Tag id={id} className={className} data-scrub>
      <span className="sr-only">{children}</span>
      {split(children, "sw")}
    </Tag>
  );
}

/**
 * Words that rise out of a mask, one after another, when scrolled into
 * view (data-words in Motion.tsx). Use inside a heading that carries
 * `data-words` and an aria-label with the full text.
 */
export function Words({ children }: { children: string }) {
  return <>{split(children, "rw")}</>;
}

/** Heading made only of rising words. */
export function RiseHeading({
  as: Tag = "h2",
  children,
  className,
  id,
}: {
  as?: "h2" | "h3";
  children: string;
  className?: string;
  id?: string;
}) {
  return (
    <Tag id={id} className={className} data-words aria-label={children}>
      <Words>{children}</Words>
    </Tag>
  );
}
