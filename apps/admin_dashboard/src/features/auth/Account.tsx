import { useState } from 'react';
import { areaLabels, areaRoles, canUse, roleLabels, type Area } from '@/utils/roles';
import { useSession } from '@/state/session';
import { Button, Card, Chip, Icon, PageHeader, ProfileHero, TextField, useToast, ui } from '@/components';
import { formatPesewas, formatRelative } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useChangePassword } from './queries';
import a from './account.module.css';

const MIN_LENGTH = 10;

export function Account() {
  const { me } = useSession();
  const toast = useToast();
  const [form, setForm] = useState({ currentPassword: '', newPassword: '', totpCode: '' });
  const change = useChangePassword();

  const locked = !!me?.lockedUntil && new Date(me.lockedUntil) > new Date();
  const areas = (Object.keys(areaRoles) as Area[]).filter(
    (k) => k !== 'overview' && k !== 'studentDetail' && k !== 'rideDetail' && me && canUse(me.staffRole, k),
  );

  const len = form.newPassword.length;
  const rules = [
    { met: len >= MIN_LENGTH, text: `At least ${MIN_LENGTH} characters` },
    {
      met: !!form.newPassword && form.newPassword !== form.currentPassword,
      text: 'Different from your current password',
    },
    { met: form.totpCode.length === 6, text: 'The 6-digit code from your authenticator app' },
  ];

  return (
    <>
      <PageHeader title="Your account" description="Your staff profile and sign-in security." />
      {me && (
        <ProfileHero
          label="Your profile"
          name={me.fullName}
          lines={[me.email]}
          chips={
            <>
              <Chip tone="accent" variant="plain">
                {roleLabels[me.staffRole]}
              </Chip>
              <Chip tone={me.isActive ? 'success' : 'neutral'}>{me.isActive ? 'Active' : 'Deactivated'}</Chip>
              {locked && <Chip tone="danger">Locked</Chip>}
            </>
          }
          stats={[
            { label: 'Last sign-in', value: me.lastLoginAt ? formatRelative(me.lastLoginAt) : 'This is your first' },
          ]}
        />
      )}

      <div className={a.columns}>
        <div className={ui.stack}>
          <Card title="Security">
            {me && (
              <ul className={a.checks}>
                <li className={a.check} data-tone={me.mfaEnrolled ? 'success' : 'warning'}>
                  <span className={a.checkIcon}>
                    <Icon name={me.mfaEnrolled ? 'check' : 'warning'} size="sm" />
                  </span>
                  <span className={a.checkText}>
                    <span className={a.checkTitle}>Authenticator app</span>
                    <span className={a.checkBody}>
                      {me.mfaEnrolled
                        ? 'Set up. You enter a code from it each time you sign in.'
                        : 'Not set up yet. Your account is protected by your password alone.'}
                    </span>
                  </span>
                </li>
                <li className={a.check} data-tone={locked ? 'warning' : 'success'}>
                  <span className={a.checkIcon}>
                    <Icon name={locked ? 'lock' : 'check'} size="sm" />
                  </span>
                  <span className={a.checkText}>
                    <span className={a.checkTitle}>Account status</span>
                    <span className={a.checkBody}>
                      {locked ? 'Temporarily locked after too many sign-in attempts.' : 'In good standing.'}
                    </span>
                  </span>
                </li>
                {me.adjustmentApprovalThresholdPesewas != null && (
                  <li className={a.check} data-tone="neutral">
                    <span className={a.checkIcon}>
                      <Icon name="adjustments" size="sm" />
                    </span>
                    <span className={a.checkText}>
                      <span className={a.checkTitle}>Adjustment approval threshold</span>
                      <span className={a.checkBody}>
                        Wallet adjustments above {formatPesewas(me.adjustmentApprovalThresholdPesewas)} need a second
                        approver.
                      </span>
                    </span>
                  </li>
                )}
              </ul>
            )}
          </Card>

          <Card title="What you can open">
            <div className={ui.stack}>
              <ul className={a.areas} aria-label="Areas you can open">
                <li className={a.area}>
                  <Icon name="check" size="sm" />
                  Overview
                </li>
                {areas.map((k) => (
                  <li key={k} className={a.area}>
                    <Icon name="check" size="sm" />
                    {areaLabels[k].replace(/^the /, '').replace(/^./, (c) => c.toUpperCase())}
                  </li>
                ))}
              </ul>
              {/* No self-service profile edit in the contract yet: CONTRACT_REQUESTS A31. */}
              <p className={ui.muted} style={{ margin: 0 }}>
                To change your name, email or role, ask a super admin.
              </p>
            </div>
          </Card>
        </div>

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
              value={form.newPassword}
              onChange={(e) => setForm({ ...form, newPassword: e.target.value })}
            />
            <div
              className={a.strength}
              data-ok={len >= MIN_LENGTH}
              role="img"
              aria-label={`${Math.min(len, MIN_LENGTH)} of ${MIN_LENGTH} characters`}
            >
              {Array.from({ length: MIN_LENGTH }, (_, i) => (
                <span key={i} className={a.strengthBar} data-on={i < len} />
              ))}
            </div>
            <TextField
              label="Authenticator code"
              inputMode="numeric"
              maxLength={6}
              value={form.totpCode}
              onChange={(e) => setForm({ ...form, totpCode: e.target.value.replace(/\D/g, '') })}
            />
            <ul className={a.rules} aria-label="Password checklist">
              {rules.map((r) => (
                <li key={r.text} data-met={r.met}>
                  <Icon name={r.met ? 'check' : 'info'} size="sm" />
                  {r.text}
                </li>
              ))}
            </ul>
            {change.error ? (
              <p role="alert" className={ui.muted}>
                {problemMessage(change.error)}
              </p>
            ) : null}
            <div className={ui.actions}>
              <Button
                variant="primary"
                busy={change.isPending}
                disabled={!form.currentPassword || len < MIN_LENGTH || form.totpCode.length !== 6}
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
