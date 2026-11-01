import { useMemo, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Link, useNavigate, useParams } from 'react-router';
import { api, call, type Schemas } from '../api/client';
import { useSession } from '../auth/session';
import { MapView } from '../components/MapView';
import {
  Button, Card, Chip, DataTable, Details, Dialog, DialogActions, ErrorState, PageHeader, Select, Skeleton, TextArea,
  useToast, ui, When, type Tone,
} from '../components/ui';
import { formatRelative, formatTime, humanize } from '../lib/format';
import { problemMessage } from '../lib/problems';
import { useAction, useCursorList } from '../lib/queries';

type Ticket = Schemas['SupportTicket'];
const ticketTone: Record<Ticket['status'], Tone> = { open: 'warning', in_progress: 'accent', waiting_on_user: 'neutral', resolved: 'success', closed: 'neutral' };
const categories = ['safety', 'driver_conduct', 'vehicle', 'wrong_charge', 'payment_problem', 'lost_item', 'account', 'phone_change', 'data_request', 'other'];
const categoryHelp: Record<string, string> = {
  phone_change: 'Phone change: re-check the Ghana Card with the student, then a verifier changes the number from the student’s page. It signs them out everywhere.',
  data_request: 'Data request: the student wants a copy or deletion of their data. Reply within the stated period; ledger entries are anonymised, never deleted.',
};

export function SupportPage() {
  const navigate = useNavigate();
  const [status, setStatus] = useState('open');
  const [category, setCategory] = useState('');
  const list = useCursorList(['tickets', status, category], (cursor) => call(api.GET('/admin/support/tickets', { params: { query: {
    status: (status || undefined) as Ticket['status'] | undefined, category: category || undefined, cursor, limit: 25,
  } } })));
  return (
    <>
      <PageHeader title="Support" description="Tickets from students and drivers. Reply in plain words; internal notes are never shown to them." />
      <div className={ui.filters}>
        <Select label="Status" value={status} onChange={(e) => setStatus(e.target.value)}
          options={[{ value: '', label: 'Any' }, ...['open', 'in_progress', 'waiting_on_user', 'resolved', 'closed'].map((s) => ({ value: s, label: humanize(s) }))]} />
        <Select label="Category" value={category} onChange={(e) => setCategory(e.target.value)}
          options={[{ value: '', label: 'Any' }, ...categories.map((c) => ({ value: c, label: humanize(c) }))]} />
      </div>
      <DataTable label="Tickets" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore} onRowClick={(r) => navigate(`/support/${r.id}`)}
        empty={{ title: 'No tickets here', body: status === 'open' ? 'Everyone has an answer.' : undefined }}
        columns={[
          { header: 'Subject', cell: (r) => r.subject },
          { header: 'Category', cell: (r) => humanize(r.category) },
          { header: 'Status', cell: (r) => <Chip tone={ticketTone[r.status]}>{humanize(r.status)}</Chip> },
          { header: 'Age', cell: (r) => formatRelative(r.createdAt) },
          { header: 'Updated', cell: (r) => <When iso={r.updatedAt} /> },
          { header: 'Assignee', cell: (r) => (r.assignedToStaffId ? 'Assigned' : <span className={ui.muted}>Nobody</span>) },
        ]} />
    </>
  );
}

export function TicketPage() {
  const { id = '' } = useParams();
  const { me } = useSession();
  const toast = useToast();
  const q = useQuery({ queryKey: ['ticket', id], queryFn: () => call(api.GET('/admin/support/tickets/{id}', { params: { path: { id } } })) });
  const [body, setBody] = useState('');
  const [internal, setInternal] = useState(false);
  const reply = useAction(() => call(api.POST('/admin/support/tickets/{id}/messages', { params: { path: { id } }, body: { body, internal } })), [['ticket', id]]);
  const update = useAction((b: Schemas['TicketUpdate']) => call(api.PATCH('/admin/support/tickets/{id}', { params: { path: { id } }, body: b })), [['ticket', id], ['tickets']]);
  if (q.isPending) return <Card><Skeleton /></Card>;
  if (q.error) return <ErrorState error={q.error} onRetry={() => void q.refetch()} />;
  const t = q.data;
  return (
    <>
      <PageHeader title={t.subject} description={`${humanize(t.category)} · opened ${formatRelative(t.createdAt)}`}
        actions={<Chip tone={ticketTone[t.status]}>{humanize(t.status)}</Chip>} />
      {categoryHelp[t.category] && <p className={ui.muted} style={{ margin: 0 }}>{categoryHelp[t.category]}</p>}
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
            <TextArea label={internal ? 'Internal note' : 'Reply'} value={body} onChange={(e) => setBody(e.target.value)} maxLength={2000} />
            <label className={ui.row}><input type="checkbox" checked={internal} onChange={(e) => setInternal(e.target.checked)} /> Internal note, staff only</label>
            {reply.error ? <p role="alert" className={ui.muted}>{problemMessage(reply.error)}</p> : null}
            <div className={ui.actions}>
              <Button variant="primary" busy={reply.isPending} disabled={!body.trim()}
                onClick={() => reply.mutate(undefined, { onSuccess: () => { setBody(''); toast(internal ? 'Note added.' : 'Reply sent.'); } })}>
                {internal ? 'Add note' : 'Send reply'}
              </Button>
            </div>
          </div>
        </Card>
        <Card title="Ticket">
          <div className={ui.stack}>
            <Select label="Status" value={t.status} disabled={update.isPending} onChange={(e) => update.mutate({ status: e.target.value as Ticket['status'] }, { onSuccess: () => toast('Status changed.') })}
              options={['open', 'in_progress', 'waiting_on_user', 'resolved', 'closed'].map((s) => ({ value: s, label: humanize(s) }))} />
            <Button onClick={() => update.mutate({ assignedToStaffId: t.assignedToStaffId === me?.id ? null : me!.id }, { onSuccess: () => toast('Assignee changed.') })}>
              {t.assignedToStaffId === me?.id ? 'Unassign me' : 'Assign to me'}
            </Button>
            {t.rideId && <Link to={`/rides/${t.rideId}`}>Open the ride</Link>}
            {update.error ? <p role="alert" className={ui.muted}>{problemMessage(update.error)}</p> : null}
          </div>
        </Card>
      </div>
    </>
  );
}

