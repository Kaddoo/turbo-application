"use client";

import { useEffect, useRef, useState } from "react";
import { Icon3d, type Icon3dName } from "./ui/Icon3d";

/**
 * One ride down the page. A 3D taxi follows a route down the right-hand page
 * margin (along the screen edge, behind the content, on narrow screens) and
 * keeps pace a little below the middle of the screen as you scroll. The route behind it fills in. At each stop,
 * marked in the sections with data-journey="…", the object waiting there plays
 * its part as the car reaches it. Everything is driven by the scroll, so it
 * moves at your pace and runs backwards if you scroll back up:
 *
 *   verify   How it works   the ID card is taken in and a check appears
 *   fare     Fixed fares    the coin spins into the car: the fare is fixed
 *   pickup   Where we go    the pin drops onto the route as the car pulls up
 *   pin      Safety         the key turns in the lock: PIN checked
 *   wallet   Wallet         the money bag bounces, still full: balance untouched
 *   help     FAQ            the speech balloon pops up: help on hand
 *   arrive   Download       the party popper goes off: arrived
 *
 * Decorative only (aria-hidden). Skipped when the visitor prefers reduced motion.
 */

type Role = "absorb" | "coin" | "drop" | "unlock" | "bounce" | "pop" | "celebrate";
type StopDef = { id: string; label: string; icon: Icon3dName; extra?: Icon3dName; role: Role; lead?: number };

const STOPS: StopDef[] = [
  { id: "verify", label: "Verified", icon: "identification-card", extra: "check-mark-button", role: "absorb" },
  { id: "fare", label: "Fare fixed", icon: "coin", role: "coin" },
  { id: "pickup", label: "At the pickup point", icon: "round-pushpin", role: "drop", lead: 160 },
  { id: "pin", label: "PIN checked", icon: "locked", extra: "key", role: "unlock" },
  { id: "wallet", label: "Balance untouched", icon: "money-bag", role: "bounce" },
  { id: "help", label: "Help on hand", icon: "speech-balloon", role: "pop" },
  { id: "arrive", label: "Arrived", icon: "party-popper", role: "celebrate" },
];

type Point = { x: number; y: number };
type Geo = { w: number; h: number; d: string; start: Point; stops: Point[]; wide: boolean };

/**
 * Where the route runs: down the right-hand page margin when there is room, otherwise
 * along the right screen edge. It never crosses the content; between stops it bends
 * gently within the margin, like a road.
 */
function measure(): Geo | null {
  const main = document.getElementById("main");
  if (!main) return null;
  const top = main.getBoundingClientRect().top + window.scrollY;
  const w = main.clientWidth;
  const margin = (w - Math.min(w, 72 * 16 + 48)) / 2;
  const wide = margin >= 110;
  const x = wide ? w - margin / 2 : w - 26;
  const sway = wide ? Math.min(28, margin / 5) : 0;
  const docY = (el: Element) => el.getBoundingClientRect().top + window.scrollY - top;

  const anchors = STOPS.map((s) => document.querySelector<HTMLElement>(`[data-journey="${s.id}"]`));
  if (anchors.some((a) => !a)) return null;
  const first = anchors[0]!.closest("section") ?? anchors[0]!;
  const start = { x, y: docY(first) + 40 };

  const stops = anchors.map((el) => {
    // A sticky scene (Safety) holds its content while the section scrolls: put the stop partway through it.
    const sticky = el!.closest<HTMLElement>("#safety");
    const y = sticky ? docY(sticky) + sticky.offsetHeight * 0.45 : docY(el!) + el!.getBoundingClientRect().height / 2;
    return { x, y };
  });

  // Each leg is a soft S-bend that leaves and arrives straight down; bends alternate sides.
  let d = `M${start.x} ${start.y}`;
  let prev: Point = start;
  stops.forEach((s, i) => {
    const dy = s.y - prev.y;
    const bend = (i % 2 ? 1 : -1) * sway;
    d += ` C${prev.x + bend} ${prev.y + dy * 0.35}, ${s.x - bend} ${prev.y + dy * 0.65}, ${s.x} ${s.y}`;
    prev = s;
  });
  const round = (n: number) => Math.round(n * 10) / 10;
  return { w, h: main.scrollHeight, d, start, stops: stops.map((s) => ({ x: round(s.x), y: round(s.y) })), wide };
}

