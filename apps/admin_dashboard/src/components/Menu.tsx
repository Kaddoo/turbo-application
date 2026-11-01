import { useEffect, type KeyboardEvent, type ReactNode } from 'react';
import { cx } from './cx';
import { Icon, type IconName } from './Icon';
import { usePopover } from './usePopover';
import s from './ui.module.css';

export interface MenuItem {
  key: string;
  label: string;
  icon?: IconName;
  onSelect: () => void;
  danger?: boolean;
  /** Shown checked; used by single-choice menus such as filters. */
  checked?: boolean;
  disabled?: boolean;
}

/** Arrow keys, Home and End move between items (menu pattern). */
function onMenuKeys(e: KeyboardEvent<HTMLDivElement>) {
  const items = Array.from(e.currentTarget.querySelectorAll<HTMLButtonElement>('[role^="menuitem"]:not(:disabled)'));
  const i = items.indexOf(document.activeElement as HTMLButtonElement);
  const go = (n: number) => {
    e.preventDefault();
    items[(n + items.length) % items.length]?.focus();
  };
  if (e.key === 'ArrowDown') go(i + 1);
  else if (e.key === 'ArrowUp') go(i - 1);
  else if (e.key === 'Home') go(0);
  else if (e.key === 'End') go(items.length - 1);
}

/**
 * Dropdown menu opened from any button. `renderTrigger` gets the props the
 * trigger needs (ref, aria wiring, toggle) so the trigger can be a chip, an
 * avatar row or an icon button.
 */
export function Menu({
  items,
  label,
  align = 'start',
  header,
  checkable,
  renderTrigger,
}: {
  items: MenuItem[];
  label: string;
  align?: 'start' | 'end';
  header?: ReactNode;
  /** Items are single-choice options (menuitemradio). */
  checkable?: boolean;
  renderTrigger: (props: {
    ref: React.RefObject<HTMLButtonElement | null>;
    'aria-haspopup': 'menu';
    'aria-expanded': boolean;
    'aria-controls': string;
    onClick: () => void;
    onKeyDown: (e: KeyboardEvent<HTMLButtonElement>) => void;
  }) => ReactNode;
}) {
  const p = usePopover();
  // Move focus into the menu when it opens: the checked item, else the first.
  useEffect(() => {
    if (!p.open) return;
    const panel = p.panelRef.current;
    const target =
      panel?.querySelector<HTMLButtonElement>('[aria-checked="true"]') ??
      panel?.querySelector<HTMLButtonElement>('[role^="menuitem"]');
    target?.focus();
  }, [p.open, p.panelRef]);

  return (
    <div className={s.popoverAnchor}>
      {renderTrigger({
        ref: p.triggerRef,
        'aria-haspopup': 'menu',
        'aria-expanded': p.open,
        'aria-controls': p.panelId,
        onClick: p.toggle,
        onKeyDown: (e) => {
          if (e.key === 'ArrowDown') {
            e.preventDefault();
            p.setOpen(true);
          }
        },
      })}
      {p.open && (
        <div
          ref={p.panelRef}
          id={p.panelId}
          role="menu"
          aria-label={label}
          className={cx(s.popover, s.menu, align === 'end' && s.popoverEnd)}
          onKeyDown={onMenuKeys}
        >
          {header}
          {items.map((it) => (
            <button
              key={it.key}
              type="button"
              role={checkable ? 'menuitemradio' : 'menuitem'}
              aria-checked={checkable ? !!it.checked : undefined}
              disabled={it.disabled}
              className={cx(s.menuItem, it.danger && s.menuItemDanger)}
              onClick={() => {
                it.onSelect();
                p.close();
              }}
            >
              {it.icon && <Icon name={it.icon} size="sm" />}
              <span className={s.menuLabel}>{it.label}</span>
              {checkable && it.checked && <Icon name="check" size="sm" />}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}

/**
 * Dropdown filter shaped as a chip ("24H ⌄"). Single choice; the chip shows
 * the current option. The accessible name says what is being filtered.
 */
export function FilterChip<T extends string>({
  label,
  value,
  options,
  onChange,
  align,
}: {
  label: string;
  value: T;
  options: { value: T; label: string }[];
  onChange: (v: T) => void;
  align?: 'start' | 'end';
}) {
  const current = options.find((o) => o.value === value)?.label ?? value;
  return (
    <Menu
      label={label}
      align={align}
      checkable
      items={options.map((o) => ({
        key: o.value,
        label: o.label,
        checked: o.value === value,
        onSelect: () => onChange(o.value),
      }))}
      renderTrigger={(t) => (
        <button type="button" className={s.filterChip} aria-label={`${label}: ${current}`} {...t}>
          {current}
          <Icon name="chevronDown" size="sm" />
        </button>
      )}
    />
  );
}
