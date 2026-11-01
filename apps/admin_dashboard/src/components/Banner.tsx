import { type ReactNode } from 'react';
import { cx } from './cx';
import { Chip, type Tone } from './Chip';
import s from './ui.module.css';

export function Banner({ tone, children, action }: { tone: Tone; children: ReactNode; action?: ReactNode }) {
  return (
    <div className={cx(s.banner, s[`tone-${tone}`])} role={tone === 'danger' ? 'alert' : 'status'}>
      <Chip tone={tone}>{tone === 'danger' ? 'Urgent' : tone === 'warning' ? 'Warning' : 'Note'}</Chip>
      <span>{children}</span>
      {action}
    </div>
  );
}
