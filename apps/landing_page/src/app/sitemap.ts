import type { MetadataRoute } from "next";
import { siteUrl } from "@/config/links";
import { draftPages } from "@/config/legal";

export const dynamic = "force-static";

export default function sitemap(): MetadataRoute.Sitemap {
  return ["/", "/privacy/", "/terms/", "/delete-account/", "/support/"]
    .filter((p) => !draftPages.includes(p))
    .map((p) => ({
    url: new URL(p, siteUrl).toString(),
    changeFrequency: "monthly",
    priority: p === "/" ? 1 : 0.5,
  }));
}
