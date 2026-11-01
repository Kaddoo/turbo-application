import { type ReactNode } from 'react';
import { problemMessage } from '@/utils/problems';
import { Button } from '@/components/Button';
import { cx } from '@/components/cx';
import { Icon, type IconName } from '@/components/Icon';
import { IconButton } from '@/components/IconButton';
import { Skeleton } from '@/components/Skeleton';
import { ChartSkeleton } from '@/components/charts/Charts';
import type { SortState } from '@/hooks/useSort';
import d from './dashboard.module.css';

/** Colour of an icon tile. Turbo's accent and status colours only. */
export type TileTone = 'accent' | 'success' | 'warning' | 'danger' | 'neutral';

/** Rounded square holding an icon, filled with a tone ("ETH", "BNB" tiles). */
export function IconTile({
  icon,
  tone = 'accent',
  size = 'md',
}: {
  icon: IconName;
  tone?: TileTone;
  size?: 'sm' | 'md';
}) {
  return (
    <span className={cx(d.tile_, d[`tile-${tone}`], size === 'sm' && d.tileSm)} aria-hidden="true">
      <Icon name={icon} size={size === 'sm' ? 'sm' : 'md'} />
    </span>
  );
}

/** Caption with a clock and a count chip, a large light title, controls on the right. */
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
        {(caption || count) && (
          <p className={d.captionRow}>
            {caption && (
              <span className={d.caption}>
                {caption}
                <Icon name="attendance" size="sm" />
              </span>
            )}
            {count && <span className={d.countChip}>{count}</span>}
          </p>
        )}
        <H className={d.bigTitle}>{title}</H>
      </div>
      {controls && <div className={d.controls}>{controls}</div>}
    </header>
  );
}

export interface Change {
  /** e.g. "3 new in 24H" */
  label: string;
  direction: 'up' | 'down' | 'flat';
  tone: 'success' | 'warning' | 'danger' | 'neutral' | 'accent';
}

/** Small round arrow and a coloured figure under a number ("● 6.25%"). */
export function ChangePill({ change }: { change: Change }) {
  return (
    <span className={cx(d.change, d[`change-${change.tone}`])}>
      <span className={d.changeIcon} aria-hidden="true">
        <Icon
          name={change.direction === 'down' ? 'arrowDown' : change.direction === 'up' ? 'arrowUp' : 'check'}
          size="sm"
        />
      </span>
      {change.label}
    </span>
  );
}

/**
 * Card for one queue or measure: icon tile, caption and name, open button,
 * the number with its change, and a chart that runs to the card's edges.
 * States: loading, error with retry, urgent, full.
 */
export function MetricCard({
  icon,
  tone = 'accent',
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
  tone?: TileTone;
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
        <IconTile icon={icon} tone={tone} />
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
          <>
            <span className={d.metricValue}>
              {value}
              {unit && <span className={d.unit}>{unit}</span>}
            </span>
            {change && <ChangePill change={change} />}
            {footnote && <span className={d.footnote}>{footnote}</span>}
          </>
        )}
      </div>
      <div className={d.metricChart}>{loading ? <ChartSkeleton /> : error ? null : chart}</div>
    </article>
  );
}

/**
 * The promo card: brand row with a chip, a large title, a sentence, and two
 * full-width actions. Dark at the top, glowing into the accent at the bottom.
 */
export function HeroCard({
  brand,
  chip,
  title,
  body,
  primary,
  secondary,
  loading,
}: {
  brand?: { mark: string; name: string };
  chip?: string;
  title: string;
  body?: string;
  primary?: { label: string; icon?: IconName; onClick: () => void };
  secondary?: { label: string; icon?: IconName; onClick: () => void };
  loading?: boolean;
}) {
  return (
    <article className={d.hero} aria-busy={loading || undefined}>
      <span className={d.heroStreak} aria-hidden="true" />
      <div className={d.heroTop}>
        {brand && (
          <span className={d.heroBrand}>
            <span className={d.heroMark} aria-hidden="true">
              {brand.mark}
            </span>
            {brand.name}
          </span>
        )}
        {chip && <span className={d.heroChip}>{chip}</span>}
      </div>
      {loading ? (
        <div className={d.heroSkeleton}>
          <Skeleton width="80%" height="var(--space-8)" />
          <Skeleton width="60%" />
        </div>
      ) : (
        <div className={d.heroText}>
          <h3 className={d.heroTitle}>{title}</h3>
          {body && <p className={d.heroBody}>{body}</p>}
        </div>
      )}
      <div className={d.heroActions}>
        {primary && (
          <Button variant="primary" block iconEnd={primary.icon} onClick={primary.onClick} disabled={loading}>
            {primary.label}
          </Button>
        )}
        {secondary && (
          <Button
            block
            iconEnd={secondary.icon}
            className={d.heroSecondary}
            onClick={secondary.onClick}
            disabled={loading}
          >
            {secondary.label}
          </Button>
        )}
      </div>
    </article>
  );
}

