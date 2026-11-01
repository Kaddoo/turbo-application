import { useState, type ReactNode } from 'react';
import { useNavigate } from 'react-router';
import { canUse, type Area } from '@/utils/roles';
import { useSession } from '@/state/session';
import { strings } from '@/app/strings';
import {
  BigNumber,
  Button,
  ControlCard,
  DetailCard,
  EmptyState,
  FilterChip,
  HeroCard,
  IconButton,
  MetricCard,
  Panel,
  RangeLines,
  SectionHeader,
  Slider,
  SortHeaderRow,
  Sparkline,
  StatTile,
  type Change,
  type IconName,
  type TileTone,
} from '@/components';
import { nextSort, type SortState } from '@/hooks';
import { formatRelative } from '@/utils/format';
import { bucketCounts, countInPeriod, expiryCurve, periods, smoothForDisplay, type Period } from '@/utils/series';
import type { Schemas } from '@/types';
import { useOverviewCounts } from './queries';
import o from './overview.module.css';

type Group = 'all' | 'People' | 'Operations' | 'Finance' | 'Care';
type Order = 'desc' | 'asc';

interface Card {
  key: string;
  group: Exclude<Group, 'all'>;
  icon: IconName;
  tone: TileTone;
  title: string;
  valueLabel: string;
  value: number | undefined;
  more?: boolean;
  times: (string | undefined)[];
  /** A rise in this queue is bad news (more work or risk). */
  riseTone: 'danger' | 'warning';
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

/**
 * Overview, laid out after the reference dashboard: queue cards beside a
 * promo card, then the live operations panel. Every figure comes from the
 * API through `useOverviewCounts`.
 */
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
  const spark = (times: (string | undefined)[], label: string, tone: 'accent' | 'danger' | 'warning') => {
    const values = bucketCounts(times, period, now);
    const total = values.reduce((a, b) => a + b, 0);
    return (
      <Sparkline
        values={smoothForDisplay(values, period === '24h' ? 2 : 1)}
        height="lg"
        tone={tone}
        pointLabel={`+${total}`}
        summary={`${label}: ${total} in the ${periods[period].label.toLowerCase()}, at most ${Math.max(...values)} in one ${period === '24h' ? 'hour' : 'day'}.`}
      />
    );
  };

  const docItems = docs.data?.items ?? [];
  const expired = docItems.filter((d) => d.daysLeft < 0).length;
  const within = (lo: number, hi: number) => docItems.filter((d) => d.daysLeft >= lo && d.daysLeft <= hi).length;
  const flagged = [...(unreachable.data?.data ?? []), ...(overdue.data?.data ?? [])];
  const oldestPending = verif.data?.data.reduce<string | null>(
    (acc, v) => (!acc || v.submittedAt < acc ? v.submittedAt : acc),
    null,
  );

