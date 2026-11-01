import { forwardRef, useEffect, useState, type InputHTMLAttributes } from 'react';
import { cx } from './cx';
import { Icon } from './Icon';
import s from './ui.module.css';

/**
 * Search box with a leading icon and a clear button. `onSearch` fires after
 * `debounceMs` of no typing (0 fires on every key). A visible label is
 * optional; `label` is always the accessible name.
 */
export const SearchInput = forwardRef<
  HTMLInputElement,
  Omit<InputHTMLAttributes<HTMLInputElement>, 'onChange' | 'value' | 'size'> & {
    label: string;
    value: string;
    onSearch: (q: string) => void;
    debounceMs?: number;
    loading?: boolean;
    size?: 'md' | 'lg';
  }
>(function SearchInput({ label, value, onSearch, debounceMs = 250, loading, size = 'md', className, ...rest }, ref) {
  const [text, setText] = useState(value);
  useEffect(() => setText(value), [value]);
  useEffect(() => {
    if (text === value) return;
    if (!debounceMs) return onSearch(text);
    const t = setTimeout(() => onSearch(text), debounceMs);
    return () => clearTimeout(t);
    // Only typing should trigger a search, not a new onSearch identity.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [text]);
  return (
    <div className={cx(s.search, size === 'lg' && s.searchLg, className)}>
      <Icon name="search" size="sm" className={s.searchIcon} />
      <input
        ref={ref}
        type="search"
        className={s.searchInput}
        aria-label={label}
        placeholder={rest.placeholder ?? label}
        value={text}
        onChange={(e) => setText(e.target.value)}
        aria-busy={loading || undefined}
        {...rest}
      />
      {loading ? (
        <span className={s.spinner} aria-hidden="true" />
      ) : text ? (
        <button
          type="button"
          className={s.searchClear}
          aria-label="Clear search"
          onClick={() => {
            setText('');
            onSearch('');
          }}
        >
          <Icon name="close" size="sm" />
        </button>
      ) : null}
    </div>
  );
});
