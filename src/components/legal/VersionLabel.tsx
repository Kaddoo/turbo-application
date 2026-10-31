"use client";

import { ExternalLink } from "lucide-react";
import { getLegal } from "@/lib/api";
import { useApi } from "@/lib/useApi";
import { legalFallback } from "@/config/legal";

const fmt = (iso: string) => {
  const d = new Date(iso);
  return Number.isNaN(d.getTime()) ? iso : d.toLocaleDateString("en-GB", { day: "numeric", month: "long", year: "numeric", timeZone: "UTC" });
};

/** "Version 1.0, updated <date>" from GET /legal, with a static fallback. */
export function VersionLabel({ doc }: { doc: "privacy" | "terms" }) {
  const state = useApi(getLegal);
  const live = state.status === "ok" ? state.data[doc] : null;
  const version = live?.version ?? legalFallback[doc].version;
  const updated = live?.updatedAt ?? legalFallback[doc].updatedAt;
  return (
    <div className="flex flex-wrap items-center gap-3 text-sm">
      <span className="inline-flex h-8 items-center rounded-full border border-white/15 px-3 text-paper/80">
        Version {version}, updated {fmt(updated)}
      </span>
      {live?.url && (
        <a href={live.url} className="inline-flex items-center gap-1.5 text-turbo underline-offset-4 hover:underline">
          Read the current published version <ExternalLink className="size-3.5" aria-hidden />
        </a>
      )}
    </div>
  );
}
