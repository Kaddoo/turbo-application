"use client";

import { useEffect, useRef, useState } from "react";

declare global {
  interface Window {
    __heroRevealed?: boolean;
  }
}

/**
 * Lets the hero copy in (see Motion.tsx). The copy waits while the street
 * chase plays and appears once the camera has risen into the map.
 */
function revealHero() {
  if (window.__heroRevealed) return;
  window.__heroRevealed = true;
  document.documentElement.classList.remove("hero-intro");
  window.dispatchEvent(new Event("turbo:hero-reveal"));
}

type NavigatorWithHints = Navigator & { connection?: { saveData?: boolean }; deviceMemory?: number };

function canRun3D() {
  const nav = navigator as NavigatorWithHints;
  if (!window.matchMedia("(min-width: 768px)").matches) return false;
  if (nav.connection?.saveData) return false;
  if (nav.deviceMemory !== undefined && nav.deviceMemory < 4) return false;
  try {
    const c = document.createElement("canvas");
    return !!(c.getContext("webgl2") || c.getContext("webgl"));
  } catch {
    return false;
  }
}

/**
 * Lazily mounts the Three.js city/route scene once the browser is idle.
 * Phones, data-saver and low-memory devices keep the static SVG instead,
 * so three.js is never downloaded there.
 */
export function HeroCanvas() {
  const ref = useRef<HTMLCanvasElement>(null);
  const [ready, setReady] = useState(false);

  useEffect(() => {
    if (!canRun3D()) {
      revealHero();
      return;
    }
    // Never hold the copy back if the scene is slow to arrive.
    const fallback = window.setTimeout(revealHero, 6000);
    let dispose: (() => void) | undefined;
    let cancelled = false;
    const reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const ric = window.requestIdleCallback ?? ((cb: () => void) => window.setTimeout(cb, 200));
    const id = ric(() => {
      import("./heroScene")
        .then(({ mountHeroScene }) => {
          if (cancelled || !ref.current) return;
          window.clearTimeout(fallback);
          dispose = mountHeroScene(ref.current, { reduced, onMap: revealHero });
          requestAnimationFrame(() => setReady(true));
        })
        .catch(revealHero);
    });
    return () => {
      cancelled = true;
      window.clearTimeout(fallback);
      if (typeof id === "number" && window.cancelIdleCallback) window.cancelIdleCallback(id);
      dispose?.();
    };
  }, []);

  return (
    <canvas
      ref={ref}
      aria-hidden
      className={`absolute inset-0 size-full transition-opacity duration-[1600ms] ${ready ? "opacity-100" : "opacity-0"}`}
    />
  );
}
