import { Fragment } from "react";
import { cn } from "@/lib/cn";

export function SectionLabel({ index, children, className }: { index: string; children: React.ReactNode; className?: string }) {
  return (
    <p className={cn("flex items-center gap-3 font-mono text-xs uppercase tracking-[0.18em]", className)} data-reveal>
      <span className="inline-flex h-6 items-center rounded-full border border-current/25 px-2.5">{index}</span>
      <span>{children}</span>
    </p>
  );
}

/** Headline whose words rise into place (see Motion.tsx). Text stays real text for screen readers. */
export function SplitHeading({
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
    <Tag id={id} className={className} data-split aria-label={children}>
      {words.map((w, i) => (
        <Fragment key={i}>
          <span aria-hidden className="w">
            <span>{w}</span>
          </span>
          {i < words.length - 1 ? " " : null}
        </Fragment>
      ))}
    </Tag>
  );
}
