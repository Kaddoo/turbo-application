import { useState } from 'react';
import { useNavigate, useParams } from 'react-router';
import { canUse } from '@/utils/roles';
import { useSession } from '@/state/session';
import { Banner, Button, Card, Chip, ConfirmDialog, DataTable, Details, Dialog, DialogActions, ErrorState, Money, PageHeader, Select, Skeleton, TextArea, TextField, useToast, ui } from '@/components';
import { accountTone, verificationTone } from '@/components/statusTones';
import { formatDate, formatPhone, humanize, maskPhone } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useChangeStudentPhone, useSetStudentStatus, useSignOutStudent, useStudent, useStudents } from './queries';


export function Students() {
  const navigate = useNavigate();
  const [q, setQ] = useState('');
  const [search, setSearch] = useState('');
  const [verificationStatus, setVs] = useState('');
  const [accountStatus, setAs] = useState('');
  const list = useStudents(search, verificationStatus, accountStatus);
  return (
    <>
      <PageHeader title="Students" description="Search by name or phone. Open a student to suspend, reactivate, change their number or sign them out." />
      <form className={ui.filters} onSubmit={(e) => { e.preventDefault(); setSearch(q.trim()); }}>
        <TextField label="Name or phone" value={q} onChange={(e) => setQ(e.target.value)} placeholder="Ama or +23324…" />
        <Select label="Verification" value={verificationStatus} onChange={(e) => setVs(e.target.value)}
          options={[{ value: '', label: 'Any' }, ...['not_submitted', 'pending', 'needs_attention', 'approved', 'rejected'].map((v) => ({ value: v, label: humanize(v) }))]} />
        <Select label="Account" value={accountStatus} onChange={(e) => setAs(e.target.value)}
          options={[{ value: '', label: 'Any' }, { value: 'active', label: 'Active' }, { value: 'suspended', label: 'Suspended' }]} />
        <Button type="submit">Search</Button>
      </form>
      <DataTable
        label="Students" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore}
        onRowClick={(r) => navigate(`/students/${r.id}`)}
        empty={{ title: 'No students match', body: 'Try part of the name, or the phone number with +233.' }}
        columns={[
          { header: 'Name', cell: (r) => r.fullName ?? <span className={ui.muted}>Not given</span> },
          { header: 'Phone', cell: (r) => maskPhone(r.phone) },
          { header: 'Verification', cell: (r) => <Chip tone={verificationTone[r.verificationStatus]}>{humanize(r.verificationStatus)}</Chip> },
          { header: 'Account', cell: (r) => <Chip tone={accountTone[r.accountStatus]}>{humanize(r.accountStatus)}</Chip> },
          { header: 'No-shows', align: 'right', cell: (r) => r.noShowCount ?? 0 },
          { header: 'Joined', cell: (r) => formatDate(r.createdAt) },
        ]}
      />
    </>
  );
}

