import { useEffect, useId, useLayoutEffect, useRef, useState, type CSSProperties, type KeyboardEvent } from 'react';
import { cx } from './cx';
import { Field, describedBy } from './Field';
import { Icon } from './Icon';
import { usePopover } from './usePopover';
import s from './ui.module.css';

export interface SelectOption {
  value: string;
  label: string;
}

/** What callers read from a change: the same `e.target.value` a native select gave. */
export interface SelectChange {
  target: { value: string };
}

interface ControlProps {
  id?: string;
  value: string;
  options: SelectOption[];
  onChange?: (e: SelectChange) => void;
  disabled?: boolean;
  invalid?: boolean;
  describedBy?: string;
  /** Shown when `value` matches no option. */
  placeholder?: string;
  className?: string;
}

/** Room the panel keeps from the screen edge, and the tallest it grows, in px. */
const EDGE = 8;
const MAX_HEIGHT = 320;
/** Below this much room under the button, the panel opens upward instead. */
const MIN_ROOM = 200;

/**
 * Dropdown for one choice, in place of the system picker. A button opens a listbox:
 * arrows, Home, End and typing a letter move through the options, Enter or Space
 * chooses, Escape closes. The panel opens below the button, or above it when there
 * is no room, and is positioned on screen so a dialog's edge never clips it.
 */
export function SelectControl({
  id,
  value,
  options,
  onChange,
  disabled,
  invalid,
  describedBy: described,
  placeholder = 'Choose',
  className,
}: ControlProps) {
  const p = usePopover();
  const listId = useId();
  const selected = options.findIndex((o) => o.value === value);
  const [active, setActive] = useState(0);
  const [pos, setPos] = useState<CSSProperties>({});
  const typed = useRef({ text: '', at: 0 });

  const open = () => {
    if (disabled) return;
    setActive(Math.max(selected, 0));
    p.setOpen(true);
  };

  // Place the panel under the button, or over it when the space below is too small.
  useLayoutEffect(() => {
    if (!p.open) return;
    const r = p.triggerRef.current?.getBoundingClientRect();
    if (!r) return;
    const below = window.innerHeight - r.bottom - EDGE * 2;
    const above = r.top - EDGE * 2;
    const flip = below < Math.min(MIN_ROOM, options.length * 44 + 16) && above > below;
    setPos({
      left: Math.max(EDGE, Math.min(r.left, window.innerWidth - r.width - EDGE)),
      minWidth: r.width,
      maxHeight: Math.min(MAX_HEIGHT, flip ? above : below),
      ...(flip ? { bottom: window.innerHeight - r.top + EDGE / 2 } : { top: r.bottom + EDGE / 2 }),
    });
  }, [p.open, p.triggerRef, options.length]);

  // Take focus, and close if the page moves under the panel.
  useEffect(() => {
    if (!p.open) return;
    p.panelRef.current?.focus();
    const away = (e: Event) => {
      if (!p.panelRef.current?.contains(e.target as Node)) p.close(false);
    };
    window.addEventListener('resize', away);
    window.addEventListener('scroll', away, true);
    return () => {
      window.removeEventListener('resize', away);
      window.removeEventListener('scroll', away, true);
    };
  }, [p.open, p.panelRef, p.close]); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    if (p.open) p.panelRef.current?.querySelector('[data-active="true"]')?.scrollIntoView?.({ block: 'nearest' });
  }, [p.open, active, p.panelRef]);

  const choose = (i: number) => {
    const o = options[i];
    if (o) onChange?.({ target: { value: o.value } });
    p.close();
  };

  const onTriggerKey = (e: KeyboardEvent<HTMLButtonElement>) => {
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      e.preventDefault();
      open();
    }
  };

  const onListKey = (e: KeyboardEvent<HTMLDivElement>) => {
    const last = options.length - 1;
    const go = (i: number) => {
      e.preventDefault();
      setActive(Math.max(0, Math.min(last, i)));
    };
    if (e.key === 'ArrowDown') go(active + 1);
    else if (e.key === 'ArrowUp') go(active - 1);
    else if (e.key === 'Home') go(0);
    else if (e.key === 'End') go(last);
    else if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault();
      choose(active);
    } else if (e.key === 'Tab') p.close(false);
    else if (e.key.length === 1 && !e.ctrlKey && !e.metaKey) {
      // Type-ahead: keep adding letters within a second, else start over.
      const now = Date.now();
      typed.current = {
        text: (now - typed.current.at < 1000 ? typed.current.text : '') + e.key.toLowerCase(),
        at: now,
      };
      const hit = options.findIndex((o) => o.label.toLowerCase().startsWith(typed.current.text));
      if (hit >= 0) go(hit);
    }
  };

  return (
    <div className={cx(s.selectAnchor, className)}>
      <button
        ref={p.triggerRef}
        id={id}
        type="button"
        role="combobox"
        className={cx(s.input, s.selectTrigger)}
        aria-haspopup="listbox"
        aria-expanded={p.open}
        aria-controls={p.open ? p.panelId : undefined}
        aria-invalid={invalid ? true : undefined}
        aria-describedby={described}
        disabled={disabled}
        onClick={() => (p.open ? p.close() : open())}
        onKeyDown={onTriggerKey}
      >
        <span className={cx(s.selectValue, selected < 0 && s.selectPlaceholder)}>
          {selected >= 0 ? options[selected]!.label : placeholder}
        </span>
        <Icon name="chevronDown" size="sm" className={cx(s.selectChevron, p.open && s.selectChevronOpen)} />
      </button>
      {p.open && (
        <div
          ref={p.panelRef}
          id={p.panelId}
          role="listbox"
          tabIndex={-1}
          className={s.selectPanel}
          style={pos}
          aria-activedescendant={`${listId}-${active}`}
          onKeyDown={onListKey}
        >
          {options.map((o, i) => (
            <div
              key={o.value}
              id={`${listId}-${i}`}
              role="option"
              aria-selected={i === selected}
              data-active={i === active}
              className={s.selectOption}
              onPointerEnter={() => setActive(i)}
              onClick={() => choose(i)}
            >
              <span className={s.selectOptionLabel}>{o.label}</span>
              {i === selected && <Icon name="check" size="sm" />}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

/** Label, dropdown, then the error (or hint), like the other fields. */
export function Select({
  label,
  hint,
  error,
  options,
  value,
  onChange,
  disabled,
  placeholder,
}: {
  label: string;
  hint?: string;
  error?: string;
  options: SelectOption[];
  value: string;
  onChange?: (e: SelectChange) => void;
  disabled?: boolean;
  placeholder?: string;
}) {
  const id = useId();
  return (
    <Field id={id} label={label} hint={hint} error={error}>
      <SelectControl
        id={id}
        value={value}
        options={options}
        onChange={onChange}
        disabled={disabled}
        invalid={!!error}
        describedBy={describedBy(id, hint, error)}
        placeholder={placeholder}
      />
    </Field>
  );
}
