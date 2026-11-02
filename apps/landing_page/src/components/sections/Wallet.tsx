import { Icon3d, type Icon3dName } from "../ui/Icon3d";

const facts: { icon: Icon3dName; label: string; value: string; body: string }[] = [
  { icon: "coin", label: "Cancellation fee", value: "GH₵0", body: "Changed your mind? Cancel any time. No fee, no penalty." },
  { icon: "key", label: "Trip PIN", value: "4 digits", body: "Your driver can only start the trip once you share your PIN." },
  { icon: "money-bag", label: "Your balance", value: "Untouched", body: "Nothing leaves your wallet until you confirm a ride." },
];

export function Wallet() {
  return (
    <section aria-labelledby="wallet-title" data-bg="ink" className="relative bg-ink py-section">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <h2 id="wallet-title" className="sr-only">
          Your money, your wallet
        </h2>
        <dl data-journey="wallet" className="grid gap-12 sm:grid-cols-3 sm:gap-8">
          {facts.map(({ icon, label, value, body }) => (
            <div key={label} data-reveal className="flex flex-col">
              <dt className="order-1 flex items-center gap-3 text-sm font-medium uppercase tracking-[0.18em] text-turbo">
                <Icon3d name={icon} className="size-14" />
                {label}
              </dt>
              <dd className="order-2 mt-5 text-5xl font-medium tracking-[-0.045em] sm:text-[3.5rem]">{value}</dd>
              <dd className="order-3 mt-3 max-w-[16rem] text-base leading-relaxed lg:text-sm text-paper/60">{body}</dd>
            </div>
          ))}
        </dl>
      </div>
    </section>
  );
}
