import { BatteryFull, Signal, Wifi } from "lucide-react";
import { cn } from "@/lib/cn";

/** Decorative device frame. Contents are illustration only, so the whole thing is hidden from assistive tech. */
export function Phone({
  children,
  className,
  screenClassName,
}: {
  children: React.ReactNode;
  className?: string;
  screenClassName?: string;
}) {
  return (
    <div
      aria-hidden
      className={cn(
        "relative aspect-[9/19.5] w-[15rem] shrink-0 rounded-[2.75rem] bg-gradient-to-b from-[#4a4d50] via-[#1c1d1f] to-[#35383a] p-[0.4rem] shadow-[0_50px_120px_-30px_rgba(0,0,0,0.95),inset_0_0_0_1px_rgba(255,255,255,0.14)] sm:w-[17rem]",
        className,
      )}
    >
      <div className={cn("relative flex h-full w-full flex-col overflow-hidden rounded-[2.4rem] bg-black text-paper", screenClassName)}>
        <div className="absolute left-1/2 top-2.5 z-20 h-6 w-20 -translate-x-1/2 rounded-full bg-black ring-1 ring-white/[0.06]" />
        <div className="relative z-10 flex items-center justify-between px-6 pt-3.5 text-[11px] font-semibold">
          <span>9:41</span>
          <span className="flex items-center gap-1">
            <Signal className="size-3" />
            <Wifi className="size-3" />
            <BatteryFull className="size-3.5" />
          </span>
        </div>
        {children}
      </div>
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
