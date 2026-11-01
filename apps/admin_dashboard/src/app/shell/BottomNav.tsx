import { NavLink } from 'react-router';
import { Icon, cx } from '@/components';
import type { NavItem } from '@/app/routes';
import sh from './shell.module.css';

/** Phone tab bar: up to four places plus More (opens the full menu). */
export function BottomNav({
  tabs,
  badges,
  onMore,
  moreOpen,
}: {
  tabs: NavItem[];
  badges: Partial<Record<string, { count: number; label: string }>>;
  onMore: () => void;
  moreOpen: boolean;
}) {
  return (
    <nav className={sh.bottomNav} aria-label="Quick menu">
      {tabs.map((t) => {
        const b = badges[t.to];
        return (
          <NavLink
            key={t.to}
            to={t.to}
            end={t.to === '/'}
            className={({ isActive }) => cx(sh.tab, isActive && sh.tabActive)}
            aria-label={b?.count ? `${t.label}, ${b.label}` : undefined}
          >
            <span className={sh.tabIcon}>
              <Icon name={t.icon} />
              {b?.count ? <span className={sh.tabDot} aria-hidden="true" /> : null}
            </span>
            <span className={sh.tabLabel}>{t.label}</span>
          </NavLink>
        );
      })}
      <button type="button" className={sh.tab} aria-expanded={moreOpen} onClick={onMore}>
        <span className={sh.tabIcon}>
          <Icon name="menu" />
        </span>
        <span className={sh.tabLabel}>More</span>
      </button>
    </nav>
  );
}
