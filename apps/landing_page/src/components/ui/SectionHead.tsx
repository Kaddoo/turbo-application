import { Fragment } from "react";
import { cn } from "@/lib/cn";
import type { Icon3dName } from "./Icon3d";
import { Tag } from "./Tag";

/** Letters that rise out of a mask, word by word (data-chars in Motion.tsx). Hidden from screen readers. */
function Chars({ text }: { text: string }) {
  const words = text.split(" ");
  return words.map((w, i) => (
    <Fragment key={i}>
      <span aria-hidden className="w">
        {[...w].map((c, j) => (
          <span key={j} className="c">
            {c}
          </span>
        ))}
      </span>
      {i < words.length - 1 ? " " : null}
    </Fragment>
  ));
}

type Pill = { icon: Icon3dName; label: string };

/**
 * Section header: a short label and a large headline, centred by default.
 * `lines` breaks the headline where given. `pillStart` sits before the first
 * line and `pillEnd` after the last (from sm up); they open out of a thin line
 * once the letters are in.
 */
export function SectionHead({
  id,
  label,
  title,
  lines,
  pillStart,
  pillEnd,
  align = "center",
  size = "display",
  className,
}: {
  id: string;
  label?: string;
  title: string;
  lines?: string[];
  pillStart?: Pill;
  pillEnd?: Pill;
  align?: "center" | "start";
  size?: "display" | "title";
  className?: string;
}) {
  const rows = lines ?? [title];
  return (
    <div data-chars className={cn("flex flex-col", align === "center" ? "items-center text-center" : "items-start", className)}>
      {label && (
        <p className="text-base font-medium uppercase tracking-[0.22em] text-turbo in-[.on-light]:text-ink/60 sm:text-lg">
          <span className="sr-only">{label}</span>
          <Chars text={label} />
        </p>
      )}
      <h2
        id={id}
        aria-label={title}
        className={cn(
          "font-medium tracking-[-0.045em] text-balance",
          label && "mt-5",
          size === "display"
            ? "text-display leading-[1.02] sm:text-6xl lg:text-[5.5rem]"
            : "text-title leading-[1.05] sm:text-4xl lg:text-5xl",
          !lines && size === "display" && "max-w-[16ch]",
        )}
      >
        {rows.map((row, i) => (
          <span key={i} className={cn("flex flex-wrap items-center gap-x-4", align === "center" ? "justify-center" : "justify-start")}>
            {i === 0 && pillStart && (
              <Tag icon={pillStart.icon} className="hidden sm:inline-flex">
                {pillStart.label}
              </Tag>
            )}
            <span>
              <Chars text={row} />
            </span>
            {i === rows.length - 1 && pillEnd && (
              <Tag icon={pillEnd.icon} className="hidden sm:inline-flex">
                {pillEnd.label}
              </Tag>
            )}
          </span>
        ))}
      </h2>
    </div>
  );
}
