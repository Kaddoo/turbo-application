"use client";

import { legal } from "@/lib/api";
import { useApi } from "@/lib/useApi";

/**
 * Privacy and Terms point to the URLs from GET /legal when they load, else to
 * the pages hosted here. A failure needs no message: the hosted pages are the
 * same documents, so the visitor loses nothing.
 */
export function LegalLinks({ className }: { className?: string }) {
  const state = useApi(legal);
  const live = state.status === "ok" ? state.data : null;
  return (
    <>
      <li>
        <a className={className} href={live?.privacyUrl ?? "/privacy/"}>
          Privacy
        </a>
      </li>
      <li>
        <a className={className} href={live?.termsUrl ?? "/terms/"}>
          Terms
        </a>
      </li>
    </>
  );
}
