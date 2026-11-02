import { useCallback, type ReactNode } from 'react';
import { useSort, type SortState } from '@/hooks/useSort';
import type { Tone } from './Chip';
import { cx } from './cx';
import { EmptyState } from './EmptyState';
import { ErrorState } from './ErrorState';
import { Icon } from './Icon';
import { LoadMore } from './Pagination';
import { SelectControl } from './Select';
import { Skeleton } from './Skeleton';
import s from './ui.module.css';

export interface Column<T> {
  header: string;
  cell: (row: T) => ReactNode;
  align?: 'right';
  width?: string;
  /** Makes the column sortable (rows on screen only; the API has no sort). */
  sortValue?: (row: T) => string | number | boolean | null | undefined;
  /**
   * Where the value sits on the card. The first column is the card's title unless
   * another is marked; `badge` goes top right (status chips); a column with an
   * empty header holds row actions along the bottom; the rest are labelled fields.
   */
  slot?: 'title' | 'badge';
  /** Kept for old call sites; cards show every field on every screen size. */
  hideOnMobile?: boolean;
}

export type CardTone = Tone;

/**
 * Cards with loading, empty, error and full states: one card per row, in a grid
 * that fills the width and drops to one column on phones. Sorting is a "Sort by"
 * control, shown when any column has `sortValue`; pass `initialSort` to start sorted.
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
  card,
  cardTone,
  cardMin,
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
  /**
   * A card designed for this kind of row. Without it the card is built from `columns`.
   * `columns` still drives the "Sort by" control either way.
   */
  card?: (row: T) => ReactNode;
  /** Colours a stripe along the top of each card (e.g. red when flagged). */
  cardTone?: (row: T) => CardTone | undefined;
  /** Narrowest a card may get before the grid drops a column, e.g. '22rem'. */
  cardMin?: string;
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

  const actions = columns.find((c) => c.header === '');
  const shown = columns.filter((c) => c !== actions);
  const title = shown.find((c) => c.slot === 'title') ?? shown.find((c) => c.slot !== 'badge');
  const badge = shown.find((c) => c.slot === 'badge' && c !== title);
  const fields = shown.filter((c) => c !== title && c !== badge);
  const sortable = columns.filter((c) => c.sortValue);

  return (
    <div className={s.cardsWrap}>
      {sortable.length > 0 && !loading && (
        <div className={s.sortBar}>
          <label className={s.sortLabel}>
            <span>Sort by</span>
            <SelectControl
              className={s.sortSelect}
              value={sorted.sort?.key ?? ''}
              onChange={(e) => sorted.setSort(e.target.value ? { key: e.target.value, dir: 'asc' } : null)}
              options={[
                { value: '', label: 'Default order' },
                ...sortable.map((c) => ({ value: c.header, label: c.header })),
              ]}
            />
          </label>
          {sorted.sort && (
            <button
              type="button"
              className={s.sortDir}
              onClick={() => sorted.toggle(sorted.sort!.key)}
              aria-label={`Sorted ${sorted.sort.dir === 'asc' ? 'ascending' : 'descending'}. Reverse the order`}
            >
              <Icon name={sorted.sort.dir === 'asc' ? 'chevronUp' : 'chevronDown'} size="sm" />
              {sorted.sort.dir === 'asc' ? 'Ascending' : 'Descending'}
            </button>
          )}
        </div>
      )}
      <ul
        className={s.cardGrid}
        aria-label={label}
        aria-busy={loading || undefined}
        style={cardMin ? ({ ['--card-min' as string]: cardMin } as React.CSSProperties) : undefined}
      >
        {loading && !rows?.length
          ? Array.from({ length: skeletonRows }, (_, i) => (
              <li key={i} className={s.dataCard} aria-hidden="true">
                <Skeleton width={i % 2 ? '55%' : '70%'} />
                <div className={s.dataFields}>
                  {fields.slice(0, 4).map((c) => (
                    <div key={c.header} className={s.dataField}>
                      <Skeleton width="40%" />
                      <Skeleton width="75%" />
                    </div>
                  ))}
                </div>
              </li>
            ))
          : sorted.rows?.map((row) => (
              <li
                key={rowKey(row)}
                className={cx(s.dataCard, onRowClick && s.dataCardLink)}
                data-tone={cardTone?.(row)}
                tabIndex={onRowClick ? 0 : undefined}
                onClick={onRowClick ? () => onRowClick(row) : undefined}
                onKeyDown={
                  onRowClick
                    ? (e) => {
                        if (e.target === e.currentTarget && (e.key === 'Enter' || e.key === ' ')) {
                          e.preventDefault();
                          onRowClick(row);
                        }
                      }
                    : undefined
                }
              >
                {card ? (
                  card(row)
                ) : (
                  <>
                    {(title || badge) && (
                      <div className={s.dataHead}>
                        {title && <div className={s.dataTitle}>{title.cell(row)}</div>}
                        {badge && <div className={s.dataBadge}>{badge.cell(row)}</div>}
                      </div>
                    )}
                    {fields.length > 0 && (
                      <dl className={s.dataFields}>
                        {fields.map((c) => (
                          <div key={c.header} className={s.dataField}>
                            <dt className={s.dataLabel}>{c.header}</dt>
                            <dd className={cx(s.dataValue, c.align === 'right' && s.num)}>{c.cell(row)}</dd>
                          </div>
                        ))}
                      </dl>
                    )}
                    {actions && <div className={s.dataActions}>{actions.cell(row)}</div>}
                  </>
                )}
              </li>
            ))}
      </ul>
      {error && rows?.length ? (
        <div className={s.tableFooter}>
          <ErrorState error={error} onRetry={onRetry} compact />
        </div>
      ) : null}
      <LoadMore hasMore={hasMore} onLoadMore={onLoadMore} loading={loadingMore} />
    </div>
  );
}
