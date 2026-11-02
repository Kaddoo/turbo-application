import { pageMeta } from "@/lib/meta";
import { DocPage } from "@/components/legal/DocPage";
import { VersionLabel } from "@/components/legal/VersionLabel";
import { links } from "@/config/links";

export const metadata = pageMeta("/privacy/", "Privacy policy", "How Turbo collects, uses and protects your information.");

export default function PrivacyPage() {
  return (
    <DocPage eyebrow="Legal" title="Privacy policy" meta={<VersionLabel doc="privacy" />}>
      <p className="note">
        <strong>Draft for review.</strong> This page is a structural placeholder. Turbo must replace it with the approved policy
        text before launch.
      </p>

      <h2>Who we are</h2>
      <p>Turbo runs a ride service for verified Central University students at Miotso. This policy covers the Turbo app, the web app and this website.</p>

      <h2>What we collect</h2>
      <ul>
        <li><strong>Identity for verification:</strong> your Ghana Card and student ID, used to confirm you are an eligible student.</li>
        <li><strong>Account details:</strong> your name and phone number.</li>
        <li><strong>Wallet activity:</strong> top-ups, fares and refunds recorded in your wallet ledger.</li>
        <li><strong>Trip details:</strong> pickup point, destination, fare and trip status.</li>
        <li><strong>Safety events:</strong> trips you share with trusted contacts and SOS alerts you raise.</li>
      </ul>

      <h2>This website</h2>
      <p>This website sets no cookies and runs no analytics. It reads public service information (fares, pickup points, opening hours) from Turbo’s API and sends nothing about you.</p>

      <h2>How we use it</h2>
      <ul>
        <li>To verify that riders are Central University students.</li>
        <li>To match you with a driver, show your fare and run your trip.</li>
        <li>To keep an accurate wallet ledger.</li>
        <li>To respond to SOS alerts and support requests.</li>
      </ul>

      <h2>Your choices</h2>
      <p>
        You can delete your account at any time. See <a href="/delete-account/">Delete my account</a> for what is removed and what is kept.
      </p>

      <h2>Contact</h2>
      <p>
        Questions about privacy: <a href={`mailto:${links.contactEmail}`}>{links.contactEmail}</a>.
      </p>
    </DocPage>
  );
}
