import { useState } from 'react';
import { roleLabels } from '@/utils/roles';
import { useSession } from '@/state/session';
import { Button, Card, Details, PageHeader, TextField, useToast, ui } from '@/components';
import { problemMessage } from '@/utils/problems';
import { useChangePassword } from './queries';

export function Account() {
  const { me } = useSession();
  const toast = useToast();
  const [form, setForm] = useState({ currentPassword: '', newPassword: '', totpCode: '' });
  const change = useChangePassword();
  return (
    <>
      <PageHeader title="Your account" />
      <div className={ui.grid2}>
        <Card title="Profile">
          {me && <Details items={[['Name', me.fullName], ['Email', me.email], ['Role', roleLabels[me.staffRole]], ['Authenticator', me.mfaEnrolled ? 'Set up' : 'Not set up']]} />}
        </Card>
        <Card title="Change password">
          <div className={ui.stack}>
            <TextField label="Current password" type="password" autoComplete="current-password" value={form.currentPassword} onChange={(e) => setForm({ ...form, currentPassword: e.target.value })} />
            <TextField label="New password" type="password" autoComplete="new-password" hint="At least 10 characters." value={form.newPassword} onChange={(e) => setForm({ ...form, newPassword: e.target.value })} />
            <TextField label="Authenticator code" inputMode="numeric" maxLength={6} value={form.totpCode} onChange={(e) => setForm({ ...form, totpCode: e.target.value.replace(/\D/g, '') })} />
            {change.error ? <p role="alert" className={ui.muted}>{problemMessage(change.error)}</p> : null}
            <div className={ui.actions}>
              <Button variant="primary" busy={change.isPending} disabled={!form.currentPassword || form.newPassword.length < 10 || form.totpCode.length !== 6}
                onClick={() => change.mutate(form, { onSuccess: () => { setForm({ currentPassword: '', newPassword: '', totpCode: '' }); toast('Password changed.'); } })}>Change password</Button>
            </div>
          </div>
        </Card>
      </div>
    </>
  );
}
