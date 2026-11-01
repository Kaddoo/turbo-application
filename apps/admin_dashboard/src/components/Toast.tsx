import { createContext, useCallback, useContext, useState, type ReactNode } from 'react';
import s from './ui.module.css';

const ToastContext = createContext<(message: string) => void>(() => {});

export function ToastProvider({ children }: { children: ReactNode }) {
  const [items, setItems] = useState<{ id: number; message: string }[]>([]);
  const show = useCallback((message: string) => {
    const id = Date.now() + Math.random();
    setItems((x) => [...x, { id, message }]);
    setTimeout(() => setItems((x) => x.filter((t) => t.id !== id)), 4000);
  }, []);
  return (
    <ToastContext.Provider value={show}>
      {children}
      <div className={s.toastRegion} role="status" aria-live="polite">
        {items.map((t) => <div key={t.id} className={s.toast}>{t.message}</div>)}
      </div>
    </ToastContext.Provider>
  );
}

export const useToast = () => useContext(ToastContext);
