import { useEffect, useMemo, useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { api, call } from '@/services/http';
import type { Schemas } from '@/types';
import { roleLabels, type StaffRole } from '@/utils/roles';
import { useSession } from '@/state/session';
import { MapView, type MapMarker } from '@/components/MapView';
import {
  Banner, Button, Card, Chip, ConfirmDialog, DataTable, Details, Dialog, DialogActions, ErrorState, PageHeader, Select,
  Skeleton, Tabs, TextArea, TextField, useToast, ui, When,
} from '@/components';
import { formatKm, formatPesewas, humanize, shortId } from '@/utils/format';
import { problemMessage } from '@/utils/problems';
import { useAction, useCursorList } from '@/hooks';

type Tab = 'boundary' | 'pickups' | 'fares' | 'settings';

export function ConfigurationPage() {
  const [tab, setTab] = useState<Tab>('boundary');
  const area = useQuery({ queryKey: ['service-area'], queryFn: () => call(api.GET('/service-area')) });
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
  const save = useAction(() => call(api.PUT('/admin/service-area', { body: { boundary: {
    type: 'Polygon', coordinates: [[...points, points[0]!].map(([lat, lng]) => [lng, lat])],
  } } })), [['service-area']]);
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
        onConfirm={() => save.mutate(undefined, { onSuccess: () => { setConfirming(false); toast('Boundary saved. It applies to new quotes.'); } })} />
    </div>
  );
}

function PickupsTab({ area }: { area: Schemas['ServiceArea'] }) {
  const toast = useToast();
  const [editing, setEditing] = useState<{ id: string | null; name: string; lat: string; lng: string; isActive: boolean } | null>(null);
  const [removing, setRemoving] = useState<Schemas['PickupPoint'] | null>(null);
  const save = useAction(() => {
    const body = { name: editing!.name, point: { lat: Number(editing!.lat), lng: Number(editing!.lng) }, isActive: editing!.isActive };
    return editing!.id ? call(api.PATCH('/admin/pickup-points/{id}', { params: { path: { id: editing!.id } }, body })) : call(api.POST('/admin/pickup-points', { body }));
  }, [['service-area']]);
  const remove = useAction(() => call(api.DELETE('/admin/pickup-points/{id}', { params: { path: { id: removing!.id } } })), [['service-area']]);
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
          <Button variant="primary" busy={save.isPending} disabled={!valid} onClick={() => save.mutate(undefined, { onSuccess: () => { setEditing(null); toast('Pickup point saved.'); } })}>Save</Button>
        </DialogActions>
      </Dialog>
      <ConfirmDialog open={!!removing} onClose={() => setRemoving(null)} title="Remove pickup point" body={`Students can no longer choose ${removing?.name ?? ''}. Past rides keep it.`}
        confirmLabel="Remove" danger busy={remove.isPending} error={remove.error}
        onConfirm={() => remove.mutate(undefined, { onSuccess: () => { setRemoving(null); toast('Pickup point removed.'); } })} />
    </div>
  );
}

