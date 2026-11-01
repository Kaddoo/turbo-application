import { type ReactNode } from 'react';
import { cx } from './cx';
import { Icon } from './Icon';
import type { Tone } from './Chip';
import s from './ui.module.css';

const icon = { danger: 'danger', warning: 'warning', success: 'success', accent: 'info', neutral: 'info' } as const;
const word = { danger: 'Urgent', warning: 'Warning', success: 'Done', accent: 'Note', neutral: 'Note' } as const;

/**
 * Page-level alert. Danger is announced at once (role="alert"); the rest are polite.
 * The tone word is read out so status is never colour alone.
 */
export function Banner({
  tone,
  title,
  children,
  action,
  onDismiss,
}: {
  tone: Tone;
  title?: string;
  children: ReactNode;
  action?: ReactNode;
  onDismiss?: () => void;
}) {
  return (
    <div className={cx(s.banner, s[`banner-${tone}`])} role={tone === 'danger' ? 'alert' : 'status'}>
      <span className={s.bannerIcon}>
        <Icon name={icon[tone]} />
      </span>
      <div className={s.bannerBody}>
        <span className={s.visuallyHidden}>{word[tone]}: </span>
        {title && <strong className={s.bannerTitle}>{title}</strong>}
        <span>{children}</span>
      </div>
      {action && <div className={s.bannerAction}>{action}</div>}
      {onDismiss && (
        <button type="button" className={s.toastClose} aria-label="Dismiss" onClick={onDismiss}>
          <Icon name="close" size="sm" />
        </button>
      )}
    </div>
  );
}
