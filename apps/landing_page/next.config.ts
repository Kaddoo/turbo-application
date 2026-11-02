import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  trailingSlash: true,
  images: { unoptimized: true },
  // Keep the spec's variable name; expose it to the browser at build time.
  env: {
    PUBLIC_API_BASE_URL: process.env.PUBLIC_API_BASE_URL ?? "",
    PUBLIC_SITE_URL: process.env.PUBLIC_SITE_URL ?? "https://turbo.example",
  },
  experimental: { optimizePackageImports: ["lucide-react", "gsap"] },
};

export default nextConfig;
