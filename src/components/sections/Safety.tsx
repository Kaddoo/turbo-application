import { BadgeCheck, KeyRound, LifeBuoy, Share2, ShieldAlert, UserCheck } from "lucide-react";
import { cn } from "@/lib/cn";
import { Tag } from "../ui/Tag";

const items = [
  { icon: BadgeCheck, title: "Verified students only", body: "Every rider is verified with a Ghana Card and student ID.", tall: true },
  { icon: UserCheck, title: "Salaried, vetted drivers", body: "Drivers are vetted and paid a salary, not chasing fares." },
  { icon: KeyRound, title: "PIN check before every trip", body: "Your driver can only start the trip with your 4-digit PIN.", tall: true },
  { icon: Share2, title: "Share your trip", body: "Send your live trip to trusted contacts in a tap." },
  { icon: LifeBuoy, title: "SOS, watched by staff", body: "The SOS button in the app goes straight to Turbo staff.", tall: true },
];

/** Card strip that drifts sideways as you scroll on large screens and swipes on small ones. */
export function Safety() {
  return (
    <section id="safety" aria-labelledby="safety-title" className="relative overflow-hidden bg-ink py-24 sm:py-36">
      <div className="mx-auto flex max-w-6xl flex-col items-center px-4 text-center sm:px-6">
        <Tag tone="dot">Safety</Tag>
        <h2 id="safety-title" data-reveal className="mt-6 text-[2.5rem] font-medium leading-[1.02] tracking-[-0.045em] sm:text-6xl lg:text-7xl">
          <span className="flex flex-wrap items-center justify-center gap-x-4">
            <Tag icon={BadgeCheck} className="hidden sm:inline-flex">
              Verified riders
            </Tag>
            Know who you’re
          </span>
          <span className="flex flex-wrap items-center justify-center gap-x-4">
            riding with.
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
          {items.map(({ icon: Icon, title, body, tall }) => (
            <li
              key={title}
              className={cn(
                "group relative flex w-[15rem] shrink-0 flex-col overflow-hidden rounded-xl p-5 sm:w-[17rem]",
                tall
                  ? "h-[22rem] justify-end bg-gradient-to-b from-[#26291f] via-ink-2 to-[#0f100d] sm:h-[24rem]"
                  : "h-[13rem] justify-between bg-[#1c1d1f]",
              )}
            >
              {tall ? (
                <>
                  <div aria-hidden className="absolute inset-x-0 top-0 h-2/3 bg-[radial-gradient(60%_60%_at_50%_35%,rgba(212,255,58,0.22),transparent)]" />
                  <Icon aria-hidden className="absolute left-1/2 top-[30%] size-24 -translate-x-1/2 -translate-y-1/2 text-turbo transition-transform duration-700 group-hover:scale-110" strokeWidth={1.1} />
                  <h3 className="relative text-base font-medium tracking-tight">{title}</h3>
                  <p className="relative mt-1.5 text-[13px] leading-relaxed text-paper/60">{body}</p>
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
