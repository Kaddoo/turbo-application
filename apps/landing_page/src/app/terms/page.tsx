import { pageMeta } from "@/lib/meta";
import { DocPage } from "@/components/legal/DocPage";
import { VersionLabel } from "@/components/legal/VersionLabel";
import { links } from "@/config/links";

export const metadata = pageMeta("/terms/", "Terms of use", "The terms for using Turbo.");

export default function TermsPage() {
  return (
    <DocPage eyebrow="Legal" title="Terms of use" meta={<VersionLabel doc="terms" />}>
      <p className="note">
        <strong>Draft for review.</strong> This page is a structural placeholder. Turbo must replace it with the approved terms
        before launch.
      </p>

      <h2>Who can use Turbo</h2>
      <p>Turbo is for verified Central University students at Miotso. You verify once with your Ghana Card and student ID.</p>

      <h2>Fares and payment</h2>
      <ul>
        <li>Rides are paid from your Turbo wallet. Top up with mobile money.</li>
        <li>You see the exact fare before you confirm. It never changes after.</li>
        <li>Trips over the maximum distance are not available.</li>
      </ul>

      <h2>Cancelling</h2>
      <p>You can cancel for free, always, with no penalty.</p>

      <h2>Safety</h2>
      <ul>
        <li>Give your 4-digit trip PIN to your driver only when you meet them.</li>
        <li>Turbo will never ask for your wallet PIN.</li>
        <li>Use SOS in the app in an emergency. It is watched by Turbo staff.</li>
      </ul>

      <h2>Contact</h2>
      <p>
        <a href={`mailto:${links.contactEmail}`}>{links.contactEmail}</a> or <a href={links.whatsappUrl}>WhatsApp</a>.
      </p>
    </DocPage>
  );
}
