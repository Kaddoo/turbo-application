import { type ReactNode } from 'react';
import s from './ui.module.css';

/** Caption over the page title, a description under it, actions on the right. */
export function PageHeader({
  title,
  caption,
  description,
  actions,
}: {
  title: string;
  caption?: string;
  description?: string;
  actions?: ReactNode;
}) {
  return (
    <header className={s.pageHeader}>
      <div>
        {caption && <p className={s.pageCaption}>{caption}</p>}
        <h1 className={s.pageTitle}>{title}</h1>
        {description && <p className={s.pageDescription}>{description}</p>}
      </div>
      {actions && <div className={s.actions}>{actions}</div>}
    </header>
  );
}
