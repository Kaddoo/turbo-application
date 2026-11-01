import { useState, type ReactNode } from 'react';
import { useNavigate } from 'react-router';
import { canUse, type Area } from '@/utils/roles';
import { useSession } from '@/state/session';
import {
  BarChart,
  BigNumber,
  Button,
  DataTable,
  EmptyState,
  FilterChip,
  HeroCard,
  IconButton,
  MetricCard,
  Panel,
  RangeBars,
  SectionHeader,
  Slider,
  SortHeaderRow,
  Sparkline,
  StatTile,
  type Change,
  type IconName,
} from '@/components';
import { nextSort, type SortState } from '@/hooks';
import { formatRelative } from '@/utils/format';
import { bucketCounts, countInPeriod, periods, type Period } from '@/utils/series';
import type { Schemas } from '@/types';
import { useOverviewCounts } from './queries';
import o from './overview.module.css';

type Group = 'all' | 'People' | 'Operations' | 'Finance' | 'Care';
type Order = 'desc' | 'asc';

interface Card {
  key: string;
  group: Exclude<Group, 'all'>;
  icon: IconName;
  title: string;
  valueLabel: string;
  value: number | undefined;
  more?: boolean;
  times: (string | undefined)[];
  /** A rise in this queue is bad news (more work or risk). */
  urgentTone: 'danger' | 'warning';
  urgent?: boolean;
  footnote?: string;
  chart?: ReactNode;
  to: string;
  loading: boolean;
  error: unknown;
  retry: () => void;
}

const display = (n: number | undefined, more?: boolean) => (n === undefined ? '—' : more ? `${n}+` : String(n));

function changeFor(n: number, period: Period, tone: 'danger' | 'warning'): Change {
  return n > 0
    ? { label: `${n} new in ${periods[period].short}`, direction: 'up', tone }
    : { label: `None new in ${periods[period].short}`, direction: 'flat', tone: 'success' };
}

const rideStatusLabel: Partial<Record<Schemas['RideStatus'], string>> = {
  searching: 'Finding a driver',
  assigned: 'Driver on the way',
  driver_arrived: 'Driver at pickup',
  in_progress: 'On trip',
};

