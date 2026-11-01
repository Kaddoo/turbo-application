/**
 * Turns timestamps from a list call into counts per hour or per day, for the
 * small charts on Overview. The contract has no time-series endpoint
 * (CONTRACT_REQUESTS A30), so these cover only the rows the list returned.
 */
export type Period = '24h' | '7d';

export const periods: Record<Period, { buckets: number; bucketMs: number; label: string; short: string }> = {
  '24h': { buckets: 24, bucketMs: 3_600_000, label: 'Last 24 hours', short: '24H' },
  '7d': { buckets: 7, bucketMs: 86_400_000, label: 'Last 7 days', short: '7D' },
};

/** Oldest bucket first; the last bucket ends now. Timestamps outside the window are ignored. */
export function bucketCounts(times: (string | null | undefined)[], period: Period, now = Date.now()): number[] {
  const { buckets, bucketMs } = periods[period];
  const start = now - buckets * bucketMs;
  const out = new Array<number>(buckets).fill(0);
  for (const t of times) {
    if (!t) continue;
    const ms = new Date(t).getTime();
    if (Number.isNaN(ms) || ms < start || ms > now) continue;
    out[Math.min(buckets - 1, Math.floor((ms - start) / bucketMs))]! += 1;
  }
  return out;
}

/** How many timestamps fall inside the period. */
export function countInPeriod(times: (string | null | undefined)[], period: Period, now = Date.now()): number {
  return bucketCounts(times, period, now).reduce((a, b) => a + b, 0);
}

/**
 * A softened copy of `values` for drawing only (centred moving average), so a
 * sparse hourly series reads as a trend instead of isolated spikes. Totals and
 * summaries always use the raw counts.
 */
export function smoothForDisplay(values: number[], radius = 2): number[] {
  return values.map((_, i) => {
    const from = Math.max(0, i - radius);
    const to = Math.min(values.length - 1, i + radius);
    let sum = 0;
    for (let j = from; j <= to; j++) sum += values[j]!;
    return sum / (to - from + 1);
  });
}

/**
 * Documents per three-day step from 30 days out down to today, then the ones
 * already expired, so the line reads left to right as time running out.
 */
export function expiryCurve(daysLeft: number[], horizon = 30, step = 3): number[] {
  const out: number[] = [];
  for (let to = horizon; to > 0; to -= step) {
    const from = Math.max(0, to - step + 1);
    out.push(daysLeft.filter((d) => d >= from && d <= to).length);
  }
  out.push(daysLeft.filter((d) => d < 0).length);
  return out;
}