/** Outer panel: a small title with plain icon tools on the right ("Your active stakings"). */
export function Panel({
  title,
  tools,
  children,
  label,
}: {
  title: string;
  tools?: ReactNode;
  children: ReactNode;
  label?: string;
  /** Kept for older call sites; the inner DetailCard shows the caption and icon now. */
  caption?: string;
  icon?: IconName;
}) {
  return (
    <section className={d.panel} aria-label={label ?? title}>
      <header className={d.panelHead}>
        <h2 className={d.panelTitle}>{title}</h2>
        {tools && <div className={d.panelTools}>{tools}</div>}
      </header>
      {children}
    </section>
  );
}

/**
 * Inner card on a dotted grid: last-update caption, a title with an icon tile,
 * round tools and a link button, then content on the left and an aside on the right.
 */
export function DetailCard({
  caption,
  title,
  icon,
  tone = 'accent',
  tools,
  link,
  aside,
  children,
}: {
  caption?: string;
  title: string;
  icon?: IconName;
  tone?: TileTone;
  tools?: ReactNode;
  link?: { label: string; onClick: () => void };
  aside?: ReactNode;
  children: ReactNode;
}) {
  return (
    <div className={d.detail}>
      <div className={d.detailMain}>
        {caption && (
          <p className={d.caption}>
            {caption} <Icon name="attendance" size="sm" className={d.inlineIcon} />
          </p>
        )}
        <div className={d.detailTitleRow}>
          <h3 className={d.detailTitle}>{title}</h3>
          {icon && <IconTile icon={icon} tone={tone} />}
          {tools}
          {link && (
            <Button small iconEnd="arrowUpRight" onClick={link.onClick}>
              {link.label}
            </Button>
          )}
        </div>
        {children}
      </div>
      {aside && <div className={d.detailAside}>{aside}</div>}
    </div>
  );
}

/** One huge number (fading towards its end) with its actions beside it. */
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
      <span className={d.caption}>{label}</span>
      <div className={d.bigRow}>
        {loading ? (
          <Skeleton width="10rem" height="var(--space-12)" />
        ) : (
          <span className={d.bigValue}>
            {value}
            {unit && <span className={d.unit}>{unit}</span>}
          </span>
        )}
        {actions && <div className={d.controls}>{actions}</div>}
      </div>
    </div>
  );
}

/** Small card with a title, a caption and a chip on the right ("Investment Period · 6 Month"). */
export function ControlCard({
  title,
  caption,
  chip,
  children,
}: {
  title: string;
  caption?: string;
  chip?: string;
  children: ReactNode;
}) {
  return (
    <div className={d.control}>
      <div className={d.controlHead}>
        <div className={d.sectionText}>
          <span className={d.controlTitle}>{title}</span>
          {caption && <span className={d.caption}>{caption}</span>}
        </div>
        {chip && <span className={d.greyChip}>{chip}</span>}
      </div>
      <div className={d.controlBody}>{children}</div>
    </div>
  );
}

/** Stat card under a sortable header: caption, grey chip, large light value, optional visual. */
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
    <div className={d.stat} aria-busy={loading || undefined}>
      <div className={d.statHead}>
        <span className={d.caption}>{label}</span>
        {chip && <span className={d.greyChip}>{chip}</span>}
      </div>
      {loading ? (
        <Skeleton width="50%" height="var(--space-8)" />
      ) : visual ? (
        <div className={d.statVisual}>{visual}</div>
      ) : (
        <div className={d.statValueRow}>
          <span className={d.statValue}>
            {value}
            {unit && <span className={d.unit}>{unit}</span>}
          </span>
          {change && <ChangePill change={change} />}
        </div>
      )}
      {hint && !loading && <span className={d.footnote}>{hint}</span>}
    </div>
  );
}

/** Column headers with a caption under each and up-down sort arrows. */
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
            <span className={d.sectionText}>
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
