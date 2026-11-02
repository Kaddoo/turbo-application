"use client";

import { useEffect } from "react";

declare global {
  interface Window {
    __turboMotion?: boolean;
  }
}

/**
 * Loads GSAP and ScrollTrigger after hydration (kept out of the critical bundle) and
 * wires declarative data-attributes. Scrolling is the browser's own: it runs on the
 * compositor and answers the wheel on the next frame. (Lenis was removed: its easing
 * took about 0.4 s to follow each wheel notch and stuttered whenever a frame ran long.)
 *   data-split     headline words rise in (the hero's wait for "turbo:hero-reveal")
 *   data-reveal    fade up on enter (batched + staggered)
 *   data-draw      SVG path draws as it scrolls through the viewport
 *   data-bar       horizontal bar grows from 0
 *   data-parallax  translateY by factor × scroll
 *   data-hscroll / data-hscroll-track   pinned horizontal scroller (≥1024px)
 *   data-scrub     headline words brighten as it scrolls through
 *   data-words     words rise out of masks one by one; [data-pop] pills inside open out of a thin line
 *   data-chars     section header: letters rise out of word masks, then its [data-pop] pills open
 *   data-pop       pills elsewhere (section eyebrows) open out of a thin line on enter
 *   data-bg        "ink" | "paper": the page background fades between section colours
 *   data-tilt      device slides in from its side into its resting tilt (value: ±1 direction)
 *   data-tapaway   pinned scene: phones rise into the glow (≥1024px)
 *   data-drift / data-drift-track   sticky scene: cards arrive one by one while the strip slides sideways (≥1024px)
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

    Promise.all([import("gsap"), import("gsap/ScrollTrigger")])
      .then(([{ gsap }, { ScrollTrigger }]) => {
        if (cancelled) return;
        gsap.registerPlugin(ScrollTrigger);

        // Scroll to a section; html's scroll-padding-top keeps it clear of the fixed header.
        const scrollToEl = (el: HTMLElement, smooth: boolean) => el.scrollIntoView({ behavior: smooth ? "smooth" : "instant", block: "start" });

        // Same-page anchor links scroll smoothly and move focus to the target.
        const onClick = (e: MouseEvent) => {
          const a = (e.target as HTMLElement).closest<HTMLAnchorElement>('a[href^="/#"], a[href^="#"]');
          if (!a || e.metaKey || e.ctrlKey || e.shiftKey) return;
          const hash = a.getAttribute("href")!.replace(/^\//, "");
          if (window.location.pathname !== "/" && a.getAttribute("href")!.startsWith("/")) return;
          const target = document.querySelector<HTMLElement>(hash);
          if (!target) return;
          e.preventDefault();
          scrollToEl(target, true);
          // Keep the section in the address bar so it can be shared and Back works.
          if (hash !== "#main" && window.location.hash !== hash) history.pushState(null, "", hash);
          if (!target.hasAttribute("tabindex")) target.setAttribute("tabindex", "-1");
          target.focus({ preventScroll: true });
        };
        document.addEventListener("click", onClick);

        const animateIn = root.classList.contains("motion");
        // A pill opens out of a thin line, then its label fades in.
        const openPills = (pills: ArrayLike<HTMLElement>) =>
          gsap
            .timeline()
            .to(pills, { clipPath: "inset(0px 0px 0px 0px round 9999px)", duration: 0.7, ease: "expo.out", stagger: 0.15 })
            .to(Array.from(pills).flatMap((p) => Array.from(p.children)), { opacity: 1, duration: 0.4, ease: "power2.out", stagger: 0.05 }, 0.3);
        let onHeroReveal = () => {};
        let veil: HTMLDivElement | undefined;
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
              tl.to(el.querySelectorAll(".rw > span"), { yPercent: 0, y: 0, duration: 1, ease: "expo.out", stagger: 0.08 });
              // Only headings with tags have [data-pop]; an empty target makes GSAP warn in the console.
              const pops = el.querySelectorAll<HTMLElement>("[data-pop]");
              if (pops.length) tl.add(openPills(pops), 0.45);
            });

            gsap.utils.toArray<HTMLElement>("[data-chars]").forEach((el) => {
              const tl = gsap.timeline({ scrollTrigger: { trigger: el, start: "top 85%", once: true } });
              tl.to(el.querySelectorAll(".c"), { yPercent: 0, y: 0, rotate: 0, duration: 1.1, ease: "expo.out", stagger: 0.018 });
              const pops = el.querySelectorAll<HTMLElement>("[data-pop]");
              if (pops.length) tl.add(openPills(pops), 0.5);
            });

            // Pills outside a heading open on their own as they arrive.
            gsap.utils.toArray<HTMLElement>("[data-pop]").forEach((pill) => {
              if (pill.closest("[data-words], [data-chars]")) return;
              const tl = openPills([pill]);
              tl.pause();
              ScrollTrigger.create({ trigger: pill, start: "top 90%", once: true, onEnter: () => void tl.play() });
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
          // The body stays ink; a fixed paper layer behind the content fades in and out.
          // Opacity runs on the compositor, where a background-color tween repaints the page every frame.
          const bgSections = gsap.utils.toArray<HTMLElement>("[data-bg]");
          if (bgSections.length) {
            const paper = (el: HTMLElement) => (el.dataset.bg === "paper" ? 1 : 0);
            const layer = document.createElement("div");
            layer.setAttribute("aria-hidden", "true");
            layer.className = "pointer-events-none fixed inset-0 -z-10 bg-paper will-change-[opacity]";
            document.body.prepend(layer);
            veil = layer;
            root.classList.add("bg-scroll");
            gsap.set(layer, { opacity: paper(bgSections[0]) });
            bgSections.forEach((el, i) => {
              if (i === 0 || paper(el) === paper(bgSections[i - 1])) return;
              gsap.fromTo(
                layer,
                { opacity: paper(bgSections[i - 1]) },
                {
                  opacity: paper(el),
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
              xPercent: 55 * dir,
              y: 80,
              rotation: 8 * dir,
              opacity: 0,
              ease: "none",
              scrollTrigger: { trigger: el.closest("section") ?? el, start: "top bottom", end: "center 60%", scrub: 0.8 },
            });
          });

          const mm = gsap.matchMedia();
          mm.add("(min-width: 1024px)", () => {
            // The section is taller than the screen and its content is sticky (TapAway.tsx); no pin.
            gsap.utils.toArray<HTMLElement>("[data-tapaway]").forEach((section) => {
              if (!animateIn) return;
              const tl = gsap.timeline({
                scrollTrigger: { trigger: section, start: "top top", end: "bottom bottom", scrub: 0.8 },
              });
              tl.from(section.querySelector("[data-tapaway-phones]"), { yPercent: 55, ease: "none" }, 0)
                .from(section.querySelector("[data-tapaway-glow]"), { opacity: 0, scale: 0.5, ease: "none" }, 0)
                .from(
                  section.querySelectorAll<HTMLElement>("[data-tapaway-side]"),
                  { xPercent: (_, t: HTMLElement) => -45 * parseFloat(t.dataset.tapawaySide || "0"), opacity: 0, ease: "none" },
                  0.25,
                );
            });

            // The section is tall and its content sticky (Safety.tsx): while it holds, the cards
            // arrive one by one and the strip slides so the last one ends in view; then it lets go.
            gsap.utils.toArray<HTMLElement>("[data-drift]").forEach((wrap) => {
              const track = wrap.querySelector<HTMLElement>("[data-drift-track]");
              const section = wrap.closest("section");
              if (!track || !section) return;
              const cards = Array.from(track.children) as HTMLElement[];
              const tl = gsap.timeline({
                scrollTrigger: { trigger: section, start: "top top", end: "bottom bottom", scrub: 0.6, invalidateOnRefresh: true },
              });
              // Slide until the last card's right edge sits 48 px inside the screen (the strip's left padding counts).
              tl.to(track, { x: () => -Math.max(0, track.offsetLeft + track.scrollWidth - wrap.clientWidth + 48), ease: "none", duration: cards.length }, 0);
              if (animateIn) tl.from(cards, { y: 80, opacity: 0, ease: "power2.out", duration: 0.8, stagger: 1 }, 0);
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
        if (landing) scrollToEl(landing, false);

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
        // Watch <main> only, where API data renders. ScrollTrigger's own refresh adds and
        // removes a helper <div> on <body>; watching <body> turned every refresh into the
        // next one, five times a second, re-measuring the page and resetting the scroll.
        mo.observe(document.getElementById("main") ?? document.body, { childList: true, subtree: true });
        window.addEventListener("load", () => ScrollTrigger.refresh(), { once: true });

        cleanup = () => {
          root.classList.remove("bg-scroll");
          veil?.remove();
          window.removeEventListener("turbo:hero-reveal", onHeroReveal);
          mo.disconnect();
          document.removeEventListener("click", onClick);
          ctx.revert();
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
