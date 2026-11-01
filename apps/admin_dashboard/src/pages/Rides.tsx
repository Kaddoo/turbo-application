import { useEffect, useMemo, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { useNavigate, useParams, useSearchParams } from 'react-router';
import { api, call, newIdempotencyKey } from '@/services/http';
import type { Schemas } from '@/types';
import { canUse } from '@/utils/roles';
import { useSession } from '@/state/session';
import { MapView, type MapMarker } from '@/components/MapView';
import {
  Banner, Button, Card, Chip, DataTable, Details, Dialog, DialogActions, ErrorState, Money, PageHeader, Select, Skeleton,
  TextArea, TextField, useToast, ui, When, type Tone,
} from '@/components';
import { formatKm, formatPesewas, formatRelative, formatTime, humanize, parseCedis } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useAction, useCursorList } from '@/hooks';

type RideStatus = Schemas['RideStatus'];
type RideFlag = Schemas['RideFlag'];

export const rideTone: Record<RideStatus, Tone> = {
  searching: 'warning', assigned: 'accent', driver_arrived: 'accent', in_progress: 'success', completed: 'neutral', cancelled: 'neutral',
};
const flagTone: Record<RideFlag, Tone> = {
  driver_unreachable: 'danger', overdue: 'danger', completed_far_from_destination: 'warning', completed_too_fast: 'warning',
};
const flagLabel: Record<RideFlag, string> = {
  driver_unreachable: 'Driver unreachable', overdue: 'Overdue', completed_far_from_destination: 'Ended far from drop-off', completed_too_fast: 'Ended too fast',
};

export function Flags({ flags }: { flags?: RideFlag[] }) {
  if (!flags?.length) return null;
  return <span className={ui.row}>{flags.map((f) => <Chip key={f} tone={flagTone[f]}>{flagLabel[f]}</Chip>)}</span>;
}

function useTabVisible() {
  const [visible, setVisible] = useState(!document.hidden);
  useEffect(() => {
    const on = () => setVisible(!document.hidden);
    document.addEventListener('visibilitychange', on);
    return () => document.removeEventListener('visibilitychange', on);
  }, []);
  return visible;
}

export function LiveMapPage() {
  const navigate = useNavigate();
  const visible = useTabVisible();
  const q = useQuery({
    queryKey: ['live'], queryFn: () => call(api.GET('/admin/rides/live')),
    refetchInterval: visible ? 5_000 : false,
  });
  const [, tick] = useState(0);
  useEffect(() => { const t = setInterval(() => tick((x) => x + 1), 1000); return () => clearInterval(t); }, []);

  const markers = useMemo<MapMarker[]>(() => {
    if (!q.data) return [];
    const onRide = new Set(q.data.rides.map((r) => r.ride.driverId));
    return [
      ...q.data.onDutyDrivers.filter((d) => d.location && !onRide.has(d.driverId)).map((d) => ({
        id: d.driverId, lat: d.location!.point.lat, lng: d.location!.point.lng, tone: 'success' as const, label: `${d.fullName} · idle`,
      })),
      ...q.data.rides.filter((r) => r.driverLocation).map((r) => ({
        id: r.ride.id, lat: r.driverLocation!.point.lat, lng: r.driverLocation!.point.lng,
        tone: (r.ride.flags?.length ? 'danger' : 'accent') as MapMarker['tone'],
        label: `${r.ride.driverName ?? 'Driver'} · ${humanize(r.ride.status)}${r.ride.flags?.length ? ' · flagged' : ''}`,
        onClick: () => navigate(`/rides/${r.ride.id}`),
      })),
    ];
  }, [q.data, navigate]);

  const updated = q.dataUpdatedAt ? Math.round((Date.now() - q.dataUpdatedAt) / 1000) : null;
  return (
    <>
      <PageHeader title="Live map" description="On-duty drivers and active rides. Refreshes every 5 seconds while this tab is open."
        actions={<span className={ui.muted} aria-live="polite">{!visible ? 'Paused while the tab is hidden' : updated !== null ? `Updated ${updated} s ago` : 'Loading…'}</span>} />
      {q.error && <Banner tone="danger">{problemMessage(q.error)} The map shows the last positions we had.</Banner>}
      {q.data && q.data.onDutyDrivers.length === 0 && <Banner tone="warning">No drivers on duty. Students asking for a ride are being refused.</Banner>}
      <div className={ui.grid2} style={{ gridTemplateColumns: 'minmax(0, 2fr) minmax(18rem, 1fr)' }}>
        <MapView markers={markers} height={560} />
        <Card title={`Active rides (${q.data?.rides.length ?? 0})`}>
          {q.isPending ? <Skeleton /> : !q.data?.rides.length ? <p className={ui.muted} style={{ margin: 0 }}>No rides right now.</p> : (
            <div className={ui.stack} style={{ gap: 12 }}>
              {q.data.rides.map(({ ride }) => (
                <button key={ride.id} type="button" onClick={() => navigate(`/rides/${ride.id}`)} className={ui.card}
                  style={{ textAlign: 'left', cursor: 'pointer', font: 'inherit', color: 'inherit', padding: 12, display: 'grid', gap: 6 }}>
                  <span className={ui.row}><Chip tone={rideTone[ride.status]}>{humanize(ride.status)}</Chip><Flags flags={ride.flags} /></span>
                  <span>{ride.studentName ?? 'Student'} with {ride.driverName ?? 'no driver yet'}</span>
                  <span className={ui.muted}>{formatKm(ride.routeDistanceMeters)} · {formatPesewas(ride.farePesewas)} · requested {formatRelative(ride.requestedAt)}</span>
                </button>
              ))}
            </div>
          )}
          <p className={ui.muted} style={{ marginBottom: 0 }}>
            {q.data ? `${q.data.onDutyDrivers.length} on duty, ${q.data.onDutyDrivers.filter((d) => d.idle).length} idle.` : ''}
          </p>
        </Card>
      </div>
    </>
  );
}