export function Journey() {
  const [geo, setGeo] = useState<Geo | null>(null);
  const routeRef = useRef<SVGPathElement>(null);
  const revealRef = useRef<SVGPathElement>(null);
  const carRef = useRef<HTMLDivElement>(null);
  const stopRefs = useRef<(HTMLDivElement | null)[]>([]);

  // Measure after layout, and again whenever the page changes height or width (fonts, API data, resize).
  useEffect(() => {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
    let last = "";
    let t: ReturnType<typeof setTimeout> | undefined;
    const update = () => {
      clearTimeout(t);
      t = setTimeout(() => {
        const g = measure();
        const key = JSON.stringify(g);
        if (g && key !== last) {
          last = key;
          setGeo(g);
        }
      }, 150);
    };
    update();
    const ro = new ResizeObserver(update);
    ro.observe(document.getElementById("main")!);
    window.addEventListener("load", update, { once: true });
    return () => {
      clearTimeout(t);
      ro.disconnect();
      window.removeEventListener("load", update);
    };
  }, []);

  // Drive the car and the stops from the scroll position.
  useEffect(() => {
    if (!geo || !routeRef.current || !carRef.current) return;
    let cancelled = false;
    let cleanup = () => {};
    import("gsap").then(({ gsap }) => {
      if (cancelled) return;
      const route = routeRef.current!;
      const car = carRef.current!;
      const total = route.getTotalLength();
      // Points every 6 px along the route; y only ever grows, so a binary search finds the car's spot.
      const samples: { x: number; y: number; l: number }[] = [];
      for (let l = 0; l <= total; l += 6) {
        const p = route.getPointAtLength(l);
        samples.push({ x: p.x, y: p.y, l });
      }
      const at = (y: number) => {
        let lo = 0;
        let hi = samples.length - 1;
        while (lo < hi) {
          const mid = (lo + hi) >> 1;
          if (samples[mid].y < y) lo = mid + 1;
          else hi = mid;
        }
        return lo;
      };
      const stopLen = geo.stops.map((s) => samples[at(s.y)].l);

      const reveal = revealRef.current!;
      reveal.style.strokeDasharray = `${total} ${total}`;
      reveal.style.strokeDashoffset = `${total}`;

      const ctx = gsap.context(() => {
        // Locked to the scroll: no easing of its own, so the car moves exactly as the page does.
        const setX = gsap.quickSetter(car, "x", "px");
        const setY = gsap.quickSetter(car, "y", "px");
        const setRot = gsap.quickSetter(car, "rotation", "deg");
        const body = car.firstElementChild!;
        gsap.set(car, { x: geo.start.x, y: geo.start.y, xPercent: -50, yPercent: -50, opacity: 0, scale: 0.6 });

        // Each stop's part, built paused and scrubbed by the car's progress (see PLAY).
        const timelines = STOPS.map((s, i) => {
          const el = stopRefs.current[i];
          if (!el) return gsap.timeline({ paused: true });
          const obj = el.querySelector("[data-obj]");
          const extra = el.querySelector("[data-extra]");
          const chip = el.querySelector("[data-chip]");
          const tl = gsap.timeline({ paused: true });
          // Waiting objects sit a little dim and small until the car comes for them.
          gsap.set(obj, { opacity: 0.6, scale: 0.85 });
          if (extra) gsap.set(extra, { opacity: 0, scale: 0 });
          if (chip) gsap.set(chip, { opacity: 0, y: 8 });
          tl.to(body, { scale: 1.18, duration: 0.16, yoyo: true, repeat: 1, ease: "power2.out" }, 0);
          switch (s.role) {
            case "absorb":
              tl.to(obj, { opacity: 1, scale: 1.1, duration: 0.2 }, 0)
                .to(obj, { scale: 0, rotation: -30, opacity: 0, duration: 0.45, ease: "back.in(2)" })
                .to(extra, { opacity: 1, scale: 1, duration: 0.5, ease: "back.out(2.2)" });
              break;
            case "coin":
              tl.to(obj, { opacity: 1, scale: 1.1, duration: 0.2 }, 0)
                .to(obj, { rotationY: 720, y: 26, scale: 0.15, opacity: 0, duration: 0.9, ease: "power2.in" });
              break;
            case "drop":
              gsap.set(obj, { y: -140, opacity: 0, scale: 1 });
              tl.to(obj, { y: 0, opacity: 1, duration: 0.9, ease: "bounce.out" }, 0);
              break;
            case "unlock":
              gsap.set(extra, { x: -46, y: 30 });
              tl.to(obj, { opacity: 1, scale: 1, duration: 0.2 }, 0)
                .to(extra, { opacity: 1, scale: 0.8, duration: 0.3, ease: "back.out(2)" })
                .to(extra, { x: -6, y: 8, duration: 0.35, ease: "power2.inOut" })
                .to(extra, { rotation: 90, duration: 0.3, ease: "power2.inOut" })
                .to(obj, { rotation: 10, duration: 0.08, yoyo: true, repeat: 3 }, "<")
                .to(extra, { opacity: 0, scale: 0.3, duration: 0.25 })
                .to(obj, { scale: 1.12, duration: 0.25, yoyo: true, repeat: 1 }, "<");
              break;
            case "bounce":
              tl.to(obj, { opacity: 1, scale: 1, duration: 0.2 }, 0).to(obj, { y: -26, duration: 0.25, yoyo: true, repeat: 3, ease: "power2.out" });
              break;
            case "pop":
              tl.to(obj, { opacity: 1, scale: 1.2, rotation: -10, duration: 0.3, ease: "back.out(2)" }, 0).to(obj, { scale: 1, rotation: 0, duration: 0.3 });
              break;
            case "celebrate":
              tl.to(obj, { opacity: 1, scale: 1.35, rotation: -20, duration: 0.35, ease: "back.out(2.5)" }, 0)
                .to(obj, { scale: 1, rotation: 0, duration: 0.35 })
                .to(body, { y: -18, duration: 0.2, yoyo: true, repeat: 1, ease: "power2.out" }, 0.1);
              break;
          }
          if (chip) tl.to(chip, { opacity: 1, y: 0, duration: 0.35, ease: "power2.out" }, ">-0.15");
          return tl;
        });
        // Each stop's part is scrubbed by the car's progress over this distance (px of route) as it arrives.
        const PLAY = 220;
        let visible = false;

        const onScroll = () => {
          const top = document.getElementById("main")!.getBoundingClientRect().top + window.scrollY;
          const target = window.scrollY - top + window.innerHeight * 0.55;
          const shown = target >= geo.start.y - 40;
          const i = at(target);
          const p = samples[i];
          const ahead = samples[Math.min(samples.length - 1, i + 8)];
          setX(p.x);
          setY(p.y);
          // Lean gently into the bends.
          setRot(gsap.utils.clamp(-8, 8, (ahead.x - p.x) * 0.5));
          reveal.style.strokeDashoffset = `${total - p.l}`;
          if (shown !== visible) {
            visible = shown;
            gsap.to(car, { opacity: shown ? 1 : 0, scale: shown ? 1 : 0.6, duration: 0.4, ease: "back.out(1.6)", overwrite: "auto" });
          }
          STOPS.forEach((s, k) => {
            const from = stopLen[k] - (s.lead ?? 30);
            timelines[k].progress(gsap.utils.clamp(0, 1, (p.l - from) / PLAY));
          });
        };
        onScroll();
        window.addEventListener("scroll", onScroll, { passive: true });
        cleanup = () => window.removeEventListener("scroll", onScroll);
      });
      const off = cleanup;
      cleanup = () => {
        off();
        ctx.revert();
      };
    });
    return () => {
      cancelled = true;
      cleanup();
    };
  }, [geo]);

  if (!geo) return <div aria-hidden className="hidden" />;
  const objSize = geo.wide ? "size-14" : "size-9";
  return (
    <div aria-hidden className={`pointer-events-none absolute inset-0 overflow-hidden ${geo.wide ? "z-20" : "-z-10"}`} style={{ height: geo.h }}>
      <svg width={geo.w} height={geo.h} className="absolute left-0 top-0" fill="none">
        {/* The road ahead, faint; the stretch already driven, in lime. */}
        <path ref={routeRef} d={geo.d} className="stroke-mute/30" strokeWidth="2" strokeDasharray="2 9" strokeLinecap="round" />
        <path ref={revealRef} d={geo.d} className="stroke-turbo-deep" strokeWidth="3" strokeLinecap="round" />
      </svg>
      {geo.stops.map((s, i) => (
        <div
          key={STOPS[i].id}
          ref={(el) => {
            stopRefs.current[i] = el;
          }}
          className="absolute -translate-x-1/2 -translate-y-1/2"
          style={{ left: s.x, top: s.y }}
        >
          <div className="relative flex flex-col items-center">
            {geo.wide && (
              <span
                data-chip
                className="absolute bottom-full right-0 mb-2 inline-flex h-7 items-center gap-1.5 whitespace-nowrap rounded-full bg-ink-3 px-3 text-xs font-medium text-paper/85 shadow-[0_6px_18px_-8px_rgba(0,0,0,0.5)]"
              >
                <span className="size-1.5 rounded-full bg-turbo" />
                {STOPS[i].label}
              </span>
            )}
            <div className={`relative ${objSize} [perspective:400px]`}>
              <div data-obj className="size-full">
                <Icon3d name={STOPS[i].icon} className="size-full drop-shadow-[0_12px_16px_rgba(0,0,0,0.35)]" />
              </div>
              {STOPS[i].extra && (
                <div data-extra className="absolute inset-0">
                  <Icon3d name={STOPS[i].extra!} className="size-full drop-shadow-[0_12px_16px_rgba(0,0,0,0.35)]" />
                </div>
              )}
            </div>
          </div>
        </div>
      ))}
      <div ref={carRef} className="absolute left-0 top-0">
        <div className={geo.wide ? "size-16" : "size-10"}>
          <Icon3d name="oncoming-taxi" eager className="size-full drop-shadow-[0_14px_18px_rgba(0,0,0,0.45)]" />
        </div>
      </div>
    </div>
  );
}