export function StudentDetail() {
  const { id = '' } = useParams();
  const { me } = useSession();
  const toast = useToast();
  const q = useStudent(id);
  const [suspendOpen, setSuspendOpen] = useState(false);
  const [reason, setReason] = useState('');
  const [phoneOpen, setPhoneOpen] = useState(false);
  const [phone, setPhone] = useState({ newPhone: '+233', ticketId: '', note: '' });
  const [signOutOpen, setSignOutOpen] = useState(false);

  const setStatus = useSetStudentStatus(id);
  const changePhone = useChangeStudentPhone(id);
  const signOutAll = useSignOutStudent(id);

  if (q.isPending) return <Card><Skeleton /></Card>;
  if (q.error) return <ErrorState error={q.error} onRetry={() => void q.refetch()} />;
  const s = q.data;
  const suspended = s.accountStatus === 'suspended';

  return (
    <>
      <PageHeader title={s.fullName ?? 'Student'} description={`Joined ${formatDate(s.createdAt)}.`} actions={<>
        <Chip tone={verificationTone[s.verificationStatus]}>{humanize(s.verificationStatus)}</Chip>
        <Chip tone={accountTone[s.accountStatus]}>{humanize(s.accountStatus)}</Chip>
      </>} />
      <div className={ui.grid2}>
        <Card title="Details">
          <Details items={[
            ['Phone', formatPhone(s.phone)],
            ['Email', s.email ?? '—'],
            ['Student ID number', s.studentIdNumber ?? '—'],
            ['Completed rides', String(s.completedRides)],
          ]} />
        </Card>
        <Card title="Wallet">
          <Details items={[
            ['Balance', <Money pesewas={s.wallet.balancePesewas} />],
            ['Held for rides', <Money pesewas={s.wallet.reservedPesewas} />],
            ['Available', <Money pesewas={s.wallet.availablePesewas} />],
            ...(s.wallet.owedPesewas ? [['Owes after a reversal', <Money pesewas={s.wallet.owedPesewas} />] as [string, React.ReactNode]] : []),
          ]} />
          {canUse(me?.staffRole, 'finance') && <p className={ui.muted}>Adjust this wallet from Finance, Adjustments.</p>}
        </Card>
      </div>
      <Card title="Account actions">
        <div className={ui.actions}>
          <Button variant={suspended ? 'primary' : 'danger'} onClick={() => setSuspendOpen(true)}>{suspended ? 'Reactivate' : 'Suspend'}</Button>
          <Button onClick={() => setPhoneOpen(true)}>Change phone number</Button>
          {canUse(me?.staffRole, 'support') && <Button onClick={() => setSignOutOpen(true)}>Sign out everywhere</Button>}
        </div>
      </Card>

      <Dialog open={suspendOpen} onClose={() => setSuspendOpen(false)} title={suspended ? 'Reactivate this student' : 'Suspend this student'}>
        <p className={ui.muted} style={{ margin: 0 }}>{suspended ? 'They can sign in and book again.' : 'They cannot book rides until reactivated. Rides already under way continue.'}</p>
        <TextArea label="Reason" hint="Kept in the audit log." value={reason} onChange={(e) => setReason(e.target.value)} maxLength={300} />
        {setStatus.error ? <p role="alert" className={ui.muted}>{problemMessage(setStatus.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setSuspendOpen(false)}>Cancel</Button>
          <Button variant={suspended ? 'primary' : 'danger'} busy={setStatus.isPending} disabled={reason.trim().length < 3}
            onClick={() => setStatus.mutate({ accountStatus: suspended ? 'active' : 'suspended', reason }, {
              onSuccess: () => { setSuspendOpen(false); setReason(''); toast(suspended ? 'Student reactivated.' : 'Student suspended.'); },
            })}>{suspended ? 'Reactivate' : 'Suspend'}</Button>
        </DialogActions>
      </Dialog>

      <Dialog open={phoneOpen} onClose={() => setPhoneOpen(false)} title="Change phone number">
        <Banner tone="warning">This signs the student out on every device. Only do it after re-checking their Ghana Card through a support ticket.</Banner>
        <TextField label="New phone number" value={phone.newPhone} onChange={(e) => setPhone({ ...phone, newPhone: e.target.value.replace(/\s/g, '') })} hint="Format +233241234567" />
        <TextField label="Support ticket id" value={phone.ticketId} onChange={(e) => setPhone({ ...phone, ticketId: e.target.value.trim() })} />
        <TextArea label="Note" value={phone.note} onChange={(e) => setPhone({ ...phone, note: e.target.value })} maxLength={300} />
        {changePhone.error ? <p role="alert" className={ui.muted}>{problemMessage(changePhone.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setPhoneOpen(false)}>Cancel</Button>
          <Button variant="primary" busy={changePhone.isPending}
            disabled={!/^\+233\d{9}$/.test(phone.newPhone) || !phone.ticketId || phone.note.trim().length < 5}
            onClick={() => changePhone.mutate(phone, { onSuccess: () => { setPhoneOpen(false); toast('Phone number changed. The student must sign in again.'); } })}>
            Change number
          </Button>
        </DialogActions>
      </Dialog>

      <ConfirmDialog open={signOutOpen} onClose={() => setSignOutOpen(false)} title="Sign out everywhere"
        body="Every device signed in to this account is signed out. Use this for a lost or stolen phone."
        confirmLabel="Sign out everywhere" danger busy={signOutAll.isPending} error={signOutAll.error}
        onConfirm={() => signOutAll.mutate(undefined, { onSuccess: () => { setSignOutOpen(false); toast('Signed out on every device.'); } })} />
    </>
  );
}
