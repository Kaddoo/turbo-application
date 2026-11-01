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
  // The last point sits a little in from the edge (its marker stays whole);
  // the line then runs flat to the edge, as on the reference cards.
  const step = values.length > 1 ? (W * 0.92) / (values.length - 1) : 0;
  // Keep a little head-room so the line and its marker never touch the top edge.
  return values.map((v, i) => ({ x: i * step, y: H - ((v - min) / span) * (H - 6) - 2, v }));
}

/** Smooth curve through the points (Catmull-Rom as cubic Béziers), kept inside the box. */
function smoothPath(pts: { x: number; y: number }[]) {
  const clamp = (y: number) => Math.max(1, Math.min(H - 1, y));
  let d = `M${pts[0]!.x.toFixed(2)},${pts[0]!.y.toFixed(2)}`;
  for (let i = 0; i < pts.length - 1; i++) {
    const p0 = pts[i - 1] ?? pts[i]!;
    const p1 = pts[i]!;
    const p2 = pts[i + 1]!;
    const p3 = pts[i + 2] ?? p2;
    const c1x = p1.x + (p2.x - p0.x) / 6;
    const c1y = clamp(p1.y + (p2.y - p0.y) / 6);
    const c2x = p2.x - (p3.x - p1.x) / 6;
    const c2y = clamp(p2.y - (p3.y - p1.y) / 6);
    d += ` C${c1x.toFixed(2)},${c1y.toFixed(2)} ${c2x.toFixed(2)},${c2y.toFixed(2)} ${p2.x.toFixed(2)},${p2.y.toFixed(2)}`;
  }
  return d;
}

/**
 * Smooth glowing line with a soft fill, a dashed average line, a hollow
 * marker on the peak and a labelled marker on the latest point (as on the
 * metric cards). `pointLabel` is the text by the latest point.
 */
export function Sparkline({
  values,
  summary,
  tone = 'accent',
  pointLabel,
  showBaseline = true,
  height = 'md',
}: {
  values: number[];
  summary: string;
  tone?: ChartTone;
  /** Text by the latest point. Defaults to its value. */
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
  const line = `${smoothPath(pts)} L${W},${pts[pts.length - 1]!.y.toFixed(2)}`;
  const area = `${line} L${W},${H} L0,${H} Z`;
  const mean = values.reduce((a, b) => a + b, 0) / values.length;
  const meanY = points([...values, mean]).at(-1)!.y;
  const last = pts.at(-1)!;
  const peakIndex = values.lastIndexOf(Math.max(...values));
  const peak = pts[peakIndex]!;
  const at = (p: { x: number; y: number }) => ({ left: `${(p.x / W) * 100}%`, top: `${(p.y / H) * 100}%` });
  return (
    <div className={cx(c.chart, c[`h-${height}`], c[`tone-${tone}`])} role="img" aria-label={summary}>
      <svg viewBox={`0 0 ${W} ${H}`} preserveAspectRatio="none" className={c.svg} aria-hidden="true">
        <defs>
          <linearGradient id={`${id}-fill`} x1="0" x2="0" y1="0" y2="1">
            <stop offset="0%" stopColor="currentColor" stopOpacity="0.22" />
            <stop offset="100%" stopColor="currentColor" stopOpacity="0" />
          </linearGradient>
        </defs>
        <path d={area} fill={`url(#${id}-fill)`} />
        {showBaseline && (
          <line x1="0" x2={W} y1={meanY} y2={meanY} className={c.baseline} vectorEffect="non-scaling-stroke" />
        )}
        <path d={line} className={c.glow} vectorEffect="non-scaling-stroke" />
        <path d={line} className={c.line} vectorEffect="non-scaling-stroke" />
      </svg>
      {peakIndex !== values.length - 1 && (
        <span className={cx(c.marker, c.markerHollow)} style={at(peak)} aria-hidden="true" />
      )}
      <span className={c.marker} style={at(last)} aria-hidden="true">
        <span className={c.markerLabel}>{pointLabel ?? last.v}</span>
      </span>
    </div>
  );
}

/**
 * Short horizontal tracks, each with a dot at its share and the value beside
 * it ("2.23% 24H ago" on the reward tile).
 */
export function RangeLines({
  items,
  summary,
  tone = 'accent',
}: {
  items: { share: number; value: string; caption: string }[];
  summary: string;
  tone?: ChartTone;
}) {
  return (
    <div className={cx(c.lines, c[`tone-${tone}`])} role="img" aria-label={summary}>
      {items.map((it) => (
        <div key={it.caption} className={c.lineRow} aria-hidden="true">
          <span className={c.lineTrack}>
            <span className={c.lineDot} style={{ left: `${Math.max(0, Math.min(1, it.share)) * 100}%` }} />
          </span>
          <span className={c.lineValue}>{it.value}</span>
          <span className={c.lineCaption}>{it.caption}</span>
        </div>
      ))}
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
