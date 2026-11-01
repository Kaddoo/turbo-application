import { cx } from './cx';
import s from './ui.module.css';

/** Initials from a name; the tone tells people apart, not meaning. */
export function initials(name: string): string {
  const parts = name.trim().split(/\s+/).filter(Boolean);
  if (!parts.length) return '?';
  return ((parts[0]![0] ?? '') + (parts.length > 1 ? (parts[parts.length - 1]![0] ?? '') : '')).toUpperCase();
}

export function Avatar({
  name,
  size = 'md',
  tone = 'neutral',
  label,
}: {
  name: string;
  size?: 'sm' | 'md' | 'lg';
  tone?: 'neutral' | 'accent' | 'danger' | 'warning';
  /** Accessible name when the avatar stands alone; omit when a name is shown next to it. */
  label?: string;
}) {
  return (
    <span
      className={cx(s.avatar, s[`avatar-${size}`], s[`avatar-${tone}`])}
      role={label ? 'img' : undefined}
      aria-label={label}
      aria-hidden={label ? undefined : true}
    >
      {initials(name)}
    </span>
  );
}
