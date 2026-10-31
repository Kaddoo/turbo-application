import { SiteShell } from "../SiteShell";

/** Shared layout for policy and help pages. */
export function DocPage({
  eyebrow,
  title,
  intro,
  meta,
  children,
}: {
  eyebrow: string;
  title: string;
  intro?: React.ReactNode;
  meta?: React.ReactNode;
  children: React.ReactNode;
}) {
  return (
    <SiteShell>
      <div className="on-light bg-paper text-ink">
        <div className="bg-ink px-4 pb-16 pt-36 text-paper sm:px-6">
          <div className="mx-auto max-w-3xl">
            <p className="font-mono text-xs uppercase tracking-[0.18em] text-turbo">{eyebrow}</p>
            <h1 className="mt-4 text-4xl font-semibold leading-[1.02] tracking-[-0.04em] sm:text-6xl">{title}</h1>
            {intro && <div className="mt-6 max-w-2xl text-lg text-paper/70">{intro}</div>}
            {meta && <div className="mt-6">{meta}</div>}
          </div>
        </div>
        <article className="prose-turbo mx-auto max-w-3xl px-4 py-16 sm:px-6 sm:py-20">{children}</article>
      </div>
    </SiteShell>
  );
}
