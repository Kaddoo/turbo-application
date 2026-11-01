import { useCallback, type ReactNode } from 'react';
import { useSort, type SortState } from '@/hooks/useSort';
import { cx } from './cx';
import { EmptyState } from './EmptyState';
import { ErrorState } from './ErrorState';
import { Icon } from './Icon';
import { LoadMore } from './Pagination';
import { Skeleton } from './Skeleton';
import s from './ui.module.css';

export interface Column<T> {
  header: string;
  cell: (row: T) => ReactNode;
  align?: 'right';
  width?: string;
  /** Makes the column sortable (rows on screen only; the API has no sort). */
  sortValue?: (row: T) => string | number | boolean | null | undefined;
  /** Hidden on phones, where each row becomes a card. */
  hideOnMobile?: boolean;
}

/**
 * Table with loading, empty, error and full states. On phones each row turns
 * into a card with the header as a label, so the page never scrolls sideways.
 * Sorting is built in for columns with `sortValue`; pass `sort` and
 * `onSortChange` to control it from outside.
 */
export function DataTable<T>({
  columns,
  rows,
  rowKey,
  loading,
  error,
  onRetry,
  empty,
  onRowClick,
  hasMore,
  onLoadMore,
  loadingMore,
  label,
  initialSort,
  skeletonRows = 6,
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
  initialSort?: SortState;
  skeletonRows?: number;
}) {
  const valueOf = useCallback(
    (row: T, key: string) => columns.find((c) => c.header === key)?.sortValue?.(row),
    [columns],
  );
  const sorted = useSort(rows, valueOf, initialSort ?? null);

  if (error && !rows?.length)
    return (
      <div className={s.tableWrap}>
        <ErrorState error={error} onRetry={onRetry} />
      </div>
    );
  if (!loading && rows && rows.length === 0)
    return (
      <div className={s.tableWrap}>
        <EmptyState {...empty} />
      </div>
    );

  const ariaSort = (c: Column<T>) =>
    !c.sortValue
      ? undefined
      : sorted.sort?.key === c.header
        ? sorted.sort.dir === 'asc'
          ? 'ascending'
          : 'descending'
        : 'none';

  return (
    <div className={s.tableWrap}>
      <table className={s.table} aria-label={label} aria-busy={loading || undefined}>
        <thead>
          <tr>
            {columns.map((c) => (
              <th
                key={c.header}
                scope="col"
                aria-sort={ariaSort(c)}
                className={cx(c.align === 'right' && s.right, c.hideOnMobile && s.hideMobile)}
                style={{ width: c.width }}
              >
                {c.sortValue ? (
                  <button type="button" className={s.sortButton} onClick={() => sorted.toggle(c.header)}>
                    {c.header}
                    <Icon
                      name={
                        sorted.sort?.key === c.header
                          ? sorted.sort.dir === 'asc'
                            ? 'chevronUp'
                            : 'chevronDown'
                          : 'sort'
                      }
                      size="sm"
                    />
                  </button>
                ) : (
                  c.header
                )}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {loading && !rows?.length
            ? Array.from({ length: skeletonRows }, (_, i) => (
                <tr key={i}>
                  {columns.map((c) => (
                    <td key={c.header} className={cx(c.hideOnMobile && s.hideMobile)}>
                      <Skeleton width={i % 2 ? '60%' : '80%'} />
                    </td>
                  ))}
                </tr>
              ))
            : sorted.rows?.map((row) => (
                <tr
                  key={rowKey(row)}
                  className={onRowClick ? s.rowLink : undefined}
                  tabIndex={onRowClick ? 0 : undefined}
                  onClick={onRowClick ? () => onRowClick(row) : undefined}
                  onKeyDown={
                    onRowClick
                      ? (e) => {
                          if (e.key === 'Enter' || e.key === ' ') {
                            e.preventDefault();
                            onRowClick(row);
                          }
                        }
                      : undefined
                  }
                >
                  {columns.map((c) => (
                    <td
                      key={c.header}
                      data-label={c.header}
                      className={cx(
                        c.align === 'right' && s.right,
                        c.align === 'right' && s.num,
                        c.hideOnMobile && s.hideMobile,
                      )}
                    >
                      {c.cell(row)}
                    </td>
                  ))}
                </tr>
              ))}
        </tbody>
      </table>
      {error && rows?.length ? (
        <div className={s.tableFooter}>
          <ErrorState error={error} onRetry={onRetry} compact />
        </div>
      ) : null}
      <LoadMore hasMore={hasMore} onLoadMore={onLoadMore} loading={loadingMore} />
    </div>
  );
}
