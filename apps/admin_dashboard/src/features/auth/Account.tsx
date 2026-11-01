import { useState } from 'react';
import { roleLabels } from '@/utils/roles';
import { useSession } from '@/state/session';
import { Button, Card, Details, PageHeader, TextField, useToast, ui } from '@/components';
import { formatRelative } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useChangePassword } from './queries';

export function Account() {
  const { me } = useSession();
  const toast = useToast();
  const [form, setForm] = useState({ currentPassword: '', newPassword: '', totpCode: '' });
  const change = useChangePassword();
  return (
    <>
      <PageHeader title="Your account" description="Your staff profile and sign-in security." />
      <div className={ui.grid2}>
        <Card title="Profile">
          {me && (
            <div className={ui.stack}>
              <Details
                items={[
                  ['Name', me.fullName],
                  ['Email', me.email],
                  ['Role', roleLabels[me.staffRole]],
                  ['Authenticator', me.mfaEnrolled ? 'Set up' : 'Not set up'],
                  ['Last sign-in', me.lastLoginAt ? formatRelative(me.lastLoginAt) : 'This is your first'],
                ]}
              />
              {/* No self-service profile edit in the contract yet: CONTRACT_REQUESTS A31. */}
              <p className={ui.muted} style={{ margin: 0 }}>
                To change your name, email or role, ask a super admin.
              </p>
            </div>
          )}
        </Card>
        <Card title="Change password">
          <div className={ui.stack}>
            <p className={ui.muted} style={{ margin: 0 }}>
              You need your current password and a code from your authenticator app. Other devices are signed out.
            </p>
            <TextField
              label="Current password"
              type="password"
              autoComplete="current-password"
              value={form.currentPassword}
              onChange={(e) => setForm({ ...form, currentPassword: e.target.value })}
            />
            <TextField
              label="New password"
              type="password"
              autoComplete="new-password"
              hint="At least 10 characters."
              value={form.newPassword}
              onChange={(e) => setForm({ ...form, newPassword: e.target.value })}
            />
            <TextField
              label="Authenticator code"
              inputMode="numeric"
              maxLength={6}
              value={form.totpCode}
              onChange={(e) => setForm({ ...form, totpCode: e.target.value.replace(/\D/g, '') })}
            />
            {change.error ? (
              <p role="alert" className={ui.muted}>
                {problemMessage(change.error)}
              </p>
            ) : null}
            <div className={ui.actions}>
              <Button
                variant="primary"
                busy={change.isPending}
                disabled={!form.currentPassword || form.newPassword.length < 10 || form.totpCode.length !== 6}
                onClick={() =>
                  change.mutate(form, {
                    onSuccess: () => {
                      setForm({ currentPassword: '', newPassword: '', totpCode: '' });
                      toast('Password changed. Any other device signed in to your account has been signed out.');
                    },
                  })
                }
              >
                Change password
              </Button>
            </div>
          </div>
        </Card>
      </div>
    </>
  );
}
