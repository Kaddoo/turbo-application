import { useEffect, useMemo, useState } from 'react';
import type { Schemas } from '@/types';
import { MapView, type MapMarker } from '@/components/MapView';
import { Banner, Button, Card, Chip, ConfirmDialog, DataTable, Dialog, DialogActions, ErrorState, PageHeader, Skeleton, Tabs, TextArea, TextField, useToast, ui } from '@/components';
import { formatKm, formatPesewas } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useServiceArea, useSettings } from '@/hooks';
import { useRemovePickupPoint, useSaveBoundary, useSaveFareBands, useSavePickupPoint, useSaveSettings } from './queries';

type Tab = 'boundary' | 'pickups' | 'fares' | 'settings';

export function Configuration() {
  const [tab, setTab] = useState<Tab>('boundary');
  const area = useServiceArea();
  return (
    <>
      <PageHeader title="Configuration" description="Service boundary, pickup points, fares and operating settings. Changes apply to new quotes only." />
      <Tabs value={tab} onChange={setTab} tabs={[
        { value: 'boundary', label: 'Boundary' }, { value: 'pickups', label: 'Pickup points' }, { value: 'fares', label: 'Fare bands' }, { value: 'settings', label: 'Settings' },
      ]} />
      {area.isPending ? <Card><Skeleton /></Card> : area.error ? <ErrorState error={area.error} onRetry={() => void area.refetch()} />
        : tab === 'boundary' ? <BoundaryTab area={area.data} />
        : tab === 'pickups' ? <PickupsTab area={area.data} />
        : tab === 'fares' ? <FaresTab area={area.data} />
        : <SettingsTab />}
    </>
  );
}

/** Ray casting; good enough to warn about pickup points outside a drawn polygon. */
function inside(lat: number, lng: number, poly: [number, number][]) {
  let c = false;
  for (let i = 0, j = poly.length - 1; i < poly.length; j = i++) {
    const [yi, xi] = poly[i]!; const [yj, xj] = poly[j]!;
    if ((yi > lat) !== (yj > lat) && lng < ((xj - xi) * (lat - yi)) / (yj - yi) + xi) c = !c;
  }
  return c;
}

function BoundaryTab({ area }: { area: Schemas['ServiceArea'] }) {
  const toast = useToast();
  const current = useMemo<[number, number][]>(() => (area.boundary?.coordinates[0] ?? []).slice(0, -1).map(([lng, lat]) => [lat!, lng!]), [area.boundary]);
  const [points, setPoints] = useState<[number, number][]>(current);
  const [confirming, setConfirming] = useState(false);
  useEffect(() => setPoints(current), [current]);
  const outside = points.length >= 3 ? area.pickupPoints.filter((p) => p.isActive && !inside(p.point.lat, p.point.lng, points)) : [];
  const save = useSaveBoundary();
  const markers: MapMarker[] = [
    ...points.map((p, i) => ({ id: `v${i}`, lat: p[0], lng: p[1], tone: 'accent' as const, label: `Corner ${i + 1}` })),
    ...area.pickupPoints.map((p) => ({ id: p.id, lat: p.point.lat, lng: p.point.lng, tone: (p.isActive ? 'success' : 'neutral') as MapMarker['tone'], label: p.name })),
  ];
  return (
    <div className={ui.stack}>
      {area.boundary === null && <Banner tone="warning">The boundary ships empty. The pilot stays blocked until Turbo approves a drawn boundary and the road distances are checked against {formatKm(area.maxTripDistanceMeters)}.</Banner>}
      <p className={ui.muted} style={{ margin: 0 }}>Version {area.version}. Click the map to add corners in order. At least three corners make a boundary.</p>
      <MapView markers={markers} boundary={points.length >= 3 ? points : null} height={480} fit={false} onMapClick={(lat, lng) => setPoints((p) => [...p, [lat, lng]])} />
      <div className={ui.actions}>
        <Button onClick={() => setPoints((p) => p.slice(0, -1))} disabled={!points.length}>Undo last corner</Button>
        <Button variant="ghost" onClick={() => setPoints([])} disabled={!points.length}>Clear</Button>
        <Button variant="ghost" onClick={() => setPoints(current)}>Reset to saved</Button>
        <Button variant="primary" disabled={points.length < 3} onClick={() => setConfirming(true)}>Save boundary</Button>
      </div>
      <ConfirmDialog open={confirming} onClose={() => setConfirming(false)} title="Save the new boundary"
        body={<>Quotes outside this boundary will be refused. {outside.length
          ? <strong>{outside.length} active pickup point{outside.length === 1 ? '' : 's'} would fall outside: {outside.map((p) => p.name).join(', ')}.</strong>
          : 'All active pickup points fall inside.'}</>}
        confirmLabel="Save boundary" typeToConfirm="SAVE" busy={save.isPending} error={save.error}
        onConfirm={() => save.mutate({ boundary: {
          type: 'Polygon', coordinates: [[...points, points[0]!].map(([lat, lng]) => [lng, lat])],
        } }, { onSuccess: () => { setConfirming(false); toast('Boundary saved. It applies to new quotes.'); } })} />
    </div>
  );
}