export function Overview() {
  const { me } = useSession();
  const navigate = useNavigate();
  const role = me?.staffRole;
  const can = (a: Area) => canUse(role, a);

  const [period, setPeriod] = useState<Period>('24h');
  const [group, setGroup] = useState<Group>('all');
  const [order, setOrder] = useState<Order>('desc');
  const [liveEvery, setLiveEvery] = useState(15);
  const [tileSort, setTileSort] = useState<SortState | null>(null);

  const q = useOverviewCounts(can, liveEvery * 1000);
  const { sos, verif, unreachable, overdue, live, topups, approvals, docs, tickets } = q;

  const now = Date.now();
  const spark = (times: (string | undefined)[], label: string, tone: 'accent' | 'danger' | 'warning' = 'accent') => {
    const values = bucketCounts(times, period, now);
    const total = values.reduce((a, b) => a + b, 0);
    return (
      <Sparkline
        values={values}
        tone={tone}
        summary={`${label}: ${total} in the ${periods[period].label.toLowerCase()}, peak ${Math.max(...values)} in one ${period === '24h' ? 'hour' : 'day'}.`}
      />
    );
  };

  const docItems = docs.data?.items ?? [];
  const expired = docItems.filter((d) => d.daysLeft < 0).length;
  const flagged = [...(unreachable.data?.data ?? []), ...(overdue.data?.data ?? [])];
  const oldestPending = verif.data?.data.reduce<string | null>(
    (acc, v) => (!acc || v.submittedAt < acc ? v.submittedAt : acc),
    null,
  );

  const candidates: (Card | false)[] = [
    can('incidents') && {
      key: 'sos',
      group: 'Care' as const,
      icon: 'incidents' as const,
      title: 'SOS and safety',
      valueLabel: 'Open now',
      value: sos.data?.data.length,
      more: sos.data?.page.hasMore,
      times: sos.data?.data.map((i) => i.createdAt) ?? [],
      urgentTone: 'danger' as const,
      urgent: !!sos.data?.data.length,
      to: '/incidents',
      loading: sos.isPending,
      error: sos.error,
      retry: () => void sos.refetch(),
    },
    can('rides') && {
      key: 'flag',
      group: 'Operations' as const,
      icon: 'rides' as const,
      title: 'Rides needing help',
      valueLabel: 'Driver unreachable or overdue',
      value: unreachable.data && overdue.data ? flagged.length : undefined,
      times: flagged.map((r) => r.requestedAt),
      urgentTone: 'danger' as const,
      urgent: flagged.length > 0,
      to: '/rides?flag=driver_unreachable',
      loading: unreachable.isPending || overdue.isPending,
      error: unreachable.error ?? overdue.error,
      retry: () => {
        void unreachable.refetch();
        void overdue.refetch();
      },
    },
    can('verification') && {
      key: 'verif',
      group: 'People' as const,
      icon: 'verification' as const,
      title: 'Verification queue',
      valueLabel: 'Waiting for review',
      value: verif.data?.data.length,
      more: verif.data?.page.hasMore,
      times: verif.data?.data.map((v) => v.submittedAt) ?? [],
      urgentTone: 'warning' as const,
      footnote: oldestPending ? `Oldest sent ${formatRelative(oldestPending)}` : undefined,
      to: '/verification',
      loading: verif.isPending,
      error: verif.error,
      retry: () => void verif.refetch(),
    },
    can('support') && {
      key: 'tickets',
      group: 'Care' as const,
      icon: 'support' as const,
      title: 'Support tickets',
      valueLabel: 'Open',
      value: tickets.data?.data.length,
      more: tickets.data?.page.hasMore,
      times: tickets.data?.data.map((t) => t.createdAt) ?? [],
      urgentTone: 'warning' as const,
      to: '/support',
      loading: tickets.isPending,
      error: tickets.error,
      retry: () => void tickets.refetch(),
    },
    can('finance') && {
      key: 'topups',
      group: 'Finance' as const,
      icon: 'topups' as const,
      title: 'Flagged top-ups',
      valueLabel: 'Need a decision',
      value: topups.data?.data.length,
      more: topups.data?.page.hasMore,
      times: topups.data?.data.map((t) => t.createdAt) ?? [],
      urgentTone: 'warning' as const,
      to: '/finance/topups',
      loading: topups.isPending,
      error: topups.error,
      retry: () => void topups.refetch(),
    },
    can('finance') && {
      key: 'approvals',
      group: 'Finance' as const,
      icon: 'adjustments' as const,
      title: 'Wallet adjustments',
      valueLabel: 'Waiting for approval',
      value: approvals.data?.items.length,
      more: approvals.data?.page?.hasMore,
      times: approvals.data?.items.map((a) => a.createdAt) ?? [],
      urgentTone: 'warning' as const,
      to: '/finance/adjustments?tab=approvals',
      loading: approvals.isPending,
      error: approvals.error,
      retry: () => void approvals.refetch(),
    },
    can('drivers') && {
      key: 'docs',
      group: 'People' as const,
      icon: 'drivers' as const,
      title: 'Driver documents',
      valueLabel: 'Expire within 30 days',
      value: docs.data ? docItems.length : undefined,
      times: [],
      urgentTone: 'danger' as const,
      urgent: expired > 0,
      footnote: expired ? `${expired} already expired` : undefined,
      chart: (
        <BarChart
          summary={`Driver documents by time left: ${expired} expired, ${docItems.filter((d) => d.daysLeft >= 0 && d.daysLeft <= 7).length} within a week.`}
          tone={expired ? 'danger' : 'accent'}
          emphasis={expired ? 0 : undefined}
          data={[
            { label: 'Past', value: expired },
            { label: '7d', value: docItems.filter((d) => d.daysLeft >= 0 && d.daysLeft <= 7).length },
            { label: '14d', value: docItems.filter((d) => d.daysLeft > 7 && d.daysLeft <= 14).length },
            { label: '30d', value: docItems.filter((d) => d.daysLeft > 14).length },
          ]}
        />
      ),
      to: '/drivers',
      loading: docs.isPending,
      error: docs.error,
      retry: () => void docs.refetch(),
    },
  ];
  const cards = candidates.filter((c): c is Card => !!c);

  const groups = Array.from(new Set(cards.map((c) => c.group)));
  const shown = cards
    .filter((c) => group === 'all' || c.group === group)
    .sort((a, b) => (order === 'desc' ? 1 : -1) * ((b.value ?? -1) - (a.value ?? -1)));

  // Hero: the most pressing thing this role can act on.
  const hero = (() => {
    if (can('incidents') && sos.data?.data.length) {
      const oldest = sos.data.data.reduce(
        (acc, i) => (i.createdAt < acc ? i.createdAt : acc),
        sos.data.data[0]!.createdAt,
      );
      return {
        chip: 'Urgent',
        title: `${display(sos.data.data.length, sos.data.page.hasMore)} open SOS ${sos.data.data.length === 1 ? 'alert' : 'alerts'}`,
        body: `Oldest raised ${formatRelative(oldest)}. Acknowledge each one from Incidents.`,
        primary: { label: 'Open incidents', onClick: () => navigate('/incidents') },
        secondary: can('liveMap') ? { label: 'Live map', onClick: () => navigate('/live') } : undefined,
      };
    }
    const busiest = cards
      .filter((c) => c.key !== 'sos' && (c.value ?? 0) > 0)
      .sort((a, b) => (b.value ?? 0) - (a.value ?? 0))[0];
    if (busiest) {
      return {
        chip: busiest.group,
        title: `${display(busiest.value, busiest.more)} · ${busiest.title}`,
        body: `${busiest.valueLabel}. ${busiest.footnote ?? 'Start with the oldest.'}`,
        primary: { label: 'Start now', onClick: () => navigate(busiest.to) },
        secondary: can('liveMap') ? { label: 'Live map', onClick: () => navigate('/live') } : undefined,
      };
    }
    return {
      chip: 'All clear',
      title: 'Nothing is waiting on you',
      body: 'Every queue you can see is empty. New items show here first.',
      primary: can('liveMap') ? { label: 'Live map', onClick: () => navigate('/live') } : undefined,
      secondary: { label: 'Account', onClick: () => navigate('/account') },
    };
  })();
  const anyLoading = cards.some((c) => c.loading);

  // Live operations
  const liveRides = live.data?.rides ?? [];
  const drivers = live.data?.onDutyDrivers ?? [];
  const busy = drivers.filter((d) => !d.idle).length;
  const byStatus = (st: Schemas['RideStatus'][]) => liveRides.filter((r) => st.includes(r.ride.status)).length;
  const tiles = [
    { key: 'searching', label: 'Finding a driver', caption: 'Searching', value: byStatus(['searching']) },
    {
      key: 'onTheWay',
      label: 'On the way',
      caption: 'Assigned or arrived',
      value: byStatus(['assigned', 'driver_arrived']),
    },
    { key: 'trip', label: 'On trip', caption: 'In progress', value: byStatus(['in_progress']) },
    {
      key: 'busy',
      label: 'Drivers busy',
      caption: `${drivers.length} on duty`,
      value: drivers.length ? Math.round((busy / drivers.length) * 100) : 0,
    },
  ];
  const sortedTiles = tileSort
    ? [...tiles].sort((a, b) => (tileSort.dir === 'asc' ? 1 : -1) * (a.value - b.value))
    : tiles;

  return (
    <>
      <SectionHeader
        as="h1"
        caption={`What needs attention · ${periods[period].label}`}
        title="Overview"
        count={`${shown.length} ${shown.length === 1 ? 'queue' : 'queues'}`}
        controls={
          <>
            <FilterChip
              label="Period"
              value={period}
              onChange={setPeriod}
              options={(Object.keys(periods) as Period[]).map((p) => ({ value: p, label: periods[p].short }))}
            />
            {groups.length > 1 && (
              <FilterChip
                label="Area"
                value={group}
                onChange={setGroup}
                options={[
                  { value: 'all' as Group, label: 'All areas' },
                  ...groups.map((g) => ({ value: g, label: g })),
                ]}
              />
            )}
            <FilterChip
              label="Order"
              value={order}
              onChange={setOrder}
              align="end"
              options={[
                { value: 'desc', label: 'Most first' },
                { value: 'asc', label: 'Fewest first' },
              ]}
            />
          </>
        }
      />

      {cards.length === 0 ? (
        <EmptyState
          title="Nothing needs attention."
          body="Your role has no queues on this page. Use the menu to open your area."
        />
      ) : (
        <div className={o.cards}>
          <div className={o.heroCell}>
            <HeroCard {...hero} loading={anyLoading && !sos.data?.data.length} />
          </div>
          {shown.map((c) => (
            <MetricCard
              key={c.key}
              icon={c.icon}
              caption={c.group}
              title={c.title}
              valueLabel={c.valueLabel}
              value={display(c.value, c.more)}
              urgent={c.urgent}
              change={
                c.times.length || c.value !== undefined
                  ? changeFor(countInPeriod(c.times, period, now), period, c.urgentTone)
                  : undefined
              }
              chart={c.chart ?? spark(c.times, c.title, c.urgent ? 'danger' : 'accent')}
              footnote={c.footnote}
              onOpen={() => navigate(c.to)}
              loading={c.loading}
              error={c.error}
              onRetry={c.retry}
            />
          ))}
        </div>
      )}

      {can('liveMap') && (
        <section className={o.section} aria-labelledby="live-ops">
          <SectionHeader
            caption="Rides and drivers right now"
            title="Live operations"
            controls={
              <>
                <IconButton icon="chart" label="Rides list" onClick={() => navigate('/rides')} />
                <IconButton icon="refresh" label="Refresh now" onClick={() => void live.refetch()} />
                <IconButton icon="liveMap" label="Live map" onClick={() => navigate('/live')} />
              </>
            }
          />
          <Panel
            caption={
              live.dataUpdatedAt
                ? `Last update · ${formatRelative(new Date(live.dataUpdatedAt).toISOString())}`
                : 'Loading'
            }
            icon="liveMap"
            title="On the road"
            label="Live operations"
            tools={
              <Button small variant="ghost" iconEnd="arrowUpRight" onClick={() => navigate('/live')}>
                View map
              </Button>
            }
          >
            {live.error && !live.data ? (
              <EmptyState
                icon="danger"
                title="Live rides did not load."
                action={
                  <Button small icon="refresh" onClick={() => void live.refetch()}>
                    Try again
                  </Button>
                }
                compact
              />
            ) : (
              <>
                <div className={o.liveTop}>
                  <BigNumber
                    label="Active rides"
                    value={liveRides.length}
                    loading={live.isPending}
                    actions={
                      <>
                        <Button variant="primary" onClick={() => navigate('/live')}>
                          Live map
                        </Button>
                        <Button onClick={() => navigate('/rides')}>All rides</Button>
                      </>
                    }
                  />
                  <div className={o.sliderCard}>
                    <Slider
                      label="Refresh every"
                      value={liveEvery}
                      min={5}
                      max={60}
                      step={5}
                      onChange={setLiveEvery}
                      format={(v) => `${v} s`}
                    />
                  </div>
                </div>
                <SortHeaderRow
                  label="Sort live counts"
                  columns={tiles.map((t) => ({ key: t.key, label: t.label, caption: t.caption }))}
                  sort={tileSort}
                  onSort={(k) => setTileSort((s) => nextSort(s, k))}
                />
                <div className={o.tiles}>
                  {sortedTiles.map((t) =>
                    t.key === 'busy' ? (
                      <StatTile
                        key={t.key}
                        label={t.label}
                        value={t.value}
                        unit="%"
                        chip="Now"
                        hint={`${busy} of ${drivers.length} drivers on a ride`}
                        loading={live.isPending}
                        visual={
                          <RangeBars
                            value={busy}
                            max={drivers.length}
                            summary={`${busy} of ${drivers.length} drivers busy`}
                          />
                        }
                      />
                    ) : (
                      <StatTile
                        key={t.key}
                        label={t.label}
                        value={t.value}
                        chip="Now"
                        hint={t.caption}
                        loading={live.isPending}
                      />
                    ),
                  )}
                </div>
                <DataTable
                  label="Active rides"
                  rows={liveRides.map((r) => r.ride)}
                  rowKey={(r) => r.id}
                  loading={live.isPending}
                  error={live.error}
                  onRetry={() => void live.refetch()}
                  onRowClick={(r) => navigate(`/rides/${r.id}`)}
                  empty={{ title: 'No rides on the road.', body: 'New rides show here as students book them.' }}
                  columns={[
                    { header: 'Student', cell: (r) => r.studentName ?? '—', sortValue: (r) => r.studentName },
                    { header: 'Driver', cell: (r) => r.driverName ?? 'Not assigned', sortValue: (r) => r.driverName },
                    {
                      header: 'Status',
                      cell: (r) => rideStatusLabel[r.status] ?? r.status,
                      sortValue: (r) => r.status,
                    },
                    {
                      header: 'Requested',
                      cell: (r) => formatRelative(r.requestedAt),
                      sortValue: (r) => r.requestedAt,
                      hideOnMobile: false,
                    },
                  ]}
                />
              </>
            )}
          </Panel>
        </section>
      )}
    </>
  );
}
