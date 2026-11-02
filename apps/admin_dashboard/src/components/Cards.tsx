import { type ReactNode } from 'react';
import { Avatar } from './Avatar';
import { cx } from './cx';
import { Icon, type IconName } from './Icon';
import type { Tone } from './Chip';
import s from './cards.module.css';

/** Building blocks for the per-screen cards in `DataTable`'s `card` prop. */

/** Top line of a card: what it is on the left, its status on the right. */
export function CardTop({ children, end }: { children: ReactNode; end?: ReactNode }) {
  return (
    <div className={s.top}>
      <div className={s.topMain}>{children}</div>
      {end && <div className={s.topEnd}>{end}</div>}
    </div>
  );
}

/** Avatar with a name and a line under it; `presence` adds a green or grey dot (on or off duty). */
export function Person({
  name,
  sub,
  tone,
  presence,
  size = 'md',
}: {
  name: string;
  sub?: ReactNode;
  tone?: 'neutral' | 'accent' | 'danger' | 'warning';
  presence?: 'on' | 'off';
  size?: 'sm' | 'md' | 'lg';
}) {
  return (
    <div className={s.person}>
      <span className={s.personAvatar}>
        <Avatar name={name} tone={tone} size={size} />
        {presence && <span className={s.presence} data-on={presence === 'on'} aria-hidden="true" />}
      </span>
      <span className={s.personText}>
        <span className={s.personName}>{name}</span>
        {sub && <span className={s.personSub}>{sub}</span>}
      </span>
    </div>
  );
}

/** One number that matters, large and in the monospace face, with a small label over it. */
export function Figure({
  label,
  children,
  tone,
  size = 'md',
  note,
}: {
  label: string;
  children: ReactNode;
  tone?: Tone;
  size?: 'md' | 'lg';
  /** Smaller text beside the number, e.g. "of GH₵100.00". */
  note?: ReactNode;
}) {
  return (
    <div className={s.figure} data-tone={tone}>
      <span className={s.label}>{label}</span>
      <span className={cx(s.figureValue, size === 'lg' && s.figureLg)}>
        {children}
        {note && <span className={s.figureNote}>{note}</span>}
      </span>
    </div>
  );
}

export function Facts({ children, columns = 2 }: { children: ReactNode; columns?: 1 | 2 | 3 }) {
  return (
    <dl className={s.facts} data-columns={columns}>
      {children}
    </dl>
  );
}

export function Fact({ label, children, mono }: { label: string; children: ReactNode; mono?: boolean }) {
  return (
    <div className={s.fact}>
      <dt className={s.label}>{label}</dt>
      <dd className={cx(s.factValue, mono && s.mono)}>{children}</dd>
    </div>
  );
}

/** A licence plate. */
export function Plate({ children }: { children: ReactNode }) {
  return <span className={s.plate}>{children}</span>;
}

/** A tinted strip for the thing that needs a look: a flag, a warning, a lock. */
export function Callout({ tone = 'neutral', icon, children }: { tone?: Tone; icon?: IconName; children: ReactNode }) {
  return (
    <div className={s.callout} data-tone={tone}>
      {icon && <Icon name={icon} size="sm" />}
      <span>{children}</span>
    </div>
  );
}

/** A row of dots that fills up: no-shows, seats, steps. */
export function Dots({ count, of, tone, label }: { count: number; of: number; tone?: Tone; label: string }) {
  return (
    <span className={s.dots} data-tone={tone} role="img" aria-label={label}>
      {Array.from({ length: of }, (_, i) => (
        <span key={i} className={s.dot} data-on={i < count} />
      ))}
    </span>
  );
}

/** Quiet text for a missing value. */
export function Muted({ children }: { children: ReactNode }) {
  return <span className={s.muted}>{children}</span>;
}

/** Footer line of a card: small text on the left, actions on the right. */
export function CardFoot({ children, end }: { children?: ReactNode; end?: ReactNode }) {
  return (
    <div className={s.foot}>
      <span className={s.footMain}>{children}</span>
      {end && <span className={s.footEnd}>{end}</span>}
    </div>
  );
}
