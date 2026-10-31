import { Mail, MessageCircle } from "lucide-react";
import { links } from "@/config/links";
import { LegalLinks } from "./LegalLinks";

const linkCls = "text-paper/70 transition-colors hover:text-turbo";

export function Footer() {
  return (
    <footer className="relative overflow-hidden bg-ink pt-20">
      <div className="mx-auto grid max-w-6xl gap-12 px-4 sm:px-6 md:grid-cols-[1.5fr_1fr_1fr]">
        <div>
          <p className="max-w-xs text-lg text-paper/80">Rides around campus for Central University students at Miotso.</p>
          <div className="mt-6 flex flex-wrap gap-3">
            <a href={`mailto:${links.contactEmail}`} className="inline-flex h-11 items-center gap-2 rounded-full border border-white/15 px-4 text-sm hover:border-turbo hover:text-turbo">
              <Mail className="size-4" aria-hidden /> {links.contactEmail}
            </a>
            <a href={links.whatsappUrl} className="inline-flex h-11 items-center gap-2 rounded-full border border-white/15 px-4 text-sm hover:border-turbo hover:text-turbo">
              <MessageCircle className="size-4" aria-hidden /> WhatsApp
            </a>
          </div>
        </div>
        <nav aria-label="Legal">
          <h2 className="font-mono text-xs uppercase tracking-[0.18em] text-mute">Legal</h2>
          <ul className="mt-4 space-y-3">
            <LegalLinks className={linkCls} />
            <li>
              <a className={linkCls} href="/delete-account/">
                Delete my account
              </a>
            </li>
          </ul>
        </nav>
        <nav aria-label="Help">
          <h2 className="font-mono text-xs uppercase tracking-[0.18em] text-mute">Help</h2>
          <ul className="mt-4 space-y-3">
            <li>
              <a className={linkCls} href="/support/">
                Contact
              </a>
            </li>
            <li>
              <a className={linkCls} href="/#faq">
                FAQ
              </a>
            </li>
            <li>
              <a className={linkCls} href={links.webAppUrl}>
                Web app
              </a>
            </li>
          </ul>
        </nav>
      </div>

      <div aria-hidden className="mx-auto mt-16 max-w-6xl select-none px-4 sm:px-6">
        <p className="translate-y-[18%] text-center text-[28vw] font-semibold leading-[0.8] tracking-[-0.07em] text-transparent [-webkit-text-stroke:1px_rgba(243,241,234,0.2)] lg:text-[17rem]">
          Turbo
        </p>
      </div>
      <div className="border-t border-white/10">
        <p className="mx-auto max-w-6xl px-4 py-6 text-sm text-mute sm:px-6">© {new Date().getFullYear()} Turbo. No cookies, no tracking.</p>
      </div>
    </footer>
  );
}
