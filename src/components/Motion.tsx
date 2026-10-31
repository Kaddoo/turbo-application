"use client";

import { useEffect } from "react";

declare global {
  interface Window {
    __turboMotion?: boolean;
  }
}

/**
 * Loads GSAP, ScrollTrigger and Lenis (smooth scrolling) after hydration (kept out of the
 * critical bundle) and wires declarative data-attributes:
 *   data-split     headline words rise in (the hero's wait for "turbo:hero-reveal")
 *   data-reveal    fade up on enter (batched + staggered)
 *   data-draw      SVG path draws as it scrolls through the viewport
 *   data-bar       horizontal bar grows from 0
 *   data-parallax  translateY by factor × scroll
 *   data-hscroll / data-hscroll-track   pinned horizontal scroller (≥1024px)
 *   data-scrub     headline words brighten as it scrolls through
 *   data-words     words rise, unblur and fade in one by one; [data-pop] tags pop in
 *   data-bg        "ink" | "paper": the page background fades between section colours
 *   data-tilt      device swings up into its resting tilt (value: ±1 direction)
 *   data-tapaway   pinned scene: phones rise into the glow (≥1024px)
 *   data-drift / data-drift-track   card strip slides sideways with scroll (≥1024px)
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

        // Lenis smooths the wheel; GSAP's ticker drives it so ScrollTrigger sees every frame.
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
          if (!target.hasAttribute("tabindex")) target.setAttribute("tabindex", "-1");
          target.focus({ preventScroll: true });
        };
        document.addEventListener("click", onClick);

        const animateIn = root.classList.contains("motion");
        let onHeroReveal = () => {};
        const ctx = gsap.context(() => {
          if (animateIn) {
            gsap.utils.toArray<HTMLElement>("[data-split]").forEach((el) => {
              if (el.closest("[data-hero]")) return;
              gsap.to(el.querySelectorAll(".w > span"), {
                yPercent: 0,
                y: 0,
                duration: 1.1,
                ease: "expo.out",
                stagger: 0.06,
                scrollTrigger: { trigger: el, start: "top 88%", once: true },
              });
            });

            // Hero copy: plays once the 3D scene has risen into the map (or straight away without it).
            const hero = document.querySelector<HTMLElement>("[data-hero]");
            if (hero) {
              const heroIn = gsap
                .timeline({ paused: true, delay: 0.1 })
                .to(hero.querySelectorAll("[data-split] .w > span"), { yPercent: 0, y: 0, duration: 1.1, ease: "expo.out", stagger: 0.06 })
                .to(hero.querySelectorAll("[data-reveal]"), { opacity: 1, y: 0, duration: 1, ease: "expo.out", stagger: 0.1 }, 0.25);
              onHeroReveal = () => heroIn.play();
              if (window.__heroRevealed || !root.classList.contains("hero-intro")) heroIn.play();
              else window.addEventListener("turbo:hero-reveal", onHeroReveal, { once: true });
            }

            gsap.utils.toArray<HTMLElement>("[data-words]").forEach((el) => {
              const tl = gsap.timeline({ scrollTrigger: { trigger: el, start: "top 85%", once: true } });
              tl.to(el.querySelectorAll(".rw"), {
                opacity: 1,
                y: 0,
                duration: 0.9,
                ease: "power3.out",
                stagger: 0.09,
              }).to(el.querySelectorAll("[data-pop]"), { opacity: 1, scale: 1, duration: 0.6, ease: "back.out(1.6)", stagger: 0.12 }, 0.35);
            });

            gsap.utils.toArray<HTMLElement>("[data-scrub]").forEach((el) => {
              gsap.to(el.querySelectorAll(".sw"), {
                opacity: 1,
                ease: "none",
                stagger: 0.1,
                scrollTrigger: { trigger: el, start: "top 85%", end: "bottom 45%", scrub: 0.6 },
              });
            });

            ScrollTrigger.batch("main > :not([data-hero]) [data-reveal]", {
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

          // Page background blends between section colours instead of switching at hard edges.
          // The footer takes part too, so the body (not #main) carries the colour.
          const bgSections = gsap.utils.toArray<HTMLElement>("[data-bg]");
          const page = document.body;
          if (bgSections.length) {
            const colour = (el: HTMLElement) => (el.dataset.bg === "paper" ? "#f3f1ea" : "#0b0c0a");
            root.classList.add("bg-scroll");
            gsap.set(page, { backgroundColor: colour(bgSections[0]) });
            bgSections.forEach((el, i) => {
              if (i === 0 || colour(el) === colour(bgSections[i - 1])) return;
              gsap.fromTo(
                page,
                { backgroundColor: colour(bgSections[i - 1]) },
                {
                  backgroundColor: colour(el),
                  ease: "none",
                  immediateRender: false,
                  // The footer never scrolls far up the viewport, so its fade runs as it enters.
                  scrollTrigger:
                    el.tagName === "FOOTER"
                      ? { trigger: el, start: "top bottom", end: "top 75%", scrub: true }
                      : { trigger: el, start: "top 80%", end: "top 35%", scrub: true },
                },
              );
            });
          }

          gsap.utils.toArray<HTMLElement>("[data-tilt]").forEach((el) => {
            const dir = parseFloat(el.dataset.tilt || "1");
            gsap.from(el, {
              y: 140,
              rotation: 6 * dir,
              opacity: 0.4,
              ease: "none",
              scrollTrigger: { trigger: el.closest("section") ?? el, start: "top bottom", end: "center 60%", scrub: 0.8 },
            });
          });

          const mm = gsap.matchMedia();
          mm.add("(min-width: 1024px)", () => {
            gsap.utils.toArray<HTMLElement>("[data-tapaway]").forEach((section) => {
              const tl = gsap.timeline({
                scrollTrigger: { trigger: section, start: "top top", end: "+=110%", pin: true, scrub: 0.8 },
              });
              tl.from(section.querySelector("[data-tapaway-phones]"), { yPercent: 55, ease: "none" }, 0)
                .from(section.querySelector("[data-tapaway-glow]"), { opacity: 0, scale: 0.5, ease: "none" }, 0)
                .from(
                  section.querySelectorAll<HTMLElement>("[data-tapaway-side]"),
                  { xPercent: (_, t: HTMLElement) => -45 * parseFloat(t.dataset.tapawaySide || "0"), opacity: 0, ease: "none" },
                  0.25,
                );
            });

            gsap.utils.toArray<HTMLElement>("[data-drift]").forEach((wrap) => {
              const track = wrap.querySelector<HTMLElement>("[data-drift-track]");
              if (!track) return;
              gsap.to(track, {
                x: () => -Math.max(0, track.scrollWidth - wrap.clientWidth + 48),
                ease: "none",
                scrollTrigger: { trigger: wrap, start: "top bottom", end: "bottom top", scrub: 0.8, invalidateOnRefresh: true },
              });
            });

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

        // Triggers were created by type, not page order; re-order so pinned sections
        // push every later trigger (background fades included) down by their pin length.
        ScrollTrigger.sort();
        ScrollTrigger.refresh();
        // Arriving on a shared /#section link: jump there now that pin spacing is known.
        const landing = window.location.hash && document.getElementById(decodeURIComponent(window.location.hash.slice(1)));
        if (landing) lenis.scrollTo(landing, { offset: -24, immediate: true });

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
          root.classList.remove("bg-scroll");
          window.removeEventListener("turbo:hero-reveal", onHeroReveal);
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
