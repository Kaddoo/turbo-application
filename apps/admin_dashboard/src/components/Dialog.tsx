import { useEffect, useRef, type ReactNode } from 'react';
import s from './ui.module.css';

/** Modal built on the native dialog element: focus trap and Escape for free. */
export function Dialog({ open, onClose, title, children }: {
  open: boolean; onClose: () => void; title: string; children: ReactNode;
}) {
  const ref = useRef<HTMLDialogElement>(null);
  useEffect(() => {
    const d = ref.current;
    if (!d) return;
    if (open && !d.open) d.showModal();
    if (!open && d.open) d.close();
  }, [open]);
  return (
    <dialog ref={ref} className={s.dialog} onClose={onClose} aria-labelledby={`${title}-t`}>
      {open && (
        <div className={s.dialogBody}>
          <h2 className={s.dialogTitle} id={`${title}-t`}>{title}</h2>
          {children}
        </div>
      )}
    </dialog>
  );
}

export function DialogActions({ children }: { children: ReactNode }) {
  return <div className={s.dialogActions}>{children}</div>;
}
