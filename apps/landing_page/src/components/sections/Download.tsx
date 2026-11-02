import QRCode from "qrcode";
import { Apple, Globe, Play } from "lucide-react";
import { links } from "@/config/links";
import { RiseHeading } from "../ui/ScrubHeading";
import dotMap from "./dotMap.json";

/** Rendered at build time; ships as inline SVG with no client JS. */
async function qrSvg(url: string) {
  return QRCode.toString(url, { type: "svg", margin: 0, color: { dark: "#0b0c0a", light: "#0000" }, errorCorrectionLevel: "M" });
}

/**
 * The real road network between the two pins as a dot grid (built by
 * scripts/map/corridor.mjs from OpenStreetMap), with the trip drawn on scroll.
 */
function RouteDots() {
  const [fx, fy] = dotMap.from;
  const [tx, ty] = dotMap.to;
  return (
    <svg viewBox={`0 0 ${dotMap.w} ${dotMap.h}`} className="h-full w-full" aria-hidden fill="none">
      <defs>
        <radialGradient id="cta-fade" cx="58%" cy="50%" r="62%">
          <stop offset="0.55" stopColor="#fff" />
          <stop offset="1" stopColor="#fff" stopOpacity="0" />
        </radialGradient>
        <mask id="cta-mask">
          <rect width={dotMap.w} height={dotMap.h} fill="url(#cta-fade)" />
        </mask>
      </defs>
      <g mask="url(#cta-mask)" strokeLinecap="round" stroke="#0b0c0a">
        <path d={dotMap.minor} strokeOpacity=".16" strokeWidth="2.4" />
        <path d={dotMap.major} strokeOpacity=".55" strokeWidth="3.2" />
      </g>
      <path
        data-draw
        d={`M${tx} ${ty} C ${tx + 40} ${ty - 120}, ${fx - 150} ${fy + 40}, ${fx} ${fy}`}
        stroke="#0b0c0a"
        strokeWidth="2"
        strokeDasharray="6 8"
        strokeLinecap="round"
      />
      {[
        [tx, ty, "Miotso Junction"],
        [fx, fy, "Central University"],
      ].map(([x, y, label]) => (
        <g key={label} transform={`translate(${x} ${y})`}>
          <path d="M0 0 C -9 -12, -12 -18, -12 -24 A 12 12 0 1 1 12 -24 C 12 -18, 9 -12, 0 0 Z" fill="#0b0c0a" />
          <circle cy="-24" r="4.5" fill="#d4ff3a" />
          <text x="18" y="-20" fill="#0b0c0a" fontSize="12" fontWeight="600">
            {label}
          </text>
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
    <section id="download" data-bg="ink" aria-labelledby="download-title" className="on-light bg-ink px-4 pb-10 pt-6 sm:px-6">
      <div className="relative mx-auto max-w-6xl overflow-hidden rounded-2xl bg-turbo p-7 text-ink sm:p-12">
        <div className="pointer-events-none absolute inset-y-0 right-0 hidden w-[62%] md:block">
          <RouteDots />
        </div>
        <div className="relative grid gap-10 md:grid-cols-[1fr_auto] md:items-end">
          <div className="max-w-md">
            <RiseHeading id="download-title" className="text-display font-medium leading-[1.02] tracking-[-0.045em] sm:text-5xl">
              Cashless rides across the corridor.
            </RiseHeading>
            <p data-reveal className="mt-4 text-base leading-relaxed lg:text-[15px] text-ink/70">
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
        <p className="relative mt-8 hidden text-[10px] text-ink/60 md:block">
          Roads ©{" "}
          <a href="https://www.openstreetmap.org/copyright" className="inline-block py-1.5 underline underline-offset-2">
            OpenStreetMap contributors
          </a>
        </p>
      </div>
    </section>
  );
}
