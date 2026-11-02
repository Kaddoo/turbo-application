import { type ReactNode } from 'react';
import { initials } from './Avatar';
import s from './profile.module.css';

/**
 * The top of a person's page: a large initials avatar, name, contact lines, status
 * chips, and a few numbers down the right (they drop under the name on phones).
 */
export function ProfileHero({
  name,
  lines = [],
  chips,
  stats = [],
  label,
}: {
  name: string;
  /** Contact lines under the name (email, phone). */
  lines?: ReactNode[];
  chips?: ReactNode;
  stats?: { label: string; value: ReactNode }[];
  label: string;
}) {
  return (
    <section className={s.hero} aria-label={label}>
      <span className={s.avatar} aria-hidden="true">
        {initials(name)}
      </span>
      <div className={s.who}>
        <h2 className={s.name}>{name}</h2>
        {lines.map((l, i) => (
          <p key={i} className={s.line}>
            {l}
          </p>
        ))}
        {chips && <div className={s.chips}>{chips}</div>}
      </div>
      {stats.length > 0 && (
        <dl className={s.stats}>
          {stats.map((x) => (
            <div key={x.label} className={s.stat}>
              <dt className={s.statLabel}>{x.label}</dt>
              <dd className={s.statValue}>{x.value}</dd>
            </div>
          ))}
        </dl>
      )}
    </section>
  );
}
