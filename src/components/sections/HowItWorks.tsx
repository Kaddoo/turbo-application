import { BadgeCheck, CarFront, IdCard, ScanFace, Smartphone, Wallet } from "lucide-react";
import { SectionLabel, SplitHeading } from "../SectionLabel";

function MiniVerify() {
  return (
    <div className="space-y-2.5">
      {[
        { icon: IdCard, label: "Ghana Card" },
        { icon: ScanFace, label: "Student ID" },
      ].map(({ icon: Icon, label }) => (
        <div key={label} className="flex items-center justify-between rounded-2xl bg-white px-4 py-3.5">
          <span className="flex items-center gap-3 text-sm font-medium">
            <Icon className="size-5" aria-hidden /> {label}
          </span>
          <BadgeCheck className="size-5 fill-turbo text-ink" aria-hidden />
        </div>
      ))}
      <p className="pt-1 text-center font-mono text-[11px] uppercase tracking-widest text-mute-dark">Once. That’s it.</p>
    </div>
  );
}

function MiniWallet() {
  return (
    <div className="rounded-3xl bg-ink p-5 text-paper">
      <p className="text-xs text-mute">Wallet</p>
      <p className="mt-1 text-3xl font-semibold tracking-tight">
        GH₵<span className="text-turbo">··</span>
      </p>
      <div className="mt-4 flex items-center gap-3 rounded-2xl bg-white/5 p-3">
        <span className="inline-flex size-9 items-center justify-center rounded-xl bg-turbo text-ink">
          <Smartphone className="size-4" aria-hidden />
        </span>
        <div className="text-sm">
          <p>Top up</p>
          <p className="text-xs text-mute">Mobile money</p>
        </div>
      </div>
    </div>
  );
}

function MiniRide() {
  return (
    <div className="rounded-3xl bg-white p-5">
      <div className="flex items-center justify-between text-sm">
        <span className="text-mute-dark">Your fare</span>
        <span className="rounded-full bg-ink px-2.5 py-1 font-mono text-[11px] uppercase tracking-wider text-turbo">Fixed</span>
      </div>
      <div className="mt-4 flex items-center gap-3 border-t border-ink/10 pt-4">
        <span className="inline-flex size-10 items-center justify-center rounded-full bg-turbo">
          <CarFront className="size-5" aria-hidden />
        </span>
        <div>
          <p className="text-xs text-mute-dark">Tell your driver your PIN</p>
          <div className="mt-1 flex gap-1.5" aria-hidden>
            {[0, 1, 2, 3].map((i) => (
              <span key={i} className="inline-flex size-8 items-center justify-center rounded-lg bg-paper-2 font-mono text-sm">
                •
              </span>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

const steps = [
  {
    n: "01",
    title: "Verify once",
    body: "Add your Ghana Card and student ID. Only verified Central University students can ride.",
    icon: BadgeCheck,
    mini: <MiniVerify />,
  },
  {
    n: "02",
    title: "Top up your wallet",
    body: "Add money with mobile money. Rides are paid from your wallet, so you never carry cash.",
    icon: Wallet,
    mini: <MiniWallet />,
  },
  {
    n: "03",
    title: "Book and ride",
    body: "Pick a destination, see the fare, and meet your driver with a 4-digit PIN.",
    icon: CarFront,
    mini: <MiniRide />,
  },
];

export function HowItWorks() {
  return (
    <section id="how-it-works" aria-labelledby="how-title" className="on-light relative bg-paper text-ink">
      <div data-hscroll className="overflow-hidden lg:flex lg:h-[100svh] lg:items-center">
        <div
          data-hscroll-track
          className="mx-auto flex max-w-6xl flex-col gap-6 px-4 py-24 sm:px-6 lg:mx-0 lg:max-w-none lg:flex-row lg:items-stretch lg:gap-8 lg:py-0 lg:pl-[max(1.5rem,calc((100vw-72rem)/2+1.5rem))] lg:pr-[10vw]"
        >
          <div className="flex shrink-0 flex-col justify-between lg:w-[26rem]">
            <div>
              <SectionLabel index="01" className="text-mute-dark">
                How it works
              </SectionLabel>
              <SplitHeading id="how-title" className="mt-6 text-4xl font-semibold leading-[1.02] tracking-[-0.035em] sm:text-5xl lg:text-6xl">
                Three steps. No guesswork.
              </SplitHeading>
            </div>
            <p data-reveal className="mt-6 max-w-sm text-lg text-ink/65 lg:mt-0">
              Set up once, then every ride is a destination, a fare you can see, and a PIN.
            </p>
          </div>

          <ol className="flex flex-col gap-6 lg:flex-row lg:gap-8">
            {steps.map(({ n, title, body, icon: Icon, mini }) => (
              <li
                key={n}
                data-reveal
                className="group relative flex shrink-0 flex-col overflow-hidden rounded-[2rem] bg-paper-2 p-6 sm:p-8 lg:h-[34rem] lg:w-[25rem]"
              >
                <div className="flex items-start justify-between">
                  <span className="font-mono text-sm text-ink/65">Step {n}</span>
                  <span className="inline-flex size-11 items-center justify-center rounded-full bg-ink text-turbo transition-transform duration-500 group-hover:rotate-[-12deg] group-hover:scale-110">
                    <Icon className="size-5" aria-hidden />
                  </span>
                </div>
                <h3 className="mt-8 text-3xl font-semibold tracking-[-0.03em]">{title}</h3>
                <p className="mt-3 text-ink/65">{body}</p>
                <div className="mt-8 lg:mt-auto" aria-hidden>
                  {mini}
                </div>
                <span aria-hidden className="pointer-events-none absolute -bottom-10 -right-4 text-[11rem] font-semibold leading-none tracking-tighter text-ink/[0.04]">
                  {n.slice(1)}
                </span>
              </li>
            ))}
          </ol>
        </div>
      </div>
    </section>
  );
}
