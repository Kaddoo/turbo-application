import type { MetadataRoute } from "next";
import { siteUrl } from "@/config/links";

export const dynamic = "force-static";

export default function robots(): MetadataRoute.Robots {
  return { rules: { userAgent: "*", allow: "/", disallow: "/mock-api/" }, sitemap: new URL("/sitemap.xml", siteUrl).toString() };
}
