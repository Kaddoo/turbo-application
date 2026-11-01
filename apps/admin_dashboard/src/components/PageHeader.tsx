import { type ReactNode } from 'react';
import s from './ui.module.css';

export function PageHeader({
  title,
  description,
  actions,
}: {
  title: string;
  description?: string;
  actions?: ReactNode;
}) {
  return (
    <header className={s.pageHeader}>
      <div>
        <h1 className={s.pageTitle}>{title}</h1>
        {description && <p className={s.pageDescription}>{description}</p>}
      </div>
      {actions && <div className={s.actions}>{actions}</div>}
    </header>
  );
}
