import { useState } from 'react';
import type { Schemas } from '@/types';
import { roleLabels, type StaffRole } from '@/utils/roles';
import { useSession } from '@/state/session';
import {
  Button,
  Chip,
  ConfirmDialog,
  DataTable,
  Details,
  Dialog,
  DialogActions,
  PageHeader,
  Select,
  TextField,
  useToast,
  ui,
  When,
  CardTop,
  Callout,
  Fact,
  Facts,
  Person,
} from '@/components';
import { problemMessage } from '@/utils/problems';
import { useInviteStaff, useResendInvite, useSignOutStaff, useStaff, useUpdateStaff } from './queries';

const roles = Object.keys(roleLabels) as StaffRole[];

export function Staff() {
  const toast = useToast();
  const { me } = useSession();
  const list = useStaff();
  const [inviting, setInviting] = useState(false);
  const [form, setForm] = useState<Schemas['StaffCreate']>({ email: '', fullName: '', staffRole: 'verifier' });
  const [selected, setSelected] = useState<Schemas['StaffUser'] | null>(null);
  const [confirm, setConfirm] = useState<'deactivate' | 'signout' | null>(null);
  const invite = useInviteStaff();
  const update = useUpdateStaff();
  const resend = useResendInvite();
  const signOut = useSignOutStaff();
  return (
    <>
      <PageHeader
        title="Staff"
        description="Every staff member signs in with their own account and an authenticator app. No shared logins."
        actions={
          <Button
            variant="primary"
            onClick={() => {
              setForm({ email: '', fullName: '', staffRole: 'verifier' });
              setInviting(true);
            }}
          >
            Invite staff
          </Button>
        }
      />
      <DataTable
        label="Staff"
        rows={list.rows}
        rowKey={(r) => r.id}
        loading={list.loading}
        error={list.error}
        onRetry={list.refetch}
        hasMore={list.hasMore}
        onLoadMore={list.loadMore}
        loadingMore={list.loadingMore}
        onRowClick={setSelected}
        empty={{ title: 'No staff yet' }}
        card={(r) => <StaffCard r={r} />}
        cardMin="22rem"
        cardTone={(r) =>
          !r.isActive
            ? 'neutral'
            : r.lockedUntil && new Date(r.lockedUntil) > new Date()
              ? 'danger'
              : r.invitePending
                ? 'warning'
                : 'success'
        }
        columns={[
          {
            header: 'Name',
            cell: (r) => (
              <>
                {r.fullName}
                <div className={ui.muted}>{r.email}</div>
              </>
            ),
          },
          { header: 'Role', cell: (r) => roleLabels[r.staffRole] },
          {
            header: 'Status',
            slot: 'badge',
            cell: (r) => (
              <span className={ui.row}>
                {!r.isActive ? (
                  <Chip>Deactivated</Chip>
                ) : r.invitePending ? (
                  <Chip tone="warning">Invite pending</Chip>
                ) : (
                  <Chip tone="success">Active</Chip>
                )}
                {r.lockedUntil && new Date(r.lockedUntil) > new Date() && <Chip tone="danger">Locked</Chip>}
              </span>
            ),
          },
          {
            header: 'Authenticator',
            cell: (r) => (r.mfaEnrolled ? <Chip tone="success">Set up</Chip> : <Chip tone="warning">Not set up</Chip>),
          },
          { header: 'Last sign-in', cell: (r) => <When iso={r.lastLoginAt} /> },
        ]}
      />
      <Dialog open={inviting} onClose={() => setInviting(false)} title="Invite a staff member">
        <TextField
          label="Full name"
          value={form.fullName}
          onChange={(e) => setForm({ ...form, fullName: e.target.value })}
        />
        <TextField
          label="Work email"
          type="email"
          value={form.email}
          onChange={(e) => setForm({ ...form, email: e.target.value })}
          hint="The invite link goes here."
        />
        <Select
          label="Role"
          value={form.staffRole}
          onChange={(e) => setForm({ ...form, staffRole: e.target.value as StaffRole })}
          options={roles.map((r) => ({ value: r, label: roleLabels[r] }))}
        />
        {invite.error ? (
          <p role="alert" className={ui.muted}>
            {problemMessage(invite.error)}
          </p>
        ) : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setInviting(false)}>
            Cancel
          </Button>
          <Button
            variant="primary"
            busy={invite.isPending}
            disabled={form.fullName.trim().length < 2 || !form.email.includes('@')}
            onClick={() =>
              invite.mutate(form, {
                onSuccess: () => {
                  setInviting(false);
                  toast('Invite sent.');
                },
              })
            }
          >
            Send invite
          </Button>
        </DialogActions>
      </Dialog>
      <Dialog open={!!selected && !confirm} onClose={() => setSelected(null)} title={selected?.fullName ?? ''}>
        {selected && (
          <>
            <Details
              items={[
                ['Email', selected.email],
                ['Last sign-in', <When iso={selected.lastLoginAt} exact />],
                ['Locked until', <When iso={selected.lockedUntil} exact />],
              ]}
            />
            <Select
              label="Role"
              value={selected.staffRole}
              disabled={selected.id === me?.id || update.isPending}
              onChange={(e) =>
                update.mutate(
                  { id: selected.id, body: { staffRole: e.target.value as StaffRole } },
                  {
                    onSuccess: (u) => {
                      setSelected(u);
                      toast('Role changed.');
                    },
                  },
                )
              }
              options={roles.map((r) => ({ value: r, label: roleLabels[r] }))}
              hint={selected.id === me?.id ? 'You cannot change your own role.' : undefined}
            />
            {update.error || resend.error ? (
              <p role="alert" className={ui.muted}>
                {problemMessage(update.error ?? resend.error)}
              </p>
            ) : null}
            <div className={ui.actions}>
              {selected.invitePending && (
                <Button
                  busy={resend.isPending}
                  onClick={() => resend.mutate(selected.id, { onSuccess: () => toast('Invite sent again.') })}
                >
                  Resend invite
                </Button>
              )}
              <Button onClick={() => setConfirm('signout')}>Sign out everywhere</Button>
              {selected.id !== me?.id && (
                <Button variant={selected.isActive ? 'danger' : 'primary'} onClick={() => setConfirm('deactivate')}>
                  {selected.isActive ? 'Deactivate' : 'Reactivate'}
                </Button>
              )}
            </div>
          </>
        )}
        <DialogActions>
          <Button variant="ghost" onClick={() => setSelected(null)}>
            Close
          </Button>
        </DialogActions>
      </Dialog>
      <ConfirmDialog
        open={confirm === 'deactivate'}
        onClose={() => setConfirm(null)}
        title={selected?.isActive ? 'Deactivate this account' : 'Reactivate this account'}
        body={
          selected?.isActive
            ? `${selected?.fullName} can no longer sign in. Their past actions stay in the audit log.`
            : 'They can sign in again.'
        }
        confirmLabel={selected?.isActive ? 'Deactivate' : 'Reactivate'}
        danger={selected?.isActive}
        typeToConfirm={selected?.isActive ? 'DEACTIVATE' : undefined}
        busy={update.isPending}
        error={update.error}
        onConfirm={() =>
          update.mutate(
            { id: selected!.id, body: { isActive: !selected!.isActive } },
            {
              onSuccess: () => {
                setConfirm(null);
                setSelected(null);
                toast('Account updated.');
              },
            },
          )
        }
      />
      <ConfirmDialog
        open={confirm === 'signout'}
        onClose={() => setConfirm(null)}
        title="Sign out everywhere"
        body={`${selected?.fullName ?? 'This person'} is signed out of every browser straight away.`}
        confirmLabel="Sign out everywhere"
        danger
        busy={signOut.isPending}
        error={signOut.error}
        onConfirm={() =>
          signOut.mutate(selected!.id, {
            onSuccess: () => {
              setConfirm(null);
              toast('Signed out everywhere.');
            },
          })
        }
      />
    </>
  );
}

function StaffCard({ r }: { r: Schemas['StaffUser'] }) {
  const locked = !!r.lockedUntil && new Date(r.lockedUntil) > new Date();
  return (
    <>
      <CardTop end={<Chip variant="plain">{roleLabels[r.staffRole]}</Chip>}>
        <Person name={r.fullName} sub={r.email} size="lg" />
      </CardTop>
      <span className={ui.row}>
        {!r.isActive ? (
          <Chip>Deactivated</Chip>
        ) : r.invitePending ? (
          <Chip tone="warning">Invite pending</Chip>
        ) : (
          <Chip tone="success">Active</Chip>
        )}
        {locked && <Chip tone="danger">Locked</Chip>}
      </span>
      <Facts>
        <Fact label="Last sign-in">
          <When iso={r.lastLoginAt} />
        </Fact>
        <Fact label="Authenticator">{r.mfaEnrolled ? 'Set up' : 'Not set up'}</Fact>
      </Facts>
      {!r.mfaEnrolled && r.isActive && (
        <Callout tone="warning" icon="lock">
          No authenticator yet
        </Callout>
      )}
    </>
  );
}