export function RidesPage() {
  const navigate = useNavigate();
  const [params, setParams] = useSearchParams();
  const status = params.get('status') ?? '';
  const flag = params.get('flag') ?? '';
  const from = params.get('from') ?? '';
  const to = params.get('to') ?? '';
  const set = (k: string, v: string) => { const p = new URLSearchParams(params); if (v) p.set(k, v); else p.delete(k); setParams(p, { replace: true }); };
  const list = useCursorList(['rides', status, flag, from, to], (cursor) => call(api.GET('/admin/rides', { params: { query: {
    status: (status || undefined) as RideStatus | undefined, flag: (flag || undefined) as RideFlag | undefined,
    from: from ? new Date(`${from}T00:00:00Z`).toISOString() : undefined, to: to ? new Date(`${to}T23:59:59Z`).toISOString() : undefined,
    cursor, limit: 25,
  } } })));
  return (
    <>
      <PageHeader title="Rides" description="Every ride, newest first. Open one for its timeline and the actions your role allows." />
      <div className={ui.filters}>
        <Select label="Status" value={status} onChange={(e) => set('status', e.target.value)}
          options={[{ value: '', label: 'Any' }, ...(['searching', 'assigned', 'driver_arrived', 'in_progress', 'completed', 'cancelled'] as RideStatus[]).map((s) => ({ value: s, label: humanize(s) }))]} />
        <Select label="Flag" value={flag} onChange={(e) => set('flag', e.target.value)}
          options={[{ value: '', label: 'Any' }, ...(Object.keys(flagLabel) as RideFlag[]).map((f) => ({ value: f, label: flagLabel[f] }))]} />
        <TextField label="From" type="date" value={from} onChange={(e) => set('from', e.target.value)} />
        <TextField label="To" type="date" value={to} onChange={(e) => set('to', e.target.value)} />
      </div>
      <DataTable label="Rides" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore} onRowClick={(r) => navigate(`/rides/${r.id}`)}
        empty={{ title: 'No rides match', body: 'Clear a filter to see more.' }}
        columns={[
          { header: 'Requested', cell: (r) => <When iso={r.requestedAt} exact /> },
          { header: 'Status', cell: (r) => <span className={ui.row}><Chip tone={rideTone[r.status]}>{humanize(r.status)}</Chip><Flags flags={r.flags} /></span> },
          { header: 'Student', cell: (r) => r.studentName ?? '—' },
          { header: 'Driver', cell: (r) => r.driverName ?? <span className={ui.muted}>Not assigned</span> },
          { header: 'Distance', align: 'right', cell: (r) => formatKm(r.routeDistanceMeters) },
          { header: 'Fare', align: 'right', cell: (r) => <Money pesewas={r.farePesewas} /> },
        ]} />
    </>
  );
}

