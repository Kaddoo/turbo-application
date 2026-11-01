import { type ReactNode } from 'react';
import { cx } from './cx';
import { Button } from './Button';
import { Skeleton } from './Skeleton';
import { EmptyState } from './EmptyState';
import { ErrorState } from './ErrorState';
import s from './ui.module.css';

export interface Column<T> {
  header: string;
  cell: (row: T) => ReactNode;
  align?: 'right';
  width?: string;
}

export function DataTable<T>({
  columns, rows, rowKey, loading, error, onRetry, empty, onRowClick, hasMore, onLoadMore, loadingMore, label,
}: {
  columns: Column<T>[];
  rows: T[] | undefined;
  rowKey: (row: T) => string;
  loading?: boolean;
  error?: unknown;
  onRetry?: () => void;
  empty: { title: string; body?: string; action?: ReactNode };
  onRowClick?: (row: T) => void;
  hasMore?: boolean;
  onLoadMore?: () => void;
  loadingMore?: boolean;
  label: string;
}) {
  if (error && !rows?.length) return <div className={s.tableWrap}><ErrorState error={error} onRetry={onRetry} /></div>;
  if (!loading && rows && rows.length === 0) return <div className={s.tableWrap}><EmptyState {...empty} /></div>;
  return (
    <div className={s.tableWrap}>
      <table className={s.table} aria-label={label} aria-busy={loading || undefined}>
        <thead>
          <tr>{columns.map((c) => <th key={c.header} className={c.align === 'right' ? s.right : undefined} style={{ width: c.width }}>{c.header}</th>)}</tr>
        </thead>
        <tbody>
          {loading && !rows?.length
            ? Array.from({ length: 6 }, (_, i) => (
              <tr key={i}>{columns.map((c) => <td key={c.header}><Skeleton width={i % 2 ? '60%' : '80%'} /></td>)}</tr>
            ))
            : rows?.map((row) => (
              <tr
                key={rowKey(row)}
                className={onRowClick ? s.rowLink : undefined}
                tabIndex={onRowClick ? 0 : undefined}
                onClick={onRowClick ? () => onRowClick(row) : undefined}
                onKeyDown={onRowClick ? (e) => { if (e.key === 'Enter') onRowClick(row); } : undefined}
              >
                {columns.map((c) => <td key={c.header} className={c.align === 'right' ? cx(s.right, s.num) : undefined}>{c.cell(row)}</td>)}
              </tr>
            ))}
        </tbody>
      </table>
      {hasMore && (
        <div className={s.tableFooter}>
          <Button small onClick={onLoadMore} busy={loadingMore}>Load more</Button>
        </div>
      )}
    </div>
  );
}
