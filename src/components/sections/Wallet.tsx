import { RotateCcw, WalletCards } from "lucide-react";
import { SectionLabel } from "../SectionLabel";

export function Wallet() {
  return (
    <section aria-labelledby="wallet-title" className="on-light relative overflow-hidden bg-paper py-24 text-ink sm:py-32">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <SectionLabel index="05" className="text-mute-dark">
          Drivers and wallet
        </SectionLabel>
        <h2 id="wallet-title" className="sr-only">
          Your money, your wallet
        </h2>
        <p data-reveal className="mt-8 max-w-5xl text-3xl font-medium leading-[1.12] tracking-[-0.03em] sm:text-5xl lg:text-[3.75rem]">
          Your wallet balance is separate from ride fares until you book.{" "}
          <span className="text-ink/55">Cancel for free, always, with no penalty.</span>
        </p>
        <div className="mt-14 grid gap-4 sm:grid-cols-2">
          <div data-reveal className="flex items-center gap-4 rounded-3xl bg-paper-2 p-6">
            <span className="inline-flex size-12 shrink-0 items-center justify-center rounded-2xl bg-ink text-turbo">
              <WalletCards className="size-6" aria-hidden />
            </span>
            <p className="text-lg">Nothing leaves your balance until you confirm a ride.</p>
          </div>
          <div data-reveal className="flex items-center gap-4 rounded-3xl bg-paper-2 p-6">
            <span className="inline-flex size-12 shrink-0 items-center justify-center rounded-2xl bg-ink text-turbo">
              <RotateCcw className="size-6" aria-hidden />
            </span>
            <p className="text-lg">Changed your mind? Cancel any time. No fee, no penalty.</p>
          </div>
        </div>
      </div>
    </section>
  );
}