function PickupsTab({ area }: { area: Schemas['ServiceArea'] }) {
  const toast = useToast();
  const [editing, setEditing] = useState<{ id: string | null; name: string; lat: string; lng: string; isActive: boolean } | null>(null);
  const [removing, setRemoving] = useState<Schemas['PickupPoint'] | null>(null);
  const save = useSavePickupPoint();
  const remove = useRemovePickupPoint();
  const valid = editing && editing.name.trim() && Number.isFinite(Number(editing.lat)) && Number.isFinite(Number(editing.lng)) && editing.lat && editing.lng;
  return (
    <div className={ui.stack}>
      <div className={ui.actions}><Button variant="primary" onClick={() => setEditing({ id: null, name: '', lat: '', lng: '', isActive: true })}>Add pickup point</Button></div>
      <DataTable label="Pickup points" rows={area.pickupPoints} rowKey={(r) => r.id}
        onRowClick={(r) => setEditing({ id: r.id, name: r.name, lat: String(r.point.lat), lng: String(r.point.lng), isActive: r.isActive })}
        empty={{ title: 'No pickup points yet', body: 'Add the gates and halls students wait at.' }}
        columns={[
          { header: 'Name', cell: (r) => r.name },
          { header: 'Location', cell: (r) => <span className={ui.num}>{r.point.lat.toFixed(5)}, {r.point.lng.toFixed(5)}</span> },
          { header: 'Status', cell: (r) => <Chip tone={r.isActive ? 'success' : 'neutral'}>{r.isActive ? 'Active' : 'Inactive'}</Chip> },
          { header: '', cell: (r) => <Button small variant="ghost" onClick={(e) => { e.stopPropagation(); setRemoving(r); }}>Remove</Button> },
        ]} />
      <Dialog open={!!editing} onClose={() => setEditing(null)} title={editing?.id ? 'Edit pickup point' : 'Add pickup point'}>
        {editing && <>
          <TextField label="Name" value={editing.name} onChange={(e) => setEditing({ ...editing, name: e.target.value })} maxLength={80} hint="Students see this, e.g. “Main gate”." />
          <MapView markers={editing.lat && editing.lng ? [{ id: 'p', lat: Number(editing.lat), lng: Number(editing.lng), tone: 'accent', label: editing.name || 'New point' }] : []}
            height={220} fit={false} onMapClick={(lat, lng) => setEditing({ ...editing, lat: lat.toFixed(6), lng: lng.toFixed(6) })} />
          <p className={ui.muted} style={{ margin: 0 }}>Click the map to place the point.</p>
          <label className={ui.row}><input type="checkbox" checked={editing.isActive} onChange={(e) => setEditing({ ...editing, isActive: e.target.checked })} /> Active</label>
        </>}
        {save.error ? <p role="alert" className={ui.muted}>{problemMessage(save.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setEditing(null)}>Cancel</Button>
          <Button variant="primary" busy={save.isPending} disabled={!valid} onClick={() => save.mutate({ id: editing!.id, body: { name: editing!.name, point: { lat: Number(editing!.lat), lng: Number(editing!.lng) }, isActive: editing!.isActive } }, { onSuccess: () => { setEditing(null); toast('Pickup point saved.'); } })}>Save</Button>
        </DialogActions>
      </Dialog>
      <ConfirmDialog open={!!removing} onClose={() => setRemoving(null)} title="Remove pickup point" body={`Students can no longer choose ${removing?.name ?? ''}. Past rides keep it.`}
        confirmLabel="Remove" danger busy={remove.isPending} error={remove.error}
        onConfirm={() => remove.mutate(removing!.id, { onSuccess: () => { setRemoving(null); toast('Pickup point removed.'); } })} />
    </div>
  );
}

function FaresTab({ area }: { area: Schemas['ServiceArea'] }) {
  const toast = useToast();
  const [bands, setBands] = useState(area.fareBands.map((b) => ({ km: String(b.upToMeters / 1000), cedis: String(b.farePesewas / 100) })));
  const [confirming, setConfirming] = useState(false);
  const parsed = bands.map((b) => ({ upToMeters: Math.round(Number(b.km) * 1000), farePesewas: /^\d+$/.test(b.cedis) ? Number(b.cedis) * 100 : NaN }));
  const errors = parsed.map((b, i) => (!Number.isFinite(b.farePesewas) ? 'Whole cedis only.' : !(b.upToMeters > 0) ? 'Enter a distance.' : i > 0 && b.upToMeters <= parsed[i - 1]!.upToMeters ? 'Each band must go further than the one before.' : null));
  const save = useSaveFareBands();
  return (
    <Card title="Fare bands">
      <p className={ui.muted} style={{ marginTop: 0 }}>Distance is the road route. Upper bounds are inclusive: exactly 3.0 km is in the first band. Trips beyond the last band cannot be booked. Changes only affect new quotes; a quoted fare is locked.</p>
      <div className={ui.stack} style={{ gap: 8 }}>
        {bands.map((b, i) => (
          <div key={i} className={ui.row} style={{ alignItems: 'flex-start' }}>
            <TextField label={`Band ${i + 1}: up to (km)`} inputMode="decimal" value={b.km} onChange={(e) => setBands(bands.map((x, j) => (j === i ? { ...x, km: e.target.value } : x)))} />
            <TextField label="Fare (GH₵)" inputMode="numeric" value={b.cedis} error={errors[i] ?? undefined} onChange={(e) => setBands(bands.map((x, j) => (j === i ? { ...x, cedis: e.target.value } : x)))} />
            <Button small variant="ghost" style={{ marginTop: 26 }} disabled={bands.length === 1} onClick={() => setBands(bands.filter((_, j) => j !== i))}>Remove</Button>
          </div>
        ))}
        <div className={ui.actions}>
          <Button onClick={() => setBands([...bands, { km: '', cedis: '' }])}>Add band</Button>
          <Button variant="primary" disabled={errors.some(Boolean)} onClick={() => setConfirming(true)}>Save fares</Button>
        </div>
      </div>
      <ConfirmDialog open={confirming} onClose={() => setConfirming(false)} title="Save new fares"
        body={<>New quotes will use: {parsed.map((b) => `${formatKm(b.upToMeters)} ${formatPesewas(b.farePesewas)}`).join(' · ')}. Quotes already given keep their fare.</>}
        confirmLabel="Save fares" busy={save.isPending} error={save.error}
        onConfirm={() => save.mutate({ bands: parsed }, { onSuccess: () => { setConfirming(false); toast('Fares saved.'); } })} />
    </Card>
  );
}

const settingFields: { key: keyof Schemas['Settings']; label: string; hint: string; unit?: 'pesewas' }[] = [
  { key: 'maxTripDistanceMeters', label: 'Longest trip (metres)', hint: 'Default 18000.' },
  { key: 'quoteTtlSeconds', label: 'Quote lifetime (seconds)', hint: 'How long a quoted fare stays valid.' },
  { key: 'driverAckTimeoutSeconds', label: 'Driver must accept within (seconds)', hint: 'Then the ride goes to the next driver.' },
  { key: 'noDriverTimeoutSeconds', label: 'Stop searching after (seconds)', hint: 'Then the ride is cancelled for free.' },
  { key: 'driverSilenceSeconds', label: 'Driver unreachable after (seconds)', hint: 'No location for this long flags the ride.' },
  { key: 'noShowWaitSeconds', label: 'No-show wait (seconds)', hint: 'Before a driver can report the student not here.' },
  { key: 'quoteLimitPerMinute', label: 'Quotes per student per minute', hint: 'Each quote can cost a maps call.' },
  { key: 'smsDailyLimit', label: 'SMS per day', hint: 'Stops SMS abuse running up costs.' },
  { key: 'minTopupPesewas', label: 'Smallest top-up (GH₵)', hint: '', unit: 'pesewas' },
  { key: 'maxTopupPesewas', label: 'Largest top-up (GH₵)', hint: '', unit: 'pesewas' },
  { key: 'adjustmentApprovalThresholdPesewas', label: 'Adjustments need approval above (GH₵)', hint: '', unit: 'pesewas' },
  { key: 'locationRetentionDays', label: 'Keep location history (days)', hint: 'Then only the ride summary stays.' },
];

function SettingsTab() {
  const toast = useToast();
  const q = useSettings();
  const [draft, setDraft] = useState<Schemas['Settings'] | null>(null);
  const [pauseOpen, setPauseOpen] = useState(false);
  const [pauseMessage, setPauseMessage] = useState('');
  useEffect(() => { if (q.data) setDraft(q.data); }, [q.data]);
  const save = useSaveSettings();
  if (q.isPending || !draft) return <Card><Skeleton /></Card>;
  if (q.error) return <ErrorState error={q.error} onRetry={() => void q.refetch()} />;
  const paused = !!q.data.bookingsPaused;
  const show = (k: keyof Schemas['Settings'], unit?: 'pesewas') => {
    const v = draft[k] as number | undefined;
    return v == null ? '' : unit ? String(v / 100) : String(v);
  };
  const set = (k: keyof Schemas['Settings'], raw: string, unit?: 'pesewas') => {
    const n = /^\d+$/.test(raw) ? Number(raw) : NaN;
    setDraft({ ...draft, [k]: Number.isNaN(n) ? undefined : unit ? n * 100 : n });
  };
  return (
    <div className={ui.stack}>
      <Card title="Pause bookings">
        {paused ? <Banner tone="danger">Bookings are paused. Students see: “{q.data.pauseMessage}”</Banner>
          : <p className={ui.muted} style={{ marginTop: 0 }}>Use for rain, an incident or a protest. Rides already under way continue.</p>}
        <div className={ui.actions} style={{ marginTop: 12 }}>
          <Button variant={paused ? 'primary' : 'danger'} onClick={() => { setPauseMessage(q.data.pauseMessage ?? ''); setPauseOpen(true); }}>{paused ? 'Resume bookings' : 'Pause bookings'}</Button>
        </div>
      </Card>
      <Card title="Operating settings">
        <div className={ui.grid2}>
          {settingFields.map((f) => (
            <TextField key={f.key} label={f.label} hint={f.hint || undefined} inputMode="numeric" value={show(f.key, f.unit)} onChange={(e) => set(f.key, e.target.value, f.unit)} />
          ))}
        </div>
        {save.error ? <p role="alert" className={ui.muted}>{problemMessage(save.error)}</p> : null}
        <div className={ui.actions} style={{ marginTop: 16 }}>
          <Button variant="ghost" onClick={() => setDraft(q.data)}>Discard changes</Button>
          <Button variant="primary" busy={save.isPending} onClick={() => save.mutate(draft, { onSuccess: () => toast('Settings saved.') })}>Save settings</Button>
        </div>
      </Card>
      <Dialog open={pauseOpen} onClose={() => setPauseOpen(false)} title={paused ? 'Resume bookings' : 'Pause new bookings'}>
        {!paused && <TextArea label="Message students see" maxLength={200} value={pauseMessage} onChange={(e) => setPauseMessage(e.target.value)} hint="For example: Bookings are paused because of heavy rain. Back by 6 pm." />}
        <p className={ui.muted} style={{ margin: 0 }}>{paused ? 'Students can request rides again straight away.' : 'Quotes are refused with your message until you resume.'}</p>
        {save.error ? <p role="alert" className={ui.muted}>{problemMessage(save.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setPauseOpen(false)}>Cancel</Button>
          <Button variant={paused ? 'primary' : 'danger'} busy={save.isPending} disabled={!paused && pauseMessage.trim().length < 3}
            onClick={() => save.mutate({ ...q.data, bookingsPaused: !paused, pauseMessage: paused ? null : pauseMessage }, { onSuccess: () => { setPauseOpen(false); toast(paused ? 'Bookings resumed.' : 'Bookings paused.'); } })}>
            {paused ? 'Resume bookings' : 'Pause bookings'}
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
}
