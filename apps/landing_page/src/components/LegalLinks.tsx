"use client";

import { getLegal } from "@/lib/api";
import { useApi } from "@/lib/useApi";

/** Privacy and Terms point to the URLs from GET /legal when present, else to the pages hosted here. */
export function LegalLinks({ className }: { className?: string }) {
  const state = useApi(getLegal);
  const legal = state.status === "ok" ? state.data : null;
  return (
    <>
      <li>
        <a className={className} href={legal?.privacy.url ?? "/privacy/"}>
          Privacy
        </a>
      </li>
      <li>
        <a className={className} href={legal?.terms.url ?? "/terms/"}>
          Terms
        </a>
      </li>
    </>
  );
}
