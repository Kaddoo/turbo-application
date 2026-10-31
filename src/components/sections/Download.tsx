import QRCode from "qrcode";
import { Apple, Globe, Play } from "lucide-react";
import { links } from "@/config/links";
import { RiseHeading } from "../ui/ScrubHeading";

/** Rendered at build time; ships as inline SVG with no client JS. */
async function qrSvg(url: string) {
  return QRCode.toString(url, { type: "svg", margin: 0, color: { dark: "#0b0c0a", light: "#0000" }, errorCorrectionLevel: "M" });
}

/** Dotted field with two pins joined by a dashed arc, drawn as you scroll (data-draw). */
function RouteDots() {
  return (
    <svg viewBox="0 0 560 300" className="h-full w-full" aria-hidden fill="none">
      <defs>
        <pattern id="cta-dots" width="10" height="10" patternUnits="userSpaceOnUse">
          <circle cx="2" cy="2" r="1.6" fill="#0b0c0a" fillOpacity=".11" />
        </pattern>
        <radialGradient id="cta-fade" cx="60%" cy="50%" r="60%">
          <stop offset="0" stopColor="#fff" />
          <stop offset="1" stopColor="#fff" stopOpacity="0" />
        </radialGradient>
        <mask id="cta-mask">
          <rect width="560" height="300" fill="url(#cta-fade)" />
        </mask>
      </defs>
      <rect width="560" height="300" fill="url(#cta-dots)" mask="url(#cta-mask)" />
      <path data-draw d="M250 210 C 300 70, 420 40, 470 120" stroke="#0b0c0a" strokeWidth="2" strokeDasharray="6 8" strokeLinecap="round" />
      {[
        [250, 210],
        [470, 120],
      ].map(([x, y]) => (
        <g key={x} transform={`translate(${x} ${y})`}>
          <path d="M0 0 C -9 -12, -12 -18, -12 -24 A 12 12 0 1 1 12 -24 C 12 -18, 9 -12, 0 0 Z" fill="#0b0c0a" />
          <circle cy="-24" r="4.5" fill="#d4ff3a" />
        </g>
      ))}
    </svg>
  );
}

function StoreLink({ href, icon: Icon, children }: { href: string; icon: typeof Apple; children: React.ReactNode }) {
  return (
    <a
      href={href}
      className="inline-flex h-11 items-center gap-2 rounded-full bg-ink px-5 text-sm font-medium text-paper transition-transform duration-300 hover:-translate-y-0.5"
    >
      <Icon className="size-4" aria-hidden /> {children}
    </a>
  );
}

export async function Download() {
  const svg = await qrSvg(links.webAppUrl);
  return (
    <section id="download" data-bg="paper" aria-labelledby="download-title" className="on-light bg-paper px-4 pb-10 pt-6 sm:px-6">
      <div className="relative mx-auto max-w-6xl overflow-hidden rounded-2xl bg-turbo p-7 text-ink sm:p-12">
        <div className="pointer-events-none absolute inset-y-0 right-0 hidden w-[62%] md:block">
          <RouteDots />
        </div>
        <div className="relative grid gap-10 md:grid-cols-[1fr_auto] md:items-end">
          <div className="max-w-md">
            <RiseHeading id="download-title" className="text-4xl font-medium leading-[1.02] tracking-[-0.045em] sm:text-5xl">
              Cashless rides across the corridor.
            </RiseHeading>
            <p data-reveal className="mt-4 text-[15px] leading-relaxed text-ink/70">
              Get Turbo on your phone, or book from any browser. Your wallet pays, your PIN starts the trip.
            </p>
            <div data-reveal className="mt-8 flex flex-wrap gap-2.5">
              <StoreLink href={links.playStoreUrl} icon={Play}>
                Google Play
              </StoreLink>
              <StoreLink href={links.appStoreUrl} icon={Apple}>
                App Store
              </StoreLink>
              <a
                href={links.webAppUrl}
                className="inline-flex h-11 items-center gap-2 rounded-full border border-ink/25 px-5 text-sm font-medium transition-colors hover:bg-ink hover:text-paper"
              >
                <Globe className="size-4" aria-hidden /> Use on the web
              </a>
            </div>
          </div>
          <figure data-reveal className="flex items-center gap-4 justify-self-start rounded-xl bg-paper p-3 pr-5 md:justify-self-end">
            <div className="size-20" role="img" aria-label="QR code that opens the Turbo web app" dangerouslySetInnerHTML={{ __html: svg }} />
            <figcaption className="max-w-[8rem] text-xs leading-snug text-ink/70">Scan to open the web app on your phone.</figcaption>
          </figure>
        </div>
      </div>
    </section>
  );
}
