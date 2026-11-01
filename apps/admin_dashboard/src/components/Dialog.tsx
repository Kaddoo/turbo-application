import { useEffect, useId, useRef, type ReactNode } from 'react';
import { cx } from './cx';
import { Icon } from './Icon';
import s from './ui.module.css';

/**
 * Modal built on the native dialog element: focus is trapped and Escape
 * closes it. On phones every size becomes a sheet from the bottom.
 */
export function Dialog({
  open,
  onClose,
  title,
  description,
  size = 'md',
  children,
}: {
  open: boolean;
  onClose: () => void;
  title: string;
  description?: string;
  size?: 'sm' | 'md' | 'lg';
  children: ReactNode;
}) {
  const ref = useRef<HTMLDialogElement>(null);
  const id = useId();
  useEffect(() => {
    const d = ref.current;
    if (!d) return;
    if (open && !d.open) d.showModal?.();
    if (!open && d.open) d.close();
  }, [open]);
  return (
    <dialog
      ref={ref}
      className={cx(s.dialog, s[`dialog-${size}`])}
      onClose={onClose}
      onCancel={(e) => {
        e.preventDefault();
        onClose();
      }}
      onClick={(e) => {
        // A click on the backdrop lands on the dialog element itself.
        if (e.target === ref.current) onClose();
      }}
      aria-labelledby={`${id}-t`}
      aria-describedby={description ? `${id}-d` : undefined}
    >
      {open && (
        <div className={s.dialogBody}>
          <div className={s.dialogHead}>
            <h2 className={s.dialogTitle} id={`${id}-t`}>
              {title}
            </h2>
            <button type="button" className={s.dialogClose} aria-label="Close" onClick={onClose}>
              <Icon name="close" size="sm" />
            </button>
          </div>
          {description && (
            <p className={s.dialogText} id={`${id}-d`}>
              {description}
            </p>
          )}
          {children}
        </div>
      )}
    </dialog>
  );
}

export function DialogActions({ children }: { children: ReactNode }) {
  return <div className={s.dialogActions}>{children}</div>;
}

/** Side sheet. The mobile menu uses the left side; detail panels can use the right. */
export function Drawer({
  open,
  onClose,
  label,
  side = 'left',
  children,
}: {
  open: boolean;
  onClose: () => void;
  label: string;
  side?: 'left' | 'right';
  children: ReactNode;
}) {
  const ref = useRef<HTMLDialogElement>(null);
  useEffect(() => {
    const d = ref.current;
    if (!d) return;
    if (open && !d.open) d.showModal?.();
    if (!open && d.open) d.close();
  }, [open]);
  return (
    <dialog
      ref={ref}
      className={cx(s.drawer, s[`drawer-${side}`])}
      aria-label={label}
      onClose={onClose}
      onCancel={(e) => {
        e.preventDefault();
        onClose();
      }}
      onClick={(e) => {
        if (e.target === ref.current) onClose();
      }}
    >
      {open && <div className={s.drawerBody}>{children}</div>}
    </dialog>
  );
}
