import { useMemo, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { api, call, newIdempotencyKey, type Schemas } from '../api/client';
import {
  Banner, Button, Chip, ConfirmDialog, DataTable, Dialog, DialogActions, Money, PageHeader, Select, TextArea, TextField,
  useToast, ui, type Tone,
} from '../components/ui';
import { formatDate, formatMinutes, formatTime, humanize, parseCedis } from '../lib/format';
import { problemMessage } from '../lib/problems';
import { useAction, useCursorList } from '../lib/queries';

/** Driver id -> name, for tables that only carry ids. */
function useDriverNames() {
  const q = useQuery({ queryKey: ['drivers-all'], queryFn: () => call(api.GET('/admin/drivers', { params: { query: { limit: 100 } } })) });
  const names = useMemo(() => new Map((q.data?.data ?? []).map((d) => [d.id, d.fullName])), [q.data]);
  return { drivers: q.data?.data ?? [], name: (id: string) => names.get(id) ?? 'Driver' };
}

const accraLocal = (date: string, time: string) => new Date(`${date}T${time}:00Z`).toISOString(); // Accra is UTC+0, no DST

const shiftTone: Record<Schemas['Shift']['status'], Tone> = { scheduled: 'neutral', in_progress: 'success', completed: 'neutral', missed: 'danger' };

export function ShiftsPage() {
  const toast = useToast();
  const { drivers, name } = useDriverNames();
  const [driverId, setDriverId] = useState('');
  const list = useCursorList(['shifts', driverId], (cursor) => call(api.GET('/admin/shifts', { params: { query: { driverId: driverId || undefined, cursor, limit: 50 } } })));
  const [open, setOpen] = useState(false);
  const [form, setForm] = useState({ driverId: '', date: '', start: '07:00', end: '15:00' });
  const [deleting, setDeleting] = useState<Schemas['Shift'] | null>(null);
  const create = useAction(() => call(api.POST('/admin/shifts', { body: { driverId: form.driverId, startsAt: accraLocal(form.date, form.start), endsAt: accraLocal(form.date, form.end) } })), [['shifts']]);
  const remove = useAction(() => call(api.DELETE('/admin/shifts/{id}', { params: { path: { id: deleting!.id } } })), [['shifts']]);
  const byDay = useMemo(() => {
    const m = new Map<string, Schemas['Shift'][]>();
    for (const s of [...(list.rows ?? [])].sort((a, b) => a.startsAt.localeCompare(b.startsAt))) {
      const k = s.startsAt.slice(0, 10);
      m.set(k, [...(m.get(k) ?? []), s]);
    }
    return m;
  }, [list.rows]);
  return (
    <>
      <PageHeader title="Shifts" description="Scheduled driver shifts. Going on duty inside a shift counts as attendance."
        actions={<Button variant="primary" onClick={() => setOpen(true)}>Schedule shift</Button>} />
      <div className={ui.filters}>
        <Select label="Driver" value={driverId} onChange={(e) => setDriverId(e.target.value)} options={[{ value: '', label: 'All drivers' }, ...drivers.map((d) => ({ value: d.id, label: d.fullName }))]} />
      </div>
      {list.rows && list.rows.length > 0 ? (
        <div className={ui.stack}>
          {[...byDay.entries()].map(([day, shifts]) => (
            <section key={day}>
              <h2 className={ui.cardTitle}>{formatDate(`${day}T12:00:00Z`)}</h2>
              <DataTable label={`Shifts on ${day}`} rows={shifts} rowKey={(r) => r.id} empty={{ title: 'None' }} columns={[
                { header: 'Driver', cell: (r) => name(r.driverId) },
                { header: 'Time', cell: (r) => `${formatTime(r.startsAt)} – ${formatTime(r.endsAt)}` },
                { header: 'Status', cell: (r) => <Chip tone={shiftTone[r.status]}>{humanize(r.status)}</Chip> },
                { header: '', cell: (r) => (r.status === 'scheduled' ? <Button small variant="ghost" onClick={() => setDeleting(r)}>Cancel shift</Button> : null) },
              ]} />
            </section>
          ))}
          {list.hasMore && <Button onClick={list.loadMore} busy={list.loadingMore}>Load more</Button>}
        </div>
      ) : (
        <DataTable label="Shifts" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
          empty={{ title: 'No shifts scheduled', action: <Button variant="primary" onClick={() => setOpen(true)}>Schedule shift</Button> }} columns={[]} />
      )}
      <Dialog open={open} onClose={() => setOpen(false)} title="Schedule a shift">
        <Select label="Driver" value={form.driverId} onChange={(e) => setForm({ ...form, driverId: e.target.value })} options={[{ value: '', label: 'Choose a driver' }, ...drivers.map((d) => ({ value: d.id, label: d.fullName }))]} />
        <TextField label="Date" type="date" value={form.date} onChange={(e) => setForm({ ...form, date: e.target.value })} />
        <div className={ui.grid2} style={{ gridTemplateColumns: '1fr 1fr' }}>
          <TextField label="Starts" type="time" value={form.start} onChange={(e) => setForm({ ...form, start: e.target.value })} />
          <TextField label="Ends" type="time" value={form.end} onChange={(e) => setForm({ ...form, end: e.target.value })} />
        </div>
        {create.error ? <p role="alert" className={ui.muted}>{problemMessage(create.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setOpen(false)}>Cancel</Button>
          <Button variant="primary" busy={create.isPending} disabled={!form.driverId || !form.date || form.end <= form.start}
            onClick={() => create.mutate(undefined, { onSuccess: () => { setOpen(false); toast('Shift scheduled.'); } })}>Schedule</Button>
        </DialogActions>
      </Dialog>
      <ConfirmDialog open={!!deleting} onClose={() => setDeleting(null)} title="Cancel this shift"
        body={deleting ? `${name(deleting.driverId)}, ${formatDate(deleting.startsAt)} ${formatTime(deleting.startsAt)} – ${formatTime(deleting.endsAt)}.` : ''}
        confirmLabel="Cancel shift" danger busy={remove.isPending} error={remove.error}
        onConfirm={() => remove.mutate(undefined, { onSuccess: () => { setDeleting(null); toast('Shift cancelled.'); } })} />
    </>
  );
}

const attTone: Record<Schemas['AttendanceRecord']['status'], Tone> = { present: 'success', late: 'warning', absent: 'danger', corrected: 'accent' };

export function AttendancePage() {
  const toast = useToast();
  const { drivers, name } = useDriverNames();
  const [driverId, setDriverId] = useState('');
  const list = useCursorList(['attendance', driverId], (cursor) => call(api.GET('/admin/attendance', { params: { query: { driverId: driverId || undefined, cursor, limit: 25 } } })));
  const [editing, setEditing] = useState<Schemas['AttendanceRecord'] | null>(null);
  const [form, setForm] = useState({ in: '', out: '', reasonCode: 'forgot_to_clock' as Schemas['AttendanceCorrection']['reasonCode'], note: '' });
  const correct = useAction(() => call(api.PATCH('/admin/attendance/{id}', { params: { path: { id: editing!.id } }, body: {
    ...(form.in ? { clockInAt: accraLocal(editing!.date, form.in) } : {}), ...(form.out ? { clockOutAt: accraLocal(editing!.date, form.out) } : {}),
    reasonCode: form.reasonCode, note: form.note,
  } })), [['attendance']]);
  const totals = useMemo(() => (list.rows ?? []).reduce((t, r) => t + r.minutesWorked, 0), [list.rows]);
  return (
    <>
      <PageHeader title="Attendance" description="Built from duty on and off inside each shift. Corrections need a reason; the original stays in the audit log." />
      <div className={ui.filters}>
        <Select label="Driver" value={driverId} onChange={(e) => setDriverId(e.target.value)} options={[{ value: '', label: 'All drivers' }, ...drivers.map((d) => ({ value: d.id, label: d.fullName }))]} />
        {list.rows && <span className={ui.muted}>Shown: {formatMinutes(totals)} worked</span>}
      </div>
      <DataTable label="Attendance" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore}
        onRowClick={(r) => { setEditing(r); setForm({ in: r.clockInAt ? formatTime(r.clockInAt) : '', out: r.clockOutAt ? formatTime(r.clockOutAt) : '', reasonCode: 'forgot_to_clock', note: '' }); }}
        empty={{ title: 'No attendance yet', body: 'Rows appear when drivers go on duty during a shift.' }}
        columns={[
          { header: 'Date', cell: (r) => formatDate(`${r.date}T12:00:00Z`) },
          { header: 'Driver', cell: (r) => name(r.driverId) },
          { header: 'In', cell: (r) => formatTime(r.clockInAt) },
          { header: 'Out', cell: (r) => formatTime(r.clockOutAt) },
          { header: 'Worked', align: 'right', cell: (r) => formatMinutes(r.minutesWorked) },
          { header: 'Status', cell: (r) => <Chip tone={attTone[r.status]}>{humanize(r.status)}</Chip> },
        ]} />
      <Dialog open={!!editing} onClose={() => setEditing(null)} title="Correct attendance">
        <div className={ui.grid2} style={{ gridTemplateColumns: '1fr 1fr' }}>
          <TextField label="Clock in" type="time" value={form.in} onChange={(e) => setForm({ ...form, in: e.target.value })} />
          <TextField label="Clock out" type="time" value={form.out} onChange={(e) => setForm({ ...form, out: e.target.value })} />
        </div>
        <Select label="Reason" value={form.reasonCode} onChange={(e) => setForm({ ...form, reasonCode: e.target.value as typeof form.reasonCode })}
          options={['forgot_to_clock', 'app_issue', 'approved_leave', 'other'].map((r) => ({ value: r, label: humanize(r) }))} />
        <TextArea label="Note" value={form.note} onChange={(e) => setForm({ ...form, note: e.target.value })} maxLength={300} />
        {correct.error ? <p role="alert" className={ui.muted}>{problemMessage(correct.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setEditing(null)}>Cancel</Button>
          <Button variant="primary" busy={correct.isPending} disabled={form.note.trim().length < 3}
            onClick={() => correct.mutate(undefined, { onSuccess: () => { setEditing(null); toast('Attendance corrected.'); } })}>Save correction</Button>
        </DialogActions>
      </Dialog>
    </>
  );
}

export function SalaryPaymentsPage() {
  const toast = useToast();
  const { drivers, name } = useDriverNames();
  const [driverId, setDriverId] = useState('');
  const list = useCursorList(['salary-payments', driverId], (cursor) => call(api.GET('/admin/salary-payments', { params: { query: { driverId: driverId || undefined, cursor, limit: 25 } } })));
  const [open, setOpen] = useState(false);
  const [key, setKey] = useState(newIdempotencyKey);
  const [form, setForm] = useState({ driverId: '', periodStart: '', periodEnd: '', amount: '', method: 'mobile_money' as Schemas['SalaryPaymentCreate']['method'], reference: '', paidAt: '' });
  const amount = parseCedis(form.amount);
  const record = useAction(() => call(api.POST('/admin/salary-payments', { params: { header: { 'Idempotency-Key': key } }, body: {
    driverId: form.driverId, periodStart: form.periodStart, periodEnd: form.periodEnd, amountPesewas: amount!, method: form.method,
    ...(form.reference ? { reference: form.reference } : {}), paidAt: new Date(`${form.paidAt}T12:00:00Z`).toISOString(),
  } })), [['salary-payments']]);
  return (
    <>
      <PageHeader title="Salary payments" description="A record of salaries paid outside the system. Recording one here does not send money."
        actions={<Button variant="primary" onClick={() => { setKey(newIdempotencyKey()); setOpen(true); }}>Record a payment</Button>} />
      <div className={ui.filters}>
        <Select label="Driver" value={driverId} onChange={(e) => setDriverId(e.target.value)} options={[{ value: '', label: 'All drivers' }, ...drivers.map((d) => ({ value: d.id, label: d.fullName }))]} />
      </div>
      <DataTable label="Salary payments" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore}
        empty={{ title: 'No payments recorded', body: 'Record each salary after it has been paid.' }}
        columns={[
          { header: 'Driver', cell: (r) => name(r.driverId) },
          { header: 'Period', cell: (r) => `${formatDate(`${r.periodStart}T12:00:00Z`)} – ${formatDate(`${r.periodEnd}T12:00:00Z`)}` },
          { header: 'Amount', align: 'right', cell: (r) => <Money pesewas={r.amountPesewas} /> },
          { header: 'Method', cell: (r) => humanize(r.method) },
          { header: 'Reference', cell: (r) => <span className={ui.num}>{r.reference ?? '—'}</span> },
          { header: 'Paid', cell: (r) => formatDate(r.paidAt) },
        ]} />
      <Dialog open={open} onClose={() => setOpen(false)} title="Record a salary payment">
        <Banner tone="warning">This only records a payment already made. It does not send any money.</Banner>
        <Select label="Driver" value={form.driverId} onChange={(e) => setForm({ ...form, driverId: e.target.value })} options={[{ value: '', label: 'Choose a driver' }, ...drivers.map((d) => ({ value: d.id, label: d.fullName }))]} />
        <div className={ui.grid2} style={{ gridTemplateColumns: '1fr 1fr' }}>
          <TextField label="Period start" type="date" value={form.periodStart} onChange={(e) => setForm({ ...form, periodStart: e.target.value })} />
          <TextField label="Period end" type="date" value={form.periodEnd} onChange={(e) => setForm({ ...form, periodEnd: e.target.value })} />
          <TextField label="Amount (GH₵)" inputMode="decimal" value={form.amount} onChange={(e) => setForm({ ...form, amount: e.target.value })} />
          <TextField label="Paid on" type="date" value={form.paidAt} onChange={(e) => setForm({ ...form, paidAt: e.target.value })} />
        </div>
        <Select label="Method" value={form.method} onChange={(e) => setForm({ ...form, method: e.target.value as typeof form.method })} options={['mobile_money', 'bank_transfer', 'cash'].map((m) => ({ value: m, label: humanize(m) }))} />
        <TextField label="Reference (optional)" value={form.reference} onChange={(e) => setForm({ ...form, reference: e.target.value })} maxLength={80} />
        {record.error ? <p role="alert" className={ui.muted}>{problemMessage(record.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setOpen(false)}>Cancel</Button>
          <Button variant="primary" busy={record.isPending}
            disabled={!form.driverId || !form.periodStart || !form.periodEnd || form.periodEnd < form.periodStart || !amount || amount <= 0 || !form.paidAt}
            onClick={() => record.mutate(undefined, { onSuccess: () => { setOpen(false); toast('Payment recorded.'); } })}>Record payment</Button>
        </DialogActions>
      </Dialog>
    </>
  );
}
