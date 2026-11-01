import { type ReactNode } from 'react';
import { problemMessage } from '@/utils/problems';
import { cx } from './cx';
import { Skeleton } from './Skeleton';
import s from './ui.module.css';

export function Stat({ label, value, urgent, onClick, loading, error }: {
  label: string; value: ReactNode; urgent?: boolean; onClick?: () => void; loading?: boolean; error?: unknown;
}) {
  return (
    <button type="button" className={cx(s.card, s.stat, urgent && s.statUrgent)} onClick={onClick}>
      <span className={s.statLabel}>{label}</span>
      {loading ? <Skeleton width="40%" /> : error ? <span className={s.error}>{problemMessage(error)}</span>
        : <span className={s.statValue}>{value}</span>}
    </button>
  );
}
