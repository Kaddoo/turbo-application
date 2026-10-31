import type { Metadata, Viewport } from "next";
import { GeistSans } from "geist/font/sans";
import { GeistMono } from "geist/font/mono";
import { siteUrl } from "@/config/links";
import "./globals.css";

const title = "Turbo — Rides around campus, paid from your wallet";
const description =
  "For verified Central University students at Miotso. No cash, no haggling, a driver assigned for you.";

export const metadata: Metadata = {
  metadataBase: new URL(siteUrl),
  title: { default: title, template: "%s · Turbo" },
  description,
  alternates: { canonical: "/" },
  openGraph: { type: "website", siteName: "Turbo", title, description, url: "/", locale: "en_GH" },
  twitter: { card: "summary_large_image", title, description },
  robots: { index: true, follow: true },
};

export const viewport: Viewport = {
  themeColor: "#0b0c0a",
  width: "device-width",
  initialScale: 1,
};

// Opts in to reveal animations before first paint; falls back to fully
// visible content if the animation chunk has not started within 3s.
// A reload starts at the top (or at the linked section): the browser's own scroll
// restore lands in the wrong place once pinned sections change the page height.
const motionBoot = `(function(d){try{if('scrollRestoration' in history)history.scrollRestoration='manual';if(!location.hash)scrollTo(0,0);if(matchMedia('(prefers-reduced-motion: reduce)').matches)return;d.documentElement.classList.add('motion');d.documentElement.classList.add('hero-intro');try{if(!sessionStorage.getItem('turbo-door')){sessionStorage.setItem('turbo-door','1');d.documentElement.classList.add('door');window.__doorEnd=Date.now()+1700}}catch(e){}setTimeout(function(){if(!window.__turboMotion)d.documentElement.classList.remove('motion')},3000)}catch(e){}})(document)`;

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={`${GeistSans.variable} ${GeistMono.variable}`} suppressHydrationWarning>
      <head>
        <script dangerouslySetInnerHTML={{ __html: motionBoot }} />
      </head>
      <body>
        <a
          href="#main"
          className="sr-only focus:not-sr-only focus:fixed focus:left-4 focus:top-4 focus:z-[100] focus:rounded-full focus:bg-turbo focus:px-5 focus:py-3 focus:font-medium focus:text-ink"
        >
          Skip to content
        </a>
        <div className="door-loader" aria-hidden>
          <div className="door-panel">
            <div className="door-window" />
            <div className="door-crease" />
            <div className="door-handle" />
            <span className="door-brand">Turbo</span>
          </div>
        </div>
        {children}
      </body>
    </html>
  );
}
