/**
 * Turbo has not supplied the terms and privacy yet; an admin will publish them
 * from the dashboard (CONTRACT_REQUESTS.md CR-8). Until then GET /legal holds
 * placeholders on the reserved `.example` domain (RFC 2606), which go nowhere.
 * Those, and anything that is not https, count as "not published", and the page
 * links to the drafts hosted here instead.
 */
export function publishedUrl(url: string | null | undefined): string | null {
  if (!url) return null;
  try {
    const u = new URL(url);
    if (u.protocol !== "https:") return null;
    const host = u.hostname.toLowerCase();
    return host === "example" || host.endsWith(".example") ? null : u.href;
  } catch {
    return null;
  }
}
