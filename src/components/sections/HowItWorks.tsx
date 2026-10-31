import { SplitHeading } from "../SectionLabel";
import { Tag } from "../ui/Tag";

const steps = [
  {
    n: "01",
    title: "Verify once",
    body: "Add your Ghana Card and student ID. Only verified Central University students can ride.",
  },
  {
    n: "02",
    title: "Top up your wallet",
    body: "Add money with mobile money. Rides are paid from your wallet, so you never carry cash.",
  },
  {
    n: "03",
    title: "Book and ride",
    body: "Pick a destination, see the fare, and meet your driver with a 4-digit PIN.",
  },
];

export function HowItWorks() {
  return (
    <section id="how-it-works" aria-labelledby="how-title" className="relative bg-ink py-28 sm:py-40">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <div className="grid gap-8 lg:grid-cols-[1.4fr_1fr] lg:items-center">
          <div>
            <Tag tone="dot">How it works</Tag>
            <SplitHeading
              id="how-title"
              className="mt-6 max-w-[12ch] text-5xl font-medium leading-[0.98] tracking-[-0.045em] sm:text-6xl lg:text-[5.25rem]"
            >
              Three steps. No guesswork.
            </SplitHeading>
          </div>
          <p data-reveal className="max-w-sm text-[15px] leading-relaxed text-paper/60 lg:justify-self-end">
            Set up once, then every ride is a destination, a fare you can see, and a PIN. No cash, no haggling, a
            driver assigned for you.
          </p>
        </div>

        <ol className="mt-20 grid gap-10 sm:mt-28 md:grid-cols-3 md:gap-8">
          {steps.map(({ n, title, body }) => (
            <li key={n} data-reveal className="border-t border-white/10 pt-6">
              <span className="font-mono text-xs text-paper/50">{n}</span>
              <h3 className="mt-3 text-lg font-medium tracking-tight">{title}</h3>
              <p className="mt-3 max-w-xs text-sm leading-relaxed text-paper/55">{body}</p>
            </li>
          ))}
        </ol>
      </div>
    </section>
  );
}
