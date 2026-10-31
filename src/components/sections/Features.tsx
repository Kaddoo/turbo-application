import { MapPin, ReceiptText } from "lucide-react";
import { Words } from "../ui/ScrubHeading";
import { Tag } from "../ui/Tag";

/** Centred intro for the feature rows that follow (Fares, Coverage). */
export function Features() {
  return (
    <section aria-labelledby="features-title" className="bg-ink pt-24 sm:pt-36">
      <div className="mx-auto flex max-w-6xl flex-col items-center px-4 text-center sm:px-6">
        <Tag tone="dot">Features</Tag>
        <h2
          id="features-title"
          data-words
          aria-label="Know your fare before you move."
          className="mt-6 text-[2.6rem] font-medium leading-[1.02] tracking-[-0.045em] sm:text-6xl lg:text-7xl"
        >
          <span className="block sm:pl-[1.5em]">
            <Words>Know your fare</Words>
          </span>
          <span className="flex flex-wrap items-center justify-center gap-x-4 gap-y-2">
            <Tag icon={ReceiptText} className="hidden sm:inline-flex">
              Fixed fares
            </Tag>
            <span>
              <Words>before you move.</Words>
            </span>
            <Tag icon={MapPin} className="hidden sm:inline-flex">
              Set pickup points
            </Tag>
          </span>
        </h2>
      </div>
    </section>
  );
}
