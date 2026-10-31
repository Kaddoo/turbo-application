import { ArrowUpRight } from "lucide-react";
import { cn } from "@/lib/cn";

type Variant = "primary" | "ghost" | "dark" | "light";

const variants: Record<Variant, string> = {
  primary: "bg-turbo text-ink hover:bg-white",
  ghost: "border border-white/20 text-paper hover:border-white/60 hover:bg-white/5",
  dark: "bg-ink text-paper hover:bg-ink-3",
  light: "bg-paper text-ink hover:bg-white",
};

/**
 * Pill CTA with a sliding icon and a sheen sweep on hover, in the style of the
 * 21st.dev "shine button" pattern. Server component: zero client JS.
 */
export function ButtonLink({
  href,
  children,
  variant = "primary",
  className,
  icon = true,
  external,
  ...rest
}: React.AnchorHTMLAttributes<HTMLAnchorElement> & { variant?: Variant; icon?: boolean; external?: boolean }) {
  return (
    <a
      href={href}
      {...(external ? { target: "_blank", rel: "noopener noreferrer" } : {})}
      {...rest}
      className={cn(
        "group relative inline-flex h-12 items-center gap-2 overflow-hidden rounded-full px-6 text-[15px] font-medium transition-colors duration-300",
        variants[variant],
        className,
      )}
    >
      <span
        aria-hidden
        className="pointer-events-none absolute inset-y-0 -left-1/2 w-1/3 -skew-x-12 bg-gradient-to-r from-transparent via-white/40 to-transparent opacity-0 transition-all duration-700 group-hover:left-[120%] group-hover:opacity-100"
      />
      <span className="relative">{children}</span>
      {icon && (
        <span className="relative inline-flex size-5 items-center justify-center overflow-hidden">
          <ArrowUpRight aria-hidden className="size-4 transition-transform duration-300 group-hover:-translate-y-5 group-hover:translate-x-5" />
          <ArrowUpRight aria-hidden className="absolute size-4 -translate-x-5 translate-y-5 transition-transform duration-300 group-hover:translate-x-0 group-hover:translate-y-0" />
        </span>
      )}
      {external && <span className="sr-only"> (opens in a new tab)</span>}
    </a>
  );
}