function FaresTab({ area }: { area: Schemas['ServiceArea'] }) {
  const toast = useToast();
  const [bands, setBands] = useState(area.fareBands.map((b) => ({ km: String(b.upToMeters / 1000), cedis: String(b.farePesewas / 100) })));
  const [confirming, setConfirming] = useState(false);
  const parsed = bands.map((b) => ({ upToMeters: Math.round(Number(b.km) * 1000), farePesewas: /^\d+$/.test(b.cedis) ? Number(b.cedis) * 100 : NaN }));
  const errors = parsed.map((b, i) => (!Number.isFinite(b.farePesewas) ? 'Whole cedis only.' : !(b.upToMeters > 0) ? 'Enter a distance.' : i > 0 && b.upToMeters <= parsed[i - 1]!.upToMeters ? 'Each band must go further than the one before.' : null));
  const save = useAction(() => call(api.PUT('/admin/fare-bands', { body: { bands: parsed } })), [['service-area']]);
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
        onConfirm={() => save.mutate(undefined, { onSuccess: () => { setConfirming(false); toast('Fares saved.'); } })} />
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
  const q = useQuery({ queryKey: ['settings'], queryFn: () => call(api.GET('/admin/settings')) });
  const [draft, setDraft] = useState<Schemas['Settings'] | null>(null);
  const [pauseOpen, setPauseOpen] = useState(false);
  const [pauseMessage, setPauseMessage] = useState('');
  useEffect(() => { if (q.data) setDraft(q.data); }, [q.data]);
  const save = useAction((s: Schemas['Settings']) => call(api.PUT('/admin/settings', { body: s })), [['settings']]);
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

export function AnnouncementsPage() {
  const toast = useToast();
  const [form, setForm] = useState<Schemas['AnnouncementCreate']>({ audience: 'students', title: '', body: '' });
  const [preview, setPreview] = useState(false);
  const [sent, setSent] = useState<Schemas['Announcement'][]>([]);
  const send = useAction(() => call(api.POST('/admin/announcements', { body: form })));
  return (
    <>
      <PageHeader title="Announcements" description="Push a short message to students, drivers or everyone. Preview before sending; it cannot be recalled." />
      <div className={ui.grid2}>
        <Card title="New announcement">
          <div className={ui.stack}>
            <Select label="Send to" value={form.audience} onChange={(e) => setForm({ ...form, audience: e.target.value as typeof form.audience })}
              options={[{ value: 'students', label: 'Students' }, { value: 'drivers', label: 'Drivers' }, { value: 'all', label: 'Everyone' }]} />
            <TextField label="Title" maxLength={80} value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value })} />
            <TextArea label="Message" maxLength={300} value={form.body} onChange={(e) => setForm({ ...form, body: e.target.value })} hint={`${form.body.length}/300`} />
            <div className={ui.actions}><Button variant="primary" disabled={form.title.trim().length < 3 || form.body.trim().length < 3} onClick={() => setPreview(true)}>Preview</Button></div>
          </div>
        </Card>
        <Card title="Sent this session">
          {sent.length === 0 ? <p className={ui.muted} style={{ margin: 0 }}>Nothing sent yet. The contract has no announcement history yet.</p> : sent.map((a) => (
            <div key={a.id} style={{ marginBottom: 12 }}>
              <strong>{a.title}</strong> <Chip>{humanize(a.audience)}</Chip>
              <div className={ui.muted}>{a.body}</div>
              <div className={ui.muted}>{a.recipientCount != null ? `${a.recipientCount} recipients · ` : ''}<When iso={a.createdAt} /></div>
            </div>
          ))}
        </Card>
      </div>
      <Dialog open={preview} onClose={() => setPreview(false)} title="Send this announcement?">
        <div className={ui.card}>
          <strong>{form.title}</strong>
          <p style={{ margin: '6px 0 0' }}>{form.body}</p>
        </div>
        <p className={ui.muted} style={{ margin: 0 }}>Goes to {form.audience === 'all' ? 'every student and driver' : `every ${form.audience.slice(0, -1)}`} as a push notification.</p>
        {send.error ? <p role="alert" className={ui.muted}>{problemMessage(send.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setPreview(false)}>Edit</Button>
          <Button variant="primary" busy={send.isPending} onClick={() => send.mutate(undefined, { onSuccess: (a) => { setSent((x) => [a, ...x]); setPreview(false); setForm({ ...form, title: '', body: '' }); toast('Announcement sent.'); } })}>Send now</Button>
        </DialogActions>
      </Dialog>
    </>
  );
}

const roles = Object.keys(roleLabels) as StaffRole[];

