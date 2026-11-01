import { type ReactNode } from 'react';
import { problemMessage } from '@/utils/problems';
import { Button } from '@/components/Button';
import { Chip, type Tone } from '@/components/Chip';
import { cx } from '@/components/cx';
import { Icon, type IconName } from '@/components/Icon';
import { IconButton } from '@/components/IconButton';
import { Skeleton } from '@/components/Skeleton';
import { ChartSkeleton } from '@/components/charts/Charts';
import type { SortState } from '@/hooks/useSort';
import d from './dashboard.module.css';

/** Caption, title with a count chip, and controls on the right ("Top Staking Assets" row). */
export function SectionHeader({
  caption,
  title,
  count,
  controls,
  as: H = 'h2',
}: {
  caption?: string;
  title: string;
  count?: string;
  controls?: ReactNode;
  as?: 'h1' | 'h2';
}) {
  return (
    <header className={d.sectionHeader}>
      <div className={d.sectionText}>
        {caption && <p className={d.caption}>{caption}</p>}
        <div className={d.titleRow}>
          <H className={H === 'h1' ? d.pageTitle : d.sectionTitle}>{title}</H>
          {count && (
            <Chip variant="plain" tone="neutral">
              {count}
            </Chip>
          )}
        </div>
      </div>
      {controls && <div className={d.controls}>{controls}</div>}
    </header>
  );
}

export interface Change {
  /** e.g. "+3 in 24H" */
  label: string;
  direction: 'up' | 'down' | 'flat';
  tone: Tone;
}

/** Up or down pill under a number. The words carry the meaning, the arrow repeats it. */
export function ChangePill({ change }: { change: Change }) {
  return (
    <span className={cx(d.change, d[`change-${change.tone}`])}>
      {change.direction !== 'flat' && <Icon name={change.direction === 'up' ? 'arrowUp' : 'arrowDown'} size="sm" />}
      {change.label}
    </span>
  );
}

/**
 * Card for one queue or measure: icon, caption, name, open button, the
 * number with its change, and a chart slot. Has loading, error, empty-chart
 * and urgent states.
 */
export function MetricCard({
  icon,
  caption,
  title,
  valueLabel,
  value,
  unit,
  change,
  chart,
  footnote,
  onOpen,
  openLabel,
  loading,
  error,
  onRetry,
  urgent,
}: {
  icon: IconName;
  caption: string;
  title: string;
  valueLabel: string;
  value: ReactNode;
  unit?: string;
  change?: Change;
  chart?: ReactNode;
  footnote?: string;
  onOpen?: () => void;
  openLabel?: string;
  loading?: boolean;
  error?: unknown;
  onRetry?: () => void;
  urgent?: boolean;
}) {
  return (
    <article className={cx(d.metric, urgent && d.metricUrgent)} aria-busy={loading || undefined}>
      <div className={d.metricHead}>
        <span className={cx(d.iconDisc, urgent && d.iconDiscUrgent)}>
          <Icon name={icon} />
        </span>
        <div className={d.metricNames}>
          <span className={d.caption}>{caption}</span>
          <h3 className={d.metricTitle}>{title}</h3>
        </div>
        {onOpen && <IconButton icon="arrowUpRight" label={openLabel ?? `Open ${title}`} round onClick={onOpen} />}
      </div>
      <div className={d.metricValueBlock}>
        <span className={d.caption}>{valueLabel}</span>
        {loading ? (
          <Skeleton width="45%" height="var(--space-10)" />
        ) : error ? (
          <div className={d.metricError} role="alert">
            <span>{problemMessage(error)}</span>
            {onRetry && (
              <Button small variant="ghost" icon="refresh" onClick={onRetry}>
                Try again
              </Button>
            )}
          </div>
        ) : (
          <div className={d.metricValueRow}>
            <span className={d.metricValue}>
              {value}
              {unit && <span className={d.unit}>{unit}</span>}
            </span>
            {change && <ChangePill change={change} />}
          </div>
        )}
      </div>
      <div className={d.metricChart}>{loading ? <ChartSkeleton /> : error ? null : chart}</div>
      {footnote && !loading && !error && <p className={d.footnote}>{footnote}</p>}
    </article>
  );
}

