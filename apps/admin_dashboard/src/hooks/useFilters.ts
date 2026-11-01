import { useCallback, useMemo } from 'react';
import { useSearchParams } from 'react-router';

/**
 * Filter values kept in the URL, so a filtered list can be bookmarked,
 * shared and restored with Back. Values equal to the default are left out of
 * the URL. `query` holds only the filters that are set, ready to pass to a
 * list call.
 */
export function useFilters<F extends Record<string, string>>(defaults: F) {
  const [params, setParams] = useSearchParams();

  const values = useMemo(() => {
    const out = { ...defaults };
    for (const k of Object.keys(defaults) as (keyof F)[]) {
      const v = params.get(k as string);
      if (v !== null) out[k] = v as F[keyof F];
    }
    return out;
    // `defaults` is a literal at the call site; its keys do not change.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [params]);

  const set = useCallback(
    <K extends keyof F>(key: K, value: F[K]) =>
      setParams(
        (p) => {
          const next = new URLSearchParams(p);
          if (value === defaults[key] || value === '') next.delete(key as string);
          else next.set(key as string, value);
          return next;
        },
        { replace: true },
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [setParams],
  );

  const reset = useCallback(
    () =>
      setParams(
        (p) => {
          const next = new URLSearchParams(p);
          Object.keys(defaults).forEach((k) => next.delete(k));
          return next;
        },
        { replace: true },
      ),
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [setParams],
  );

  const query = useMemo(() => {
    const q: Partial<F> = {};
    for (const k of Object.keys(values) as (keyof F)[]) {
      if (values[k] !== '' && values[k] !== defaults[k]) q[k] = values[k];
    }
    return q;
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [values]);

  return { values, set, reset, query, active: Object.keys(query).length };
}
