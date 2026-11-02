import { Navigation } from "lucide-react";
import { MapScreen, Phone } from "../ui/Phone";
import { ScrubHeading } from "../ui/ScrubHeading";
import { SectionHead } from "../ui/SectionHead";
import { PickupChips } from "./PickupChips";

/** Schematic route screen only: not to scale, not a map (open decision D1). */
function RouteScreen() {
  return (
    <div className="relative flex-1">
      <MapScreen />
      <div className="absolute inset-x-3 top-9 flex items-center justify-between rounded-2xl bg-white/10 p-2.5">
        <div className="flex items-center gap-2.5">
          <span className="inline-flex size-8 items-center justify-center rounded-full bg-paper text-ink">
            <Navigation className="size-3.5" />
          </span>
          <p className="text-[11px] leading-tight">
            Miotso
            <br />
            <span className="text-paper/55">to Ashaiman China Mall</span>
          </p>
        </div>
      </div>
      <div className="absolute bottom-5 left-1/2 flex -translate-x-1/2 items-center gap-2">
        <span className="inline-flex size-8 items-center justify-center rounded-full bg-white/15 text-xs">×</span>
        <span className="inline-flex h-8 items-center rounded-full bg-turbo px-4 text-[11px] font-medium text-ink">Share trip</span>
      </div>
    </div>
  );
}

export function Coverage() {
  return (
    <section id="where-we-go" data-bg="paper" aria-labelledby="where-title" className="on-light relative overflow-hidden bg-paper py-section-tight text-ink">
      <div className="mx-auto grid max-w-6xl items-center gap-14 px-4 sm:px-6 lg:grid-cols-2 lg:gap-20">
        <div className="max-w-md lg:order-1">
          <SectionHead id="where-title" label="Where we go" title="Miotso toward Ashaiman China Mall." align="start" size="title" />
          <ScrubHeading as="p" className="mt-5 text-base leading-relaxed text-ink/80 lg:text-[15px]">
            One corridor, served well. Pick up from the points below; the app shows exactly where to stand.
          </ScrubHeading>

          <div data-journey="pickup" className="mt-8">
            <h3 className="text-xs font-medium uppercase tracking-[0.14em] text-ink/60">Pickup points</h3>
            <PickupChips />
          </div>
        </div>

        <div className="-my-8 flex justify-center lg:order-2 lg:-my-12 lg:justify-end lg:pr-10">
          <div data-tilt="1">
            <Phone pose="tiltRight" className="w-68 sm:w-84 lg:w-108">
              <RouteScreen />
            </Phone>
          </div>
        </div>
      </div>
    </section>
  );
}
