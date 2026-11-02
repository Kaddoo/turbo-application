import type { NextConfig } from "next";
import { version } from "./package.json";

const nextConfig: NextConfig = {
  output: "export",
  trailingSlash: true,
  images: { unoptimized: true },
  // Keep the spec's variable name; expose it to the browser at build time.
  env: {
    PUBLIC_API_BASE_URL: process.env.PUBLIC_API_BASE_URL ?? "",
    // Sent as X-App-Version (web/<version>), as the contract asks of every client.
    PUBLIC_APP_VERSION: version,
    PUBLIC_SITE_URL: process.env.PUBLIC_SITE_URL ?? "https://turbo.example",
  },
  experimental: { optimizePackageImports: ["lucide-react", "gsap"] },
};

export default nextConfig;
