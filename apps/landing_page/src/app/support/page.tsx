import { pageMeta } from "@/lib/meta";
import { DocPage } from "@/components/legal/DocPage";
import { OperatingHours } from "@/components/legal/OperatingHours";
import { links } from "@/config/links";
import { Icon3d } from "@/components/ui/Icon3d";

export const metadata = pageMeta("/support/", "Support", "Contact Turbo by email or WhatsApp.");

const card = "flex items-center gap-4 rounded-3xl bg-paper-2 p-6 no-underline transition-colors hover:bg-turbo";

export default function SupportPage() {
  return (
    <DocPage eyebrow="Help" title="Support and contact" intro="Reach us by email or WhatsApp. We don’t have a contact form.">
      <div className="not-prose grid gap-4 sm:grid-cols-2">
        <a className={card} href={`mailto:${links.contactEmail}`} style={{ textDecoration: "none" }}>
          <Icon3d name="speech-balloon" className="size-12" />
          <span>
            <span className="block text-sm text-ink/60">Email</span>
            <span className="font-medium">{links.contactEmail}</span>
          </span>
        </a>
        <a className={card} href={links.whatsappUrl} style={{ textDecoration: "none" }}>
          <Icon3d name="mobile-phone" className="size-12" />
          <span>
            <span className="block text-sm text-ink/60">WhatsApp</span>
            <span className="font-medium">{links.whatsappDisplay}</span>
          </span>
        </a>
      </div>

      <h2>Operating hours</h2>
      <OperatingHours />

      <h2>In an emergency</h2>
      <p>During a trip, use the SOS button in the app. It is watched by Turbo staff.</p>
      <p className="flex items-center gap-3">
        <Icon3d name="telephone-receiver" className="size-10" />
        Campus security: <a href={`tel:${links.campusSecurityPhone.replace(/\s/g, "")}`}>{links.campusSecurityPhone}</a>{" "}
        <span className="text-ink/65">(placeholder)</span>
      </p>

      <h2>Before you contact us</h2>
      <p>
        Many answers are in the <a href="/#faq">FAQ</a>. We will never ask you for your wallet PIN.
      </p>
    </DocPage>
  );
}
