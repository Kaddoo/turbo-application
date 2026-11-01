import { type ReactNode } from 'react';
import { cx } from './cx';
import s from './ui.module.css';

export type Tone = 'neutral' | 'success' | 'warning' | 'danger' | 'accent';

/**
 * - status (default): a dot plus a word; status is never colour alone
 * - plain: a quiet pill for counts and periods ("3 queues", "24H")
 * - solid: a filled pill, e.g. "New" on a hero card
 */
export function Chip({
  tone = 'neutral',
  variant = 'status',
  children,
}: {
  tone?: Tone;
  variant?: 'status' | 'plain' | 'solid';
  children: ReactNode;
}) {
  return (
    <span className={cx(s.chip, s[`chip-${variant}`], s[`tone-${tone}`])}>
      <span>{children}</span>
    </span>
  );
}