/** The accent gradient card with a chip, a title, a sentence and two actions. */
export function HeroCard({
  chip,
  title,
  body,
  primary,
  secondary,
  loading,
}: {
  chip?: string;
  title: string;
  body?: string;
  primary?: { label: string; onClick: () => void };
  secondary?: { label: string; onClick: () => void };
  loading?: boolean;
}) {
  return (
    <article className={d.hero} aria-busy={loading || undefined}>
      <span className={d.heroGlow} aria-hidden="true" />
      {chip && <span className={d.heroChip}>{chip}</span>}
      {loading ? (
        <div className={d.heroSkeleton}>
          <Skeleton width="80%" height="var(--space-8)" />
          <Skeleton width="60%" />
        </div>
      ) : (
        <>
          <h3 className={d.heroTitle}>{title}</h3>
          {body && <p className={d.heroBody}>{body}</p>}
        </>
      )}
      <div className={d.heroActions}>
        {primary && (
          <Button variant="inverse" onClick={primary.onClick} disabled={loading}>
            {primary.label}
          </Button>
        )}
        {secondary && (
          <Button variant="inverseOutline" onClick={secondary.onClick} disabled={loading}>
            {secondary.label}
          </Button>
        )}
      </div>
    </article>
  );
}

/** Large detail panel: last-update caption, title with icon, tools on the right, then content. */
export function Panel({
  caption,
  icon,
  title,
  tools,
  children,
  label,
}: {
  caption?: string;
  icon?: IconName;
  title: string;
  tools?: ReactNode;
  children: ReactNode;
  label?: string;
}) {
  return (
    <section className={d.panel} aria-label={label ?? title}>
      <header className={d.panelHead}>
        <div className={d.sectionText}>
          {caption && <p className={d.caption}>{caption}</p>}
          <h3 className={d.panelTitle}>
            {icon && (
              <span className={d.iconDisc}>
                <Icon name={icon} />
              </span>
            )}
            {title}
          </h3>
        </div>
        {tools && <div className={d.controls}>{tools}</div>}
      </header>
      {children}
    </section>
  );
}

/** One huge number with its actions ("31.39686  Upgrade  Unstake"). */
export function BigNumber({
  label,
  value,
  unit,
  actions,
  loading,
}: {
  label: string;
  value: ReactNode;
  unit?: string;
  actions?: ReactNode;
  loading?: boolean;
}) {
  return (
    <div className={d.bigNumber}>
      <div className={d.sectionText}>
        <span className={d.caption}>{label}</span>
        {loading ? (
          <Skeleton width="10rem" height="var(--space-12)" />
        ) : (
          <span className={d.bigValue}>
            {value}
            {unit && <span className={d.unit}>{unit}</span>}
          </span>
        )}
      </div>
      {actions && <div className={d.controls}>{actions}</div>}
    </div>
  );
}

/** Small stat card under a sortable header: caption, value, optional change, chip and visual. */
export function StatTile({
  label,
  value,
  unit,
  change,
  chip,
  visual,
  loading,
  hint,
}: {
  label: string;
  value: ReactNode;
  unit?: string;
  change?: Change;
  chip?: string;
  visual?: ReactNode;
  loading?: boolean;
  hint?: string;
}) {
  return (
    <div className={d.tile} aria-busy={loading || undefined}>
      <div className={d.tileHead}>
        <span className={d.caption}>{label}</span>
        {chip && (
          <Chip variant="plain" tone="neutral">
            {chip}
          </Chip>
        )}
      </div>
      {loading ? (
        <Skeleton width="50%" height="var(--space-8)" />
      ) : (
        <div className={d.tileValueRow}>
          <span className={d.tileValue}>
            {value}
            {unit && <span className={d.unit}>{unit}</span>}
          </span>
          {change && <ChangePill change={change} />}
        </div>
      )}
      {hint && <span className={d.footnote}>{hint}</span>}
      {visual && !loading && <div className={d.tileVisual}>{visual}</div>}
    </div>
  );
}

/**
 * Row of column headers with a caption under each and sort arrows, laid out
 * on the same grid as the tiles below it.
 */
export function SortHeaderRow({
  columns,
  sort,
  onSort,
  label,
}: {
  columns: { key: string; label: string; caption?: string }[];
  sort: SortState | null;
  onSort: (key: string) => void;
  label: string;
}) {
  return (
    <div className={d.sortRow} role="group" aria-label={label}>
      {columns.map((c) => {
        const active = sort?.key === c.key;
        const state = active ? (sort!.dir === 'asc' ? 'ascending' : 'descending') : 'not sorted';
        return (
          <button
            key={c.key}
            type="button"
            className={cx(d.sortHead, active && d.sortHeadActive)}
            aria-label={`Sort by ${c.label}, ${state}`}
            onClick={() => onSort(c.key)}
          >
            <span className={d.sortText}>
              <span className={d.sortLabel}>{c.label}</span>
              {c.caption && <span className={d.caption}>{c.caption}</span>}
            </span>
            <Icon name={active ? (sort!.dir === 'asc' ? 'chevronUp' : 'chevronDown') : 'sort'} size="sm" />
          </button>
        );
      })}
    </div>
  );
}
