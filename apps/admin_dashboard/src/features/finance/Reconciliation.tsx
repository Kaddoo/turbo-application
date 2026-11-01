import { useState } from 'react';
import type { Schemas } from '@/types';
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
  Skeleton,
  TextField,
  useToast,
  ui,
  When,
} from '@/components';
import { formatDate, shortId } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { newIdempotencyKey } from '@/services/http';
import { useReconciliationReports, useRunReconciliation } from './queries';

const issueLabel: Record<Schemas['ReconciliationItem']['issue'], string> = {
  missing_here: 'Missing here',
  missing_at_provider: 'Missing at provider',
  amount_mismatch: 'Amount mismatch',
  status_mismatch: 'Status mismatch',
};

export function Reconciliation() {
  const toast = useToast();
  const list = useReconciliationReports();
  const [open, setOpen] = useState(false);
  const [form, setForm] = useState<{ file: File | null; from: string; to: string }>({ file: null, from: '', to: '' });
  const [selected, setSelected] = useState<Schemas['ReconciliationReport'] | null>(null);
  const run = useRunReconciliation();
  const [runKey, setRunKey] = useState(newIdempotencyKey);
  const report = selected ?? list.rows?.[0] ?? null;
  return (
    <>
      <PageHeader
        title="Reconciliation"
        description="Compare our top-ups with the Payaza collections statement. Every difference becomes an exception to work."
        actions={
          <Button
            variant="primary"
            onClick={() => {
              setRunKey(newIdempotencyKey());
              setOpen(true);
            }}
          >
            Run reconciliation
          </Button>
        }
      />
      {list.loading ? (
        <Card>
          <Skeleton />
        </Card>
      ) : report ? (
        <Card title={`Report for ${formatDate(report.periodFrom)} to ${formatDate(report.periodTo)}`}>
          <div className={ui.grid4}>
            <Details items={[['Matched', String(report.matchedCount)]]} />
            <Details items={[['Provider total', <Money pesewas={report.providerTotalPesewas} />]]} />
            <Details items={[['Our total', <Money pesewas={report.ourTotalPesewas} />]]} />
            <Details
              items={[['Difference', <Money pesewas={report.providerTotalPesewas - report.ourTotalPesewas} />]]}
            />
          </div>
          <h3 className={ui.cardTitle} style={{ marginTop: 20 }}>
            Exceptions ({report.exceptions.length})
          </h3>
          {report.exceptions.length === 0 ? (
            <p className={ui.muted}>Everything matched to the pesewa.</p>
          ) : (
            <DataTable
              label="Exceptions"
              rows={report.exceptions}
              rowKey={(r) => `${r.issue}-${r.providerReference}-${r.topupId}`}
              empty={{ title: 'None' }}
              columns={[
                {
                  header: 'Issue',
                  cell: (r) => (
                    <Chip tone={r.issue === 'amount_mismatch' ? 'danger' : 'warning'}>{issueLabel[r.issue]}</Chip>
                  ),
                },
                {
                  header: 'Provider reference',
                  cell: (r) => <span className={ui.num}>{r.providerReference ?? '—'}</span>,
                },
                {
                  header: 'Top-up',
                  cell: (r) => (r.topupId ? <span className={ui.num}>{shortId(r.topupId)}</span> : '—'),
                },
                { header: 'Provider', align: 'right', cell: (r) => <Money pesewas={r.providerAmountPesewas} /> },
                { header: 'Ours', align: 'right', cell: (r) => <Money pesewas={r.ourAmountPesewas} /> },
              ]}
            />
          )}
        </Card>
      ) : null}
      <h2 className={ui.cardTitle}>History</h2>
      <DataTable
        label="Past reports"
        rows={list.rows}
        rowKey={(r) => r.id}
        loading={list.loading}
        error={list.error}
        onRetry={list.refetch}
        hasMore={list.hasMore}
        onLoadMore={list.loadMore}
        loadingMore={list.loadingMore}
        onRowClick={setSelected}
        empty={{
          title: 'No reconciliation run yet',
          body: 'Download the collections statement from the Payaza dashboard, then run it here.',
        }}
        columns={[
          { header: 'Period', cell: (r) => `${formatDate(r.periodFrom)} – ${formatDate(r.periodTo)}` },
          { header: 'Matched', align: 'right', cell: (r) => r.matchedCount },
          {
            header: 'Exceptions',
            cell: (r) => (
              <Chip tone={r.exceptions.length ? 'warning' : 'success'}>
                {r.exceptions.length ? `${r.exceptions.length} to work` : 'None'}
              </Chip>
            ),
          },
          { header: 'Run', cell: (r) => <When iso={r.createdAt} /> },
        ]}
      />
      <Dialog open={open} onClose={() => setOpen(false)} title="Run reconciliation">
        <TextField
          label="Payaza statement"
          type="file"
          accept=".csv,text/csv,application/pdf,image/png,image/jpeg"
          onChange={(e) => setForm({ ...form, file: e.target.files?.[0] ?? null })}
          hint="The collections export from the Payaza dashboard, as CSV (or PDF), up to 10 MB."
        />
        <div className={ui.grid2} style={{ gridTemplateColumns: '1fr 1fr' }}>
          <TextField
            label="From"
            type="date"
            value={form.from}
            onChange={(e) => setForm({ ...form, from: e.target.value })}
          />
          <TextField
            label="To"
            type="date"
            value={form.to}
            onChange={(e) => setForm({ ...form, to: e.target.value })}
          />
        </div>
        {run.error ? (
          <p role="alert" className={ui.muted}>
            {problemMessage(run.error)}
          </p>
        ) : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setOpen(false)}>
            Cancel
          </Button>
          <Button
            variant="primary"
            busy={run.isPending}
            disabled={!form.file || !form.from || !form.to || form.from > form.to}
            onClick={() =>
              run.mutate(
                { file: form.file!, from: form.from, to: form.to, key: runKey },
                {
                  onSuccess: (r) => {
                    setOpen(false);
                    setSelected(r);
                    toast('Reconciliation finished.');
                  },
                },
              )
            }
          >
            Run
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
}
