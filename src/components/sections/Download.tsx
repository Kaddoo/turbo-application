import QRCode from "qrcode";
import { Apple, Globe, Play } from "lucide-react";
import { links } from "@/config/links";
import { ButtonLink } from "../Button";
import { SplitHeading } from "../SectionLabel";

/** Rendered at build time; ships as inline SVG with no client JS. */
async function qrSvg(url: string) {
  return QRCode.toString(url, { type: "svg", margin: 0, color: { dark: "#0b0c0a", light: "#0000" }, errorCorrectionLevel: "M" });
}

function StoreBadge({ href, icon: Icon, top, bottom }: { href: string; icon: typeof Apple; top: string; bottom: string }) {
  return (
    <a
      href={href}
      className="group inline-flex h-14 items-center gap-3 rounded-2xl bg-ink px-5 text-paper transition-transform duration-300 hover:-translate-y-0.5"
    >
      <Icon className="size-6 transition-colors group-hover:text-turbo" aria-hidden />
      <span className="flex flex-col leading-none">
        <span className="text-[11px] text-paper/60">{top}</span>
        <span className="mt-1 text-base font-semibold">{bottom}</span>
      </span>
    </a>
  );
}

export async function Download() {
  const svg = await qrSvg(links.webAppUrl);
  return (
    <section id="download" aria-labelledby="download-title" className="on-light bg-ink px-4 pb-6 sm:px-6">
      <div className="relative mx-auto max-w-6xl overflow-hidden rounded-[2.5rem] bg-turbo p-8 text-ink sm:p-14 lg:p-20">
        <div aria-hidden className="pointer-events-none absolute -right-24 -top-24 size-96 rounded-full border-[40px] border-ink/[0.06]" />
        <div aria-hidden className="pointer-events-none absolute -bottom-40 right-40 size-80 rounded-full border-[28px] border-ink/[0.05]" />
        <div className="relative grid gap-12 lg:grid-cols-[1.4fr_1fr] lg:items-center">
          <div>
            <SplitHeading id="download-title" className="text-5xl font-semibold leading-[0.98] tracking-[-0.045em] sm:text-6xl lg:text-7xl">
              Your next ride is a tap away.
            </SplitHeading>
            <p data-reveal className="mt-6 max-w-md text-lg text-ink/70">
              Get Turbo on your phone, or book from any browser.
            </p>
            <div data-reveal className="mt-10 flex flex-wrap gap-3">
              <StoreBadge href={links.appStoreUrl} icon={Apple} top="Download on the" bottom="App Store" />
              <StoreBadge href={links.playStoreUrl} icon={Play} top="Get it on" bottom="Google Play" />
              <ButtonLink href={links.webAppUrl} variant="light" className="h-14 rounded-2xl">
                <span className="inline-flex items-center gap-2">
                  <Globe className="size-5" aria-hidden /> Use on the web
                </span>
              </ButtonLink>
            </div>
          </div>
          <figure data-reveal className="justify-self-start rounded-[2rem] bg-paper p-6 shadow-[0_30px_80px_-30px_rgba(0,0,0,0.45)] lg:justify-self-end">
            <div
              className="size-44 sm:size-52"
              role="img"
              aria-label="QR code that opens the Turbo web app"
              dangerouslySetInnerHTML={{ __html: svg }}
            />
            <figcaption className="mt-4 max-w-44 text-sm text-ink/70 sm:max-w-52">
              Scan to open the web app on your phone.
            </figcaption>
          </figure>
        </div>
      </div>
    </section>
  );
}
