import { type ButtonHTMLAttributes } from 'react';
import { cx } from './cx';
import s from './ui.module.css';

type Variant = 'primary' | 'secondary' | 'danger' | 'ghost';

export function Button({
  variant = 'secondary', small, busy, className, children, disabled, ...rest
}: ButtonHTMLAttributes<HTMLButtonElement> & { variant?: Variant; small?: boolean; busy?: boolean }) {
  return (
    <button
      type="button"
      className={cx(s.button, s[variant], small && s.small, className)}
      disabled={disabled || busy}
      aria-busy={busy || undefined}
      {...rest}
    >
      {busy ? 'Working…' : children}
    </button>
  );
}
