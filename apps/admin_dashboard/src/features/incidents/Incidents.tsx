import { useMemo, useState } from 'react';
import { Link } from 'react-router';
import type { Schemas } from '@/types';
import { MapView } from '@/components/MapView';
import {
  Button,
  Chip,
  DataTable,
  Details,
  Dialog,
  DialogActions,
  PageHeader,
  Select,
  TextArea,
  useToast,
  ui,
  When,
  type Tone,
  CardFoot,
  CardTop,
  Callout,
  Title,
} from '@/components';
import { humanize } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useIncidents, useUpdateIncident } from './queries';

type Incident = Schemas['Incident'];
const incidentTone: Record<Incident['status'], Tone> = { open: 'danger', acknowledged: 'warning', resolved: 'success' };

export function Incidents() {
  const toast = useToast();
  const [status, setStatus] = useState('open');
  const list = useIncidents(status);
  const [selected, setSelected] = useState<Incident | null>(null);
  const [note, setNote] = useState('');
  const act = useUpdateIncident();
  const markers = useMemo(
    () =>
      selected?.location
        ? [
            {
              id: selected.id,
              lat: selected.location.lat,
              lng: selected.location.lng,
              tone: 'danger' as const,
              label: 'Last known location',
            },
          ]
        : [],
    [selected],
  );
  const minutes = (iso: string) => (Date.now() - new Date(iso).getTime()) / 60_000;

  return (
    <>
      <PageHeader
        title="Incidents"
        description="SOS alerts and safety reports. Acknowledge an SOS within 2 minutes; after that it turns more urgent."
      />
      <div className={ui.filters}>
        <Select
          label="Status"
          value={status}
          onChange={(e) => setStatus(e.target.value)}
          options={[
            { value: '', label: 'Any' },
            ...['open', 'acknowledged', 'resolved'].map((s) => ({ value: s, label: humanize(s) })),
          ]}
        />
      </div>
      <DataTable
        label="Incidents"
        rows={list.rows}
        rowKey={(r) => r.id}
        loading={list.loading}
        error={list.error}
        onRetry={list.refetch}
        hasMore={list.hasMore}
        onLoadMore={list.loadMore}
        loadingMore={list.loadingMore}
        onRowClick={(r) => {
          setSelected(r);
          setNote('');
        }}
        empty={{
          title: status === 'open' ? 'No open incidents' : 'No incidents',
          body: 'An SOS from the apps appears here and as a red banner on every page.',
        }}
        card={(r) => <IncidentCard r={r} />}
        cardTone={(r) => (r.status === 'open' ? 'danger' : incidentTone[r.status])}
        columns={[
          { header: 'Raised', cell: (r) => <When iso={r.createdAt} exact /> },
          {
            header: 'Type',
            cell: (r) => (
              <Chip tone={r.type === 'sos' ? 'danger' : 'warning'}>{r.type === 'sos' ? 'SOS' : 'Safety report'}</Chip>
            ),
          },
          {
            header: 'Status',
            slot: 'badge',
            cell: (r) => (
              <span className={ui.row}>
                <Chip tone={incidentTone[r.status]}>{humanize(r.status)}</Chip>
                {r.status === 'open' && minutes(r.createdAt) > 2 && <Chip tone="danger">Over 2 min</Chip>}
              </span>
            ),
          },
          { header: 'Note', cell: (r) => r.note ?? '—' },
          {
            header: 'Ride',
            cell: (r) =>
              r.rideId ? (
                <Link to={`/rides/${r.rideId}`} onClick={(e) => e.stopPropagation()}>
                  Open ride
                </Link>
              ) : (
                '—'
              ),
          },
        ]}
      />
      <Dialog
        open={!!selected}
        onClose={() => setSelected(null)}
        title={selected?.type === 'sos' ? 'SOS' : 'Safety report'}
      >
        {selected && (
          <>
            <Details
              items={[
                ['Raised', <When iso={selected.createdAt} exact />],
                ['Status', humanize(selected.status)],
                ['Note', selected.note ?? '—'],
              ]}
            />
            {markers.length > 0 && <MapView markers={markers} height={220} />}
            <p className={ui.muted} style={{ margin: 0 }}>
              Call the student or driver through the campus security line, and send help to the location shown.
            </p>
            {selected.status !== 'resolved' && (
              <TextArea
                label={selected.status === 'open' ? 'Note (optional)' : 'How it was resolved'}
                value={note}
                onChange={(e) => setNote(e.target.value)}
                maxLength={1000}
              />
            )}
          </>
        )}
        {act.error ? (
          <p role="alert" className={ui.muted}>
            {problemMessage(act.error)}
          </p>
        ) : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setSelected(null)}>
            Close
          </Button>
          {selected?.status === 'open' && (
            <Button
              variant="danger"
              busy={act.isPending}
              onClick={() =>
                act.mutate(
                  { id: selected!.id, body: { status: 'acknowledged', ...(note ? { note } : {}) } },
                  {
                    onSuccess: () => {
                      setSelected(null);
                      toast('Acknowledged. Stay on it until it is resolved.');
                    },
                  },
                )
              }
            >
              Acknowledge
            </Button>
          )}
          {selected?.status === 'acknowledged' && (
            <Button
              variant="primary"
              busy={act.isPending}
              disabled={note.trim().length < 3}
              onClick={() =>
                act.mutate(
                  { id: selected!.id, body: { status: 'resolved', note } },
                  {
                    onSuccess: () => {
                      setSelected(null);
                      toast('Incident resolved.');
                    },
                  },
                )
              }
            >
              Resolve
            </Button>
          )}
        </DialogActions>
      </Dialog>
    </>
  );
}

function IncidentCard({ r }: { r: Incident }) {
  const mins = Math.round((Date.now() - new Date(r.createdAt).getTime()) / 60_000);
  return (
    <>
      <CardTop end={<Chip tone={incidentTone[r.status]}>{humanize(r.status)}</Chip>}>
        <Chip tone={r.type === 'sos' ? 'danger' : 'warning'}>{r.type === 'sos' ? 'SOS' : 'Safety report'}</Chip>
      </CardTop>
      {r.note ? <Title lines={3}>{r.note}</Title> : <span className={ui.muted}>No note left</span>}
      {r.status === 'open' && mins > 2 && (
        <Callout tone="danger" icon="danger">
          Open for {mins} min
        </Callout>
      )}
      <CardFoot
        end={
          r.rideId ? (
            <Link to={`/rides/${r.rideId}`} onClick={(e) => e.stopPropagation()}>
              Open ride
            </Link>
          ) : undefined
        }
      >
        <When iso={r.createdAt} exact />
      </CardFoot>
    </>
  );
}
