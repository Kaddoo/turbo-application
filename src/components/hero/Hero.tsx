import { MapPin } from "lucide-react";
import { ButtonLink } from "../Button";
import { SplitHeading } from "../SectionLabel";
import { HeroCanvas } from "./HeroCanvas";
import { links } from "@/config/links";

/** Static route drawing used on phones (no WebGL download) and as the canvas backdrop. */
function RouteSketch() {
  return (
    <svg viewBox="0 0 360 240" className="h-auto w-full" aria-hidden fill="none">
      <defs>
        <pattern id="grid" width="24" height="24" patternUnits="userSpaceOnUse">
          <path d="M24 0H0V24" stroke="#262a22" strokeWidth="1" />
        </pattern>
      </defs>
      <rect width="360" height="240" fill="url(#grid)" />
      <path d="M24 192H96V144H192V96H264V48H336" stroke="#d4ff3a" strokeOpacity=".18" strokeWidth="10" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M24 192H96V144H192V96H264V48H336" stroke="#d4ff3a" strokeWidth="3.5" strokeLinecap="round" strokeLinejoin="round" />
      <circle cx="24" cy="192" r="7" fill="#f3f1ea" />
      <circle cx="336" cy="48" r="9" fill="#d4ff3a" />
      <circle cx="336" cy="48" r="9" stroke="#d4ff3a" className="origin-[336px_48px] animate-pulse-ring" />
      <circle cx="144" cy="144" r="4" fill="#f3f1ea" />
      <circle cx="228" cy="96" r="4" fill="#f3f1ea" />
    </svg>
  );
}

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
    <section data-hero aria-labelledby="hero-title" className="relative isolate overflow-hidden bg-ink pt-28 md:min-h-[100svh] md:pt-0">
      <div aria-hidden className="grain pointer-events-none absolute inset-0 -z-10" />
      <div
        aria-hidden
        className="pointer-events-none absolute -left-72 top-0 -z-10 size-[56rem] rounded-full bg-[radial-gradient(closest-side,rgba(212,255,58,0.10),transparent)]"
      />

      {/* 3D stage (desktop/tablet) */}
      <div aria-hidden className="absolute inset-0 hidden md:block">
        <div className="absolute inset-y-0 right-0 w-[60%] opacity-40">
          <div className="absolute inset-x-[10%] top-1/2 -translate-y-1/2">
            <RouteSketch />
          </div>
        </div>
        <HeroCanvas />
        <div className="pointer-events-none absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-ink to-transparent" />
        {/* Shade behind the copy; fades in with it once the map has settled. */}
        <div
          data-hero-shade
          className="pointer-events-none absolute inset-y-0 left-0 w-[62%] bg-gradient-to-r from-ink via-ink/80 to-transparent transition-opacity duration-1000"
        />

      </div>

      <div className="relative mx-auto flex max-w-6xl flex-col px-4 sm:px-6 md:min-h-[100svh] md:justify-center md:pb-24">
        <div data-hero-copy className="max-w-xl lg:max-w-2xl">
          <p data-reveal className="mb-6 inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-3 py-1.5 text-xs text-paper/80">
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
          <p data-reveal className="mt-6 max-w-md text-lg leading-relaxed text-paper/70">
            For verified Central University students at Miotso. No cash, no haggling, a driver assigned for you.
          </p>
          <div data-reveal className="mt-9 flex flex-wrap items-center gap-3">
            <ButtonLink href="#download">Get the app</ButtonLink>
            <ButtonLink href={links.webAppUrl} variant="ghost" icon>
              Use on the web
            </ButtonLink>
          </div>
        </div>

        <div className="mt-12 md:hidden" aria-hidden>
          <div className="overflow-hidden rounded-3xl border border-white/10 bg-ink-2">
            <RouteSketch />
          </div>
        </div>
      </div>

      <div className="relative border-y border-white/10 bg-ink py-4 md:absolute md:inset-x-0 md:bottom-0">
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
