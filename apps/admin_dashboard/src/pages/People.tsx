import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { useNavigate, useParams } from 'react-router';
import { api, call, type Schemas, uploadFile } from '../api/client';
import { canUse } from '../auth/roles';
import { useSession } from '../auth/session';
import {
  Banner, Button, Card, Chip, ConfirmDialog, DataTable, Details, Dialog, DialogActions, ErrorState, Money,
  PageHeader, Select, Skeleton, TextArea, TextField, useToast, ui, When, type Tone,
} from '../components/ui';
import { formatDate, formatPhone, humanize, maskPhone } from '../lib/format';
import { problemMessage } from '../lib/problems';
import { useAction, useCursorList } from '../lib/queries';
import { verificationTone } from './Verification';

const accountTone: Record<Schemas['AccountStatus'], Tone> = { active: 'success', suspended: 'danger' };

export function StudentsPage() {
  const navigate = useNavigate();
  const [q, setQ] = useState('');
  const [search, setSearch] = useState('');
  const [verificationStatus, setVs] = useState('');
  const [accountStatus, setAs] = useState('');
  const list = useCursorList(['students', search, verificationStatus, accountStatus], (cursor) =>
    call(api.GET('/admin/students', { params: { query: {
      q: search || undefined,
      verificationStatus: (verificationStatus || undefined) as Schemas['VerificationStatus'] | undefined,
      accountStatus: (accountStatus || undefined) as Schemas['AccountStatus'] | undefined,
      cursor, limit: 25,
    } } })));
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

export function StudentDetailPage() {
  const { id = '' } = useParams();
  const { me } = useSession();
  const toast = useToast();
  const q = useQuery({ queryKey: ['student', id], queryFn: () => call(api.GET('/admin/students/{id}', { params: { path: { id } } })) });
  const [suspendOpen, setSuspendOpen] = useState(false);
  const [reason, setReason] = useState('');
  const [phoneOpen, setPhoneOpen] = useState(false);
  const [phone, setPhone] = useState({ newPhone: '+233', ticketId: '', note: '' });
  const [signOutOpen, setSignOutOpen] = useState(false);

  const setStatus = useAction((body: Schemas['AccountStatusUpdate']) =>
    call(api.PATCH('/admin/students/{id}', { params: { path: { id } }, body })), [['student', id], ['students']]);
  const changePhone = useAction(() => call(api.PUT('/admin/students/{id}/phone', { params: { path: { id } }, body: phone })), [['student', id]]);
  const signOutAll = useAction(() => call(api.DELETE('/admin/students/{id}/sessions', { params: { path: { id } } })));

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
            onClick={() => changePhone.mutate(undefined, { onSuccess: () => { setPhoneOpen(false); toast('Phone number changed. The student must sign in again.'); } })}>
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

const docTypes: Schemas['DriverDocumentCreate']['type'][] = ['drivers_licence', 'insurance', 'roadworthy', 'vehicle_registration', 'ghana_card', 'other'];

export function DriversPage() {
  const navigate = useNavigate();
  const toast = useToast();
  const [status, setStatus] = useState('');
  const [duty, setDuty] = useState('');
  const list = useCursorList(['drivers', status, duty], (cursor) => call(api.GET('/admin/drivers', { params: { query: {
    status: (status || undefined) as Schemas['AccountStatus'] | undefined,
    dutyStatus: (duty || undefined) as 'on_duty' | 'off_duty' | undefined, cursor, limit: 25,
  } } })));
  const expiring = useQuery({ queryKey: ['expiring-docs'], queryFn: () => call(api.GET('/admin/driver-documents/expiring', { params: { query: { withinDays: 30 } } })) });
  const vehicles = useQuery({ queryKey: ['vehicles-all'], queryFn: () => call(api.GET('/admin/vehicles', { params: { query: { limit: 100 } } })) });
  const [createOpen, setCreateOpen] = useState(false);
  const [form, setForm] = useState({ fullName: '', phone: '+233', email: '', vehicleId: '' });
  const create = useAction(() => call(api.POST('/admin/drivers', { body: {
    fullName: form.fullName, phone: form.phone, ...(form.email ? { email: form.email } : {}), vehicleId: form.vehicleId || null,
  } })), [['drivers']]);

  return (
    <>
      <PageHeader title="Drivers" description="Salaried drivers. Creating one sends them an SMS invitation to the driver app."
        actions={<Button variant="primary" onClick={() => setCreateOpen(true)}>Add driver</Button>} />
      <Card title="Documents expiring in the next 30 days">
        {expiring.isPending ? <Skeleton /> : expiring.error ? <ErrorState error={expiring.error} onRetry={() => void expiring.refetch()} />
          : expiring.data.items.length === 0 ? <p className={ui.muted} style={{ margin: 0 }}>No documents expire in the next 30 days.</p> : (
            <div className={ui.stack} style={{ gap: 8 }}>
              {expiring.data.items.map((d) => (
                <div key={`${d.driverId}-${d.documentType}`} className={ui.row}>
                  <Chip tone={d.daysLeft < 0 ? 'danger' : d.daysLeft <= 7 ? 'warning' : 'neutral'}>
                    {d.daysLeft < 0 ? `Expired ${-d.daysLeft} days ago` : `${d.daysLeft} days left`}
                  </Chip>
                  <button type="button" className={ui.muted} style={{ background: 'none', border: 'none', cursor: 'pointer', font: 'inherit', padding: 0 }}
                    onClick={() => navigate(`/drivers/${d.driverId}`)}>
                    <strong style={{ color: 'var(--color-text-primary)' }}>{d.driverName}</strong> · {humanize(d.documentType)} · {formatDate(d.expiresOn)}
                  </button>
                </div>
              ))}
              {expiring.data.items.some((d) => d.daysLeft < 0) && (
                <p className={ui.muted} style={{ margin: 0 }}>A driver with an expired licence, insurance or roadworthy certificate cannot go on duty.</p>
              )}
            </div>
          )}
      </Card>
      <div className={ui.filters}>
        <Select label="Account" value={status} onChange={(e) => setStatus(e.target.value)} options={[{ value: '', label: 'Any' }, { value: 'active', label: 'Active' }, { value: 'suspended', label: 'Suspended' }]} />
        <Select label="Duty" value={duty} onChange={(e) => setDuty(e.target.value)} options={[{ value: '', label: 'Any' }, { value: 'on_duty', label: 'On duty' }, { value: 'off_duty', label: 'Off duty' }]} />
      </div>
      <DataTable label="Drivers" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore} onRowClick={(r) => navigate(`/drivers/${r.id}`)}
        empty={{ title: 'No drivers yet', body: 'Add the first driver to send their invitation.', action: <Button variant="primary" onClick={() => setCreateOpen(true)}>Add driver</Button> }}
        columns={[
          { header: 'Name', cell: (r) => r.fullName },
          { header: 'Phone', cell: (r) => maskPhone(r.phone) },
          { header: 'Duty', cell: (r) => <Chip tone={r.dutyStatus === 'on_duty' ? 'success' : 'neutral'}>{humanize(r.dutyStatus)}</Chip> },
          { header: 'Account', cell: (r) => <Chip tone={accountTone[r.status]}>{humanize(r.status)}</Chip> },
          { header: 'Vehicle', cell: (r) => (r.vehicle ? `${r.vehicle.plateNumber} · ${r.vehicle.make} ${r.vehicle.model}` : <span className={ui.muted}>None</span>) },
          { header: 'On a ride', cell: (r) => (r.currentRideId ? <Chip tone="accent">Yes</Chip> : <span className={ui.muted}>No</span>) },
        ]} />
      <Dialog open={createOpen} onClose={() => setCreateOpen(false)} title="Add a driver">
        <TextField label="Full name" value={form.fullName} onChange={(e) => setForm({ ...form, fullName: e.target.value })} />
        <TextField label="Phone number" value={form.phone} onChange={(e) => setForm({ ...form, phone: e.target.value.replace(/\s/g, '') })} hint="Format +233241234567. The invitation goes here by SMS." />
        <TextField label="Email (optional)" type="email" value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} />
        <Select label="Vehicle" value={form.vehicleId} onChange={(e) => setForm({ ...form, vehicleId: e.target.value })}
          options={[{ value: '', label: 'Assign later' }, ...(vehicles.data?.data ?? []).filter((v) => v.status === 'active').map((v) => ({ value: v.id, label: `${v.plateNumber} · ${v.make} ${v.model}` }))]} />
        {create.error ? <p role="alert" className={ui.muted}>{problemMessage(create.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setCreateOpen(false)}>Cancel</Button>
          <Button variant="primary" busy={create.isPending} disabled={form.fullName.trim().length < 2 || !/^\+233\d{9}$/.test(form.phone)}
            onClick={() => create.mutate(undefined, { onSuccess: () => { setCreateOpen(false); setForm({ fullName: '', phone: '+233', email: '', vehicleId: '' }); toast('Driver added. Their invitation is on its way by SMS.'); } })}>
            Add and invite
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
}

export function DriverDetailPage() {
  const { id = '' } = useParams();
  const toast = useToast();
  const q = useQuery({ queryKey: ['driver', id], queryFn: () => call(api.GET('/admin/drivers/{id}', { params: { path: { id } } })) });
  const vehicles = useQuery({ queryKey: ['vehicles-all'], queryFn: () => call(api.GET('/admin/vehicles', { params: { query: { limit: 100 } } })) });
  const salary = useQuery({ queryKey: ['salary-profile', id], retry: false, queryFn: () => call(api.GET('/admin/drivers/{id}/salary-profile', { params: { path: { id } } })) });
  const update = useAction((body: Schemas['DriverUpdate']) => call(api.PATCH('/admin/drivers/{id}', { params: { path: { id } }, body })), [['driver', id], ['drivers']]);
  const [docOpen, setDocOpen] = useState(false);
  const [doc, setDoc] = useState<{ type: Schemas['DriverDocumentCreate']['type']; expiresOn: string; file: File | null }>({ type: 'drivers_licence', expiresOn: '', file: null });
  const [salaryOpen, setSalaryOpen] = useState(false);
  const [salaryForm, setSalaryForm] = useState({ cedis: '', payPeriod: 'monthly' as Schemas['SalaryProfileWrite']['payPeriod'] });
  const [suspendOpen, setSuspendOpen] = useState(false);

  const addDoc = useAction(async () => {
    if (!doc.file) throw new Error('No file');
    const uploadId = await uploadFile('driver_document', doc.file);
    return call(api.POST('/admin/drivers/{id}/documents', { params: { path: { id } }, body: { type: doc.type, uploadId, ...(doc.expiresOn ? { expiresOn: doc.expiresOn } : {}) } }));
  }, [['driver', id], ['expiring-docs']]);
  const saveSalary = useAction(() => {
    const cedis = Number(salaryForm.cedis);
    return call(api.PUT('/admin/drivers/{id}/salary-profile', { params: { path: { id } }, body: { monthlySalaryPesewas: Math.round(cedis) * 100, payPeriod: salaryForm.payPeriod } }));
  }, [['salary-profile', id]]);

  if (q.isPending) return <Card><Skeleton /></Card>;
  if (q.error) return <ErrorState error={q.error} onRetry={() => void q.refetch()} />;
  const d = q.data;
  const suspended = d.status === 'suspended';
  return (
    <>
      <PageHeader title={d.fullName} description={`Added ${formatDate(d.createdAt)}.`} actions={<>
        <Chip tone={d.dutyStatus === 'on_duty' ? 'success' : 'neutral'}>{humanize(d.dutyStatus)}</Chip>
        <Chip tone={accountTone[d.status]}>{humanize(d.status)}</Chip>
      </>} />
      <div className={ui.grid2}>
        <Card title="Details">
          <Details items={[
            ['Phone', formatPhone(d.phone)],
            ['Email', d.email ?? '—'],
            ['Last seen', <When iso={d.lastLocation?.recordedAt} />],
            ['Current ride', d.currentRideId ? <a href={`/rides/${d.currentRideId}`}>Open ride</a> : 'None'],
          ]} />
          <div className={ui.actions} style={{ marginTop: 16 }}>
            <Button variant={suspended ? 'primary' : 'danger'} onClick={() => setSuspendOpen(true)}>{suspended ? 'Reactivate' : 'Deactivate'}</Button>
          </div>
        </Card>
        <Card title="Vehicle">
          <Select label="Assigned vehicle" value={d.vehicle?.id ?? ''} disabled={update.isPending}
            onChange={(e) => update.mutate({ vehicleId: e.target.value || null }, { onSuccess: () => toast('Vehicle updated.') })}
            options={[{ value: '', label: 'None' }, ...(vehicles.data?.data ?? []).filter((v) => v.status === 'active' || v.id === d.vehicle?.id)
              .map((v) => ({ value: v.id, label: `${v.plateNumber} · ${v.make} ${v.model} (${v.colour})` }))]} />
          {update.error ? <p role="alert" className={ui.muted}>{problemMessage(update.error)}</p> : null}
        </Card>
        <Card title="Documents" actions={<Button small onClick={() => setDocOpen(true)}>Add document</Button>}>
          {d.documents?.length ? (
            <div className={ui.stack} style={{ gap: 8 }}>
              {d.documents.map((x) => {
                const expired = x.expiresOn ? new Date(x.expiresOn) < new Date() : false;
                return (
                  <div key={x.id} className={ui.row}>
                    <strong>{humanize(x.type)}</strong>
                    <span className={ui.muted}>{x.expiresOn ? `expires ${formatDate(x.expiresOn)}` : 'no expiry'}</span>
                    {expired && <Chip tone="danger">Expired</Chip>}
                  </div>
                );
              })}
            </div>
          ) : <p className={ui.muted} style={{ margin: 0 }}>No documents yet. Add the licence, insurance and roadworthy certificate.</p>}
        </Card>
        <Card title="Salary" actions={<Button small onClick={() => { setSalaryForm({ cedis: salary.data ? String(salary.data.monthlySalaryPesewas / 100) : '', payPeriod: salary.data?.payPeriod ?? 'monthly' }); setSalaryOpen(true); }}>Edit</Button>}>
          {salary.isPending ? <Skeleton /> : salary.data ? (
            <Details items={[['Monthly salary', <Money pesewas={salary.data.monthlySalaryPesewas} />], ['Pay period', humanize(salary.data.payPeriod)], ['Updated', <When iso={salary.data.updatedAt} />]]} />
          ) : <p className={ui.muted} style={{ margin: 0 }}>No salary set yet.</p>}
        </Card>
      </div>

      <ConfirmDialog open={suspendOpen} onClose={() => setSuspendOpen(false)} title={suspended ? 'Reactivate driver' : 'Deactivate driver'}
        body={suspended ? 'They can go on duty again.' : 'They cannot go on duty or receive rides. Their history stays.'}
        confirmLabel={suspended ? 'Reactivate' : 'Deactivate'} danger={!suspended} busy={update.isPending} error={update.error}
        onConfirm={() => update.mutate({ status: suspended ? 'active' : 'suspended' }, { onSuccess: () => { setSuspendOpen(false); toast(suspended ? 'Driver reactivated.' : 'Driver deactivated.'); } })} />

      <Dialog open={docOpen} onClose={() => setDocOpen(false)} title="Add a document">
        <Select label="Type" value={doc.type} onChange={(e) => setDoc({ ...doc, type: e.target.value as typeof doc.type })} options={docTypes.map((t) => ({ value: t, label: humanize(t) }))} />
        <TextField label="Expires on" type="date" value={doc.expiresOn} onChange={(e) => setDoc({ ...doc, expiresOn: e.target.value })} hint="Required for licence, insurance and roadworthy." />
        <TextField label="File" type="file" accept="image/jpeg,image/png,application/pdf" onChange={(e) => setDoc({ ...doc, file: e.target.files?.[0] ?? null })} hint="JPEG, PNG or PDF, up to 10 MB." />
        {addDoc.error ? <p role="alert" className={ui.muted}>{problemMessage(addDoc.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setDocOpen(false)}>Cancel</Button>
          <Button variant="primary" busy={addDoc.isPending} disabled={!doc.file || (['drivers_licence', 'insurance', 'roadworthy'].includes(doc.type) && !doc.expiresOn)}
            onClick={() => addDoc.mutate(undefined, { onSuccess: () => { setDocOpen(false); toast('Document added.'); } })}>Add document</Button>
        </DialogActions>
      </Dialog>

      <Dialog open={salaryOpen} onClose={() => setSalaryOpen(false)} title="Salary">
        <TextField label="Monthly salary (GH₵, whole cedis)" inputMode="numeric" value={salaryForm.cedis} onChange={(e) => setSalaryForm({ ...salaryForm, cedis: e.target.value.replace(/\D/g, '') })} />
        <Select label="Pay period" value={salaryForm.payPeriod} onChange={(e) => setSalaryForm({ ...salaryForm, payPeriod: e.target.value as typeof salaryForm.payPeriod })}
          options={['weekly', 'biweekly', 'monthly'].map((p) => ({ value: p, label: humanize(p) }))} />
        {saveSalary.error ? <p role="alert" className={ui.muted}>{problemMessage(saveSalary.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setSalaryOpen(false)}>Cancel</Button>
          <Button variant="primary" busy={saveSalary.isPending} disabled={!salaryForm.cedis}
            onClick={() => saveSalary.mutate(undefined, { onSuccess: () => { setSalaryOpen(false); toast('Salary saved.'); } })}>Save</Button>
        </DialogActions>
      </Dialog>
    </>
  );
}

const vehicleTone: Record<Schemas['Vehicle']['status'], Tone> = { active: 'success', maintenance: 'warning', retired: 'neutral' };
const emptyVehicle: Schemas['VehicleWrite'] = { make: '', model: '', colour: '', plateNumber: '', seats: 4, status: 'active' };

export function VehiclesPage() {
  const toast = useToast();
  const list = useCursorList(['vehicles'], (cursor) => call(api.GET('/admin/vehicles', { params: { query: { cursor, limit: 25 } } })));
  const [editing, setEditing] = useState<{ id: string | null; form: Schemas['VehicleWrite'] } | null>(null);
  const save = useAction(() => {
    if (!editing) throw new Error('nothing to save');
    return editing.id
      ? call(api.PATCH('/admin/vehicles/{id}', { params: { path: { id: editing.id } }, body: editing.form }))
      : call(api.POST('/admin/vehicles', { body: editing.form }));
  }, [['vehicles'], ['vehicles-all']]);
  const f = editing?.form;
  const set = (patch: Partial<Schemas['VehicleWrite']>) => editing && setEditing({ ...editing, form: { ...editing.form, ...patch } });
  return (
    <>
      <PageHeader title="Vehicles" description="Each vehicle is driven by one driver at a time. Assign them on the driver’s page."
        actions={<Button variant="primary" onClick={() => setEditing({ id: null, form: emptyVehicle })}>Add vehicle</Button>} />
      <DataTable label="Vehicles" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore}
        onRowClick={(r) => setEditing({ id: r.id, form: { make: r.make, model: r.model, colour: r.colour, plateNumber: r.plateNumber, seats: r.seats ?? 4, status: r.status } })}
        empty={{ title: 'No vehicles yet', action: <Button variant="primary" onClick={() => setEditing({ id: null, form: emptyVehicle })}>Add vehicle</Button> }}
        columns={[
          { header: 'Plate', cell: (r) => <span className={ui.num}>{r.plateNumber}</span> },
          { header: 'Vehicle', cell: (r) => `${r.make} ${r.model}` },
          { header: 'Colour', cell: (r) => r.colour },
          { header: 'Seats', align: 'right', cell: (r) => r.seats ?? '—' },
          { header: 'Status', cell: (r) => <Chip tone={vehicleTone[r.status]}>{humanize(r.status)}</Chip> },
        ]} />
      <Dialog open={!!editing} onClose={() => setEditing(null)} title={editing?.id ? 'Edit vehicle' : 'Add vehicle'}>
        {f && <>
          <TextField label="Plate number" value={f.plateNumber} onChange={(e) => set({ plateNumber: e.target.value.toUpperCase() })} />
          <div className={ui.grid2} style={{ gridTemplateColumns: '1fr 1fr' }}>
            <TextField label="Make" value={f.make} onChange={(e) => set({ make: e.target.value })} />
            <TextField label="Model" value={f.model} onChange={(e) => set({ model: e.target.value })} />
            <TextField label="Colour" value={f.colour} onChange={(e) => set({ colour: e.target.value })} />
            <TextField label="Seats" type="number" min={1} max={8} value={f.seats ?? 4} onChange={(e) => set({ seats: Number(e.target.value) })} />
          </div>
          <Select label="Status" value={f.status ?? 'active'} onChange={(e) => set({ status: e.target.value as Schemas['Vehicle']['status'] })}
            options={['active', 'maintenance', 'retired'].map((s) => ({ value: s, label: humanize(s) }))} />
        </>}
        {save.error ? <p role="alert" className={ui.muted}>{problemMessage(save.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setEditing(null)}>Cancel</Button>
          <Button variant="primary" busy={save.isPending} disabled={!f?.plateNumber || !f.make || !f.model || !f.colour}
            onClick={() => save.mutate(undefined, { onSuccess: () => { setEditing(null); toast('Vehicle saved.'); } })}>Save</Button>
        </DialogActions>
      </Dialog>
    </>
  );
}