export function RideDetailPage() {
  const { id = '' } = useParams();
  const { me } = useSession();
  const toast = useToast();
  const q = useQuery({ queryKey: ['ride', id], queryFn: () => call(api.GET('/admin/rides/{id}', { params: { path: { id } } })), refetchInterval: 10_000 });
  const live = useQuery({ queryKey: ['live'], queryFn: () => call(api.GET('/admin/rides/live')), enabled: canUse(me?.staffRole, 'liveMap') });
  const [dialog, setDialog] = useState<'reassign' | 'cancel' | 'complete' | 'refund' | null>(null);
  const [reason, setReason] = useState('');
  const [driverId, setDriverId] = useState('');
  const [completeCode, setCompleteCode] = useState<Schemas['AdminCompleteRequest']['reasonCode']>('driver_unreachable');
  const [refund, setRefund] = useState({ amount: '', reasonCode: 'service_issue' as Schemas['RefundRequest']['reasonCode'] });
  const [refundKey, setRefundKey] = useState(newIdempotencyKey);
  const close = () => { setDialog(null); setReason(''); };
  const inval = [['ride', id], ['rides'], ['live']];

  const reassign = useAction(() => call(api.POST('/admin/rides/{id}/reassign', { params: { path: { id } }, body: { driverId, reason } })), inval);
  const cancel = useAction(() => call(api.POST('/admin/rides/{id}/cancel', { params: { path: { id } }, body: { reason } })), inval);
  const complete = useAction(() => call(api.POST('/admin/rides/{id}/complete', { params: { path: { id } }, body: { reasonCode: completeCode, note: reason } })), inval);
  const doRefund = useAction(() => {
    const amount = refund.amount ? parseCedis(refund.amount) : null;
    return call(api.POST('/admin/rides/{id}/refund', {
      params: { path: { id }, header: { 'Idempotency-Key': refundKey } },
      body: { reasonCode: refund.reasonCode, note: reason, ...(amount ? { amountPesewas: amount } : {}) },
    }));
  }, inval);

  if (q.isPending) return <Card><Skeleton /><br /><Skeleton width="50%" /></Card>;
  if (q.error) return <ErrorState error={q.error} onRetry={() => void q.refetch()} />;
  const { ride, student, driver, events, flags } = q.data;
  const role = me?.staffRole;
  const active = ['searching', 'assigned', 'driver_arrived', 'in_progress'].includes(ride.status);
  const canDispatch = canUse(role, 'rides');
  const refundable = ride.payment.chargedPesewas - ride.payment.refundedPesewas;
  const idleDrivers = live.data?.onDutyDrivers.filter((d) => d.idle && d.driverId !== driver?.id) ?? [];
  const refundAmount = refund.amount ? parseCedis(refund.amount) : refundable;

  const markers: MapMarker[] = [
    { id: 'pickup', lat: ride.pickup.point.lat, lng: ride.pickup.point.lng, tone: 'success', label: `Pickup: ${ride.pickup.label ?? ''}` },
    { id: 'dropoff', lat: ride.dropoff.point.lat, lng: ride.dropoff.point.lng, tone: 'danger', label: `Drop-off: ${ride.dropoff.label ?? ''}` },
    ...(driver?.lastLocation ? [{ id: 'driver', lat: driver.lastLocation.point.lat, lng: driver.lastLocation.point.lng, tone: 'accent' as const, label: `${driver.fullName}, last seen ${formatRelative(driver.lastLocation.recordedAt)}` }] : []),
  ];

  return (
    <>
      <PageHeader title={`${ride.pickup.label ?? 'Pickup'} → ${ride.dropoff.label ?? 'Drop-off'}`}
        description={`Requested ${formatRelative(ride.requestedAt)} · ${formatKm(ride.routeDistanceMeters)} · fare locked at ${formatPesewas(ride.farePesewas)}`}
        actions={<><Chip tone={rideTone[ride.status]}>{humanize(ride.status)}</Chip><Flags flags={flags} /></>} />
      {flags?.includes('driver_unreachable') && (
        <Banner tone="danger">No location from the driver for several minutes. Contact the driver; if the trip is over, force-complete it so the student can book again.</Banner>
      )}
      <div className={ui.actions}>
        {canDispatch && active && ride.status !== 'in_progress' && <Button onClick={() => setDialog('reassign')}>Reassign</Button>}
        {canDispatch && active && <Button variant="danger" onClick={() => setDialog('cancel')}>Cancel ride</Button>}
        {canDispatch && ride.status === 'in_progress' && <Button variant="primary" onClick={() => setDialog('complete')}>Force-complete</Button>}
        {canUse(role, 'finance') && refundable > 0 && <Button onClick={() => { setRefundKey(newIdempotencyKey()); setDialog('refund'); }}>Refund</Button>}
      </div>
      <div className={ui.grid2}>
        <Card title="Route"><MapView markers={markers} lines={[{ id: 'r', tone: 'accent', points: [[ride.pickup.point.lat, ride.pickup.point.lng], [ride.dropoff.point.lat, ride.dropoff.point.lng]] }]} height={320} /></Card>
        <div className={ui.stack}>
          <Card title="People">
            <Details items={[
              ['Student', student.fullName ?? '—'],
              ['Driver', driver ? driver.fullName : 'Not assigned'],
              ['Vehicle', driver?.vehicle ? `${driver.vehicle.plateNumber} · ${driver.vehicle.make} ${driver.vehicle.model}` : '—'],
              ['Pickup landmark', ride.pickup.landmark ?? '—'],
            ]} />
          </Card>
          <Card title="Payment">
            <Details items={[
              ['Status', <Chip tone={ride.payment.status === 'charged' ? 'success' : 'neutral'}>{humanize(ride.payment.status)}</Chip>],
              ['Held', <Money pesewas={ride.payment.heldPesewas} />],
              ['Charged', <Money pesewas={ride.payment.chargedPesewas} />],
              ['Refunded', <Money pesewas={ride.payment.refundedPesewas} />],
            ]} />
          </Card>
          {ride.cancellation && (
            <Card title="Cancellation">
              <Details items={[['By', humanize(ride.cancellation.by)], ['Reason', humanize(ride.cancellation.reasonCode)], ['Note', ride.cancellation.note ?? '—'], ['When', <When iso={ride.cancellation.cancelledAt} exact />]]} />
            </Card>
          )}
        </div>
      </div>
      <Card title="Timeline">
        <ol style={{ margin: 0, paddingLeft: 20, display: 'grid', gap: 10 }}>
          {events.map((e, i) => (
            <li key={`${e.at}-${i}`}>
              <strong>{humanize(e.type)}</strong> <span className={ui.muted}>· {formatTime(e.at)} · {e.actor.startsWith('staff:') ? 'staff' : e.actor}</span>
              {e.detail && <div className={ui.muted}>{e.detail}</div>}
            </li>
          ))}
        </ol>
      </Card>

      <Dialog open={dialog === 'reassign'} onClose={close} title="Reassign to another driver">
        <Select label="Driver" value={driverId} onChange={(e) => setDriverId(e.target.value)}
          options={[{ value: '', label: idleDrivers.length ? 'Choose an idle driver' : 'No idle drivers right now' }, ...idleDrivers.map((d) => ({ value: d.driverId, label: d.fullName }))]} />
        <TextArea label="Reason" value={reason} onChange={(e) => setReason(e.target.value)} maxLength={300} />
        {reassign.error ? <p role="alert" className={ui.muted}>{problemMessage(reassign.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={close}>Cancel</Button>
          <Button variant="primary" busy={reassign.isPending} disabled={!driverId || reason.trim().length < 3}
            onClick={() => reassign.mutate(undefined, { onSuccess: () => { close(); toast('Ride reassigned. Both people have been told.'); } })}>Reassign</Button>
        </DialogActions>
      </Dialog>

      <Dialog open={dialog === 'cancel'} onClose={close} title="Cancel this ride">
        <p className={ui.muted} style={{ margin: 0 }}>
          {ride.status === 'in_progress'
            ? 'The trip is under way. Cancelling releases the held fare; refund any amount separately if needed.'
            : `The held fare of ${formatPesewas(ride.payment.heldPesewas)} goes back to the student. Cancellations are free for students.`}
        </p>
        <TextArea label="Reason" value={reason} onChange={(e) => setReason(e.target.value)} maxLength={300} />
        {cancel.error ? <p role="alert" className={ui.muted}>{problemMessage(cancel.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={close}>Keep the ride</Button>
          <Button variant="danger" busy={cancel.isPending} disabled={reason.trim().length < 3}
            onClick={() => cancel.mutate(undefined, { onSuccess: () => { close(); toast('Ride cancelled. The hold is released.'); } })}>Cancel ride</Button>
        </DialogActions>
      </Dialog>

      <Dialog open={dialog === 'complete'} onClose={close} title="Force-complete this ride">
        <Banner tone="warning">The locked fare of {formatPesewas(ride.farePesewas)} is charged to the student. Use this only when the trip really ended.</Banner>
        <Select label="Why" value={completeCode} onChange={(e) => setCompleteCode(e.target.value as typeof completeCode)}
          options={['driver_unreachable', 'app_failure', 'driver_forgot', 'other'].map((c) => ({ value: c, label: humanize(c) }))} />
        <TextArea label="Note" hint="At least 5 characters. Kept in the audit log." value={reason} onChange={(e) => setReason(e.target.value)} maxLength={300} />
        {complete.error ? <p role="alert" className={ui.muted}>{problemMessage(complete.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={close}>Cancel</Button>
          <Button variant="primary" busy={complete.isPending} disabled={reason.trim().length < 5}
            onClick={() => complete.mutate(undefined, { onSuccess: () => { close(); toast('Ride completed and charged.'); } })}>Complete and charge</Button>
        </DialogActions>
      </Dialog>

      <Dialog open={dialog === 'refund'} onClose={close} title="Refund this ride">
        <p className={ui.muted} style={{ margin: 0 }}>Up to {formatPesewas(refundable)} can be refunded. Leave the amount empty for the full amount.</p>
        <TextField label="Amount (GH₵)" inputMode="decimal" placeholder={(refundable / 100).toFixed(2)} value={refund.amount}
          onChange={(e) => setRefund({ ...refund, amount: e.target.value })}
          error={refund.amount && (refundAmount === null || refundAmount <= 0 || refundAmount > refundable) ? `Enter an amount up to ${formatPesewas(refundable)}.` : undefined} />
        <Select label="Reason" value={refund.reasonCode} onChange={(e) => setRefund({ ...refund, reasonCode: e.target.value as typeof refund.reasonCode })}
          options={['driver_cancelled', 'service_issue', 'breakdown', 'partial_trip', 'wrong_charge', 'other'].map((c) => ({ value: c, label: humanize(c) }))} />
        <TextArea label="Note" value={reason} onChange={(e) => setReason(e.target.value)} maxLength={300} />
        {doRefund.error ? <p role="alert" className={ui.muted}>{problemMessage(doRefund.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={close}>Cancel</Button>
          <Button variant="primary" busy={doRefund.isPending}
            disabled={reason.trim().length < 3 || refundAmount === null || refundAmount <= 0 || refundAmount > refundable}
            onClick={() => doRefund.mutate(undefined, { onSuccess: () => { close(); toast(`Refunded ${formatPesewas(refundAmount ?? refundable)} to the student’s wallet.`); } })}>
            Refund {formatPesewas(refundAmount ?? refundable)}
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
}
