import { Icon3d, type Icon3dName } from "../ui/Icon3d";
import { ScrubHeading } from "../ui/ScrubHeading";
import { SectionHead } from "../ui/SectionHead";

const steps: { n: string; icon: Icon3dName; title: string; body: string }[] = [
  {
    n: "01",
    icon: "identification-card",
    title: "Verify once",
    body: "Add your Ghana Card and student ID. Only verified Central University students can ride.",
  },
  {
    n: "02",
    icon: "money-bag",
    title: "Top up your wallet",
    body: "Add money with mobile money. Rides are paid from your wallet, so you never carry cash.",
  },
  {
    n: "03",
    icon: "automobile",
    title: "Book and ride",
    body: "Pick a destination, see the fare, and meet your driver with a 4-digit PIN.",
  },
];

export function HowItWorks() {
  return (
    <section id="how-it-works" data-bg="paper" aria-labelledby="how-title" className="on-light relative bg-paper py-section text-ink">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <SectionHead id="how-title" label="How it works" title="Three steps. No guesswork." />
        <ScrubHeading as="p" className="mx-auto mt-8 max-w-md text-center text-base leading-relaxed text-ink/75 lg:text-[15px]">
          Set up once, then every ride is a destination, a fare you can see, and a PIN. No cash, no haggling, a driver assigned for you.
        </ScrubHeading>

        <ol data-journey="verify" className="mt-20 grid gap-10 sm:mt-28 md:grid-cols-3 md:gap-8">
          {steps.map(({ n, icon, title, body }) => (
            <li key={n} data-reveal className="border-t border-ink/15 pt-6">
              <div className="flex items-center justify-between">
                <span className="font-mono text-xs text-ink/70">{n}</span>
                <Icon3d name={icon} className="size-16" />
              </div>
              <h3 className="mt-3 text-lg font-medium tracking-tight">{title}</h3>
              <p className="mt-3 max-w-xs text-base leading-relaxed text-ink/65 lg:text-sm">{body}</p>
            </li>
          ))}
        </ol>
      </div>
    </section>
  );
}
