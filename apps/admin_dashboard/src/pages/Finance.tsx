import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { useSearchParams } from 'react-router';
import { api, call, newIdempotencyKey, uploadFile, type Schemas } from '../api/client';
import { useSession } from '../auth/session';
import { canUse } from '../auth/roles';
import {
  Button, Card, Chip, DataTable, Details, Dialog, DialogActions, Money, PageHeader, Select, Skeleton, Tabs,
  TextArea, TextField, useToast, ui, When, type Tone,
} from '../components/ui';
import { formatDate, formatPesewas, humanize, parseCedis, shortId } from '../lib/format';
import { ApiError, problemMessage } from '../lib/problems';
import { useAction, useCursorList } from '../lib/queries';

type Topup = Schemas['Topup'];
const topupTone: Record<Topup['status'], Tone> = { pending: 'warning', succeeded: 'success', failed: 'danger', abandoned: 'neutral' };
const validationTone = { exact: 'success', underpayment: 'danger', overpayment: 'warning' } as const;

export function TopupsPage() {
  const toast = useToast();
  const [flaggedOnly, setFlagged] = useState(true);
  const [status, setStatus] = useState('');
  const list = useCursorList(['topups', flaggedOnly, status], (cursor) => call(api.GET('/admin/topups', { params: { query: {
    flagged: flaggedOnly || undefined, status: (status || undefined) as Topup['status'] | undefined, cursor, limit: 25,
  } } })));
  const [resolving, setResolving] = useState<Topup | null>(null);
  const [resolution, setResolution] = useState<Schemas['TopupResolve']['resolution']>('accept_received_amount');
  const [note, setNote] = useState('');
  const resolve = useAction(() => call(api.POST('/admin/topups/{id}/resolve', { params: { path: { id: resolving!.id } }, body: { resolution, note } })), [['topups'], ['ov']]);

  return (
    <>
      <PageHeader title="Top-ups" description="Mobile money top-ups from Payaza. Flagged ones need a finance decision. Any change to a wallet goes through Adjustments, not here." />
      <div className={ui.filters}>
        <Select label="Show" value={flaggedOnly ? 'flagged' : 'all'} onChange={(e) => setFlagged(e.target.value === 'flagged')}
          options={[{ value: 'flagged', label: 'Flagged only' }, { value: 'all', label: 'All top-ups' }]} />
        <Select label="Status" value={status} onChange={(e) => setStatus(e.target.value)}
          options={[{ value: '', label: 'Any' }, ...['pending', 'succeeded', 'failed', 'abandoned'].map((s) => ({ value: s, label: humanize(s) }))]} />
      </div>
      <DataTable label="Top-ups" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore}
        onRowClick={(r) => (r.flagged && !r.resolvedAt ? (setResolving(r), setNote('')) : undefined)}
        empty={{ title: flaggedOnly ? 'No flagged top-ups' : 'No top-ups yet', body: flaggedOnly ? 'Every top-up matched what the provider received.' : undefined }}
        columns={[
          { header: 'When', cell: (r) => <When iso={r.createdAt} exact /> },
          { header: 'Reference', cell: (r) => <span className={ui.num}>{r.reference}</span> },
          { header: 'Status', cell: (r) => <Chip tone={topupTone[r.status]}>{humanize(r.status)}</Chip> },
          { header: 'Requested', align: 'right', cell: (r) => <Money pesewas={r.amountPesewas} /> },
          { header: 'Received', align: 'right', cell: (r) => <Money pesewas={r.amountReceivedPesewas} /> },
          { header: 'Check', cell: (r) => (r.validation ? <Chip tone={validationTone[r.validation]}>{humanize(r.validation)}</Chip> : '—') },
          { header: 'Flag', cell: (r) => (r.resolvedAt ? <Chip tone="success">Resolved</Chip> : r.flagged ? <span><Chip tone="danger">Flagged</Chip> <span className={ui.muted}>{r.flagReason}</span></span> : '—') },
        ]} />
      <Dialog open={!!resolving} onClose={() => setResolving(null)} title="Close a flagged top-up">
        {resolving && <Details items={[
          ['Reference', resolving.reference], ['Requested', formatPesewas(resolving.amountPesewas)],
          ['Received', resolving.amountReceivedPesewas == null ? '—' : formatPesewas(resolving.amountReceivedPesewas)], ['Why flagged', resolving.flagReason ?? '—'],
        ]} />}
        <Select label="Resolution" value={resolution} onChange={(e) => setResolution(e.target.value as typeof resolution)} options={[
          { value: 'accept_received_amount', label: 'Accept the amount received (already credited)' },
          { value: 'refund_outside_system', label: 'Refunded to the student outside the system' },
          { value: 'no_action', label: 'No action needed' },
        ]} />
        <TextArea label="Note" hint="At least 5 characters." value={note} onChange={(e) => setNote(e.target.value)} maxLength={300} />
        <p className={ui.muted} style={{ margin: 0 }}>Closing does not move money. If the wallet needs correcting, make an adjustment too.</p>
        {resolve.error ? <p role="alert" className={ui.muted}>{problemMessage(resolve.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setResolving(null)}>Cancel</Button>
          <Button variant="primary" busy={resolve.isPending} disabled={note.trim().length < 5}
            onClick={() => resolve.mutate(undefined, { onSuccess: () => { setResolving(null); toast('Top-up closed.'); } })}>Close top-up</Button>
        </DialogActions>
      </Dialog>
    </>
  );
}

const adjustmentReasons: Schemas['WalletAdjustment']['reasonCode'][] = ['goodwill', 'duplicate_charge', 'provider_reconciliation', 'correction', 'other'];
const adjTone: Record<Schemas['AdjustmentRequest']['status'], Tone> = { pending: 'warning', approved: 'success', rejected: 'neutral' };

export function AdjustmentsPage() {
  const [params, setParams] = useSearchParams();
  const tab = (params.get('tab') ?? 'wallet') as 'wallet' | 'approvals';
  return (
    <>
      <PageHeader title="Adjustments" description="Credit or debit a student wallet with a reason. Large adjustments need a second finance user to approve." />
      <Tabs value={tab} onChange={(v) => setParams({ tab: v }, { replace: true })} tabs={[{ value: 'wallet', label: 'Student wallet' }, { value: 'approvals', label: 'Approvals' }]} />
      {tab === 'wallet' ? <WalletTab /> : <ApprovalsTab />}
    </>
  );
}

function WalletTab() {
  const toast = useToast();
  const [input, setInput] = useState('');
  const [studentId, setStudentId] = useState('');
  const { me } = useSession();
  // Settings are super_admin only (x-roles); finance users never see the limit, so the hint omits it.
  const settings = useQuery({ queryKey: ['settings'], queryFn: () => call(api.GET('/admin/settings')), enabled: canUse(me?.staffRole, 'configuration') });
  const threshold = settings.data?.adjustmentApprovalThresholdPesewas;
  const wallet = useQuery({ queryKey: ['wallet', studentId], enabled: !!studentId, queryFn: () => call(api.GET('/admin/students/{id}/wallet', { params: { path: { id: studentId } } })) });
  const tx = useCursorList(['wallet-tx', studentId], (cursor) => call(api.GET('/admin/students/{id}/wallet/transactions', { params: { path: { id: studentId }, query: { cursor, limit: 25 } } })), !!studentId);
  const [open, setOpen] = useState(false);
  const [form, setForm] = useState({ direction: 'credit', amount: '', reasonCode: 'goodwill' as Schemas['WalletAdjustment']['reasonCode'], note: '' });
  const [key, setKey] = useState(newIdempotencyKey);
  const parsed = parseCedis(form.amount);
  const pesewas = parsed !== null && parsed > 0 ? parsed : 0;
  const signed = form.direction === 'credit' ? pesewas : -pesewas;
  const adjust = useAction(async () => {
    const { data, error, response } = await api.POST('/admin/students/{id}/wallet/adjustments', {
      params: { path: { id: studentId }, header: { 'Idempotency-Key': key } },
      body: { amountPesewas: signed, reasonCode: form.reasonCode, note: form.note },
    });
    if (!response.ok) throw new ApiError(response.status, (error as Schemas['Problem']) ?? null);
    return { pending: response.status === 202, data };
  }, [['wallet', studentId], ['wallet-tx', studentId], ['adjustments']]);

  return (
    <div className={ui.stack}>
      <form className={ui.filters} onSubmit={(e) => { e.preventDefault(); setStudentId(input.trim()); }}>
        <TextField label="Student id" value={input} onChange={(e) => setInput(e.target.value)} placeholder="Paste from a ride, top-up or ticket"
          hint="Finance cannot search students by name yet (CONTRACT_REQUESTS A4)." />
        <Button type="submit" disabled={!input.trim()}>Open wallet</Button>
      </form>
      {studentId && (
        <>
          <Card title="Wallet" actions={<Button variant="primary" onClick={() => { setKey(newIdempotencyKey()); setForm({ direction: 'credit', amount: '', reasonCode: 'goodwill', note: '' }); setOpen(true); }}>New adjustment</Button>}>
            {wallet.isPending ? <Skeleton /> : wallet.error ? <p className={ui.muted}>{problemMessage(wallet.error)}</p> : (
              <Details items={[
                ['Balance', <Money pesewas={wallet.data.balancePesewas} />], ['Held for rides', <Money pesewas={wallet.data.reservedPesewas} />],
                ['Available', <Money pesewas={wallet.data.availablePesewas} />],
              ]} />
            )}
          </Card>
          <DataTable label="Wallet history" rows={tx.rows} rowKey={(r) => r.id} loading={tx.loading} error={tx.error} onRetry={tx.refetch}
            hasMore={tx.hasMore} onLoadMore={tx.loadMore} loadingMore={tx.loadingMore} empty={{ title: 'No wallet activity yet' }}
            columns={[
              { header: 'When', cell: (r) => <When iso={r.createdAt} exact /> },
              { header: 'Type', cell: (r) => humanize(r.type) },
              { header: 'Description', cell: (r) => r.description },
              { header: 'Amount', align: 'right', cell: (r) => <span className={r.affectsBalance ? undefined : ui.muted}>{formatPesewas(r.amountPesewas)}</span> },
              { header: 'Balance after', align: 'right', cell: (r) => <Money pesewas={r.balanceAfterPesewas} /> },
            ]} />
        </>
      )}
      <Dialog open={open} onClose={() => setOpen(false)} title="New adjustment">
        <Select label="Direction" value={form.direction} onChange={(e) => setForm({ ...form, direction: e.target.value })}
          options={[{ value: 'credit', label: 'Credit (add money)' }, { value: 'debit', label: 'Debit (take money)' }]} />
        <TextField label="Amount (GH₵)" inputMode="decimal" value={form.amount} onChange={(e) => setForm({ ...form, amount: e.target.value })}
          hint={threshold != null
            ? `Up to ${formatPesewas(threshold)} applies at once; above that another finance user must approve.`
            : 'Small amounts apply at once; above the approval limit another finance user must approve.'} />
        <Select label="Reason" value={form.reasonCode} onChange={(e) => setForm({ ...form, reasonCode: e.target.value as typeof form.reasonCode })}
          options={adjustmentReasons.map((r) => ({ value: r, label: humanize(r) }))} />
        <TextArea label="Note" value={form.note} onChange={(e) => setForm({ ...form, note: e.target.value })} maxLength={300} />
        {adjust.error ? <p role="alert" className={ui.muted}>{problemMessage(adjust.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setOpen(false)}>Cancel</Button>
          <Button variant="primary" busy={adjust.isPending} disabled={!pesewas || form.note.trim().length < 3}
            onClick={() => adjust.mutate(undefined, { onSuccess: (r) => { setOpen(false); toast(r.pending ? 'Sent for approval.' : `${form.direction === 'credit' ? 'Credited' : 'Debited'} ${formatPesewas(pesewas)}.`); } })}>
            {form.direction === 'credit' ? 'Credit' : 'Debit'} {pesewas ? formatPesewas(pesewas) : ''}
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}

function ApprovalsTab() {
  const toast = useToast();
  const { me } = useSession();
  const [status, setStatus] = useState<Schemas['AdjustmentRequest']['status']>('pending');
  const list = useCursorList(['adjustments', status], (cursor) => call(api.GET('/admin/wallet-adjustments', { params: { query: { status, cursor, limit: 25 } } })));
  const [deciding, setDeciding] = useState<{ row: Schemas['AdjustmentRequest']; approve: boolean } | null>(null);
  const [note, setNote] = useState('');
  const [key, setKey] = useState(newIdempotencyKey);
  const decide = useAction(() => {
    const opts = { params: { path: { id: deciding!.row.id }, header: { 'Idempotency-Key': key } }, body: note ? { note } : {} };
    return call(deciding!.approve ? api.POST('/admin/wallet-adjustments/{id}/approve', opts) : api.POST('/admin/wallet-adjustments/{id}/reject', opts));
  }, [['adjustments'], ['ov']]);
  return (
    <div className={ui.stack}>
      <div className={ui.filters}>
        <Select label="Status" value={status} onChange={(e) => setStatus(e.target.value as typeof status)} options={['pending', 'approved', 'rejected'].map((s) => ({ value: s, label: humanize(s) }))} />
      </div>
      <DataTable label="Adjustment requests" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore}
        empty={{ title: status === 'pending' ? 'Nothing waiting for approval' : 'No requests' }}
        columns={[
          { header: 'Requested', cell: (r) => <When iso={r.createdAt} exact /> },
          { header: 'Student', cell: (r) => <span className={ui.num}>{shortId(r.studentId)}</span> },
          { header: 'Amount', align: 'right', cell: (r) => formatPesewas(r.amountPesewas) },
          { header: 'Reason', cell: (r) => <>{humanize(r.reasonCode)}<div className={ui.muted}>{r.note}</div></> },
          { header: 'Status', cell: (r) => <Chip tone={adjTone[r.status]}>{humanize(r.status)}</Chip> },
          { header: '', cell: (r) => (r.status === 'pending' ? (r.requestedBy === me?.id
            ? <span className={ui.muted}>Your request</span>
            : <span className={ui.row}>
              <Button small variant="primary" onClick={() => { setKey(newIdempotencyKey()); setNote(''); setDeciding({ row: r, approve: true }); }}>Approve</Button>
              <Button small onClick={() => { setKey(newIdempotencyKey()); setNote(''); setDeciding({ row: r, approve: false }); }}>Reject</Button>
            </span>) : null) },
        ]} />
      <Dialog open={!!deciding} onClose={() => setDeciding(null)} title={deciding?.approve ? 'Approve adjustment' : 'Reject adjustment'}>
        {deciding && <p style={{ margin: 0 }}>{deciding.approve ? 'This moves' : 'This cancels'} {formatPesewas(deciding.row.amountPesewas)} {deciding.row.amountPesewas >= 0 ? 'into' : 'out of'} the student’s wallet.</p>}
        <TextArea label="Note (optional)" value={note} onChange={(e) => setNote(e.target.value)} maxLength={300} />
        {decide.error ? <p role="alert" className={ui.muted}>{problemMessage(decide.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setDeciding(null)}>Cancel</Button>
          <Button variant={deciding?.approve ? 'primary' : 'danger'} busy={decide.isPending}
            onClick={() => decide.mutate(undefined, { onSuccess: () => { setDeciding(null); toast(deciding?.approve ? 'Approved and applied.' : 'Rejected.'); } })}>
            {deciding?.approve ? 'Approve' : 'Reject'}
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}

const issueLabel: Record<Schemas['ReconciliationItem']['issue'], string> = {
  missing_here: 'Missing here', missing_at_provider: 'Missing at provider', amount_mismatch: 'Amount mismatch', status_mismatch: 'Status mismatch',
};

export function ReconciliationPage() {
  const toast = useToast();
  const list = useCursorList(['recon'], (cursor) => call(api.GET('/admin/reconciliation/reports', { params: { query: { cursor, limit: 10 } } })));
  const [open, setOpen] = useState(false);
  const [form, setForm] = useState<{ file: File | null; from: string; to: string }>({ file: null, from: '', to: '' });
  const [selected, setSelected] = useState<Schemas['ReconciliationReport'] | null>(null);
  const run = useAction(async () => {
    const statementUploadId = await uploadFile('provider_statement', form.file!);
    return call(api.POST('/admin/reconciliation/reports', { body: { statementUploadId, periodFrom: form.from, periodTo: form.to } }));
  }, [['recon']]);
  const report = selected ?? list.rows?.[0] ?? null;
  return (
    <>
      <PageHeader title="Reconciliation" description="Compare our top-ups with the Payaza collections statement. Every difference becomes an exception to work."
        actions={<Button variant="primary" onClick={() => setOpen(true)}>Run reconciliation</Button>} />
      {list.loading ? <Card><Skeleton /></Card> : report ? (
        <Card title={`Report for ${formatDate(report.periodFrom)} to ${formatDate(report.periodTo)}`}>
          <div className={ui.grid4}>
            <Details items={[['Matched', String(report.matchedCount)]]} />
            <Details items={[['Provider total', <Money pesewas={report.providerTotalPesewas} />]]} />
            <Details items={[['Our total', <Money pesewas={report.ourTotalPesewas} />]]} />
            <Details items={[['Difference', <Money pesewas={report.providerTotalPesewas - report.ourTotalPesewas} />]]} />
          </div>
          <h3 className={ui.cardTitle} style={{ marginTop: 20 }}>Exceptions ({report.exceptions.length})</h3>
          {report.exceptions.length === 0 ? <p className={ui.muted}>Everything matched to the pesewa.</p> : (
            <DataTable label="Exceptions" rows={report.exceptions} rowKey={(r) => `${r.issue}-${r.providerReference}-${r.topupId}`} empty={{ title: 'None' }} columns={[
              { header: 'Issue', cell: (r) => <Chip tone={r.issue === 'amount_mismatch' ? 'danger' : 'warning'}>{issueLabel[r.issue]}</Chip> },
              { header: 'Provider reference', cell: (r) => <span className={ui.num}>{r.providerReference ?? '—'}</span> },
              { header: 'Top-up', cell: (r) => (r.topupId ? <span className={ui.num}>{shortId(r.topupId)}</span> : '—') },
              { header: 'Provider', align: 'right', cell: (r) => <Money pesewas={r.providerAmountPesewas} /> },
              { header: 'Ours', align: 'right', cell: (r) => <Money pesewas={r.ourAmountPesewas} /> },
            ]} />
          )}
        </Card>
      ) : null}
      <h2 className={ui.cardTitle}>History</h2>
      <DataTable label="Past reports" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore} onRowClick={setSelected}
        empty={{ title: 'No reconciliation run yet', body: 'Download the collections statement from the Payaza dashboard, then run it here.' }}
        columns={[
          { header: 'Period', cell: (r) => `${formatDate(r.periodFrom)} – ${formatDate(r.periodTo)}` },
          { header: 'Matched', align: 'right', cell: (r) => r.matchedCount },
          { header: 'Exceptions', cell: (r) => <Chip tone={r.exceptions.length ? 'warning' : 'success'}>{r.exceptions.length ? `${r.exceptions.length} to work` : 'None'}</Chip> },
          { header: 'Run', cell: (r) => <When iso={r.createdAt} /> },
        ]} />
      <Dialog open={open} onClose={() => setOpen(false)} title="Run reconciliation">
        <TextField label="Payaza statement" type="file" accept=".csv,text/csv,application/pdf,image/png,image/jpeg" onChange={(e) => setForm({ ...form, file: e.target.files?.[0] ?? null })}
          hint="The collections export from the Payaza dashboard, as CSV (or PDF), up to 10 MB." />
        <div className={ui.grid2} style={{ gridTemplateColumns: '1fr 1fr' }}>
          <TextField label="From" type="date" value={form.from} onChange={(e) => setForm({ ...form, from: e.target.value })} />
          <TextField label="To" type="date" value={form.to} onChange={(e) => setForm({ ...form, to: e.target.value })} />
        </div>
        {run.error ? <p role="alert" className={ui.muted}>{problemMessage(run.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setOpen(false)}>Cancel</Button>
          <Button variant="primary" busy={run.isPending} disabled={!form.file || !form.from || !form.to || form.from > form.to}
            onClick={() => run.mutate(undefined, { onSuccess: (r) => { setOpen(false); setSelected(r); toast('Reconciliation finished.'); } })}>Run</Button>
        </DialogActions>
      </Dialog>
    </>
  );
}
