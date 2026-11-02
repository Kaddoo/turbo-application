import { useState } from 'react';
import type { Schemas } from '@/types';
import {
  Button,
  Chip,
  DataTable,
  Details,
  Dialog,
  DialogActions,
  Money,
  PageHeader,
  Select,
  TextArea,
  useToast,
  ui,
  When,
  type Tone,
  CardTop,
  Callout,
  Figure,
  Row,
} from '@/components';
import { formatPesewas, humanize } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { newIdempotencyKey } from '@/services/http';
import { useResolveTopup, useTopups } from './queries';

type Topup = Schemas['Topup'];
const topupTone: Record<Topup['status'], Tone> = {
  pending: 'warning',
  succeeded: 'success',
  failed: 'danger',
  abandoned: 'neutral',
};
const validationTone = { exact: 'success', underpayment: 'danger', overpayment: 'warning' } as const;

export function Topups() {
  const toast = useToast();
  const [flaggedOnly, setFlagged] = useState(true);
  const [status, setStatus] = useState('');
  const list = useTopups(flaggedOnly, status);
  const [resolving, setResolving] = useState<Topup | null>(null);
  const [resolution, setResolution] = useState<Schemas['TopupResolve']['resolution']>('accept_received_amount');
  const [note, setNote] = useState('');
  const resolve = useResolveTopup();
  const [resolveKey, setResolveKey] = useState(newIdempotencyKey);

  return (
    <>
      <PageHeader
        title="Top-ups"
        description="Mobile money top-ups from Payaza. Flagged ones need a finance decision. Any change to a wallet goes through Adjustments, not here."
      />
      <div className={ui.filters}>
        <Select
          label="Show"
          value={flaggedOnly ? 'flagged' : 'all'}
          onChange={(e) => setFlagged(e.target.value === 'flagged')}
          options={[
            { value: 'flagged', label: 'Flagged only' },
            { value: 'all', label: 'All top-ups' },
          ]}
        />
        <Select
          label="Status"
          value={status}
          onChange={(e) => setStatus(e.target.value)}
          options={[
            { value: '', label: 'Any' },
            ...['pending', 'succeeded', 'failed', 'abandoned'].map((s) => ({ value: s, label: humanize(s) })),
          ]}
        />
      </div>
      <DataTable
        label="Top-ups"
        rows={list.rows}
        rowKey={(r) => r.id}
        loading={list.loading}
        error={list.error}
        onRetry={list.refetch}
        hasMore={list.hasMore}
        onLoadMore={list.loadMore}
        loadingMore={list.loadingMore}
        onRowClick={(r) =>
          r.flagged && !r.resolvedAt ? (setResolving(r), setNote(''), setResolveKey(newIdempotencyKey())) : undefined
        }
        empty={{
          title: flaggedOnly ? 'No flagged top-ups' : 'No top-ups yet',
          body: flaggedOnly ? 'Every top-up matched what the provider received.' : undefined,
        }}
        card={(r) => <TopupCard r={r} />}
        cardTone={(r) => (r.resolvedAt ? 'success' : r.flagged ? 'danger' : topupTone[r.status])}
        columns={[
          { header: 'When', cell: (r) => <When iso={r.createdAt} exact /> },
          { header: 'Reference', cell: (r) => <span className={ui.num}>{r.reference}</span> },
          {
            header: 'Status',
            slot: 'badge',
            cell: (r) => <Chip tone={topupTone[r.status]}>{humanize(r.status)}</Chip>,
          },
          { header: 'Requested', align: 'right', cell: (r) => <Money pesewas={r.amountPesewas} /> },
          { header: 'Received', align: 'right', cell: (r) => <Money pesewas={r.amountReceivedPesewas} /> },
          {
            header: 'Check',
            cell: (r) =>
              r.validation ? <Chip tone={validationTone[r.validation]}>{humanize(r.validation)}</Chip> : '—',
          },
          {
            header: 'Flag',
            cell: (r) =>
              r.resolvedAt ? (
                <Chip tone="success">Resolved</Chip>
              ) : r.flagged ? (
                <span>
                  <Chip tone="danger">Flagged</Chip> <span className={ui.muted}>{r.flagReason}</span>
                </span>
              ) : (
                '—'
              ),
          },
        ]}
      />
      <Dialog open={!!resolving} onClose={() => setResolving(null)} title="Close a flagged top-up">
        {resolving && (
          <Details
            items={[
              ['Reference', resolving.reference],
              ['Requested', formatPesewas(resolving.amountPesewas)],
              [
                'Received',
                resolving.amountReceivedPesewas == null ? '—' : formatPesewas(resolving.amountReceivedPesewas),
              ],
              ['Why flagged', resolving.flagReason ?? '—'],
            ]}
          />
        )}
        <Select
          label="Resolution"
          value={resolution}
          onChange={(e) => setResolution(e.target.value as typeof resolution)}
          options={[
            { value: 'accept_received_amount', label: 'Accept the amount received (already credited)' },
            { value: 'refund_outside_system', label: 'Refunded to the student outside the system' },
            { value: 'no_action', label: 'No action needed' },
          ]}
        />
        <TextArea
          label="Note"
          hint="At least 5 characters."
          value={note}
          onChange={(e) => setNote(e.target.value)}
          maxLength={300}
        />
        <p className={ui.muted} style={{ margin: 0 }}>
          Closing does not move money. If the wallet needs correcting, make an adjustment too.
        </p>
        {resolve.error ? (
          <p role="alert" className={ui.muted}>
            {problemMessage(resolve.error)}
          </p>
        ) : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setResolving(null)}>
            Cancel
          </Button>
          <Button
            variant="primary"
            busy={resolve.isPending}
            disabled={note.trim().length < 5}
            onClick={() =>
              resolve.mutate(
                { id: resolving!.id, body: { resolution, note }, key: resolveKey },
                {
                  onSuccess: () => {
                    setResolving(null);
                    toast('Top-up closed.');
                  },
                },
              )
            }
          >
            Close top-up
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
}

function TopupCard({ r }: { r: Topup }) {
  const short = r.amountReceivedPesewas != null && r.amountReceivedPesewas < r.amountPesewas;
  return (
    <>
      <CardTop end={<Chip tone={topupTone[r.status]}>{humanize(r.status)}</Chip>}>
        <span className={ui.num}>{r.reference}</span>
      </CardTop>
      <Figure
        label="Received"
        size="lg"
        tone={short ? 'danger' : undefined}
        note={
          <>
            of <Money pesewas={r.amountPesewas} /> requested
          </>
        }
      >
        <Money pesewas={r.amountReceivedPesewas} />
      </Figure>
      <Row>
        {r.validation ? <Chip tone={validationTone[r.validation]}>{humanize(r.validation)}</Chip> : null}
        <When iso={r.createdAt} exact />
      </Row>
      {r.resolvedAt ? (
        <Callout tone="success" icon="check">
          Resolved
        </Callout>
      ) : r.flagged ? (
        <Callout tone="danger" icon="warning">
          {r.flagReason ?? 'Flagged'}
        </Callout>
      ) : null}
    </>
  );
}
