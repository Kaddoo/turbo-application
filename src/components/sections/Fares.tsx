"use client";

import { Info, ShieldCheck } from "lucide-react";
import { getServiceArea, formatCedis, formatKm, type ServiceArea } from "@/lib/api";
import { useApi } from "@/lib/useApi";
import { SectionLabel, SplitHeading } from "../SectionLabel";

const hasBands = (d: ServiceArea) => d.fareBands.length > 0;

function Skeleton() {
  return (
    <div aria-hidden className="space-y-3">
      {[0, 1, 2, 3].map((i) => (
        <div key={i} className="h-[4.5rem] animate-pulse rounded-2xl bg-white/5" />
      ))}
    </div>
  );
}

export function Fares() {
  const state = useApi(getServiceArea, hasBands);

  return (
    <section id="fares" aria-labelledby="fares-title" className="relative overflow-hidden bg-ink py-24 sm:py-32">
      <div aria-hidden className="pointer-events-none absolute -right-40 top-0 size-[32rem] rounded-full bg-turbo/[0.07] blur-[120px]" />
      <div className="relative mx-auto grid max-w-6xl gap-12 px-4 sm:px-6 lg:grid-cols-[1fr_1.25fr] lg:gap-20">
        <div>
          <SectionLabel index="02" className="text-mute">
            Fares
          </SectionLabel>
          <SplitHeading id="fares-title" className="mt-6 text-4xl font-semibold leading-[1.02] tracking-[-0.035em] sm:text-5xl lg:text-6xl">
            One price per distance band.
          </SplitHeading>
          {state.status !== "error" && (
            <div data-reveal className="mt-8 flex gap-3 rounded-2xl border border-turbo/25 bg-turbo/[0.06] p-4 text-paper/85">
              <ShieldCheck className="mt-0.5 size-5 shrink-0 text-turbo" aria-hidden />
              <p>You see the exact fare before you confirm. It never changes after.</p>
            </div>
          )}
        </div>

        <div aria-live="polite" aria-busy={state.status === "loading"}>
          {state.status === "loading" && <Skeleton />}

          {state.status === "error" && (
            <p className="rounded-3xl border border-white/10 bg-ink-2 p-8 text-2xl font-medium tracking-tight text-paper/90">
              Fares are shown in the app before you book.
            </p>
          )}

          {state.status === "ok" && (
            <>
              <table className="w-full border-separate border-spacing-y-3">
                <caption className="sr-only">Fare by trip distance, in Ghana cedis</caption>
                <thead className="sr-only">
                  <tr>
                    <th scope="col">Distance</th>
                    <th scope="col">Fare</th>
                  </tr>
                </thead>
                <tbody>
                  {state.data.fareBands.map((b, i, all) => {
                    const max = all[all.length - 1].maxDistanceMeters;
                    return (
                      <tr key={b.maxDistanceMeters} className="group">
                        <th scope="row" className="relative overflow-hidden rounded-l-2xl bg-ink-2 py-5 pl-5 text-left font-normal">
                          <span
                            aria-hidden
                            data-bar={i}
                            className="absolute inset-y-0 left-0 bg-gradient-to-r from-turbo/[0.14] to-turbo/[0.02] transition-colors group-hover:from-turbo/25"
                            style={{ width: `${Math.max(18, (b.maxDistanceMeters / max) * 100)}%` }}
                          />
                          <span className="relative text-paper/60">Up to </span>
                          <span className="relative text-lg font-medium">{formatKm(b.maxDistanceMeters)}</span>
                        </th>
                        <td className="rounded-r-2xl bg-ink-2 py-5 pr-5 text-right text-2xl font-semibold tracking-tight tabular-nums text-turbo">
                          {formatCedis(b.fareMinor)}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
              {state.data.maxTripDistanceMeters != null && (
                <p className="mt-4 flex items-center gap-2 text-sm text-mute">
                  <Info className="size-4" aria-hidden />
                  Trips over {formatKm(state.data.maxTripDistanceMeters)} are not available.
                </p>
              )}
            </>
          )}
        </div>
      </div>
    </section>
  );
}
