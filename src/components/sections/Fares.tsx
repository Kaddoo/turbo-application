"use client";

import { CarFront, Info, ReceiptText, ShieldCheck } from "lucide-react";
import { getServiceArea, formatCedis, formatKm, type ServiceArea } from "@/lib/api";
import { useApi } from "@/lib/useApi";
import { Phone } from "../ui/Phone";
import { RiseHeading } from "../ui/ScrubHeading";
import { Tag } from "../ui/Tag";

const hasBands = (d: ServiceArea) => d.fareBands.length > 0;

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
        <img src="/photos/avatar-kofi.jpg" alt="" className="size-8 rounded-full object-cover" />
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
  const state = useApi(getServiceArea, hasBands);

  return (
    <section id="fares" data-bg="paper" aria-labelledby="fares-title" className="on-light relative overflow-hidden bg-paper py-10 text-ink sm:py-14">
      <div className="relative mx-auto grid max-w-6xl items-center gap-14 px-4 sm:px-6 lg:grid-cols-2 lg:gap-20">
        <div className="-my-8 flex justify-center lg:-my-12 lg:justify-start lg:pl-10">
          <div data-tilt="-1">
            <Phone pose="tiltLeft" className="w-[16rem] sm:w-[19rem] lg:w-[22rem]">
              <FareScreen />
            </Phone>
          </div>
        </div>

        <div className="max-w-md">
          <Tag icon={ReceiptText}>Fixed fares</Tag>
          <RiseHeading id="fares-title" className="mt-5 text-3xl font-medium leading-[1.05] tracking-[-0.035em] sm:text-4xl">
            One price per distance band.
          </RiseHeading>
          {state.status !== "error" && (
            <p data-reveal className="mt-5 flex gap-2.5 text-[15px] leading-relaxed text-ink/70">
              <ShieldCheck className="mt-0.5 size-4 shrink-0 text-ink" aria-hidden />
              You see the exact fare before you confirm. It never changes after.
            </p>
          )}

          <div aria-live="polite" aria-busy={state.status === "loading"} className="mt-8">
            {state.status === "loading" && <Skeleton />}

            {state.status === "error" && (
              <p data-reveal className="text-[15px] leading-relaxed text-ink/70">
                Fares are shown in the app before you book. You see the exact price before you confirm, and it never
                changes after.
              </p>
            )}

            {state.status === "ok" && (
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
                    {state.data.fareBands.map((b, i, all) => {
                      const max = all[all.length - 1].maxDistanceMeters;
                      return (
                        <tr key={b.maxDistanceMeters}>
                          <th scope="row" className="relative py-4 text-left font-normal">
                            <span
                              aria-hidden
                              data-bar={i}
                              className="absolute bottom-0 left-0 h-0.5 bg-turbo"
                              style={{ width: `${Math.max(12, (b.maxDistanceMeters / max) * 100)}%` }}
                            />
                            <span className="text-ink/60">Up to </span>
                            <span className="font-medium">{formatKm(b.maxDistanceMeters)}</span>
                          </th>
                          <td className="py-4 text-right text-xl font-medium tracking-tight tabular-nums text-ink">
                            {formatCedis(b.fareMinor)}
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
                {state.data.maxTripDistanceMeters != null && (
                  <p className="mt-4 flex items-center gap-2 text-sm text-ink/60">
                    <Info className="size-4" aria-hidden />
                    Trips over {formatKm(state.data.maxTripDistanceMeters)} are not available.
                  </p>
                )}
              </>
            )}
          </div>
        </div>
      </div>
    </section>
  );
}
