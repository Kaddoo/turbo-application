import { pageMeta } from "@/lib/meta";
import { DocPage } from "@/components/legal/DocPage";
import { links } from "@/config/links";

export const metadata = pageMeta("/delete-account/", "Delete my account", "How to delete your Turbo account, what is removed and what is kept.");

export default function DeleteAccountPage() {
  return (
    <DocPage
      eyebrow="Account"
      title="Delete my account"
      intro="You can delete your Turbo account from inside the app at any time."
    >
      <h2>How to delete your account</h2>
      <ol>
        <li>Open the Turbo app (or the web app) and sign in.</li>
        <li>Go to <strong>Profile</strong>.</li>
        <li>Tap <strong>Delete account</strong> and confirm.</li>
      </ol>
      <p>
        Can’t sign in? Email <a href={`mailto:${links.contactEmail}?subject=Delete%20my%20account`}>{links.contactEmail}</a> or message
        us on <a href={links.whatsappUrl}>WhatsApp</a> from the phone number on your account.
      </p>

      <h2>What is removed</h2>
      <ul>
        <li>Your profile: name and phone number.</li>
        <li>Your verification documents: Ghana Card and student ID.</li>
        <li>Your trusted contacts.</li>
      </ul>

      <h2>What is kept</h2>
      <ul>
        <li>
          <strong>Wallet ledger entries are anonymised, not deleted.</strong> Money records must stay complete, so each entry is kept
          with your identity removed.
        </li>
      </ul>

      <h2>How long it takes</h2>
      <p>
        Deletion is completed within <strong>[placeholder: confirm with Turbo]</strong> of your request. What happens to a remaining
        wallet balance: <strong>[placeholder: confirm with Turbo]</strong>.
      </p>
    </DocPage>
  );
}
