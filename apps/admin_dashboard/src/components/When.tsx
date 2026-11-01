import { formatDateTime, formatRelative } from '@/utils/format';
import s from './ui.module.css';

/** Relative time with the exact Accra time on hover. */
export function When({ iso, exact }: { iso: string | null | undefined; exact?: boolean }) {
  if (!iso) return <span className={s.muted}>—</span>;
  return (
    <time dateTime={iso} title={formatDateTime(iso)}>
      {exact ? formatDateTime(iso) : formatRelative(iso)}
    </time>
  );
}
