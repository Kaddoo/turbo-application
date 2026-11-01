import { type ReactNode } from 'react';
import type { Tone } from './Chip';
import { cx } from './cx';
import s from './ui.module.css';

/**
 * Small count or label, e.g. a nav item's queue size ("12") or a tag ("Live").
 * A count above `max` shows as "99+". Decorative when the holder already says the number.
 */
export function Badge({
  count,
  children,
  tone = 'accent',
  max = 99,
  className,
}: {
  count?: number;
  children?: ReactNode;
  tone?: Tone;
  max?: number;
  className?: string;
}) {
  const text = count !== undefined ? (count > max ? `${max}+` : String(count)) : children;
  return <span className={cx(s.badge, s[`badge-${tone}`], className)}>{text}</span>;
}
