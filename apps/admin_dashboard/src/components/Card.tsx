import { type ReactNode } from 'react';
import s from './ui.module.css';

export function Card({ title, children, actions }: { title?: string; children: ReactNode; actions?: ReactNode }) {
  return (
    <section className={s.card}>
      {(title || actions) && (
        <div className={s.cardHead}>
          {title && <h2 className={s.cardTitle}>{title}</h2>}
          {actions && <div className={s.actions}>{actions}</div>}
        </div>
      )}
      {children}
    </section>
  );
}
