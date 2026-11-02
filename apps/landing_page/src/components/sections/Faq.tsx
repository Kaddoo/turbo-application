import { Plus } from "lucide-react";
import { SectionHead } from "../ui/SectionHead";
import { links } from "@/config/links";

const faqs: { q: string; a: React.ReactNode }[] = [
  {
    q: "Who can use Turbo?",
    a: "Verified Central University students at the Miotso campus. You verify once with your Ghana Card and student ID before your first ride.",
  },
  {
    q: "How does verification work, and how long does it take?",
    a: "In the app, add your Ghana Card and student ID. Turbo checks them before your first ride. Approval usually comes within a day.",
  },
  {
    q: "How do I top up my wallet?",
    a: "Top up your wallet in the app with mobile money.",
  },
  {
    q: "What if my driver does not show?",
    a: (
      <>
        Cancel from the trip screen. It’s free and nothing is charged. If something feels wrong, use SOS in the app or{" "}
        <a className="underline underline-offset-4" href="/support/">
          contact support
        </a>
        .
      </>
    ),
  },
  { q: "Can I cancel?", a: "Yes. Cancel for free, always, with no penalty." },
  {
    q: "What if I lose my phone?",
    a: (
      <>
        Your wallet is protected by your wallet PIN, which we never ask for. Message us on{" "}
        <a className="underline underline-offset-4" href={links.whatsappUrl}>
          WhatsApp
        </a>{" "}
        or{" "}
        <a className="underline underline-offset-4" href={`mailto:${links.contactEmail}`}>
          email
        </a>{" "}
        straight away so we can help you secure your account.
      </>
    ),
  },
  {
    q: "How do I delete my account?",
    a: (
      <>
        In the app go to Profile, then Delete account. The{" "}
        <a className="underline underline-offset-4" href="/delete-account/">
          Delete my account
        </a>{" "}
        page explains what is removed and what is kept.
      </>
    ),
  },
];

export function Faq() {
  return (
    <section id="faq" data-bg="ink" aria-labelledby="faq-title" className="bg-ink py-section">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <div className="flex flex-col items-center text-center">
          <SectionHead id="faq-title" label="FAQ" title="Questions, answered." />
          <p data-reveal className="mt-6 text-paper/60">
            Still stuck?{" "}
            <a href="/support/" className="text-turbo underline-offset-4 hover:underline">
              Contact support
            </a>
            .
          </p>
        </div>
        <div data-journey="help" className="mx-auto mt-12 max-w-3xl divide-y divide-white/10 border-y border-white/10 sm:mt-16">
          {faqs.map(({ q, a }) => (
            <details key={q} data-reveal className="group">
              <summary className="flex cursor-pointer items-center justify-between gap-6 py-6 text-lg font-medium tracking-tight transition-colors hover:text-turbo">
                <h3>{q}</h3>
                <span className="inline-flex size-9 shrink-0 items-center justify-center rounded-full border border-white/15 transition-colors group-open:border-turbo group-open:bg-turbo group-open:text-ink">
                  <Plus className="faq-icon size-4 transition-transform duration-300" aria-hidden />
                </span>
              </summary>
              <div className="max-w-2xl pb-7 pr-12 text-base leading-relaxed lg:text-[15px] text-paper/60">{a}</div>
            </details>
          ))}
        </div>
      </div>
    </section>
  );
}
