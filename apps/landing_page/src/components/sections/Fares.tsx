"use client";

import { CarFront } from "lucide-react";
import { serviceArea, formatCedis, formatKm } from "@/lib/api";
import { useApi } from "@/lib/useApi";
import { LoadProblem } from "../ui/LoadProblem";
import { Phone } from "../ui/Phone";
import { Photo } from "../ui/Photo";
import { Icon3d } from "../ui/Icon3d";
import { SectionHead } from "../ui/SectionHead";

function Skeleton() {
  return (
    <div aria-hidden className="space-y-px">
      {[0, 1, 2, 3].map((i) => (
        <div key={i} className="h-14 animate-pulse bg-ink/5" />
      ))}
    </div>
  );
}

function FareScreen() {
  return (
    <div className="flex flex-1 flex-col px-5 pt-8">
      <p className="text-[1.45rem] leading-[1.1] tracking-tight">See your fare before you book</p>
      <p className="mt-2 text-[11px] text-paper/50">Fixed. It never changes after.</p>
      <div className="mt-6 flex items-center gap-2.5 rounded-2xl bg-white/[0.07] p-2.5">
        <Photo name="avatar-kofi" sizes="32px" className="size-8 rounded-full object-cover" />
        <p className="text-[11px] leading-tight">
          Kofi
          <br />
          <span className="text-paper/50">Your driver</span>
        </p>
      </div>
      <div className="mt-3 rounded-[1.5rem] bg-turbo p-4 text-ink">
        <p className="rounded-full bg-ink/90 px-3 py-2 text-[11px] text-paper">Pickup · Miotso campus</p>
        <div className="mt-5 flex items-end justify-between">
          <div>
            <p className="text-[9px] uppercase tracking-wider text-ink/60">From</p>
            <p className="text-2xl font-semibold tracking-tight">MIO</p>
          </div>
          <CarFront className="mb-1.5 size-5" />
          <div className="text-right">
            <p className="text-[9px] uppercase tracking-wider text-ink/60">To</p>
            <p className="text-2xl font-semibold tracking-tight">ACM</p>
          </div>
        </div>
      </div>
      <div className="mt-3 flex items-center gap-2">
        <span className="inline-flex h-9 flex-1 items-center justify-center rounded-full bg-paper text-xs font-medium text-ink">Confirm</span>
        <span className="text-xs text-ink/70">GH₵ ··</span>
      </div>
    </div>
  );
}

export function Fares() {
  const state = useApi(serviceArea);
  // The contract orders bands by upToMeters; sort anyway so the table always reads short to long.
  const bands = state.status === "ok" ? [...state.data.fareBands].sort((a, b) => a.upToMeters - b.upToMeters) : [];
  const fallback = state.status === "error" || (state.status === "ok" && bands.length === 0);

  return (
    <section id="fares" data-bg="paper" aria-labelledby="fares-title" className="on-light relative overflow-hidden bg-paper py-section-tight text-ink">
      <div className="relative mx-auto grid max-w-6xl items-center gap-14 px-4 sm:px-6 lg:grid-cols-2 lg:gap-20">
        <div className="-my-8 flex justify-center lg:-my-12 lg:justify-start lg:pl-10">
          <div data-tilt="-1">
            <Phone pose="tiltLeft" className="w-[17rem] sm:w-[21rem] lg:w-[27rem]">
              <FareScreen />
            </Phone>
          </div>
        </div>

        <div className="max-w-md">
          <SectionHead id="fares-title" label="Fixed fares" title="One price per distance band." align="start" size="title" />
          {!fallback && (
            <p data-reveal className="mt-5 flex items-center gap-3 text-base leading-relaxed lg:text-[15px] text-ink/70">
              <Icon3d name="shield" className="size-11" />
              You see the exact fare before you confirm. It never changes after.
            </p>
          )}

          <div aria-live="polite" aria-busy={state.status === "loading"} className="mt-8">
            {state.status === "loading" && <Skeleton />}

            {fallback && (
              <>
                <p data-reveal className="text-base leading-relaxed text-ink/70 lg:text-[15px]">
                  Fares are shown in the app before you book. You see the exact price before you confirm, and it never
                  changes after.
                </p>
                {state.status === "error" && <LoadProblem problem={state.problem} what="the current fares" onRetry={state.retry} className="text-ink" />}
              </>
            )}

            {state.status === "ok" && bands.length > 0 && (
              <>
                <table className="w-full border-y border-ink/10">
                  <caption className="sr-only">Fare by trip distance, in Ghana cedis</caption>
                  <thead className="sr-only">
                    <tr>
                      <th scope="col">Distance</th>
                      <th scope="col">Fare</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-ink/10">
                    {bands.map((b, i, all) => {
                      const max = all[all.length - 1].upToMeters;
                      return (
                        <tr key={b.upToMeters}>
                          <th scope="row" className="relative py-4 text-left font-normal">
                            <span
                              aria-hidden
                              data-bar={i}
                              className="absolute bottom-0 left-0 h-0.5 bg-turbo"
                              style={{ width: `${Math.max(12, (b.upToMeters / max) * 100)}%` }}
                            />
                            <span className="text-ink/60">Up to </span>
                            <span className="font-medium">{formatKm(b.upToMeters)}</span>
                          </th>
                          <td className="py-4 text-right text-xl font-medium tracking-tight tabular-nums text-ink">
                            {formatCedis(b.farePesewas)}
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
                <p className="mt-4 flex items-center gap-3 text-base text-ink/60 lg:text-sm">
                  <Icon3d name="warning" className="size-8" />
                  Trips over {formatKm(state.data.maxTripDistanceMeters)} are not available.
                </p>
              </>
            )}
          </div>
        </div>
      </div>
    </section>
  );
}
