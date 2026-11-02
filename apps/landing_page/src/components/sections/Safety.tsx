import { cn } from "@/lib/cn";
import { Icon3d, type Icon3dName } from "../ui/Icon3d";
import { Photo } from "../ui/Photo";
import { SectionHead } from "../ui/SectionHead";

const items: { icon: Icon3dName; title: string; body: string; photo?: "student-phone" | "driver" | "student-bench" }[] = [
  { icon: "identification-card", title: "Verified students only", body: "Every rider is verified with a Ghana Card and student ID.", photo: "student-phone" },
  { icon: "key", title: "PIN check before every trip", body: "Your driver can only start the trip with your 4-digit PIN." },
  { icon: "oncoming-taxi", title: "Salaried, vetted drivers", body: "Drivers are vetted and paid a salary, not chasing fares.", photo: "driver" },
  { icon: "bell", title: "SOS, watched by staff", body: "The SOS button in the app goes straight to Turbo staff." },
  { icon: "mobile-phone", title: "Share your trip", body: "Send your live trip to trusted contacts in a tap.", photo: "student-bench" },
];

/**
 * On large screens the section is taller than the screen and its content is sticky:
 * it holds still while the cards arrive one by one and the strip slides across
 * (data-drift in Motion.tsx), then the page moves on. Small screens swipe the strip.
 */
export function Safety() {
  return (
    <section id="safety" data-bg="ink" aria-labelledby="safety-title" className="relative overflow-clip bg-ink lg:motion-safe:h-[calc(max(100svh,50rem)_+_150svh)]">
      <div className="flex flex-col justify-center py-section lg:min-h-[50rem] lg:motion-safe:sticky lg:motion-safe:top-0 lg:motion-safe:h-[100svh] lg:motion-safe:py-0 lg:motion-safe:pt-16">
      <div className="mx-auto flex max-w-6xl flex-col items-center px-4 text-center sm:px-6">
        <SectionHead
          id="safety-title"
          label="Safety"
          title="Know who you’re riding with."
          lines={["Know who you’re", "riding with."]}
          pillStart={{ icon: "locked", label: "Verified riders" }}
          pillEnd={{ icon: "shield", label: "Vetted drivers" }}
        />
      </div>

      <div
        data-drift
        data-journey="pin"
        role="region"
        aria-label="Safety features"
        tabIndex={0}
        className="mt-14 overflow-x-auto px-4 pb-4 lg:mt-12 [scrollbar-width:none] sm:mt-20 sm:px-6 lg:overflow-visible lg:pl-[max(1.5rem,calc((100vw-72rem)/2+1.5rem))]"
      >
        <ul data-drift-track className="flex w-max items-start gap-4">
          {items.map(({ icon, title, body, photo }) => (
            <li
              key={title}
              className={cn(
                "group relative flex w-[15rem] shrink-0 flex-col overflow-hidden rounded-xl p-5 text-paper sm:w-[17rem]",
                photo ? "h-[22rem] justify-end bg-ink-2 sm:h-[24rem]" : "h-[13rem] justify-between bg-[#1c1d1f]",
              )}
            >
              {photo ? (
                <>
                  <Photo
                    name={photo}
                    sizes="(min-width: 640px) 17rem, 15rem"
                    className="absolute inset-0 h-full w-full object-cover transition-transform duration-700 group-hover:scale-105"
                  />
                  <div aria-hidden className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/30 to-transparent" />
                  <span className="absolute right-3 top-3 inline-flex size-12 items-center justify-center rounded-full bg-black/40 backdrop-blur-sm">
                    <Icon3d name={icon} className="size-9" />
                  </span>
                  <h3 className="relative text-base font-medium tracking-tight">{title}</h3>
                  <p className="relative mt-1.5 text-base leading-relaxed lg:text-[13px] text-paper/80">{body}</p>
                </>
              ) : (
                <>
                  <span className="inline-flex size-12 items-center justify-center self-end rounded-full bg-white/10">
                    <Icon3d name={icon} className="size-9" />
                  </span>
                  <div>
                    <h3 className="text-base font-medium tracking-tight">{title}</h3>
                    <p className="mt-1.5 text-base leading-relaxed lg:text-[13px] text-paper/60">{body}</p>
                  </div>
                </>
              )}
            </li>
          ))}
          <li className="flex h-[13rem] w-[15rem] shrink-0 flex-col justify-between rounded-xl bg-turbo p-5 text-ink sm:w-[17rem]">
            <Icon3d name="warning" className="size-12" />
            <div>
              <p className="text-base font-semibold leading-snug tracking-tight">We never ask you for your wallet PIN.</p>
              <p className="mt-1.5 text-base leading-relaxed lg:text-[13px] text-ink/70">Not by call, text or WhatsApp. If someone asks, it isn’t us.</p>
            </div>
          </li>
        </ul>
      </div>
      </div>
    </section>
  );
}
