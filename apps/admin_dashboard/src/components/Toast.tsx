import { createContext, useCallback, useContext, useState, type ReactNode } from 'react';
import { cx } from './cx';
import { Icon } from './Icon';
import s from './ui.module.css';

export type ToastTone = 'success' | 'info' | 'warning' | 'danger';

interface ToastOptions {
  tone?: ToastTone;
  /** Errors stay until closed; everything else closes after 4 seconds. */
  sticky?: boolean;
}

type Show = (message: string, options?: ToastOptions) => void;

const ToastContext = createContext<Show>(() => {});

const icons = { success: 'success', info: 'info', warning: 'warning', danger: 'danger' } as const;

export function ToastProvider({ children }: { children: ReactNode }) {
  const [items, setItems] = useState<{ id: number; message: string; tone: ToastTone }[]>([]);
  const dismiss = useCallback((id: number) => setItems((x) => x.filter((t) => t.id !== id)), []);
  const show = useCallback<Show>(
    (message, { tone = 'success', sticky = tone === 'danger' } = {}) => {
      const id = Date.now() + Math.random();
      setItems((x) => [...x, { id, message, tone }]);
      if (!sticky) setTimeout(() => dismiss(id), 4000);
    },
    [dismiss],
  );
  return (
    <ToastContext.Provider value={show}>
      {children}
      <div className={s.toastRegion} role="status" aria-live="polite">
        {items.map((t) => (
          <div key={t.id} className={cx(s.toast, s[`toast-${t.tone}`])}>
            <Icon name={icons[t.tone]} size="sm" className={s.toastIcon} />
            <span className={s.toastText}>{t.message}</span>
            <button type="button" className={s.toastClose} aria-label="Dismiss" onClick={() => dismiss(t.id)}>
              <Icon name="close" size="sm" />
            </button>
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  );
}

/** `toast('Saved')` or `toast('Could not save', { tone: 'danger' })`. */
export const useToast = () => useContext(ToastContext);
