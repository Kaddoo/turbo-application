import { useNavigate } from 'react-router';
import { canUse, type Area } from '@/utils/roles';
import { useSession } from '@/state/session';
import { Card, EmptyState, PageHeader, Stat, ui } from '@/components';
import { formatRelative } from '@/utils/format';
import { useOverviewCounts } from './queries';

/** The contract returns no totals (CONTRACT_REQUESTS A5), so counts are "50+" past one page. */
const count = (rows: unknown[] | undefined, hasMore: boolean | undefined) =>
  rows === undefined ? '—' : hasMore ? `${rows.length}+` : String(rows.length);

export function Overview() {
  const { me } = useSession();
  const navigate = useNavigate();
  const role = me?.staffRole;
  const can = (a: Area) => canUse(role, a);

  const { sos, verif, unreachable, overdue, live, topups, approvals, docs } = useOverviewCounts(can);

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
