"use client";

import { useLayoutEffect, useRef, useState } from "react";
import { BatteryFull, Signal, Wifi } from "lucide-react";
import { cn } from "@/lib/cn";
import poses from "./devicePoses.json";

export type Pose = keyof typeof poses;

/** Size the screens are laid out at, in CSS px (matches the model's display aspect). */
const SW = 272;
const SH = 568;

/**
 * CSS matrix3d that maps the SW×SH screen rectangle onto four image-space
 * corners (TL, TR, BR, BL): a projective transform solved by Gaussian elimination.
 */
function homography(c: number[][]) {
  const src = [
    [0, 0],
    [SW, 0],
    [SW, SH],
    [0, SH],
  ];
  const A: number[][] = [];
  src.forEach(([x, y], i) => {
    const [u, v] = c[i];
    A.push([x, y, 1, 0, 0, 0, -u * x, -u * y, u]);
    A.push([0, 0, 0, x, y, 1, -v * x, -v * y, v]);
  });
  for (let i = 0; i < 8; i++) {
    let p = i;
    for (let r = i + 1; r < 8; r++) if (Math.abs(A[r][i]) > Math.abs(A[p][i])) p = r;
    [A[i], A[p]] = [A[p], A[i]];
    for (let r = 0; r < 8; r++) {
      if (r === i) continue;
      const f = A[r][i] / A[i][i];
      for (let k = i; k < 9; k++) A[r][k] -= f * A[i][k];
    }
  }
  const [a, b, cc, d, e, f, g, h] = A.map((row, i) => row[8] / row[i]);
  return `matrix3d(${[a, d, 0, g, b, e, 0, h, 0, 0, 1, 0, cc, f, 0, 1].map((n) => +n.toFixed(8)).join(",")})`;
}

const matrices = Object.fromEntries(Object.entries(poses).map(([k, p]) => [k, homography(p.corners)])) as Record<Pose, string>;

/**
 * Rendered iPhone 17 Pro (see scripts/mockups) with a live HTML screen warped
 * into its display. Width comes from className; height follows the render.
 * Decorative, so hidden from assistive tech.
 */
export function Phone({
  children,
  pose = "front",
  className,
  screenClassName,
}: {
  children: React.ReactNode;
  pose?: Pose;
  className?: string;
  screenClassName?: string;
}) {
  const p = poses[pose];
  const ref = useRef<HTMLDivElement>(null);
  const [k, setK] = useState(0);

  useLayoutEffect(() => {
    const el = ref.current!;
    const ro = new ResizeObserver(() => setK(el.clientWidth / p.width));
    ro.observe(el);
    return () => ro.disconnect();
  }, [p.width]);

  return (
    <div
      ref={ref}
      aria-hidden
      className={cn("relative w-60 shrink-0 sm:w-68", className)}
      style={{ aspectRatio: `${p.width} / ${p.height}` }}
    >
      <div
        className="absolute left-0 top-0 origin-top-left"
        style={{ width: p.width, height: p.height, transform: `scale(${k})`, visibility: k ? undefined : "hidden" }}
      >
        <div
          className={cn("absolute left-0 top-0 flex flex-col overflow-hidden rounded-[15%/7.2%] bg-black text-paper", screenClassName)}
          style={{ width: SW, height: SH, transformOrigin: "0 0", transform: matrices[pose] }}
        >
          <div className="relative z-10 flex h-11.5 items-center justify-between px-7.5 pt-1.5 text-[12px] font-semibold">
            <span>9:41</span>
            <span className="flex items-center gap-1">
              <Signal className="size-3" />
              <Wifi className="size-3" />
              <BatteryFull className="size-3.5" />
            </span>
          </div>
          {children}
          <div className="pointer-events-none absolute inset-0 z-20 bg-[linear-gradient(115deg,rgba(255,255,255,0.10)_0%,rgba(255,255,255,0.03)_28%,transparent_42%)]" />
        </div>
      </div>
      {/* eslint-disable-next-line @next/next/no-img-element -- static export, pre-sized render */}
      <img src={`/mockups/${pose}.webp`} width={pose === "front" ? 900 : 1000} height={1800} alt="" decoding="async" loading="lazy" className="pointer-events-none absolute inset-0 h-full w-full select-none" />
    </div>
  );
}

/** Dark street-grid backdrop with a lime route, used on map screens. */
export function MapScreen({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 270 520" preserveAspectRatio="xMidYMid slice" className={cn("absolute inset-0 h-full w-full", className)} fill="none">
      <rect width="270" height="520" fill="#0f110d" />
      <g stroke="#1f231b" strokeWidth="10">
        <path d="M-10 120 L280 60" />
        <path d="M-10 300 L280 250" />
        <path d="M60 -10 L110 530" />
        <path d="M190 -10 L210 530" />
        <path d="M-10 430 L280 420" />
      </g>
      <g stroke="#181b15" strokeWidth="4">
        <path d="M-10 200 L280 170" />
        <path d="M140 -10 L150 530" />
        <path d="M-10 370 L280 340" />
      </g>
      <path d="M70 470 C 80 400, 150 380, 150 300 S 200 180, 205 110" stroke="#d4ff3a" strokeOpacity=".2" strokeWidth="16" strokeLinecap="round" />
      <path d="M70 470 C 80 400, 150 380, 150 300 S 200 180, 205 110" stroke="#d4ff3a" strokeWidth="5" strokeLinecap="round" />
      <circle cx="70" cy="470" r="9" fill="#f3f1ea" />
      <circle cx="205" cy="110" r="14" fill="#d4ff3a" fillOpacity=".25" />
      <circle cx="205" cy="110" r="7" fill="#d4ff3a" />
    </svg>
  );
}
