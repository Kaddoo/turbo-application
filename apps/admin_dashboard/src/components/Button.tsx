import { type ButtonHTMLAttributes } from 'react';
import { cx } from './cx';
import { Icon, type IconName } from './Icon';
import s from './ui.module.css';

/**
 * - primary: the one main action on a screen (accent fill)
 * - secondary: outlined
 * - ghost: quiet, text only
 * - danger: destructive
 * - inverse / inverseOutline: for use on an accent fill (hero cards)
 */
export type ButtonVariant = 'primary' | 'secondary' | 'ghost' | 'danger' | 'inverse' | 'inverseOutline';

export function Button({
  variant = 'secondary',
  small,
  busy,
  icon,
  iconEnd,
  block,
  className,
  children,
  disabled,
  ...rest
}: ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: ButtonVariant;
  small?: boolean;
  busy?: boolean;
  icon?: IconName;
  iconEnd?: IconName;
  /** Full width. */
  block?: boolean;
}) {
  return (
    <button
      type="button"
      className={cx(s.button, s[variant], small && s.small, block && s.block, className)}
      disabled={disabled || busy}
      aria-busy={busy || undefined}
      {...rest}
    >
      {busy ? (
        <>
          <span className={s.spinner} aria-hidden="true" />
          Working…
        </>
      ) : (
        <>
          {icon && <Icon name={icon} size="sm" />}
          {children}
          {iconEnd && <Icon name={iconEnd} size="sm" />}
        </>
      )}
    </button>
  );
}
