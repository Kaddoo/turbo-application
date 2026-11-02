import { SectionHead } from "../ui/SectionHead";
import { Floaters } from "../ui/Floaters";

/** Centred intro for the feature rows that follow (Fares, Coverage). */
export function Features() {
  return (
    <section aria-labelledby="features-title" data-bg="paper" className="on-light relative isolate bg-paper pt-14 text-ink sm:pt-20">
      <Floaters
        items={[
          { icon: "credit-card", className: "hidden lg:block left-[4%] top-10 size-20", speed: 1, spin: -16 },
          { icon: "round-pushpin", className: "hidden lg:block right-[5%] top-24 size-16", speed: 1.4, spin: 22 },
        ]}
      />
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <SectionHead
          id="features-title"
          label="Features"
          title="Know your fare before you move."
          lines={["Know your fare", "before you move."]}
          pillStart={{ icon: "coin", label: "Fixed fares" }}
          pillEnd={{ icon: "round-pushpin", label: "Set pickup points" }}
        />
      </div>
    </section>
  );
}
