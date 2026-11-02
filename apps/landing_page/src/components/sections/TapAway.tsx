import { Bell, CarFront, MapPin, Play } from "lucide-react";
import { links } from "@/config/links";
import { Phone } from "../ui/Phone";
import { Photo } from "../ui/Photo";
import { Icon3d } from "../ui/Icon3d";
import { RiseHeading } from "../ui/ScrubHeading";

function HomeScreen() {
  return (
    <div className="flex flex-1 flex-col px-5 pt-8">
      <div className="flex items-start justify-between">
        <p className="text-[1.6rem] leading-[1.1] tracking-tight">
          <span className="font-light text-paper/70">Hello</span>
          <br />
          <span className="font-medium">Ama</span>
        </p>
        <Photo name="avatar-ama" sizes="44px" className="size-11 rounded-full object-cover ring-2 ring-white/10" />
      </div>
      <div className="relative mt-6 flex-1 overflow-hidden rounded-t-[1.75rem] bg-turbo p-4 text-ink">
        <span className="inline-flex h-7 items-center gap-1.5 rounded-full bg-ink px-3 text-[11px] font-medium text-paper">
          <span className="size-1.5 rounded-full bg-turbo" /> Fixed fare
        </span>
        <p className="mt-4 max-w-[9rem] text-lg font-medium leading-tight tracking-tight">Paid from your wallet</p>
        <Icon3d name="money-bag" eager className="absolute -bottom-3 -right-2 size-36 rotate-[-10deg] drop-shadow-[0_12px_18px_rgba(0,0,0,0.35)]" />
      </div>
    </div>
  );
}

function DriverScreen() {
  return (
    <div className="relative flex-1">
      <Photo name="road" sizes="(min-width: 1024px) 19rem, 12rem" className="absolute inset-0 h-full w-full object-cover" />
      <svg viewBox="0 0 272 568" className="absolute inset-0 h-full w-full" fill="none" preserveAspectRatio="none">
        <path d="M150 568 C 150 470, 140 400, 136 330" stroke="#d4ff3a" strokeOpacity=".35" strokeWidth="46" strokeLinecap="round" />
        <path d="M150 568 C 150 470, 140 400, 136 330" stroke="#d4ff3a" strokeWidth="5" strokeLinecap="round" />
      </svg>
      <div className="absolute inset-x-3 top-12 flex items-center gap-2.5 rounded-2xl bg-black/60 p-2.5">
        <Photo name="avatar-kofi" sizes="36px" className="size-9 rounded-full object-cover" />
        <div className="text-[11px] leading-tight">
          <p className="font-medium">Kofi · your driver</p>
          <p className="text-paper/60">Vetted, salaried</p>
        </div>
      </div>
      <span className="absolute bottom-6 left-1/2 inline-flex h-8 -translate-x-1/2 items-center gap-1.5 rounded-full bg-turbo px-3.5 text-[11px] font-medium text-ink">
        <MapPin className="size-3" /> Share trip
      </span>
    </div>
  );
}

function ArrivingScreen() {
  return (
    <div className="flex flex-1 flex-col px-5 pt-8">
      <div className="flex items-center justify-between">
        <span className="inline-flex size-9 items-center justify-center rounded-full bg-white/10">
          <CarFront className="size-4" />
        </span>
        <span className="inline-flex size-9 items-center justify-center rounded-full bg-white/10">
          <Bell className="size-4" />
        </span>
      </div>
      <p className="mt-10 text-[1.6rem] leading-[1.1] tracking-tight">Your driver is arriving</p>
      <div className="mt-5 flex gap-1.5">
        {[0, 1, 2, 3].map((i) => (
          <span key={i} className="inline-flex size-10 items-center justify-center rounded-xl bg-white/10 font-mono text-paper/70">
            •
          </span>
        ))}
      </div>
      <p className="mt-2 text-[11px] text-paper/60">Tell your driver your PIN</p>
    </div>
  );
}

/**
 * Second hero: a centred statement with three devices that rise into a lime
 * glow. On large screens the content sticks while the section scrolls past and
 * the rise is scroll-driven (data-tapaway in Motion.tsx). Sticky, not a GSAP pin:
 * a pin switches to position: fixed and back, which Chrome counts as a full-screen
 * layout shift. Elsewhere it renders in its final state.
 */
export function TapAway() {
  return (
    <section id="tap-away" data-bg="ink" data-bg-solid aria-labelledby="tapaway-title" data-tapaway className="relative overflow-clip bg-ink lg:motion-safe:h-[calc(max(100svh,46rem)_+_110svh)]">
      <div className="relative mx-auto flex h-[44rem] max-w-6xl flex-col items-center px-4 pt-24 sm:h-[52rem] sm:px-6 lg:h-[100svh] lg:min-h-[46rem] lg:pt-28 lg:motion-safe:sticky lg:motion-safe:top-0">
        <div
          data-tapaway-glow
          aria-hidden
          className="pointer-events-none absolute -bottom-40 left-1/2 h-[42rem] w-[min(70rem,140vw)] -translate-x-1/2 rounded-full bg-[radial-gradient(closest-side,rgba(212,255,58,0.32),rgba(212,255,58,0.08)_55%,transparent)]"
        />

        <RiseHeading
          id="tapaway-title"
          className="relative max-w-[11ch] text-center text-display font-medium leading-[0.95] tracking-[-0.05em] text-paper sm:text-7xl lg:text-[8.25rem]"
        >
          Smart, safe, and fast rides just a tap away
        </RiseHeading>

        <div data-tapaway-phones className="relative -mt-4 flex w-full justify-center sm:-mt-10 lg:-mt-24">
          <div data-tapaway-side="-1" className="absolute left-1/2 top-20 -translate-x-[132%] sm:top-28 lg:top-40">
            <Phone className="w-[12rem] sm:w-[16rem] lg:w-[23rem]">
              <DriverScreen />
            </Phone>
          </div>
          <div data-tapaway-side="1" className="absolute left-1/2 top-20 translate-x-[32%] sm:top-28 lg:top-40">
            <Phone className="w-[12rem] sm:w-[16rem] lg:w-[23rem]">
              <ArrivingScreen />
            </Phone>
          </div>
          <div className="relative z-10">
            <Phone className="w-[17rem] sm:w-[22rem] lg:w-[32rem]">
              <HomeScreen />
            </Phone>
            <a
              href={links.playStoreUrl}
              className="absolute left-1/2 top-[44%] z-20 inline-flex h-11 -translate-x-1/2 items-center gap-2 whitespace-nowrap rounded-full bg-paper px-4 text-sm font-medium text-ink shadow-[0_10px_30px_-10px_rgba(0,0,0,0.6)] transition-colors hover:bg-white"
            >
              <Play aria-hidden className="size-3.5 fill-ink" /> Google Play
            </a>
          </div>
        </div>
        {/* Fade the phones out at the bottom. An overlay, not a mask: a mask over the moving phones re-renders
            the whole scene every frame. Full width (the side phones reach past the container), and the section
            stays solid ink (data-bg-solid) so the paper fading in behind How it works never shows at the sides. */}
        <div aria-hidden className="pointer-events-none absolute bottom-0 left-1/2 z-30 h-1/5 w-screen -translate-x-1/2 bg-gradient-to-b from-transparent to-ink" />
      </div>
    </section>
  );
}
