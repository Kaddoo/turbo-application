import { cx } from './cx';
import s from './ui.module.css';

/**
 * Placeholder while data loads. Hidden from screen readers: the region that
 * holds it sets aria-busy instead.
 * - text: one line (default)
 * - block: a chart or image area
 * - circle: an avatar or icon
 */
export function Skeleton({
  width = '100%',
  height,
  variant = 'text',
}: {
  width?: string;
  height?: string;
  variant?: 'text' | 'block' | 'circle';
}) {
  return <span className={cx(s.skeleton, s[`skeleton-${variant}`])} style={{ width, height }} aria-hidden="true" />;
}

/** A card-shaped placeholder: caption, title, big number, chart. */
export function SkeletonCard() {
  return (
    <div className={cx(s.card, s.skeletonCard)} aria-hidden="true">
      <div className={s.row}>
        <Skeleton variant="circle" width="var(--space-10)" height="var(--space-10)" />
        <div className={s.stackTight} style={{ flex: 1 }}>
          <Skeleton width="40%" />
          <Skeleton width="70%" />
        </div>
      </div>
      <Skeleton width="50%" height="var(--space-8)" />
      <Skeleton variant="block" height="var(--space-12)" />
    </div>
  );
}
