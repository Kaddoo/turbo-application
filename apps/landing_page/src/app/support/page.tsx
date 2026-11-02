import { Mail, MessageCircle, Phone } from "lucide-react";
import { pageMeta } from "@/lib/meta";
import { DocPage } from "@/components/legal/DocPage";
import { OperatingHours } from "@/components/legal/OperatingHours";
import { links } from "@/config/links";

export const metadata = pageMeta("/support/", "Support", "Contact Turbo by email or WhatsApp.");

const card = "flex items-center gap-4 rounded-3xl bg-paper-2 p-6 no-underline transition-colors hover:bg-turbo";

export default function SupportPage() {
  return (
    <DocPage eyebrow="Help" title="Support and contact" intro="Reach us by email or WhatsApp. We don’t have a contact form.">
      <div className="not-prose grid gap-4 sm:grid-cols-2">
        <a className={card} href={`mailto:${links.contactEmail}`} style={{ textDecoration: "none" }}>
          <Mail className="size-6 shrink-0" aria-hidden />
          <span>
            <span className="block text-sm text-ink/60">Email</span>
            <span className="font-medium">{links.contactEmail}</span>
          </span>
        </a>
        <a className={card} href={links.whatsappUrl} style={{ textDecoration: "none" }}>
          <MessageCircle className="size-6 shrink-0" aria-hidden />
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
      <p className="flex items-center gap-2">
        <Phone className="size-5" aria-hidden />
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