  const candidates: (Card | false)[] = [
    can('incidents') && {
      key: 'sos',
      group: 'Care',
      icon: 'incidents',
      tone: 'danger',
      title: 'SOS and safety',
      valueLabel: 'Open now',
      value: sos.data?.data.length,
      more: sos.data?.page.hasMore,
      times: sos.data?.data.map((i) => i.createdAt) ?? [],
      riseTone: 'danger',
      urgent: !!sos.data?.data.length,
      to: '/incidents',
      loading: sos.isPending,
      error: sos.error,
      retry: () => void sos.refetch(),
    },
    can('verification') && {
      key: 'verif',
      group: 'People',
      icon: 'verification',
      tone: 'accent',
      title: 'Verification',
      valueLabel: 'Waiting for review',
      value: verif.data?.data.length,
      more: verif.data?.page.hasMore,
      times: verif.data?.data.map((v) => v.submittedAt) ?? [],
      riseTone: 'warning',
      footnote: oldestPending ? `Oldest ${formatRelative(oldestPending)}` : undefined,
      to: '/verification',
      loading: verif.isPending,
      error: verif.error,
      retry: () => void verif.refetch(),
    },
    can('rides') && {
      key: 'flag',
      group: 'Operations',
      icon: 'rides',
      tone: 'warning',
      title: 'Flagged rides',
      valueLabel: 'Unreachable or overdue',
      value: unreachable.data && overdue.data ? flagged.length : undefined,
      times: flagged.map((r) => r.requestedAt),
      riseTone: 'danger',
      urgent: flagged.length > 0,
      to: '/rides?flag=driver_unreachable',
      loading: unreachable.isPending || overdue.isPending,
      error: unreachable.error ?? overdue.error,
      retry: () => {
        void unreachable.refetch();
        void overdue.refetch();
      },
    },
    can('support') && {
      key: 'tickets',
      group: 'Care',
      icon: 'support',
      tone: 'neutral',
      title: 'Support',
      valueLabel: 'Open',
      value: tickets.data?.data.length,
      more: tickets.data?.page.hasMore,
      times: tickets.data?.data.map((t) => t.createdAt) ?? [],
      riseTone: 'warning',
      to: '/support',
      loading: tickets.isPending,
      error: tickets.error,
      retry: () => void tickets.refetch(),
    },
    can('finance') && {
      key: 'topups',
      group: 'Finance',
      icon: 'topups',
      tone: 'warning',
      title: 'Top-ups',
      valueLabel: 'Flagged for a decision',
      value: topups.data?.data.length,
      more: topups.data?.page.hasMore,
      times: topups.data?.data.map((t) => t.createdAt) ?? [],
      riseTone: 'warning',
      to: '/finance/topups',
      loading: topups.isPending,
      error: topups.error,
      retry: () => void topups.refetch(),
    },
    can('finance') && {
      key: 'approvals',
      group: 'Finance',
      icon: 'adjustments',
      tone: 'success',
      title: 'Adjustments',
      valueLabel: 'Waiting for approval',
      value: approvals.data?.items.length,
      more: approvals.data?.page?.hasMore,
      times: approvals.data?.items.map((a) => a.createdAt) ?? [],
      riseTone: 'warning',
      to: '/finance/adjustments?tab=approvals',
      loading: approvals.isPending,
      error: approvals.error,
      retry: () => void approvals.refetch(),
    },
    can('drivers') && {
      key: 'docs',
      group: 'People',
      icon: 'drivers',
      tone: 'success',
      title: 'Documents',
      valueLabel: 'Expire within 30 days',
      value: docs.data ? docItems.length : undefined,
      times: [],
      riseTone: 'danger',
      urgent: expired > 0,
      footnote: expired ? `${expired} already expired` : undefined,
      chart: (
        <Sparkline
          values={smoothForDisplay(expiryCurve(docItems.map((d) => d.daysLeft)), 1)}
          height="lg"
          tone={expired ? 'danger' : 'success'}
          pointLabel={`${within(0, 7)} in 7d`}
          summary={`Driver documents by time left: ${expired} expired, ${within(0, 7)} within a week, ${within(8, 14)} within two weeks, ${within(15, 30)} within 30 days.`}
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

  // Promo card: the most pressing thing this role can act on.
  const brand = { mark: strings.appName.slice(0, 1), name: strings.appName };
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
        primary: { label: 'Open incidents', icon: 'arrowUpRight' as const, onClick: () => navigate('/incidents') },
        secondary: can('liveMap')
          ? { label: 'Open live map', icon: 'liveMap' as const, onClick: () => navigate('/live') }
          : undefined,
      };
    }
    const busiest = cards
      .filter((c) => c.key !== 'sos' && (c.value ?? 0) > 0)
      .sort((a, b) => (b.value ?? 0) - (a.value ?? 0))[0];
    if (busiest) {
      return {
        chip: 'Next up',
        title: `${display(busiest.value, busiest.more)} in ${busiest.title}`,
        body: `${busiest.valueLabel}. ${busiest.footnote ? `${busiest.footnote}. ` : ''}Start with the oldest.`,
        primary: { label: 'Start now', icon: 'arrowUpRight' as const, onClick: () => navigate(busiest.to) },
        secondary: can('liveMap')
          ? { label: 'Open live map', icon: 'liveMap' as const, onClick: () => navigate('/live') }
          : undefined,
      };
    }
    return {
      chip: 'All clear',
      title: 'Nothing is waiting on you',
      body: 'Every queue you can see is empty. New items show here first.',
      primary: can('liveMap')
        ? { label: 'Open live map', icon: 'liveMap' as const, onClick: () => navigate('/live') }
        : { label: 'Account', icon: 'account' as const, onClick: () => navigate('/account') },
    };
  })();
  const anyLoading = cards.some((c) => c.loading);

  // Live operations
  const liveRides = live.data?.rides ?? [];
  const drivers = live.data?.onDutyDrivers ?? [];
  const busy = drivers.filter((d) => !d.idle).length;
  const idle = drivers.length - busy;
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
    { key: 'drivers', label: 'Drivers', caption: `${drivers.length} on duty`, value: drivers.length },
  ];
  const sortedTiles = tileSort
    ? [...tiles].sort((a, b) => (tileSort.dir === 'asc' ? 1 : -1) * (a.value - b.value))
    : tiles;
  const pct = (n: number) => (drivers.length ? `${Math.round((n / drivers.length) * 100)}%` : '0%');

  return (
    <>
      <div className={o.top}>
        <div className={o.topMain}>
          <SectionHeader
            as="h1"
            caption={`What needs attention, ${periods[period].label.toLowerCase()}`}
            count={`${shown.length} ${shown.length === 1 ? 'queue' : 'queues'}`}
            title="Needs attention"
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
                    { value: 'desc', label: 'Desc' },
                    { value: 'asc', label: 'Asc' },
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
            <div className={o.cards} role="region" aria-label="Queues" tabIndex={0}>
              {shown.map((c) => (
                <MetricCard
                  key={c.key}
                  icon={c.icon}
                  tone={c.tone}
                  caption={c.group}
                  title={c.title}
                  valueLabel={c.valueLabel}
                  value={display(c.value, c.more)}
                  urgent={c.urgent}
                  change={c.chart ? undefined : changeFor(countInPeriod(c.times, period, now), period, c.riseTone)}
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
        </div>
        <div className={o.heroCell}>
          <HeroCard brand={brand} {...hero} loading={anyLoading && !sos.data?.data.length} />
        </div>
      </div>

      {can('liveMap') && (
        <Panel
          title="Live operations"
          tools={
            <>
              <IconButton icon="chart" label="All rides" variant="ghost" onClick={() => navigate('/rides')} />
              <IconButton icon="liveMap" label="Live map" variant="ghost" onClick={() => navigate('/live')} />
              <IconButton icon="refresh" label="Refresh now" variant="ghost" onClick={() => void live.refetch()} />
            </>
          }
        >
          {live.error && !live.data ? (
            <EmptyState
              icon="danger"
              title="Live rides did not load."
              compact
              action={
                <Button small icon="refresh" onClick={() => void live.refetch()}>
                  Try again
                </Button>
              }
            />
          ) : (
            <>
              <DetailCard
                caption={
                  live.dataUpdatedAt
                    ? `Last update – ${formatRelative(new Date(live.dataUpdatedAt).toISOString())}`
                    : 'Loading'
                }
                title="Rides on the road"
                icon="liveMap"
                tools={
                  <>
                    <IconButton icon="rides" label="Rides list" round onClick={() => navigate('/rides')} />
                    <IconButton icon="incidents" label="Incidents" round onClick={() => navigate('/incidents')} />
                  </>
                }
                link={{ label: 'View live map', onClick: () => navigate('/live') }}
                aside={
                  <ControlCard title="Refresh rate" caption="How often these counts update (seconds)" chip="60 s">
                    <Slider
                      label="Refresh every"
                      labelHidden
                      value={liveEvery}
                      min={5}
                      max={60}
                      step={5}
                      onChange={setLiveEvery}
                      format={(v) => `${v} s`}
                    />
                  </ControlCard>
                }
              >
                <BigNumber
                  label="Active rides right now"
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
              </DetailCard>
              <SortHeaderRow
                label="Sort live counts"
                columns={tiles.map((t) => ({ key: t.key, label: t.label, caption: t.caption }))}
                sort={tileSort}
                onSort={(k) => setTileSort((s) => nextSort(s, k))}
              />
              <div className={o.tiles}>
                {sortedTiles.map((t) =>
                  t.key === 'drivers' ? (
                    <StatTile
                      key={t.key}
                      label="Driver use"
                      value={drivers.length}
                      loading={live.isPending}
                      visual={
                        <RangeLines
                          summary={`${busy} of ${drivers.length} drivers on a ride, ${idle} idle`}
                          items={[
                            { share: drivers.length ? busy / drivers.length : 0, value: pct(busy), caption: 'busy' },
                            { share: drivers.length ? idle / drivers.length : 0, value: pct(idle), caption: 'idle' },
                          ]}
                        />
                      }
                    />
                  ) : (
                    <StatTile key={t.key} label={t.caption} value={t.value} chip="Now" loading={live.isPending} />
                  ),
                )}
              </div>
            </>
          )}
        </Panel>
      )}
    </>
  );
}
