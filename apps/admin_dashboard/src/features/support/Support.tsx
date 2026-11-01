import { useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router';
import type { Schemas } from '@/types';
import { useSession } from '@/state/session';
import {
  Button,
  Card,
  Chip,
  DataTable,
  ErrorState,
  PageHeader,
  Select,
  Skeleton,
  TextArea,
  useToast,
  ui,
  When,
  type Tone,
} from '@/components';
import { formatRelative, formatTime, humanize } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useReplyToTicket, useTicket, useTickets, useUpdateTicket } from './queries';

type Ticket = Schemas['SupportTicket'];
const ticketTone: Record<Ticket['status'], Tone> = {
  open: 'warning',
  in_progress: 'accent',
  waiting_on_user: 'neutral',
  resolved: 'success',
  closed: 'neutral',
};
const categories = [
  'safety',
  'driver_conduct',
  'vehicle',
  'wrong_charge',
  'payment_problem',
  'lost_item',
  'account',
  'phone_change',
  'data_request',
  'other',
];
const categoryHelp: Record<string, string> = {
  phone_change:
    'Phone change: re-check the Ghana Card with the student, then a verifier changes the number from the student’s page. It signs them out everywhere.',
  data_request:
    'Data request: the student wants a copy or deletion of their data. Reply within the stated period; ledger entries are anonymised, never deleted.',
};

export function Support() {
  const navigate = useNavigate();
  const [status, setStatus] = useState('open');
  const [category, setCategory] = useState('');
  const list = useTickets(status, category);
  return (
    <>
      <PageHeader
        title="Support"
        description="Tickets from students and drivers. Reply in plain words; internal notes are never shown to them."
      />
      <div className={ui.filters}>
        <Select
          label="Status"
          value={status}
          onChange={(e) => setStatus(e.target.value)}
          options={[
            { value: '', label: 'Any' },
            ...['open', 'in_progress', 'waiting_on_user', 'resolved', 'closed'].map((s) => ({
              value: s,
              label: humanize(s),
            })),
          ]}
        />
        <Select
          label="Category"
          value={category}
          onChange={(e) => setCategory(e.target.value)}
          options={[{ value: '', label: 'Any' }, ...categories.map((c) => ({ value: c, label: humanize(c) }))]}
        />
      </div>
      <DataTable
        label="Tickets"
        rows={list.rows}
        rowKey={(r) => r.id}
        loading={list.loading}
        error={list.error}
        onRetry={list.refetch}
        hasMore={list.hasMore}
        onLoadMore={list.loadMore}
        loadingMore={list.loadingMore}
        onRowClick={(r) => navigate(`/support/${r.id}`)}
        empty={{ title: 'No tickets here', body: status === 'open' ? 'Everyone has an answer.' : undefined }}
        columns={[
          { header: 'Subject', cell: (r) => r.subject },
          { header: 'Category', cell: (r) => humanize(r.category) },
          { header: 'Status', cell: (r) => <Chip tone={ticketTone[r.status]}>{humanize(r.status)}</Chip> },
          { header: 'Age', cell: (r) => formatRelative(r.createdAt) },
          { header: 'Updated', cell: (r) => <When iso={r.updatedAt} /> },
          {
            header: 'Assignee',
            cell: (r) => (r.assignedToStaffId ? 'Assigned' : <span className={ui.muted}>Nobody</span>),
          },
        ]}
      />
    </>
  );
}

export function TicketDetail() {
  const { id = '' } = useParams();
  const { me } = useSession();
  const toast = useToast();
  const q = useTicket(id);
  const [body, setBody] = useState('');
  const [internal, setInternal] = useState(false);
  const reply = useReplyToTicket(id);
  const update = useUpdateTicket(id);
  if (q.isPending)
    return (
      <Card>
        <Skeleton />
      </Card>
    );
  if (q.error) return <ErrorState error={q.error} onRetry={() => void q.refetch()} />;
  const t = q.data;
  return (
    <>
      <PageHeader
        title={t.subject}
        description={`${humanize(t.category)} · opened ${formatRelative(t.createdAt)}`}
        actions={<Chip tone={ticketTone[t.status]}>{humanize(t.status)}</Chip>}
      />
      {categoryHelp[t.category] && (
        <p className={ui.muted} style={{ margin: 0 }}>
          {categoryHelp[t.category]}
        </p>
      )}
      <div className={ui.grid2} style={{ gridTemplateColumns: 'minmax(0, 2fr) minmax(16rem, 1fr)' }}>
        <Card title="Conversation">
          <div className={ui.stack} style={{ gap: 12 }}>
            {(t.messages ?? []).map((m) => (
              <div key={m.id} className={ui.card} style={{ padding: 12, borderStyle: m.internal ? 'dashed' : 'solid' }}>
                <div className={ui.row}>
                  <strong>{m.author === 'staff' ? 'Staff' : 'Student or driver'}</strong>
                  {m.internal && <Chip tone="warning">Internal note</Chip>}
                  <span className={ui.muted}>{formatTime(m.createdAt)}</span>
                </div>
                <p style={{ margin: '6px 0 0', whiteSpace: 'pre-wrap' }}>{m.body}</p>
              </div>
            ))}
            <TextArea
              label={internal ? 'Internal note' : 'Reply'}
              value={body}
              onChange={(e) => setBody(e.target.value)}
              maxLength={2000}
            />
            <label className={ui.row}>
              <input type="checkbox" checked={internal} onChange={(e) => setInternal(e.target.checked)} /> Internal
              note, staff only
            </label>
            {reply.error ? (
              <p role="alert" className={ui.muted}>
                {problemMessage(reply.error)}
              </p>
            ) : null}
            <div className={ui.actions}>
              <Button
                variant="primary"
                busy={reply.isPending}
                disabled={!body.trim()}
                onClick={() =>
                  reply.mutate(
                    { body, internal },
                    {
                      onSuccess: () => {
                        setBody('');
                        toast(internal ? 'Note added.' : 'Reply sent.');
                      },
                    },
                  )
                }
              >
                {internal ? 'Add note' : 'Send reply'}
              </Button>
            </div>
          </div>
        </Card>
        <Card title="Ticket">
          <div className={ui.stack}>
            <Select
              label="Status"
              value={t.status}
              disabled={update.isPending}
              onChange={(e) =>
                update.mutate(
                  { status: e.target.value as Ticket['status'] },
                  { onSuccess: () => toast('Status changed.') },
                )
              }
              options={['open', 'in_progress', 'waiting_on_user', 'resolved', 'closed'].map((s) => ({
                value: s,
                label: humanize(s),
              }))}
            />
            <Button
              onClick={() =>
                update.mutate(
                  { assignedToStaffId: t.assignedToStaffId === me?.id ? null : me!.id },
                  { onSuccess: () => toast('Assignee changed.') },
                )
              }
            >
              {t.assignedToStaffId === me?.id ? 'Unassign me' : 'Assign to me'}
            </Button>
            {t.rideId && <Link to={`/rides/${t.rideId}`}>Open the ride</Link>}
            {update.error ? (
              <p role="alert" className={ui.muted}>
                {problemMessage(update.error)}
              </p>
            ) : null}
          </div>
        </Card>
      </div>
    </>
  );
}
