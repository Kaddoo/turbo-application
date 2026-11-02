import { SectionHead } from "../ui/SectionHead";

/** Centred intro for the feature rows that follow (Fares, Coverage). */
export function Features() {
  return (
    <section aria-labelledby="features-title" data-bg="paper" className="on-light bg-paper pt-14 text-ink sm:pt-20">
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
