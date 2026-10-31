import { Tag } from "../ui/Tag";

const facts = [
  { label: "Cancellation fee", value: "GH₵0", body: "Changed your mind? Cancel any time. No fee, no penalty." },
  { label: "Trip PIN", value: "4 digits", body: "Your driver can only start the trip once you share your PIN." },
  { label: "Your balance", value: "Untouched", body: "Nothing leaves your wallet until you confirm a ride." },
];

export function Wallet() {
  return (
    <section aria-labelledby="wallet-title" className="on-light relative bg-paper py-20 text-ink sm:py-28">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <h2 id="wallet-title" className="sr-only">
          Your money, your wallet
        </h2>
        <dl className="grid gap-12 sm:grid-cols-3 sm:gap-8">
          {facts.map(({ label, value, body }) => (
            <div key={label} data-reveal className="flex flex-col">
              <dt className="order-1">
                <Tag>{label}</Tag>
              </dt>
              <dd className="order-2 mt-5 text-5xl font-medium tracking-[-0.045em] sm:text-[3.5rem]">{value}</dd>
              <dd className="order-3 mt-3 max-w-[16rem] text-sm leading-relaxed text-ink/65">{body}</dd>
            </div>
          ))}
        </dl>
      </div>
    </section>
  );
}
