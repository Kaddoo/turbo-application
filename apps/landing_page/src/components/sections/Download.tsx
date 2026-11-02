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
 * Halftone map in the style of the reference: an even grid of dots in a darker
 * lime wherever the real road network is (dotMap.json, built by
 * scripts/map/corridor.mjs from OpenStreetMap), spread a little so towns read as
 * soft shapes. Computed once at build time; ships as static SVG.
 */
const PITCH = 11; // halftone grid pitch, in viewBox units
const REACH = 14; // a halftone dot is drawn when a road dot lies this close
const halftone = (() => {
  const pts = [...`${dotMap.minor}${dotMap.major}`.matchAll(/M([\d.]+) ([\d.]+)h0/g)].map((m) => [+m[1], +m[2]]);
  const near = new Set(pts.map(([x, y]) => `${Math.round(x / REACH)},${Math.round(y / REACH)}`));
  let d = "";
  for (let y = PITCH / 2; y < dotMap.h; y += PITCH)
    for (let x = PITCH / 2; x < dotMap.w; x += PITCH) {
      const cx = Math.round(x / REACH);
      const cy = Math.round(y / REACH);
      let hit = false;
      for (let dx = -1; dx <= 1 && !hit; dx++) for (let dy = -1; dy <= 1 && !hit; dy++) hit = near.has(`${cx + dx},${cy + dy}`);
      if (hit) d += `M${x} ${y}h0`;
    }
  return d;
})();

/** The trip between the two pins: a dashed arc that draws itself on scroll, over the halftone map. */
function RouteDots() {
  const [fx, fy] = dotMap.from;
  const [tx, ty] = dotMap.to;
  const arc = `M${tx} ${ty} Q ${(tx + fx) / 2 - 20} ${Math.min(ty, fy) - 90}, ${fx} ${fy}`;
  return (
    <svg viewBox={`0 0 ${dotMap.w} ${dotMap.h}`} className="h-full w-full" aria-hidden fill="none">
      <defs>
        <radialGradient id="cta-fade" cx="58%" cy="50%" r="62%">
          <stop offset="0.5" stopColor="#fff" />
          <stop offset="1" stopColor="#fff" stopOpacity="0" />
        </radialGradient>
        <mask id="cta-mask">
          <rect width={dotMap.w} height={dotMap.h} fill="url(#cta-fade)" />
        </mask>
        {/* The solid stroke draws on scroll (data-draw) and reveals the dashed arc beneath it. */}
        <mask id="cta-arc" maskUnits="userSpaceOnUse">
          <path data-draw d={arc} stroke="#fff" strokeWidth="6" strokeLinecap="round" />
        </mask>
      </defs>
      <path d={halftone} mask="url(#cta-mask)" stroke="#0b0c0a" strokeOpacity=".13" strokeWidth="5.5" strokeLinecap="round" />
      <path d={arc} mask="url(#cta-arc)" stroke="#0b0c0a" strokeWidth="1.6" strokeDasharray="5 6" strokeLinecap="round" />
      {[
        [tx, ty],
        [fx, fy],
      ].map(([x, y]) => (
        <g key={`${x}-${y}`} transform={`translate(${x} ${y})`}>
          <ellipse cy="1" rx="6" ry="2" fill="#0b0c0a" fillOpacity=".18" />
          <path d="M0 0 C -7 -10, -10 -15, -10 -20 A 10 10 0 1 1 10 -20 C 10 -15, 7 -10, 0 0 Z" fill="#0b0c0a" />
          <circle cy="-20" r="3.6" fill="#d4ff3a" />
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
      <div data-journey="arrive" className="relative mx-auto max-w-6xl overflow-hidden rounded-2xl bg-turbo p-7 text-ink sm:p-12">
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
            <figcaption className="max-w-32 text-xs leading-snug text-ink/70">Scan to open the web app on your phone.</figcaption>
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
