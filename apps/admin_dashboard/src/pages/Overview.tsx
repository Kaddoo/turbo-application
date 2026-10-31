import { useQuery } from '@tanstack/react-query';
import { useNavigate } from 'react-router';
import { api, call } from '../api/client';
import { canUse, type Area } from '../auth/roles';
import { useSession } from '../auth/session';
import { Card, EmptyState, PageHeader, Stat, ui } from '../components/ui';
import { formatRelative } from '../lib/format';

const LIMIT = 50;
/** The contract returns no totals (CONTRACT_REQUESTS A5), so counts are "50+" past one page. */
const count = (rows: unknown[] | undefined, hasMore: boolean | undefined) =>
  rows === undefined ? '—' : hasMore ? `${rows.length}+` : String(rows.length);

export function OverviewPage() {
  const { me } = useSession();
  const navigate = useNavigate();
  const role = me?.staffRole;
  const can = (a: Area) => canUse(role, a);

  const sos = useQuery({ queryKey: ['ov', 'sos'], enabled: can('incidents'), refetchInterval: 15_000,
    queryFn: () => call(api.GET('/admin/incidents', { params: { query: { status: 'open', limit: LIMIT } } })) });
  const verif = useQuery({ queryKey: ['ov', 'verif'], enabled: can('verification'),
    queryFn: () => call(api.GET('/admin/verifications', { params: { query: { status: 'pending', limit: LIMIT } } })) });
  const unreachable = useQuery({ queryKey: ['ov', 'unreachable'], enabled: can('rides'),
    queryFn: () => call(api.GET('/admin/rides', { params: { query: { flag: 'driver_unreachable', limit: LIMIT } } })) });
  const overdue = useQuery({ queryKey: ['ov', 'overdue'], enabled: can('rides'),
    queryFn: () => call(api.GET('/admin/rides', { params: { query: { flag: 'overdue', limit: LIMIT } } })) });
  const live = useQuery({ queryKey: ['ov', 'live'], enabled: can('liveMap'), refetchInterval: 15_000,
    queryFn: () => call(api.GET('/admin/rides/live')) });
  const topups = useQuery({ queryKey: ['ov', 'topups'], enabled: can('finance'),
    queryFn: () => call(api.GET('/admin/topups', { params: { query: { flagged: true, limit: LIMIT } } })) });
  const approvals = useQuery({ queryKey: ['ov', 'approvals'], enabled: can('finance'),
    queryFn: () => call(api.GET('/admin/wallet-adjustments', { params: { query: { status: 'pending', limit: LIMIT } } })) });
  const docs = useQuery({ queryKey: ['ov', 'docs'], enabled: can('drivers'),
    queryFn: () => call(api.GET('/admin/driver-documents/expiring', { params: { query: { withinDays: 30 } } })) });

  const oldestPending = verif.data?.data.reduce<string | null>((o, v) => (!o || v.submittedAt < o ? v.submittedAt : o), null);
  const expired = docs.data?.items.filter((d) => d.daysLeft < 0).length ?? 0;
  const inProgress = live.data?.rides.filter((r) => r.ride.status === 'in_progress').length;

  const cards = [
    can('incidents') && <Stat key="sos" label="Open SOS and safety incidents" urgent={!!sos.data?.data.length}
      value={count(sos.data?.data, sos.data?.page.hasMore)} loading={sos.isPending} error={sos.error} onClick={() => navigate('/incidents')} />,
    can('rides') && <Stat key="flag" label="Rides with driver unreachable or overdue"
      urgent={!!(unreachable.data?.data.length || overdue.data?.data.length)}
      value={unreachable.data && overdue.data ? String(unreachable.data.data.length + overdue.data.data.length) : '—'}
      loading={unreachable.isPending || overdue.isPending} error={unreachable.error ?? overdue.error} onClick={() => navigate('/rides?flag=driver_unreachable')} />,
    can('verification') && <Stat key="verif" label={oldestPending ? `Pending verifications, oldest ${formatRelative(oldestPending)}` : 'Pending verifications'}
      value={count(verif.data?.data, verif.data?.page.hasMore)} loading={verif.isPending} error={verif.error} onClick={() => navigate('/verification')} />,
    can('finance') && <Stat key="topups" label="Flagged top-ups" value={count(topups.data?.data, topups.data?.page.hasMore)}
      loading={topups.isPending} error={topups.error} onClick={() => navigate('/finance/topups')} />,
    can('finance') && <Stat key="appr" label="Adjustments waiting for approval" value={count(approvals.data?.items, approvals.data?.page.hasMore)}
      loading={approvals.isPending} error={approvals.error} onClick={() => navigate('/finance/adjustments?tab=approvals')} />,
    can('drivers') && <Stat key="docs" label={expired ? `Driver documents expiring (${expired} expired)` : 'Driver documents expiring in 30 days'}
      urgent={expired > 0} value={docs.data ? String(docs.data.items.length) : '—'} loading={docs.isPending} error={docs.error} onClick={() => navigate('/drivers')} />,
    can('liveMap') && <Stat key="duty" label="Drivers on duty" value={live.data ? String(live.data.onDutyDrivers.length) : '—'}
      urgent={live.data?.onDutyDrivers.length === 0} loading={live.isPending} error={live.error} onClick={() => navigate('/live')} />,
    can('liveMap') && <Stat key="prog" label="Rides in progress" value={inProgress ?? '—'} loading={live.isPending} error={live.error} onClick={() => navigate('/live')} />,
  ].filter(Boolean);

  return (
    <>
      <PageHeader title="Overview" description="What needs attention now. Each card opens its list." />
      {cards.length ? <div className={ui.grid4}>{cards}</div> : (
        <Card><EmptyState title="Nothing needs attention." body="Your role has no queues on this page. Use the menu to open your area." /></Card>
      )}
    </>
  );
}
