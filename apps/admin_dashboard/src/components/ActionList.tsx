import { type ReactNode } from 'react';
import { Icon, type IconName } from './Icon';
import type { Tone } from './Chip';
import s from './actions.module.css';

/** A list of things staff can do, each with what it does in plain words. */
export function ActionList({ children, label }: { children: ReactNode; label: string }) {
  return (
    <ul className={s.list} aria-label={label}>
      {children}
    </ul>
  );
}

/**
 * One action: an icon, a title, what happens, and the whole row as the button.
 * `danger` and `warning` tint it so the serious ones look serious before they are read.
 */
export function ActionRow({
  icon,
  title,
  description,
  tone = 'neutral',
  onClick,
  disabled,
}: {
  icon: IconName;
  title: string;
  description: string;
  tone?: Tone;
  onClick: () => void;
  disabled?: boolean;
}) {
  return (
    <li>
      <button type="button" className={s.row} data-tone={tone} onClick={onClick} disabled={disabled}>
        <span className={s.icon} aria-hidden="true">
          <Icon name={icon} size="sm" />
        </span>
        <span className={s.text}>
          <span className={s.title}>{title}</span>
          <span className={s.description}>{description}</span>
        </span>
        <Icon name="chevronRight" size="sm" className={s.chevron} />
      </button>
    </li>
  );
}
