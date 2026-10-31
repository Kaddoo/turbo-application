import { MapPin, ReceiptText } from "lucide-react";
import { Tag } from "../ui/Tag";

/** Centred intro for the feature rows that follow (Fares, Coverage). */
export function Features() {
  return (
    <section aria-labelledby="features-title" className="bg-ink pt-16 sm:pt-24">
      <div className="mx-auto flex max-w-6xl flex-col items-center px-4 text-center sm:px-6">
        <Tag tone="dot">Features</Tag>
        <h2
          id="features-title"
          data-reveal
          className="mt-6 text-[2.6rem] font-medium leading-[1.02] tracking-[-0.045em] sm:text-6xl lg:text-7xl"
        >
          <span className="block sm:pl-[1.5em]">Know your fare</span>
          <span className="flex flex-wrap items-center justify-center gap-x-4 gap-y-2">
            <Tag icon={ReceiptText} className="hidden sm:inline-flex">
              Fixed fares
            </Tag>
            before you move.
            <Tag icon={MapPin} className="hidden sm:inline-flex">
              Set pickup points
            </Tag>
          </span>
        </h2>
      </div>
    </section>
  );
}
