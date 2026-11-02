import { MapPin } from "lucide-react";
import { ButtonLink } from "../Button";
import { SplitHeading } from "../SectionLabel";
import { FlatMap } from "./FlatMap";
import { HeroStage } from "./HeroStage";
import { links } from "@/config/links";

const ticker = [
  "No cash",
  "No haggling",
  "Verified students only",
  "Fare fixed before you confirm",
  "4-digit PIN on every trip",
  "Cancel free, always",
  "Mobile money top-ups",
];

export function Hero() {
  return (
    <section data-hero aria-labelledby="hero-title" className="relative isolate min-h-[100svh] overflow-hidden bg-ink">
      {/* Video, then the map of the real streets around campus (3D on large screens, flat on phones). */}
      <HeroStage flatMap={<FlatMap />} />
      <div aria-hidden className="pointer-events-none absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-ink to-transparent" />
      {/* Shade behind the copy; fades in with it once the map has taken over. */}
      <div
        aria-hidden
        data-hero-shade
        className="pointer-events-none absolute inset-0 bg-gradient-to-t from-ink via-ink/70 to-transparent transition-opacity duration-1000 md:bg-gradient-to-r md:from-ink md:via-ink/75 md:via-35% md:to-transparent md:to-65%"
      />

      <div className="relative mx-auto flex min-h-[100svh] max-w-6xl flex-col justify-end px-4 pb-28 sm:px-6 md:justify-center md:pb-24">
        <div data-hero-copy className="max-w-xl lg:max-w-2xl">
          <p data-reveal className="mb-6 inline-flex items-center gap-2 rounded-full border border-white/10 bg-ink/60 px-3 py-1.5 text-xs text-paper/80">
            <MapPin className="size-3.5 text-turbo" aria-hidden />
            Central University · Miotso
          </p>
          <SplitHeading
            as="h1"
            id="hero-title"
            className="text-[2.75rem] font-semibold leading-[0.98] tracking-[-0.04em] text-balance sm:text-6xl lg:text-[5.25rem]"
          >
            Rides around campus, paid from your wallet.
          </SplitHeading>
          <p data-reveal className="mt-6 max-w-md text-lg leading-relaxed text-paper/75">
            For verified Central University students at Miotso. No cash, no haggling, a driver assigned for you.
          </p>
          <div data-reveal className="mt-9 flex flex-wrap items-center gap-3">
            <ButtonLink href="#download">Get the app</ButtonLink>
            <ButtonLink href={links.webAppUrl} variant="ghost" icon>
              Use on the web
            </ButtonLink>
          </div>
        </div>
      </div>

      <p data-hero-shade className="absolute bottom-16 right-4 text-[10px] text-paper/40 transition-opacity duration-1000 sm:right-6">
        Map ©{" "}
        <a href="https://www.openstreetmap.org/copyright" className="underline underline-offset-2 hover:text-paper/70">
          OpenStreetMap contributors
        </a>
      </p>

      <div className="absolute inset-x-0 bottom-0 border-y border-white/10 bg-ink py-4">
        <p className="sr-only">{ticker.join(". ")}.</p>
        <div aria-hidden className="flex w-max animate-marquee gap-10 whitespace-nowrap pl-10 text-sm text-paper/70 hover:[animation-play-state:paused]">
          {[...ticker, ...ticker].map((t, i) => (
            <span key={i} className="flex items-center gap-10">
              {t}
              <span className="size-1.5 rounded-full bg-turbo" />
            </span>
          ))}
        </div>
      </div>
    </section>
  );
}
