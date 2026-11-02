"use client";

import { useEffect, useRef, useState } from "react";

declare global {
  interface Window {
    __heroRevealed?: boolean;
    __doorEnd?: number;
    /** Set by the boot script in layout.tsx: this browser has watched the intro video before. */
    __heroSeen?: boolean;
  }
}

/**
 * Lets the hero copy in (see Motion.tsx). The copy waits while the video
 * plays and appears once the map has taken over.
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
  if (nav.connection?.saveData) return false;
  if (nav.deviceMemory !== undefined && nav.deviceMemory < 4) return false;
  try {
    const c = document.createElement("canvas");
    return !!(c.getContext("webgl2") || c.getContext("webgl"));
  } catch {
    return false;
  }
}

type Scene = { play(): void; dispose(): void };

/**
 * Hero sequence. First visit (any device): the car-door loader, then the ride
 * video (a student hails the Turbo car, gets in and it pulls away), handing
 * over to the 3D map, which picks up behind the same car at street level and
 * rises into the overview. Later visits skip the loader and video and open on
 * the map. Devices without WebGL, low memory or Save-Data get the flat map
 * (`flatMap`); reduced motion skips the video and shows the map at once.
 */
export function HeroStage({ flatMap }: { flatMap: React.ReactNode }) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const videoRef = useRef<HTMLVideoElement>(null);
  const flatRef = useRef<HTMLDivElement>(null);
  const [mode, setMode] = useState<"video" | "3d" | "flat">("video");

  useEffect(() => {
    const reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const saveData = (navigator as NavigatorWithHints).connection?.saveData;
    const video = videoRef.current!;
    const use3D = canRun3D();
    let scene: Scene | undefined;
    let cancelled = false;
    let handedOver = false;
    const timers: number[] = [];

    const phone = !window.matchMedia("(min-width: 768px)").matches;
    // The intro (car-door loader and ride video) plays on the first visit only, on every device;
    // after that the page opens straight on the map. Remembered in localStorage.
    const seen = !!window.__heroSeen;
    const markSeen = () => {
      try {
        localStorage.setItem("turbo-hero-seen", "1");
      } catch {}
    };

    const startFlat = () => {
      setMode("flat");
      flatRef.current?.querySelector<SVGAnimationElement>("[data-flat-drive]")?.beginElement?.();
      timers.push(window.setTimeout(revealHero, reduced || phone ? 0 : 900));
    };

    // The map takes over from the video (or straight away when there is none).
    const handOver = () => {
      if (handedOver) return;
      handedOver = true;
      markSeen();
      // Let the video play out under the cross-fade, then stop it.
      timers.push(window.setTimeout(() => video.pause(), 1800));
      if (scene) {
        setMode("3d");
        scene.play();
      } else if (use3D && !reduced) {
        // Scene still loading: give it a moment, then settle for the flat map.
        const wait = window.setInterval(() => {
          if (scene) {
            window.clearInterval(wait);
            setMode("3d");
            scene.play();
          }
        }, 100);
        // A returning visitor has no video to cover the load, so allow the 3D scene longer to arrive.
        timers.push(wait, window.setTimeout(() => {
          window.clearInterval(wait);
          if (!scene) startFlat();
        }, seen ? 8000 : 2500));
      } else startFlat();
    };

    if (use3D) {
      const ric = window.requestIdleCallback ?? ((cb: () => void) => window.setTimeout(cb, 200));
      ric(() => {
        import("./heroScene")
          .then(({ mountHeroScene }) => {
            if (cancelled || !canvasRef.current) return;
            scene = mountHeroScene(canvasRef.current, { reduced, onMap: revealHero });
            if (reduced) {
              setMode("3d");
              revealHero();
            }
          })
          .catch(() => {});
      });
    }

    if (reduced || saveData) {
      if (!use3D || saveData) startFlat();
      else timers.push(window.setTimeout(() => !scene && startFlat(), 2500));
      return () => {
        cancelled = true;
        timers.forEach((t) => window.clearTimeout(t));
        scene?.dispose();
      };
    }

    // Returning visitor: no video, the map takes over at once (3D when it loads, else the flat map).
    if (seen) {
      handOver();
      return () => {
        cancelled = true;
        timers.forEach((t) => window.clearTimeout(t));
        scene?.dispose();
      };
    }

    const wide = window.matchMedia("(min-aspect-ratio: 1/1)").matches;
    const webm = video.canPlayType('video/webm; codecs="vp9"') !== "";
    video.poster = `/video/hero-${wide ? "wide" : "tall"}.jpg`;
    video.src = `/video/hero-${wide ? "wide" : "tall"}.${webm ? "webm" : "mp4"}`;

    // Hand over as the car pulls away; the last frame holds under the cross-fade.
    const onTime = () => {
      if (video.duration && video.currentTime > video.duration - 0.8) handOver();
    };
    video.addEventListener("timeupdate", onTime);
    video.addEventListener("ended", handOver);
    video.addEventListener("error", handOver);

    // Start once the car-door loader has opened; if the video can't start (autoplay blocked, slow network), go to the map.
    const begin = () => video.play().catch(handOver);
    timers.push(window.setTimeout(begin, Math.max(0, (window.__doorEnd ?? 0) - Date.now())));
    timers.push(window.setTimeout(() => video.paused && video.currentTime === 0 && handOver(), 9000));

    return () => {
      cancelled = true;
      timers.forEach((t) => window.clearTimeout(t));
      video.removeEventListener("timeupdate", onTime);
      video.removeEventListener("ended", handOver);
      video.removeEventListener("error", handOver);
      scene?.dispose();
    };
  }, []);

  return (
    <div aria-hidden className="absolute inset-0 overflow-hidden bg-ink">
      <div ref={flatRef} className={`absolute inset-0 transition-opacity duration-1000 ${mode === "flat" ? "opacity-100" : "opacity-0"}`}>
        {flatMap}
      </div>
      <canvas
        ref={canvasRef}
        className={`absolute inset-0 size-full transition-opacity duration-[1600ms] ease-in-out ${mode === "3d" ? "opacity-100" : "opacity-0"}`}
      />
      <video
        ref={videoRef}
        muted
        playsInline
        preload="auto"
        className={`absolute inset-0 size-full object-cover transition-[opacity,transform,filter] duration-[1600ms] ease-in-out ${mode === "video" ? "opacity-100" : "scale-[1.08] opacity-0 brightness-50"}`}
      />
    </div>
  );
}
