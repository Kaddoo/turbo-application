"use client";

import { legal } from "@/lib/api";
import { publishedUrl } from "@/lib/legal";
import { useApi } from "@/lib/useApi";

/**
 * Privacy and Terms point to the URLs from GET /legal once an admin has
 * published them, else to the drafts hosted here (see lib/legal.ts). A failure
 * needs no message: the visitor still reaches a page.
 */
export function LegalLinks({ className }: { className?: string }) {
  const state = useApi(legal);
  const live = state.status === "ok" ? state.data : null;
  return (
    <>
      <li>
        <a className={className} href={publishedUrl(live?.privacyUrl) ?? "/privacy/"}>
          Privacy
        </a>
      </li>
      <li>
        <a className={className} href={publishedUrl(live?.termsUrl) ?? "/terms/"}>
          Terms
        </a>
      </li>
    </>
  );
}
