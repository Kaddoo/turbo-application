"use client";

import { useEffect, useState } from "react";
import { Menu, Play, X } from "lucide-react";
import { MaintenanceBanner } from "./MaintenanceBanner";
import { links } from "@/config/links";
import { cn } from "@/lib/cn";

const nav = [
  { href: "/#how-it-works", label: "How it works" },
  { href: "/#fares", label: "Fares" },
  { href: "/#safety", label: "Safety" },
  { href: "/#faq", label: "FAQ" },
];

export function Header() {
  const [hidden, setHidden] = useState(false);
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState<string | null>(null);

  // Floating nav: slides away while scrolling down the page, comes back on any scroll up.
  useEffect(() => {
    let last = window.scrollY;
    const onScroll = () => {
      const y = window.scrollY;
      if (Math.abs(y - last) < 6) return;
      setHidden(y > last && y > 120);
      last = y;
    };
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  // Highlights the pill for the section in the middle of the screen (home page only).
  useEffect(() => {
    const ids = nav.map((n) => n.href.split("#")[1]);
    const els = ids.map((id) => document.getElementById(id)).filter((e): e is HTMLElement => !!e);
    if (!els.length) return;
    const io = new IntersectionObserver(
      (entries) => entries.forEach((e) => e.isIntersecting && setActive(e.target.id)),
      { rootMargin: "-45% 0px -50% 0px" },
    );
    els.forEach((e) => io.observe(e));
    const onTop = () => window.scrollY < 200 && setActive(null);
    window.addEventListener("scroll", onTop, { passive: true });
    return () => {
      io.disconnect();
      window.removeEventListener("scroll", onTop);
    };
  }, []);

  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && setOpen(false);
    // Scrolling the page means the visitor has moved on: close the menu.
    const start = window.scrollY;
    const onScroll = () => Math.abs(window.scrollY - start) > 80 && setOpen(false);
    window.addEventListener("keydown", onKey);
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => {
      window.removeEventListener("keydown", onKey);
      window.removeEventListener("scroll", onScroll);
    };
  }, [open]);

  return (
    <header className={cn("fixed inset-x-0 top-0 z-50 px-4 pt-3 transition-transform duration-500 ease-out sm:px-6 sm:pt-4", hidden && !open && "-translate-y-[130%]")}>
      <div className="-mx-4 -mt-3 mb-3 sm:-mx-6 sm:-mt-4">
        <MaintenanceBanner />
      </div>
      <div
        className="mx-auto grid h-14 max-w-6xl grid-cols-[1fr_auto] items-center px-0 md:grid-cols-[1fr_auto_1fr]"
      >
        <a href="/" className="inline-flex items-center gap-2.5 justify-self-start text-lg text-paper" aria-label="Turbo home">
          <span aria-hidden className="inline-flex size-11 items-center justify-center rounded-full bg-turbo shadow-[0_6px_20px_-8px_rgba(0,0,0,0.6)]">
            <span className="size-3 rounded-full bg-ink" />
          </span>
        </a>

        <nav aria-label="Main" className="hidden md:block">
          <ul className="flex items-center gap-1.5">
            {nav.map((n) => (
              <li key={n.href}>
                <a
                  href={n.href}
                  aria-current={active === n.href.split("#")[1] ? "true" : undefined}
                  className="inline-flex h-9 items-center rounded-full bg-ink-3/95 px-4 pointer-coarse:h-11 text-[13px] text-paper/60 shadow-[0_6px_20px_-10px_rgba(0,0,0,0.7)] transition-colors hover:bg-line hover:text-paper aria-[current=true]:bg-line aria-[current=true]:text-paper"
                >
                  {n.label}
                </a>
              </li>
            ))}
          </ul>
        </nav>

        <div className="flex items-center gap-2 justify-self-end">
          <a
            href="/#download"
            className="inline-flex h-11 items-center gap-2 rounded-full bg-turbo px-5 text-sm font-medium text-ink shadow-[0_6px_20px_-8px_rgba(0,0,0,0.6)] transition-colors hover:bg-white"
          >
            <Play aria-hidden className="size-3.5 fill-ink" />
            Get the app
          </a>
          <button
            type="button"
            className="inline-flex size-11 items-center justify-center rounded-full bg-ink-3/95 text-paper hover:bg-line md:hidden"
            aria-expanded={open}
            aria-controls="mobile-nav"
            onClick={() => setOpen((o) => !o)}
          >
            {open ? <X aria-hidden className="size-5" /> : <Menu aria-hidden className="size-5" />}
            <span className="sr-only">{open ? "Close menu" : "Open menu"}</span>
          </button>
        </div>
      </div>

      <nav
        id="mobile-nav"
        aria-label="Mobile"
        hidden={!open}
        className="mx-auto mt-2 max-w-6xl rounded-3xl border border-white/10 bg-ink p-3 md:hidden"
      >
        <ul>
          {nav.map((n) => (
            <li key={n.href}>
              <a
                href={n.href}
                onClick={() => setOpen(false)}
                className="block rounded-2xl px-4 py-3.5 text-lg text-paper hover:bg-white/5"
              >
                {n.label}
              </a>
            </li>
          ))}
          <li>
            <a
              href={links.webAppUrl}
              className="block rounded-2xl px-4 py-3.5 text-lg text-turbo hover:bg-white/5"
            >
              Use on the web
            </a>
          </li>
        </ul>
      </nav>
    </header>
  );
}