export function StaffPage() {
  const toast = useToast();
  const { me } = useSession();
  const list = useCursorList(['staff'], (cursor) => call(api.GET('/admin/staff', { params: { query: { cursor, limit: 50 } } })));
  const [inviting, setInviting] = useState(false);
  const [form, setForm] = useState<Schemas['StaffCreate']>({ email: '', fullName: '', staffRole: 'verifier' });
  const [selected, setSelected] = useState<Schemas['StaffUser'] | null>(null);
  const [confirm, setConfirm] = useState<'deactivate' | 'signout' | null>(null);
  const invite = useAction(() => call(api.POST('/admin/staff', { body: form })), [['staff']]);
  const update = useAction((b: Schemas['StaffUpdate']) => call(api.PATCH('/admin/staff/{id}', { params: { path: { id: selected!.id } }, body: b })), [['staff']]);
  const resend = useAction(() => call(api.POST('/admin/staff/{id}/invite', { params: { path: { id: selected!.id } } })));
  const signOut = useAction(() => call(api.DELETE('/admin/staff/{id}/sessions', { params: { path: { id: selected!.id } } })));
  return (
    <>
      <PageHeader title="Staff" description="Every staff member signs in with their own account and an authenticator app. No shared logins."
        actions={<Button variant="primary" onClick={() => { setForm({ email: '', fullName: '', staffRole: 'verifier' }); setInviting(true); }}>Invite staff</Button>} />
      <DataTable label="Staff" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore} onRowClick={setSelected}
        empty={{ title: 'No staff yet' }}
        columns={[
          { header: 'Name', cell: (r) => <>{r.fullName}<div className={ui.muted}>{r.email}</div></> },
          { header: 'Role', cell: (r) => roleLabels[r.staffRole] },
          { header: 'Status', cell: (r) => <span className={ui.row}>
            {!r.isActive ? <Chip>Deactivated</Chip> : r.invitePending ? <Chip tone="warning">Invite pending</Chip> : <Chip tone="success">Active</Chip>}
            {r.lockedUntil && new Date(r.lockedUntil) > new Date() && <Chip tone="danger">Locked</Chip>}
          </span> },
          { header: 'Authenticator', cell: (r) => (r.mfaEnrolled ? <Chip tone="success">Set up</Chip> : <Chip tone="warning">Not set up</Chip>) },
          { header: 'Last sign-in', cell: (r) => <When iso={r.lastLoginAt} /> },
        ]} />
      <Dialog open={inviting} onClose={() => setInviting(false)} title="Invite a staff member">
        <TextField label="Full name" value={form.fullName} onChange={(e) => setForm({ ...form, fullName: e.target.value })} />
        <TextField label="Work email" type="email" value={form.email} onChange={(e) => setForm({ ...form, email: e.target.value })} hint="The invite link goes here." />
        <Select label="Role" value={form.staffRole} onChange={(e) => setForm({ ...form, staffRole: e.target.value as StaffRole })} options={roles.map((r) => ({ value: r, label: roleLabels[r] }))} />
        {invite.error ? <p role="alert" className={ui.muted}>{problemMessage(invite.error)}</p> : null}
        <DialogActions>
          <Button variant="ghost" onClick={() => setInviting(false)}>Cancel</Button>
          <Button variant="primary" busy={invite.isPending} disabled={form.fullName.trim().length < 2 || !form.email.includes('@')}
            onClick={() => invite.mutate(undefined, { onSuccess: () => { setInviting(false); toast('Invite sent.'); } })}>Send invite</Button>
        </DialogActions>
      </Dialog>
      <Dialog open={!!selected && !confirm} onClose={() => setSelected(null)} title={selected?.fullName ?? ''}>
        {selected && <>
          <Details items={[['Email', selected.email], ['Last sign-in', <When iso={selected.lastLoginAt} exact />], ['Locked until', <When iso={selected.lockedUntil} exact />]]} />
          <Select label="Role" value={selected.staffRole} disabled={selected.id === me?.id || update.isPending}
            onChange={(e) => update.mutate({ staffRole: e.target.value as StaffRole }, { onSuccess: (u) => { setSelected(u); toast('Role changed.'); } })}
            options={roles.map((r) => ({ value: r, label: roleLabels[r] }))} hint={selected.id === me?.id ? 'You cannot change your own role.' : undefined} />
          {(update.error || resend.error) ? <p role="alert" className={ui.muted}>{problemMessage(update.error ?? resend.error)}</p> : null}
          <div className={ui.actions}>
            {selected.invitePending && <Button busy={resend.isPending} onClick={() => resend.mutate(undefined, { onSuccess: () => toast('Invite sent again.') })}>Resend invite</Button>}
            <Button onClick={() => setConfirm('signout')}>Sign out everywhere</Button>
            {selected.id !== me?.id && <Button variant={selected.isActive ? 'danger' : 'primary'} onClick={() => setConfirm('deactivate')}>{selected.isActive ? 'Deactivate' : 'Reactivate'}</Button>}
          </div>
        </>}
        <DialogActions><Button variant="ghost" onClick={() => setSelected(null)}>Close</Button></DialogActions>
      </Dialog>
      <ConfirmDialog open={confirm === 'deactivate'} onClose={() => setConfirm(null)} title={selected?.isActive ? 'Deactivate this account' : 'Reactivate this account'}
        body={selected?.isActive ? `${selected?.fullName} can no longer sign in. Their past actions stay in the audit log.` : 'They can sign in again.'}
        confirmLabel={selected?.isActive ? 'Deactivate' : 'Reactivate'} danger={selected?.isActive} typeToConfirm={selected?.isActive ? 'DEACTIVATE' : undefined}
        busy={update.isPending} error={update.error}
        onConfirm={() => update.mutate({ isActive: !selected!.isActive }, { onSuccess: () => { setConfirm(null); setSelected(null); toast('Account updated.'); } })} />
      <ConfirmDialog open={confirm === 'signout'} onClose={() => setConfirm(null)} title="Sign out everywhere"
        body={`${selected?.fullName ?? 'This person'} is signed out of every browser straight away.`} confirmLabel="Sign out everywhere" danger
        busy={signOut.isPending} error={signOut.error}
        onConfirm={() => signOut.mutate(undefined, { onSuccess: () => { setConfirm(null); toast('Signed out everywhere.'); } })} />
    </>
  );
}

