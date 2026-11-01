import { useEffect, useId, useMemo, useRef, useState, type KeyboardEvent } from 'react';
import { Icon, cx, type IconName } from '@/components';
import sh from './shell.module.css';

export interface SearchTarget {
  to: string;
  label: string;
  group: string;
  icon: IconName;
}

/**
 * Finds pages the signed-in role can open (combobox pattern: arrows move,
 * Enter opens, Escape clears). Record search (students, rides, tickets by
 * name or phone) waits on a search endpoint: CONTRACT_REQUESTS A29.
 * Press "/" anywhere to jump here.
 */
export function GlobalSearch({
  targets,
  onOpen,
  autoFocus,
  shortcut = true,
}: {
  targets: SearchTarget[];
  onOpen: (to: string) => void;
  autoFocus?: boolean;
  shortcut?: boolean;
}) {
  const [q, setQ] = useState('');
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState(0);
  const inputRef = useRef<HTMLInputElement>(null);
  const wrapRef = useRef<HTMLDivElement>(null);
  const id = useId();

  const results = useMemo(() => {
    const t = q.trim().toLowerCase();
    if (!t) return [];
    return targets.filter((x) => x.label.toLowerCase().includes(t) || x.group.toLowerCase().includes(t)).slice(0, 8);
  }, [q, targets]);

  useEffect(() => {
    if (!shortcut) return;
    const onKey = (e: globalThis.KeyboardEvent) => {
      const el = e.target as HTMLElement;
      const typing = el.closest('input, textarea, select, [contenteditable="true"]');
      if (e.key === '/' && !typing) {
        e.preventDefault();
        inputRef.current?.focus();
      }
    };
    document.addEventListener('keydown', onKey);
    return () => document.removeEventListener('keydown', onKey);
  }, [shortcut]);

  useEffect(() => {
    if (!open) return;
    const onDown = (e: PointerEvent) => {
      if (!wrapRef.current?.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener('pointerdown', onDown);
    return () => document.removeEventListener('pointerdown', onDown);
  }, [open]);

  const go = (to: string) => {
    setQ('');
    setOpen(false);
    onOpen(to);
  };

  const onKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'ArrowDown' && results.length) {
      e.preventDefault();
      setOpen(true);
      setActive((a) => (a + 1) % results.length);
    } else if (e.key === 'ArrowUp' && results.length) {
      e.preventDefault();
      setActive((a) => (a - 1 + results.length) % results.length);
    } else if (e.key === 'Enter' && results[active]) {
      e.preventDefault();
      go(results[active]!.to);
    } else if (e.key === 'Escape') {
      if (q) setQ('');
      else inputRef.current?.blur();
      setOpen(false);
    }
  };

  const showPanel = open && q.trim().length > 0;
  return (
    <div ref={wrapRef} className={sh.searchWrap}>
      <div className={sh.searchBox}>
        <input
          ref={inputRef}
          type="search"
          role="combobox"
          aria-label="Search pages"
          aria-keyshortcuts={shortcut ? '/' : undefined}
          aria-expanded={showPanel}
          aria-controls={`${id}-list`}
          aria-autocomplete="list"
          aria-activedescendant={showPanel && results[active] ? `${id}-${active}` : undefined}
          placeholder="Search…"
          className={sh.searchField}
          value={q}
          autoFocus={autoFocus}
          onChange={(e) => {
            setQ(e.target.value);
            setActive(0);
            setOpen(true);
          }}
          onFocus={() => setOpen(true)}
          onKeyDown={onKeyDown}
        />
        <Icon name="search" size="sm" />
      </div>
      {showPanel && (
        <div className={sh.searchPanel}>
          <ul id={`${id}-list`} role="listbox" aria-label="Pages" className={sh.searchList}>
            {results.map((r, i) => (
              <li
                key={r.to}
                id={`${id}-${i}`}
                role="option"
                aria-selected={i === active}
                className={cx(sh.searchOption, i === active && sh.searchOptionActive)}
                onPointerDown={(e) => e.preventDefault()}
                onClick={() => go(r.to)}
                onMouseEnter={() => setActive(i)}
              >
                <Icon name={r.icon} size="sm" />
                <span className={sh.searchLabel}>{r.label}</span>
                {r.group && <span className={sh.searchGroup}>{r.group}</span>}
              </li>
            ))}
          </ul>
          {results.length === 0 && (
            <p className={sh.searchEmpty} role="status">
              No pages match “{q.trim()}”.
            </p>
          )}
          <p className={sh.searchNote}>Search finds pages for now. Finding people and rides by name comes later.</p>
        </div>
      )}
    </div>
  );
}