type Incident = Schemas['Incident'];
const incidentTone: Record<Incident['status'], Tone> = { open: 'danger', acknowledged: 'warning', resolved: 'success' };

export function IncidentsPage() {
  const toast = useToast();
  const [status, setStatus] = useState('open');
  const list = useCursorList(['incidents', status], (cursor) => call(api.GET('/admin/incidents', { params: { query: { status: (status || undefined) as Incident['status'] | undefined, cursor, limit: 25 } } })));
  const [selected, setSelected] = useState<Incident | null>(null);
  const [note, setNote] = useState('');
  const act = useAction((b: Schemas['IncidentUpdate']) => call(api.PATCH('/admin/incidents/{id}', { params: { path: { id: selected!.id } }, body: b })), [['incidents'], ['ov']]);
  const markers = useMemo(() => (selected?.location ? [{ id: selected.id, lat: selected.location.lat, lng: selected.location.lng, tone: 'danger' as const, label: 'Last known location' }] : []), [selected]);
  const minutes = (iso: string) => (Date.now() - new Date(iso).getTime()) / 60_000;

  return (
    <>
      <PageHeader title="Incidents" description="SOS alerts and safety reports. Acknowledge an SOS within 2 minutes; after that it turns more urgent." />
      <div className={ui.filters}>
        <Select label="Status" value={status} onChange={(e) => setStatus(e.target.value)}
          options={[{ value: '', label: 'Any' }, ...['open', 'acknowledged', 'resolved'].map((s) => ({ value: s, label: humanize(s) }))]} />
      </div>
      <DataTable label="Incidents" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore} onRowClick={(r) => { setSelected(r); setNote(''); }}
        empty={{ title: status === 'open' ? 'No open incidents' : 'No incidents', body: 'An SOS from the apps appears here and as a red banner on every page.' }}
        columns={[
          { header: 'Raised', cell: (r) => <When iso={r.createdAt} exact /> },
          { header: 'Type', cell: (r) => <Chip tone={r.type === 'sos' ? 'danger' : 'warning'}>{r.type === 'sos' ? 'SOS' : 'Safety report'}</Chip> },
          { header: 'Status', cell: (r) => <span className={ui.row}><Chip tone={incidentTone[r.status]}>{humanize(r.status)}</Chip>
            {r.status === 'open' && minutes(r.createdAt) > 2 && <Chip tone="danger">Over 2 min</Chip>}</span> },
          { header: 'Note', cell: (r) => r.note ?? '—' },
          { header: 'Ride', cell: (r) => (r.rideId ? <Link to={`/rides/${r.rideId}`} onClick={(e) => e.stopPropagation()}>Open ride</Link> : '—') },
        ]} />
      <Dialog open={!!selected} onClose={() => setSelected(null)} title={selected?.type === 'sos' ? 'SOS' : 'Safety report'}>
        {selected && <>
          <Details items={[['Raised', <When iso={selected.createdAt} exact />], ['Status', humanize(selected.status)], ['Note', selected.note ?? '—']]} />
          {markers.length > 0 && <MapView markers={markers} height={220} />}
          <p className={ui.muted} style={{ margin: 0 }}>Call the student or driver through the campus security line, and send help to the location shown.</p>
          {selected.status !== 'resolved' && <TextArea label={selected.status === 'open' ? 'Note (optional)' : 'How it was resolved'} value={note} onChange={(e) => setNote(e.target.value)} maxLength={1000} />}
        </>}
        {act.error ? <p role="alert" className={ui.muted}>{problemMessage(act.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setSelected(null)}>Close</Button>
          {selected?.status === 'open' && <Button variant="danger" busy={act.isPending}
            onClick={() => act.mutate({ status: 'acknowledged', ...(note ? { note } : {}) }, { onSuccess: () => { setSelected(null); toast('Acknowledged. Stay on it until it is resolved.'); } })}>Acknowledge</Button>}
          {selected?.status === 'acknowledged' && <Button variant="primary" busy={act.isPending} disabled={note.trim().length < 3}
            onClick={() => act.mutate({ status: 'resolved', note }, { onSuccess: () => { setSelected(null); toast('Incident resolved.'); } })}>Resolve</Button>}
        </DialogActions>
      </Dialog>
    </>
  );
}
