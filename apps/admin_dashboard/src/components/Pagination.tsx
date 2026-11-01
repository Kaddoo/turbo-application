import { Button } from './Button';
import { IconButton } from './IconButton';
import s from './ui.module.css';

/**
 * Cursor lists (what the contract offers) load more at the end.
 * Numbered pages are for lists that are already fully in memory.
 */
export function LoadMore({
  hasMore,
  onLoadMore,
  loading,
  shown,
}: {
  hasMore?: boolean;
  onLoadMore?: () => void;
  loading?: boolean;
  /** Rows on screen, for "Showing 25". */
  shown?: number;
}) {
  if (!hasMore && shown === undefined) return null;
  return (
    <div className={s.tableFooter}>
      {shown !== undefined && <span className={s.muted}>{hasMore ? `Showing ${shown}` : `All ${shown} shown`}</span>}
      {hasMore && (
        <Button small onClick={onLoadMore} busy={loading}>
          Load more
        </Button>
      )}
    </div>
  );
}

export function Pagination({
  page,
  pageCount,
  onPage,
  label = 'Pages',
}: {
  /** One-based. */
  page: number;
  pageCount: number;
  onPage: (p: number) => void;
  label?: string;
}) {
  if (pageCount <= 1) return null;
  // First, last, current and its neighbours; gaps become an ellipsis.
  const pages = Array.from({ length: pageCount }, (_, i) => i + 1).filter(
    (p) => p === 1 || p === pageCount || Math.abs(p - page) <= 1,
  );
  return (
    <nav className={s.pagination} aria-label={label}>
      <IconButton
        icon="chevronLeft"
        label="Previous page"
        small
        disabled={page <= 1}
        onClick={() => onPage(page - 1)}
      />
      {pages.map((p, i) => (
        <span key={p} className={s.row}>
          {i > 0 && p - pages[i - 1]! > 1 && <span className={s.muted}>…</span>}
          <button
            type="button"
            className={s.pageButton}
            aria-current={p === page ? 'page' : undefined}
            aria-label={`Page ${p}`}
            onClick={() => onPage(p)}
          >
            {p}
          </button>
        </span>
      ))}
      <IconButton
        icon="chevronRight"
        label="Next page"
        small
        disabled={page >= pageCount}
        onClick={() => onPage(page + 1)}
      />
    </nav>
  );
}
