import { BadgeCheck, KeyRound, LifeBuoy, Share2, ShieldAlert, UserCheck } from "lucide-react";
import { SectionLabel, SplitHeading } from "../SectionLabel";
import { cn } from "@/lib/cn";

const items = [
  { icon: BadgeCheck, title: "Verified students only", body: "Every rider is verified with a Ghana Card and student ID.", span: "lg:col-span-2" },
  { icon: UserCheck, title: "Salaried, vetted drivers", body: "Drivers are vetted and paid a salary, not chasing fares." },
  { icon: KeyRound, title: "PIN check before every trip", body: "Your driver can only start the trip with your 4-digit PIN." },
  { icon: Share2, title: "Share your trip", body: "Send your live trip to trusted contacts in a tap." },
  { icon: LifeBuoy, title: "SOS, watched by staff", body: "The SOS button in the app goes straight to Turbo staff.", span: "lg:col-span-2" },
];

/** Bento grid with a cursor spotlight on each tile (CSS only), after the 21st.dev "spotlight card" pattern. */
export function Safety() {
  return (
    <section id="safety" aria-labelledby="safety-title" className="relative bg-ink py-24 sm:py-32">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <SectionLabel index="04" className="text-mute">
          Safety
        </SectionLabel>
        <SplitHeading id="safety-title" className="mt-6 max-w-3xl text-4xl font-semibold leading-[1.02] tracking-[-0.035em] sm:text-5xl lg:text-6xl">
          Built so you always know who you’re riding with.
        </SplitHeading>

        <ul className="mt-14 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {items.map(({ icon: Icon, title, body, span }) => (
            <li
              key={title}
              data-reveal
              className={cn(
                "group relative overflow-hidden rounded-[1.75rem] border border-white/10 bg-ink-2 p-7 transition-colors duration-500 hover:border-turbo/40",
                span,
              )}
            >
              <div
                aria-hidden
                className="pointer-events-none absolute -right-16 -top-16 size-48 rounded-full bg-turbo/0 blur-3xl transition-colors duration-700 group-hover:bg-turbo/15"
              />
              <span className="inline-flex size-12 items-center justify-center rounded-2xl bg-white/5 text-turbo">
                <Icon className="size-6" aria-hidden />
              </span>
              <h3 className="mt-10 text-xl font-semibold tracking-tight">{title}</h3>
              <p className="mt-2 text-paper/60">{body}</p>
            </li>
          ))}
          <li data-reveal className="relative overflow-hidden rounded-[1.75rem] bg-turbo p-7 text-ink sm:col-span-2 lg:col-span-1">
            <ShieldAlert className="size-8" aria-hidden />
            <p className="mt-10 text-2xl font-semibold leading-tight tracking-tight">We never ask you for your wallet PIN.</p>
            <p className="mt-2 text-ink/70">Not by call, text or WhatsApp. If someone asks, it isn’t us.</p>
          </li>
        </ul>
      </div>
    </section>
  );
}
