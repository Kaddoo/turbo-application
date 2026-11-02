import { useState } from 'react';
import { useSearchParams } from 'react-router';
import { newIdempotencyKey } from '@/services/http';
import type { Schemas } from '@/types';
import { useSession } from '@/state/session';
import { canDo } from '@/utils/permissions';
import {
  Button,
  Card,
  Chip,
  DataTable,
  Details,
  Dialog,
  DialogActions,
  Money,
  PageHeader,
  Select,
  Skeleton,
  Tabs,
  TextArea,
  TextField,
  useToast,
  ui,
  When,
  type Tone,
} from '@/components';
import { formatPesewas, humanize, parseCedis, shortId } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useSettings } from '@/hooks';
import {
  useAdjustmentRequests,
  useAdjustWallet,
  useDecideAdjustment,
  useStudentWallet,
  useWalletTransactions,
} from './queries';

const adjustmentReasons: Schemas['WalletAdjustment']['reasonCode'][] = [
  'goodwill',
  'duplicate_charge',
  'provider_reconciliation',
  'correction',
  'other',
];
const adjTone: Record<Schemas['AdjustmentRequest']['status'], Tone> = {
  pending: 'warning',
  approved: 'success',
  rejected: 'neutral',
};

export function Adjustments() {
  const [params, setParams] = useSearchParams();
  const tab = (params.get('tab') ?? 'wallet') as 'wallet' | 'approvals';
  return (
    <>
      <PageHeader
        title="Adjustments"
        description="Credit or debit a student wallet with a reason. Large adjustments need a second finance user to approve."
      />
      <Tabs
        value={tab}
        onChange={(v) => setParams({ tab: v }, { replace: true })}
        tabs={[
          { value: 'wallet', label: 'Student wallet' },
          { value: 'approvals', label: 'Approvals' },
        ]}
      />
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
  const settings = useSettings(canDo(me?.staffRole, 'config.viewSettings'));
  // Finance cannot read the settings; the API sends them the amount on /admin/me (contract 0.3.1).
  const threshold = me?.adjustmentApprovalThresholdPesewas ?? settings.data?.adjustmentApprovalThresholdPesewas;
  const wallet = useStudentWallet(studentId);
  const tx = useWalletTransactions(studentId);
  const [open, setOpen] = useState(false);
  const [form, setForm] = useState({
    direction: 'credit',
    amount: '',
    reasonCode: 'goodwill' as Schemas['WalletAdjustment']['reasonCode'],
    note: '',
  });
  const [key, setKey] = useState(newIdempotencyKey);
  const parsed = parseCedis(form.amount);
  const pesewas = parsed !== null && parsed > 0 ? parsed : 0;
  const signed = form.direction === 'credit' ? pesewas : -pesewas;
  const adjust = useAdjustWallet(studentId);

  return (
    <div className={ui.stack}>
      <form
        className={ui.filters}
        onSubmit={(e) => {
          e.preventDefault();
          setStudentId(input.trim());
        }}
      >
        <TextField
          label="Student id"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Paste from a ride, top-up or ticket"
          hint="Finance cannot search students by name yet (CONTRACT_REQUESTS A4)."
        />
        <Button type="submit" disabled={!input.trim()}>
          Open wallet
        </Button>
      </form>
      {studentId && (
        <>
          <Card
            title="Wallet"
            actions={
              <Button
                variant="primary"
                onClick={() => {
                  setKey(newIdempotencyKey());
                  setForm({ direction: 'credit', amount: '', reasonCode: 'goodwill', note: '' });
                  setOpen(true);
                }}
              >
                New adjustment
              </Button>
            }
          >
            {wallet.isPending ? (
              <Skeleton />
            ) : wallet.error ? (
              <p className={ui.muted}>{problemMessage(wallet.error)}</p>
            ) : (
              <Details
                items={[
                  ['Balance', <Money pesewas={wallet.data.balancePesewas} />],
                  ['Held for rides', <Money pesewas={wallet.data.reservedPesewas} />],
                  ['Available', <Money pesewas={wallet.data.availablePesewas} />],
                ]}
              />
            )}
          </Card>
          <DataTable
            label="Wallet history"
            rows={tx.rows}
            rowKey={(r) => r.id}
            loading={tx.loading}
            error={tx.error}
            onRetry={tx.refetch}
            hasMore={tx.hasMore}
            onLoadMore={tx.loadMore}
            loadingMore={tx.loadingMore}
            empty={{ title: 'No wallet activity yet' }}
            columns={[
              { header: 'When', cell: (r) => <When iso={r.createdAt} exact /> },
              { header: 'Type', cell: (r) => humanize(r.type) },
              { header: 'Description', cell: (r) => r.description },
              {
                header: 'Amount',
                align: 'right',
                cell: (r) => (
                  <span className={r.affectsBalance ? undefined : ui.muted}>{formatPesewas(r.amountPesewas)}</span>
                ),
              },
              { header: 'Balance after', align: 'right', cell: (r) => <Money pesewas={r.balanceAfterPesewas} /> },
            ]}
          />
        </>
      )}
      <Dialog open={open} onClose={() => setOpen(false)} title="New adjustment">
        <Select
          label="Direction"
          value={form.direction}
          onChange={(e) => setForm({ ...form, direction: e.target.value })}
          options={[
            { value: 'credit', label: 'Credit (add money)' },
            { value: 'debit', label: 'Debit (take money)' },
          ]}
        />
        <TextField
          label="Amount (GH₵)"
          inputMode="decimal"
          value={form.amount}
          onChange={(e) => setForm({ ...form, amount: e.target.value })}
          hint={
            threshold != null
              ? `Up to ${formatPesewas(threshold)} applies at once; above that another finance user must approve.`
              : 'Small amounts apply at once; above the approval limit another finance user must approve.'
          }
        />
        <Select
          label="Reason"
          value={form.reasonCode}
          onChange={(e) => setForm({ ...form, reasonCode: e.target.value as typeof form.reasonCode })}
          options={adjustmentReasons.map((r) => ({ value: r, label: humanize(r) }))}
        />
        <TextArea
          label="Note"
          value={form.note}
          onChange={(e) => setForm({ ...form, note: e.target.value })}
          maxLength={300}
        />
        {adjust.error ? (
          <p role="alert" className={ui.muted}>
            {problemMessage(adjust.error)}
          </p>
        ) : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setOpen(false)}>
            Cancel
          </Button>
          <Button
            variant="primary"
            busy={adjust.isPending}
            disabled={!pesewas || form.note.trim().length < 3}
            onClick={() =>
              adjust.mutate(
                { key, body: { amountPesewas: signed, reasonCode: form.reasonCode, note: form.note } },
                {
                  onSuccess: (r) => {
                    setOpen(false);
                    toast(
                      r.pending
                        ? 'Sent for approval.'
                        : `${form.direction === 'credit' ? 'Credited' : 'Debited'} ${formatPesewas(pesewas)}.`,
                    );
                  },
                },
              )
            }
          >
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
  const list = useAdjustmentRequests(status);
  const [deciding, setDeciding] = useState<{ row: Schemas['AdjustmentRequest']; approve: boolean } | null>(null);
  const [note, setNote] = useState('');
  const [key, setKey] = useState(newIdempotencyKey);
  const decide = useDecideAdjustment();
  return (
    <div className={ui.stack}>
      <div className={ui.filters}>
        <Select
          label="Status"
          value={status}
          onChange={(e) => setStatus(e.target.value as typeof status)}
          options={['pending', 'approved', 'rejected'].map((s) => ({ value: s, label: humanize(s) }))}
        />
      </div>
      <DataTable
        label="Adjustment requests"
        rows={list.rows}
        rowKey={(r) => r.id}
        loading={list.loading}
        error={list.error}
        onRetry={list.refetch}
        hasMore={list.hasMore}
        onLoadMore={list.loadMore}
        loadingMore={list.loadingMore}
        empty={{ title: status === 'pending' ? 'Nothing waiting for approval' : 'No requests' }}
        columns={[
          { header: 'Requested', cell: (r) => <When iso={r.createdAt} exact /> },
          { header: 'Student', cell: (r) => <span className={ui.num}>{shortId(r.studentId)}</span> },
          { header: 'Amount', align: 'right', cell: (r) => formatPesewas(r.amountPesewas) },
          {
            header: 'Reason',
            cell: (r) => (
              <>
                {humanize(r.reasonCode)}
                <div className={ui.muted}>{r.note}</div>
              </>
            ),
          },
          { header: 'Status', slot: 'badge', cell: (r) => <Chip tone={adjTone[r.status]}>{humanize(r.status)}</Chip> },
          {
            header: '',
            cell: (r) =>
              r.status === 'pending' ? (
                r.requestedBy === me?.id ? (
                  <span className={ui.muted}>Your request</span>
                ) : (
                  <span className={ui.row}>
                    <Button
                      small
                      variant="primary"
                      onClick={() => {
                        setKey(newIdempotencyKey());
                        setNote('');
                        setDeciding({ row: r, approve: true });
                      }}
                    >
                      Approve
                    </Button>
                    <Button
                      small
                      onClick={() => {
                        setKey(newIdempotencyKey());
                        setNote('');
                        setDeciding({ row: r, approve: false });
                      }}
                    >
                      Reject
                    </Button>
                  </span>
                )
              ) : null,
          },
        ]}
      />
      <Dialog
        open={!!deciding}
        onClose={() => setDeciding(null)}
        title={deciding?.approve ? 'Approve adjustment' : 'Reject adjustment'}
      >
        {deciding && (
          <p style={{ margin: 0 }}>
            {deciding.approve ? 'This moves' : 'This cancels'} {formatPesewas(deciding.row.amountPesewas)}{' '}
            {deciding.row.amountPesewas >= 0 ? 'into' : 'out of'} the student’s wallet.
          </p>
        )}
        <TextArea label="Note (optional)" value={note} onChange={(e) => setNote(e.target.value)} maxLength={300} />
        {decide.error ? (
          <p role="alert" className={ui.muted}>
            {problemMessage(decide.error)}
          </p>
        ) : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setDeciding(null)}>
            Cancel
          </Button>
          <Button
            variant={deciding?.approve ? 'primary' : 'danger'}
            busy={decide.isPending}
            onClick={() =>
              decide.mutate(
                { id: deciding!.row.id, approve: deciding!.approve, note, key },
                {
                  onSuccess: () => {
                    setDeciding(null);
                    toast(deciding?.approve ? 'Approved and applied.' : 'Rejected.');
                  },
                },
              )
            }
          >
            {deciding?.approve ? 'Approve' : 'Reject'}
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}
