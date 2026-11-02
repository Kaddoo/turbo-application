"use client";

import { ExternalLink } from "lucide-react";
import { legal } from "@/lib/api";
import { publishedUrl } from "@/lib/legal";
import { useApi } from "@/lib/useApi";
import { legalFallback } from "@/config/legal";

const fmt = (iso: string) => {
  const d = new Date(iso);
  return Number.isNaN(d.getTime()) ? iso : d.toLocaleDateString("en-GB", { day: "numeric", month: "long", year: "numeric", timeZone: "UTC" });
};

/**
 * "Version 1.0, updated <date>". The version and URL come from GET /legal. The
 * contract carries no date (contract request filed), so the date shown is the
 * one in config/legal.ts, and only when that config describes the same version.
 */
export function VersionLabel({ doc }: { doc: "privacy" | "terms" }) {
  const state = useApi(legal);
  const fallback = legalFallback[doc];
  const live = state.status === "ok" ? state.data : null;
  const version = live ? (doc === "terms" ? live.termsVersion : live.privacyVersion) : fallback.version;
  const url = live ? publishedUrl(doc === "terms" ? live.termsUrl : live.privacyUrl) : null;
  const updated = version === fallback.version ? fallback.updatedAt : null;
  return (
    <div className="flex flex-wrap items-center gap-3 text-sm">
      <span className="inline-flex h-8 items-center rounded-full border border-white/15 px-3 text-paper/80">
        Version {version}
        {updated && `, updated ${fmt(updated)}`}
      </span>
      {url && (
        <a href={url} className="inline-flex items-center gap-1.5 text-turbo underline-offset-4 hover:underline">
          Read the current published version <ExternalLink className="size-3.5" aria-hidden />
        </a>
      )}
    </div>
  );
}
