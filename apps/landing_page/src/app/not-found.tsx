import { SiteShell } from "@/components/SiteShell";
import { ButtonLink } from "@/components/Button";

export default function NotFound() {
  return (
    <SiteShell>
      <section className="flex min-h-[80svh] items-center px-4 pt-28 sm:px-6">
        <div className="mx-auto w-full max-w-3xl">
          <p className="font-mono text-sm text-turbo">404</p>
          <h1 className="mt-4 text-5xl font-semibold leading-[1] tracking-[-0.04em] sm:text-7xl">Wrong turn.</h1>
          <p className="mt-6 max-w-md text-lg text-paper/70">This page doesn’t exist. Let’s get you back on the route.</p>
          <div className="mt-10">
            <ButtonLink href="/">Back to home</ButtonLink>
          </div>
        </div>
      </section>
    </SiteShell>
  );
}
