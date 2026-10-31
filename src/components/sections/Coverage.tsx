import { MapPin } from "lucide-react";
import { SectionLabel, SplitHeading } from "../SectionLabel";
import { PickupChips } from "./PickupChips";

/** Schematic illustration only: not to scale, not a map (open decision D1). */
function CorridorIllustration() {
  const road = "M70 330 C 160 330, 170 250, 260 240 S 380 260, 420 190 S 520 90, 640 80";
  return (
    <svg viewBox="0 0 720 400" className="h-auto w-full" role="img" aria-labelledby="corridor-title corridor-desc">
      <title id="corridor-title">Service corridor illustration</title>
      <desc id="corridor-desc">
        A schematic line from Central University at Miotso to Ashaiman China Mall. Not to scale.
      </desc>
      <defs>
        <pattern id="dots" width="18" height="18" patternUnits="userSpaceOnUse">
          <circle cx="1.5" cy="1.5" r="1.5" fill="#0b0c0a" fillOpacity=".09" />
        </pattern>
      </defs>
      <rect width="720" height="400" rx="32" fill="url(#dots)" />
      <path d={road} fill="none" stroke="#0b0c0a" strokeOpacity=".08" strokeWidth="28" strokeLinecap="round" />
      <path d={road} fill="none" stroke="#0b0c0a" strokeOpacity=".22" strokeWidth="2" strokeDasharray="2 10" strokeLinecap="round" />
      <path data-draw d={road} fill="none" stroke="#0b0c0a" strokeWidth="5" strokeLinecap="round" />
      {[
        [260, 240],
        [420, 190],
      ].map(([x, y]) => (
        <circle key={x} cx={x} cy={y} r="7" fill="#f3f1ea" stroke="#0b0c0a" strokeWidth="3" />
      ))}
      <g>
        <circle cx="70" cy="330" r="16" fill="#0b0c0a" />
        <circle cx="70" cy="330" r="6" fill="#d4ff3a" />
        <text x="70" y="378" textAnchor="middle" className="fill-ink text-[17px] font-semibold">Miotso</text>
      </g>
      <g>
        <circle cx="640" cy="80" r="20" fill="#d4ff3a" stroke="#0b0c0a" strokeWidth="3" />
        <circle cx="640" cy="80" r="6" fill="#0b0c0a" />
        <text x="664" y="40" textAnchor="end" className="fill-ink text-[17px] font-semibold">Ashaiman China Mall</text>
      </g>
    </svg>
  );
}

export function Coverage() {
  return (
    <section id="where-we-go" aria-labelledby="where-title" className="on-light bg-paper py-24 text-ink sm:py-32">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <div className="grid gap-10 lg:grid-cols-[1fr_1.3fr] lg:items-end">
          <div>
            <SectionLabel index="03" className="text-mute-dark">
              Where we go
            </SectionLabel>
            <SplitHeading id="where-title" className="mt-6 text-4xl font-semibold leading-[1.02] tracking-[-0.035em] sm:text-5xl lg:text-6xl">
              Miotso toward Ashaiman China Mall.
            </SplitHeading>
          </div>
          <p data-reveal className="max-w-md text-lg text-ink/65 lg:justify-self-end">
            One corridor, served well. Pick up from the points below; the app shows exactly where to stand.
          </p>
        </div>

        <div data-reveal className="mt-12 overflow-hidden rounded-[2rem] bg-paper-2 p-4 sm:p-8">
          <CorridorIllustration />
        </div>

        <div className="mt-10">
          <h3 className="flex items-center gap-2 text-sm font-medium uppercase tracking-[0.14em] text-ink/60">
            <MapPin className="size-4" aria-hidden /> Pickup points
          </h3>
          <PickupChips />
        </div>
      </div>
    </section>
  );
}

