"use client";

import { useEffect, useState } from "react";
import { Menu, X } from "lucide-react";
import { Wordmark } from "./Wordmark";
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
  const [scrolled, setScrolled] = useState(false);
  const [open, setOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 24);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  useEffect(() => {
    if (!open) return;
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && setOpen(false);
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [open]);

  return (
    <header className="fixed inset-x-0 top-0 z-50 px-4 pt-3 sm:px-6 sm:pt-4">
      <div className="-mx-4 -mt-3 mb-3 sm:-mx-6 sm:-mt-4">
        <MaintenanceBanner />
      </div>
      <div
        className={cn(
          "mx-auto flex h-14 max-w-6xl items-center justify-between rounded-full pl-5 pr-2 transition-all duration-500",
          scrolled || open
            ? "border border-white/10 bg-ink/80 shadow-[0_8px_40px_-12px_rgba(0,0,0,0.6)] backdrop-blur-xl"
            : "border border-transparent",
        )}
      >
        <a href="/" className="text-xl text-paper" aria-label="Turbo home">
          <Wordmark />
        </a>

        <nav aria-label="Main" className="hidden md:block">
          <ul className="flex items-center gap-1">
            {nav.map((n) => (
              <li key={n.href}>
                <a
                  href={n.href}
                  className="rounded-full px-4 py-2 text-sm text-paper/75 transition-colors hover:bg-white/5 hover:text-paper"
                >
                  {n.label}
                </a>
              </li>
            ))}
          </ul>
        </nav>

        <div className="flex items-center gap-2">
          <a
            href="/#download"
            className="inline-flex h-10 items-center rounded-full bg-turbo px-5 text-sm font-medium text-ink transition-colors hover:bg-white"
          >
            Get the app
          </a>
          <button
            type="button"
            className="inline-flex size-10 items-center justify-center rounded-full text-paper hover:bg-white/10 md:hidden"
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
        className="mx-auto mt-2 max-w-6xl rounded-3xl border border-white/10 bg-ink/95 p-3 backdrop-blur-xl md:hidden"
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
