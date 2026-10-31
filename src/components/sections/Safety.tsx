import { BadgeCheck, KeyRound, LifeBuoy, Share2, ShieldAlert, UserCheck } from "lucide-react";
import { cn } from "@/lib/cn";
import { Words } from "../ui/ScrubHeading";
import { Tag } from "../ui/Tag";

const items = [
  { icon: BadgeCheck, title: "Verified students only", body: "Every rider is verified with a Ghana Card and student ID.", photo: "/photos/student-phone.jpg" },
  { icon: KeyRound, title: "PIN check before every trip", body: "Your driver can only start the trip with your 4-digit PIN." },
  { icon: UserCheck, title: "Salaried, vetted drivers", body: "Drivers are vetted and paid a salary, not chasing fares.", photo: "/photos/driver.jpg" },
  { icon: LifeBuoy, title: "SOS, watched by staff", body: "The SOS button in the app goes straight to Turbo staff." },
  { icon: Share2, title: "Share your trip", body: "Send your live trip to trusted contacts in a tap.", photo: "/photos/student-bench.jpg" },
];

/** Card strip that drifts sideways as you scroll on large screens and swipes on small ones. */
export function Safety() {
  return (
    <section id="safety" aria-labelledby="safety-title" className="relative overflow-hidden bg-ink py-24 sm:py-36">
      <div className="mx-auto flex max-w-6xl flex-col items-center px-4 text-center sm:px-6">
        <Tag tone="dot">Safety</Tag>
        <h2
          id="safety-title"
          data-words
          aria-label="Know who you’re riding with."
          className="mt-6 text-[2.5rem] font-medium leading-[1.02] tracking-[-0.045em] sm:text-6xl lg:text-7xl">
          <span className="flex flex-wrap items-center justify-center gap-x-4">
            <Tag icon={BadgeCheck} className="hidden sm:inline-flex">
              Verified riders
            </Tag>
            <span>
              <Words>Know who you’re</Words>
            </span>
          </span>
          <span className="flex flex-wrap items-center justify-center gap-x-4">
            <span>
              <Words>riding with.</Words>
            </span>
            <Tag icon={UserCheck} className="hidden sm:inline-flex">
              Vetted drivers
            </Tag>
          </span>
        </h2>
      </div>

      <div
        data-drift
        role="region"
        aria-label="Safety features"
        tabIndex={0}
        className="mt-14 overflow-x-auto px-4 pb-4 [scrollbar-width:none] sm:mt-20 sm:px-6 lg:overflow-visible lg:pl-[max(1.5rem,calc((100vw-72rem)/2+1.5rem))]"
      >
        <ul data-drift-track className="flex w-max items-start gap-4">
          {items.map(({ icon: Icon, title, body, photo }) => (
            <li
              key={title}
              className={cn(
                "group relative flex w-[15rem] shrink-0 flex-col overflow-hidden rounded-xl p-5 sm:w-[17rem]",
                photo ? "h-[22rem] justify-end bg-ink-2 sm:h-[24rem]" : "h-[13rem] justify-between bg-[#1c1d1f]",
              )}
            >
              {photo ? (
                <>
                  {/* eslint-disable-next-line @next/next/no-img-element -- static export */}
                  <img
                    src={photo}
                    alt=""
                    loading="lazy"
                    decoding="async"
                    className="absolute inset-0 h-full w-full object-cover transition-transform duration-700 group-hover:scale-105"
                  />
                  <div aria-hidden className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/30 to-transparent" />
                  <span className="absolute right-4 top-4 inline-flex size-9 items-center justify-center rounded-full bg-black/40 text-turbo backdrop-blur-sm">
                    <Icon aria-hidden className="size-4" />
                  </span>
                  <h3 className="relative text-base font-medium tracking-tight">{title}</h3>
                  <p className="relative mt-1.5 text-[13px] leading-relaxed text-paper/80">{body}</p>
                </>
              ) : (
                <>
                  <span className="inline-flex size-9 items-center justify-center self-end rounded-full bg-white/10 text-turbo">
                    <Icon aria-hidden className="size-4" />
                  </span>
                  <div>
                    <h3 className="text-base font-medium tracking-tight">{title}</h3>
                    <p className="mt-1.5 text-[13px] leading-relaxed text-paper/60">{body}</p>
                  </div>
                </>
              )}
            </li>
          ))}
          <li className="flex h-[13rem] w-[15rem] shrink-0 flex-col justify-between rounded-xl bg-turbo p-5 text-ink sm:w-[17rem]">
            <ShieldAlert className="size-6" aria-hidden />
            <div>
              <p className="text-base font-semibold leading-snug tracking-tight">We never ask you for your wallet PIN.</p>
              <p className="mt-1.5 text-[13px] leading-relaxed text-ink/70">Not by call, text or WhatsApp. If someone asks, it isn’t us.</p>
            </div>
          </li>
        </ul>
      </div>
    </section>
  );
}
