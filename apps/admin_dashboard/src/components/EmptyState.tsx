import { type ReactNode } from 'react';
import { cx } from './cx';
import { Icon, type IconName } from './Icon';
import s from './ui.module.css';

/** Nothing to show. Says why, and what to do next when there is something to do. */
export function EmptyState({
  title,
  body,
  action,
  icon = 'inbox',
  compact,
}: {
  title: string;
  body?: string;
  action?: ReactNode;
  icon?: IconName;
  compact?: boolean;
}) {
  return (
    <div className={cx(s.state, compact && s.stateCompact)} role="status">
      <span className={s.stateIcon}>
        <Icon name={icon} />
      </span>
      <p className={s.stateTitle}>{title}</p>
      {body && <p className={s.stateBody}>{body}</p>}
      {action}
    </div>
  );
}
