/** Shown when GET /legal is unavailable. Update with each published revision. */
export const legalFallback = {
  privacy: { version: "1.0", updatedAt: "2026-10-31" },
  terms: { version: "1.0", updatedAt: "2026-10-31" },
};

/**
 * Pages whose text is still a draft or has "[placeholder]" gaps. They are
 * noindex and left out of the sitemap. Remove a path once Turbo approves it.
 */
export const draftPages: string[] = ["/privacy/", "/terms/", "/delete-account/"];
