/**
 * Every outbound link lives here. All values are placeholders until Turbo
 * supplies the real ones; components must import from this file only.
 */
export const links = {
  appStoreUrl: "https://apps.apple.com/app/turbo-placeholder",
  playStoreUrl: "https://play.google.com/store/apps/details?id=placeholder.turbo",
  webAppUrl: "https://app.turbo.example",
  contactEmail: "hello@turbo.example",
  /** wa.me link, international format without "+" */
  whatsappUrl: "https://wa.me/233000000000",
  whatsappDisplay: "+233 00 000 0000",
  /** Placeholder: confirm with Central University campus security. */
  campusSecurityPhone: "+233 00 000 0000",
} as const;

export const siteUrl = process.env.PUBLIC_SITE_URL || "https://turbo.example";
