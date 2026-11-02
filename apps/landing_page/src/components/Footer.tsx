import { links } from "@/config/links";
import { LegalLinks } from "./LegalLinks";
import { Wordmark } from "./Wordmark";
import { Tag } from "./ui/Tag";

const linkCls = "text-paper/80 transition-colors hover:text-turbo";

/** Dot-separated inline list, as in the footer rows. */
function DotList({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <nav aria-label={label}>
      <h2 className="text-xs text-paper/50">{label}</h2>
      <ul className="mt-3 flex flex-wrap items-center gap-x-3 gap-y-2 text-sm [&>li+li]:before:mr-3 [&>li+li]:before:inline-block [&>li+li]:before:size-1 [&>li+li]:before:rounded-full [&>li+li]:before:bg-paper/40 [&>li+li]:before:align-middle [&>li+li]:before:content-['']">
        {children}
      </ul>
    </nav>
  );
}

const nav = [
  { href: "/#how-it-works", label: "How it works" },
  { href: "/#fares", label: "Fares" },
  { href: "/#safety", label: "Safety" },
  { href: "/#faq", label: "FAQ" },
];

export function Footer() {
  return (
    <footer data-bg="ink" className="bg-ink pt-16 sm:pt-24">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <div className="grid gap-10 md:grid-cols-[1fr_minmax(0,22rem)]">
          <a href="/" className="self-start text-2xl text-paper" aria-label="Turbo home">
            <Wordmark />
          </a>
          <div>
            <Tag>About</Tag>
            <p className="mt-4 text-sm leading-relaxed text-paper/60">
              Rides around campus for Central University students at Miotso. No cash, no haggling, a driver assigned for
              you.
            </p>
          </div>
        </div>

        <div className="mt-16 grid gap-10 sm:mt-24 md:grid-cols-[1fr_minmax(0,22rem)]">
          <div className="grid gap-10 sm:grid-cols-2">
            <DotList label="Contact">
              <li>
                <a className={linkCls} href={`mailto:${links.contactEmail}`}>
                  Email
                </a>
              </li>
              <li>
                <a className={linkCls} href={links.whatsappUrl}>
                  WhatsApp
                </a>
              </li>
              <li>
                <a className={linkCls} href="/support/">
                  Support
                </a>
              </li>
            </DotList>
            <DotList label="Legal">
              <LegalLinks className={linkCls} />
              <li>
                <a className={linkCls} href="/delete-account/">
                  Delete my account
                </a>
              </li>
            </DotList>
          </div>
          <DotList label="Navigation">
            {nav.map((n) => (
              <li key={n.href}>
                <a className={linkCls} href={n.href}>
                  {n.label}
                </a>
              </li>
            ))}
            <li>
              <a className={linkCls} href={links.webAppUrl}>
                Web app
              </a>
            </li>
          </DotList>
        </div>

        <div className="mt-16 flex flex-wrap justify-between gap-3 border-t border-white/10 py-6 text-xs text-paper/50">
          <p>© {new Date().getFullYear()} Turbo. No cookies, no tracking.</p>
          <p>Central University, Miotso</p>
        </div>
      </div>
    </footer>
  );
}
