import { forwardRef, type ButtonHTMLAttributes } from 'react';
import { Badge } from './Badge';
import { cx } from './cx';
import { Icon, type IconName } from './Icon';
import s from './ui.module.css';

/** Square or round icon-only button. `label` is required: it is the accessible name and the hover hint. */
export const IconButton = forwardRef<
  HTMLButtonElement,
  Omit<ButtonHTMLAttributes<HTMLButtonElement>, 'children'> & {
    icon: IconName;
    label: string;
    variant?: 'outline' | 'ghost' | 'filled' | 'accent';
    small?: boolean;
    round?: boolean;
    /** Count shown on the corner, e.g. unread notifications. */
    count?: number;
  }
>(function IconButton({ icon, label, variant = 'outline', small, round, count, className, ...rest }, ref) {
  return (
    <button
      ref={ref}
      type="button"
      aria-label={count ? `${label}, ${count}` : label}
      title={label}
      className={cx(s.iconButton, s[`ib-${variant}`], small && s.ibSmall, round && s.ibRound, className)}
      {...rest}
    >
      <Icon name={icon} size={small ? 'sm' : 'md'} />
      {count ? <Badge count={count} className={s.ibBadge} /> : null}
    </button>
  );
});
