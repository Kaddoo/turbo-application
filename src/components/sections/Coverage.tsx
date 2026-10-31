import { MapPin, Navigation } from "lucide-react";
import { MapScreen, Phone } from "../ui/Phone";
import { Tag } from "../ui/Tag";
import { PickupChips } from "./PickupChips";

/** Schematic route screen only: not to scale, not a map (open decision D1). */
function RouteScreen() {
  return (
    <div className="relative flex-1">
      <MapScreen />
      <div className="absolute inset-x-3 top-9 flex items-center justify-between rounded-2xl bg-white/10 p-2.5 backdrop-blur-md">
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
    <section id="where-we-go" aria-labelledby="where-title" className="relative overflow-hidden bg-ink py-20 sm:py-28">
      <div className="mx-auto grid max-w-6xl items-center gap-14 px-4 sm:px-6 lg:grid-cols-2 lg:gap-20">
        <div className="max-w-md lg:order-1">
          <Tag icon={MapPin}>Where we go</Tag>
          <h2 id="where-title" data-reveal className="mt-5 text-3xl font-medium leading-[1.05] tracking-[-0.035em] sm:text-4xl">
            Miotso toward Ashaiman China Mall.
          </h2>
          <p data-reveal className="mt-5 text-[15px] leading-relaxed text-paper/60">
            One corridor, served well. Pick up from the points below; the app shows exactly where to stand.
          </p>

          <div className="mt-8">
            <h3 className="text-xs font-medium uppercase tracking-[0.14em] text-paper/50">Pickup points</h3>
            <PickupChips />
          </div>
        </div>

        <div className="flex justify-center lg:order-2 lg:justify-end lg:pr-10">
          <div data-tilt="1">
            <div className="[transform:perspective(1800px)_rotateX(12deg)_rotateY(-14deg)_rotateZ(14deg)]">
              <Phone>
                <RouteScreen />
              </Phone>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