export function AuditLogPage() {
  const [entityType, setEntityType] = useState('');
  const [entityId, setEntityId] = useState('');
  const [actor, setActor] = useState('');
  const [applied, setApplied] = useState({ entityType: '', entityId: '', actor: '' });
  const list = useCursorList(['audit', applied], (cursor) => call(api.GET('/admin/audit-log', { params: { query: {
    entityType: applied.entityType || undefined, entityId: applied.entityId || undefined, actorStaffId: applied.actor || undefined, cursor, limit: 50,
  } } })));
  function exportCsv() {
    const rows = list.rows ?? [];
    const esc = (v: string) => `"${v.replace(/"/g, '""')}"`;
    const csv = ['at,actor,action,entity_type,entity_id,detail', ...rows.map((r) =>
      [r.at, r.actorStaffId ?? 'system', r.action, r.entityType, r.entityId, JSON.stringify(r.detail ?? {})].map((x) => esc(String(x))).join(','))].join('\n');
    const url = URL.createObjectURL(new Blob([csv], { type: 'text/csv' }));
    const a = document.createElement('a');
    a.href = url; a.download = `audit-log-${new Date().toISOString().slice(0, 10)}.csv`; a.click();
    URL.revokeObjectURL(url);
  }
  return (
    <>
      <PageHeader title="Audit log" description="Who did what, and when. Read only." actions={<Button onClick={exportCsv} disabled={!list.rows?.length}>Export shown rows (CSV)</Button>} />
      <form className={ui.filters} onSubmit={(e) => { e.preventDefault(); setApplied({ entityType: entityType.trim(), entityId: entityId.trim(), actor: actor.trim() }); }}>
        <TextField label="Entity type" value={entityType} onChange={(e) => setEntityType(e.target.value)} placeholder="ride, wallet, verification" />
        <TextField label="Entity id" value={entityId} onChange={(e) => setEntityId(e.target.value)} />
        <TextField label="Staff id" value={actor} onChange={(e) => setActor(e.target.value)} />
        <Button type="submit">Filter</Button>
      </form>
      <DataTable label="Audit log" rows={list.rows} rowKey={(r) => r.id} loading={list.loading} error={list.error} onRetry={list.refetch}
        hasMore={list.hasMore} onLoadMore={list.loadMore} loadingMore={list.loadingMore} empty={{ title: 'No entries match' }}
        columns={[
          { header: 'When', cell: (r) => <When iso={r.at} exact /> },
          { header: 'Who', cell: (r) => (r.actorStaffId ? <span className={ui.num}>{shortId(r.actorStaffId)}</span> : 'System') },
          { header: 'Action', cell: (r) => <span className={ui.num}>{r.action}</span> },
          { header: 'Entity', cell: (r) => <>{humanize(r.entityType)} <span className={`${ui.num} ${ui.muted}`}>{shortId(r.entityId)}</span></> },
          { header: 'Detail', cell: (r) => <span className={ui.muted}>{r.detail ? Object.entries(r.detail).map(([k, v]) => `${k}: ${String(v)}`).join(' · ') : '—'}</span> },
        ]} />
    </>
  );
}

export function AccountPage() {
  const { me } = useSession();
  const toast = useToast();
  const [form, setForm] = useState({ currentPassword: '', newPassword: '', totpCode: '' });
  const change = useAction(() => call(api.POST('/admin/me/password', { body: form })));
  return (
    <>
      <PageHeader title="Your account" />
      <div className={ui.grid2}>
        <Card title="Profile">
          {me && <Details items={[['Name', me.fullName], ['Email', me.email], ['Role', roleLabels[me.staffRole]], ['Authenticator', me.mfaEnrolled ? 'Set up' : 'Not set up']]} />}
        </Card>
        <Card title="Change password">
          <div className={ui.stack}>
            <TextField label="Current password" type="password" autoComplete="current-password" value={form.currentPassword} onChange={(e) => setForm({ ...form, currentPassword: e.target.value })} />
            <TextField label="New password" type="password" autoComplete="new-password" hint="At least 10 characters." value={form.newPassword} onChange={(e) => setForm({ ...form, newPassword: e.target.value })} />
            <TextField label="Authenticator code" inputMode="numeric" maxLength={6} value={form.totpCode} onChange={(e) => setForm({ ...form, totpCode: e.target.value.replace(/\D/g, '') })} />
            {change.error ? <p role="alert" className={ui.muted}>{problemMessage(change.error)}</p> : null}
            <div className={ui.actions}>
              <Button variant="primary" busy={change.isPending} disabled={!form.currentPassword || form.newPassword.length < 10 || form.totpCode.length !== 6}
                onClick={() => change.mutate(undefined, { onSuccess: () => { setForm({ currentPassword: '', newPassword: '', totpCode: '' }); toast('Password changed.'); } })}>Change password</Button>
            </div>
          </div>
        </Card>
      </div>
    </>
  );
}
