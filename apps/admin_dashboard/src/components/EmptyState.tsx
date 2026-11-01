import { type ReactNode } from 'react';
import s from './ui.module.css';

export function EmptyState({ title, body, action }: { title: string; body?: string; action?: ReactNode }) {
  return (
    <div className={s.state} role="status">
      <p className={s.stateTitle}>{title}</p>
      {body && <p style={{ margin: 0 }}>{body}</p>}
      {action}
    </div>
  );
}
