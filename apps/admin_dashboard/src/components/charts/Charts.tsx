import { useId } from 'react';
import { cx } from '@/components/cx';
import c from './charts.module.css';

export type ChartTone = 'accent' | 'success' | 'warning' | 'danger' | 'neutral';

/**
 * Every chart is one image to assistive tech (`role="img"`) with `summary` as
 * its name, so the numbers are never only visual. Colours come from the theme
 * through `currentColor`.
 */

const W = 100;
const H = 40;

function points(values: number[]) {
  const max = Math.max(...values, 1);
  const min = Math.min(...values, 0);
  const span = max - min || 1;
  const step = values.length > 1 ? W / (values.length - 1) : 0;
  // Keep a little head-room so the line and its marker never touch the top edge.
  return values.map((v, i) => ({ x: i * step, y: H - ((v - min) / span) * (H - 6) - 2, v }));
}

/**
 * Area sparkline with a dashed average line and one labelled point (the
 * highest value unless `highlight` says otherwise), as on the metric cards.
 */
export function Sparkline({
  values,
  summary,
  tone = 'accent',
  highlight,
  pointLabel,
  showBaseline = true,
  height = 'md',
}: {
  values: number[];
  summary: string;
  tone?: ChartTone;
  /** Index of the labelled point. Defaults to the peak. */
  highlight?: number;
  /** Text on the labelled point. Defaults to its value. */
  pointLabel?: string;
  showBaseline?: boolean;
  height?: 'sm' | 'md' | 'lg';
}) {
  const id = useId();
  if (values.length < 2) {
    return (
      <div className={cx(c.chart, c[`h-${height}`], c.empty)} role="img" aria-label={summary}>
        <span className={c.emptyLine} />
      </div>
    );
  }
  const pts = points(values);
  const line = pts.map((p, i) => `${i ? 'L' : 'M'}${p.x.toFixed(2)},${p.y.toFixed(2)}`).join(' ');
  const area = `${line} L${W},${H} L0,${H} Z`;
  const mean = values.reduce((a, b) => a + b, 0) / values.length;
  const meanY = points([...values, mean]).at(-1)!.y;
  const hi = highlight ?? values.indexOf(Math.max(...values));
  const p = pts[hi]!;
  return (
    <div className={cx(c.chart, c[`h-${height}`], c[`tone-${tone}`])} role="img" aria-label={summary}>
      <svg viewBox={`0 0 ${W} ${H}`} preserveAspectRatio="none" className={c.svg} aria-hidden="true">
        <defs>
          <linearGradient id={`${id}-fill`} x1="0" x2="0" y1="0" y2="1">
            <stop offset="0%" stopColor="currentColor" stopOpacity="0.32" />
            <stop offset="100%" stopColor="currentColor" stopOpacity="0" />
          </linearGradient>
        </defs>
        <path d={area} fill={`url(#${id}-fill)`} />
        {showBaseline && (
          <line x1="0" x2={W} y1={meanY} y2={meanY} className={c.baseline} vectorEffect="non-scaling-stroke" />
        )}
        <path d={line} className={c.line} vectorEffect="non-scaling-stroke" />
      </svg>
      <span className={c.marker} style={{ left: `${(p.x / W) * 100}%`, top: `${(p.y / H) * 100}%` }} aria-hidden="true">
        <span className={c.markerLabel}>{pointLabel ?? p.v}</span>
      </span>
    </div>
  );
}

/** Vertical bars with a label under each. One bar can be emphasised. */
export function BarChart({
  data,
  summary,
  tone = 'accent',
  emphasis,
}: {
  data: { label: string; value: number }[];
  summary: string;
  tone?: ChartTone;
  emphasis?: number;
}) {
  const max = Math.max(...data.map((d) => d.value), 1);
  return (
    <div className={cx(c.bars, c[`tone-${tone}`])} role="img" aria-label={summary}>
      {data.map((d, i) => (
        <div key={d.label} className={c.barCol} aria-hidden="true">
          <span className={c.barValue}>{d.value}</span>
          <span className={c.barTrack}>
            <span
              className={cx(c.bar, emphasis !== undefined && emphasis !== i && c.barMuted)}
              style={{ height: `${Math.max((d.value / max) * 100, d.value ? 4 : 0)}%` }}
            />
          </span>
          <span className={c.barLabel}>{d.label}</span>
        </div>
      ))}
    </div>
  );
}

/**
 * A row of thin bars, the first `active` of them lit: a level meter for a
 * share such as "drivers busy".
 */
export function RangeBars({
  value,
  max,
  summary,
  count = 12,
  tone = 'accent',
}: {
  value: number;
  max: number;
  summary: string;
  count?: number;
  tone?: ChartTone;
}) {
  const lit = max > 0 ? Math.round((value / max) * count) : 0;
  return (
    <div className={cx(c.range, c[`tone-${tone}`])} role="img" aria-label={summary}>
      {Array.from({ length: count }, (_, i) => (
        <span
          key={i}
          aria-hidden="true"
          className={cx(c.rangeBar, i < lit && c.rangeLit)}
          style={{ height: `${40 + ((i * 37) % 60)}%` }}
        />
      ))}
    </div>
  );
}

/** Ring meter for one share of a whole, with the percentage in the middle. */
export function Donut({
  value,
  max,
  summary,
  tone = 'accent',
}: {
  value: number;
  max: number;
  summary: string;
  tone?: ChartTone;
}) {
  const pct = max > 0 ? Math.min(value / max, 1) : 0;
  const r = 16;
  const len = 2 * Math.PI * r;
  return (
    <div className={cx(c.donut, c[`tone-${tone}`])} role="img" aria-label={summary}>
      <svg viewBox="0 0 40 40" aria-hidden="true">
        <circle cx="20" cy="20" r={r} className={c.donutTrack} />
        <circle
          cx="20"
          cy="20"
          r={r}
          className={c.donutValue}
          strokeDasharray={`${pct * len} ${len}`}
          transform="rotate(-90 20 20)"
        />
      </svg>
      <span className={c.donutText} aria-hidden="true">
        {Math.round(pct * 100)}%
      </span>
    </div>
  );
}

/** Loading placeholder sized like a chart. */
export function ChartSkeleton({ height = 'md' }: { height?: 'sm' | 'md' | 'lg' }) {
  return <div className={cx(c.chart, c[`h-${height}`], c.skeleton)} aria-hidden="true" />;
}
