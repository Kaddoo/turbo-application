import { type ReactNode } from 'react';
import { cx } from './cx';
import s from './ui.module.css';

export type Tone = 'neutral' | 'success' | 'warning' | 'danger' | 'accent';

/** Status is never colour alone: the chip always carries its word. */
export function Chip({ tone = 'neutral', children }: { tone?: Tone; children: ReactNode }) {
  return (
    <span className={cx(s.chip, s[`tone-${tone}`])}>
      <span>{children}</span>
    </span>
  );
}
