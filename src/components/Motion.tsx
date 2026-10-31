"use client";

import { useEffect } from "react";

declare global {
  interface Window {
    __turboMotion?: boolean;
  }
}

/**
 * Loads GSAP, ScrollTrigger and Lenis after hydration (kept out of the
 * critical bundle) and wires declarative data-attributes:
 *   data-split     headline words rise in
 *   data-reveal    fade up on enter (batched + staggered)
 *   data-draw      SVG path draws as it scrolls through the viewport
 *   data-bar       horizontal bar grows from 0
 *   data-parallax  translateY by factor × scroll
 *   data-hscroll / data-hscroll-track   pinned horizontal scroller (≥1024px)
 * Everything is skipped when the visitor prefers reduced motion.
 */
export function Motion() {
  useEffect(() => {
    window.__turboMotion = true;
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const root = document.documentElement;
    if (reduce) {
      root.classList.remove("motion");
      return;
    }

    let cleanup = () => {};
    let cancelled = false;

    Promise.all([import("gsap"), import("gsap/ScrollTrigger"), import("lenis")])
      .then(([{ gsap }, { ScrollTrigger }, { default: Lenis }]) => {
        if (cancelled) return;
        gsap.registerPlugin(ScrollTrigger);

        const lenis = new Lenis({ lerp: 0.1, wheelMultiplier: 1 });
        lenis.on("scroll", ScrollTrigger.update);
        const tick = (t: number) => lenis.raf(t * 1000);
        gsap.ticker.add(tick);
        gsap.ticker.lagSmoothing(0);

        // Same-page anchor links scroll smoothly and move focus to the target.
        const onClick = (e: MouseEvent) => {
          const a = (e.target as HTMLElement).closest<HTMLAnchorElement>('a[href^="/#"], a[href^="#"]');
          if (!a || e.metaKey || e.ctrlKey || e.shiftKey) return;
          const hash = a.getAttribute("href")!.replace(/^\//, "");
          if (window.location.pathname !== "/" && a.getAttribute("href")!.startsWith("/")) return;
          const target = document.querySelector<HTMLElement>(hash);
          if (!target) return;
          e.preventDefault();
          lenis.scrollTo(target, { offset: hash === "#main" ? 0 : -24, duration: 1.4 });
          history.pushState(null, "", hash);
          if (!target.hasAttribute("tabindex")) target.setAttribute("tabindex", "-1");
          target.focus({ preventScroll: true });
        };
        document.addEventListener("click", onClick);

        const animateIn = root.classList.contains("motion");
        const ctx = gsap.context(() => {
          if (animateIn) {
            gsap.utils.toArray<HTMLElement>("[data-split]").forEach((el) => {
              const words = el.querySelectorAll(".w > span");
              gsap.to(words, {
                yPercent: 0,
                y: 0,
                duration: 1.1,
                ease: "expo.out",
                stagger: 0.06,
                delay: el.closest("[data-hero]") ? 0.15 : 0,
                scrollTrigger: el.closest("[data-hero]") ? undefined : { trigger: el, start: "top 88%", once: true },
                onStart: () => gsap.set(words, { clearProps: "willChange" }),
              });
            });

            ScrollTrigger.batch("[data-reveal]", {
              start: "top 90%",
              once: true,
              onEnter: (els) =>
                gsap.to(els, {
                  opacity: 1,
                  y: 0,
                  duration: 1,
                  ease: "expo.out",
                  stagger: 0.08,
                  clearProps: "transform",
                }),
            });
          }

          gsap.utils.toArray<SVGPathElement>("[data-draw]").forEach((p) => {
            const len = p.getTotalLength();
            gsap.fromTo(
              p,
              { strokeDasharray: len, strokeDashoffset: len },
              {
                strokeDashoffset: 0,
                ease: "none",
                scrollTrigger: { trigger: p.closest("section") ?? p, start: "top 70%", end: "center 45%", scrub: 0.8 },
              },
            );
          });

          gsap.utils.toArray<HTMLElement>("[data-parallax]").forEach((el) => {
            const f = parseFloat(el.dataset.parallax || "0.2");
            gsap.to(el, {
              yPercent: -100 * f,
              ease: "none",
              scrollTrigger: { trigger: el.closest("section") ?? el, start: "top bottom", end: "bottom top", scrub: true },
            });
          });

          const mm = gsap.matchMedia();
          mm.add("(min-width: 1024px)", () => {
            gsap.utils.toArray<HTMLElement>("[data-hscroll]").forEach((wrap) => {
              const track = wrap.querySelector<HTMLElement>("[data-hscroll-track]");
              if (!track) return;
              const dist = () => Math.max(0, track.scrollWidth - wrap.clientWidth);
              gsap.to(track, {
                x: () => -dist(),
                ease: "none",
                scrollTrigger: {
                  trigger: wrap,
                  start: "top top",
                  end: () => `+=${dist()}`,
                  pin: true,
                  scrub: 0.6,
                  invalidateOnRefresh: true,
                },
              });
            });
          });
        });

        // Bars are rendered after data arrives; observe them as they appear.
        const animateBars = () => {
          document.querySelectorAll<HTMLElement>("[data-bar]:not([data-bar-done])").forEach((bar) => {
            bar.setAttribute("data-bar-done", "");
            gsap.from(bar, {
              scaleX: 0,
              transformOrigin: "left center",
              duration: 1.2,
              ease: "expo.out",
              delay: Number(bar.dataset.bar || 0) * 0.08,
              scrollTrigger: { trigger: bar, start: "top 92%", once: true },
            });
          });
        };
        animateBars();
        let refreshTimer: ReturnType<typeof setTimeout> | undefined;
        const mo = new MutationObserver(() => {
          animateBars();
          clearTimeout(refreshTimer);
          refreshTimer = setTimeout(() => ScrollTrigger.refresh(), 200);
        });
        mo.observe(document.body, { childList: true, subtree: true });
        window.addEventListener("load", () => ScrollTrigger.refresh(), { once: true });

        cleanup = () => {
          mo.disconnect();
          document.removeEventListener("click", onClick);
          ctx.revert();
          gsap.ticker.remove(tick);
          lenis.destroy();
        };
      })
      .catch(() => root.classList.remove("motion"));

    return () => {
      cancelled = true;
      cleanup();
    };
  }, []);

  return null;
}
