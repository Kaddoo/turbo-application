import { useCallback, useMemo, useState } from 'react';

export type SortDir = 'asc' | 'desc';
export interface SortState {
  key: string;
  dir: SortDir;
}

type Value = string | number | boolean | null | undefined;

/** Next state for a header click: none -> ascending -> descending -> none. */
export function nextSort(current: SortState | null, key: string): SortState | null {
  if (!current || current.key !== key) return { key, dir: 'asc' };
  return current.dir === 'asc' ? { key, dir: 'desc' } : null;
}

export function compare(a: Value, b: Value): number {
  if (a === b) return 0;
  // Missing values always go last, whichever way the sort runs.
  if (a === null || a === undefined) return 1;
  if (b === null || b === undefined) return -1;
  if (typeof a === 'number' && typeof b === 'number') return a - b;
  return String(a).localeCompare(String(b), undefined, { numeric: true, sensitivity: 'base' });
}

/**
 * Sorts rows already loaded in the browser. The contract's list endpoints have
 * no sort parameter, so this orders the current page(s) only.
 */
export function useSort<T>(
  rows: T[] | undefined,
  valueOf: (row: T, key: string) => Value,
  initial: SortState | null = null,
) {
  const [sort, setSort] = useState<SortState | null>(initial);
  const toggle = useCallback((key: string) => setSort((s) => nextSort(s, key)), []);
  const sorted = useMemo(() => {
    if (!rows || !sort) return rows;
    const sign = sort.dir === 'asc' ? 1 : -1;
    return [...rows].sort((a, b) => {
      const va = valueOf(a, sort.key);
      const vb = valueOf(b, sort.key);
      if (va === null || va === undefined || vb === null || vb === undefined) return compare(va, vb);
      return sign * compare(va, vb);
    });
  }, [rows, sort, valueOf]);
  return { rows: sorted, sort, setSort, toggle };
}
