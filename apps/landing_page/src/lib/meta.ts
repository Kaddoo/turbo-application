import type { Metadata } from "next";
import { draftPages } from "@/config/legal";
import { alt, size } from "@/app/opengraph-image";

/**
 * Metadata for a sub-page. Without its own openGraph and twitter blocks a page
 * inherits the home page's (og:url "/", the home title), so shares of
 * /privacy/ showed the home card. Setting openGraph drops the inherited
 * image, so the shared social image is named here. Draft pages are kept out of search until the
 * approved text is in (config/legal.ts).
 */
export function pageMeta(path: string, title: string, description: string): Metadata {
  const full = `${title} · Turbo`;
  return {
    title,
    description,
    alternates: { canonical: path },
    openGraph: {
      type: "website", siteName: "Turbo", locale: "en_GH", url: path, title: full, description,
      images: [{ url: "/opengraph-image", ...size, alt, type: "image/png" }],
    },
    twitter: { card: "summary_large_image", title: full, description, images: [{ url: "/twitter-image", ...size, alt }] },
    ...(draftPages.includes(path) ? { robots: { index: false, follow: true } } : {}),
  };
}
