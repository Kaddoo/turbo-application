import { useId, useState } from 'react';
import { NavLink } from 'react-router';
import {
  Avatar,
  Badge,
  Icon,
  IconButton,
  SegmentedControl,
  Skeleton,
  cx,
  type IconName,
  type Tone,
} from '@/components';
import { navSides, type NavItem, type NavSide } from '@/app/routes';
import sh from './shell.module.css';

export interface SidebarListItem {
  id: string;
  name: string;
  label: string;
  meta: string;
  tone?: 'neutral' | 'danger' | 'warning' | 'accent';
  onSelect: () => void;
}

export interface SidebarNotice {
  icon: IconName;
  title: string;
  body: string;
  tone: Tone;
}

/**
 * The left column: brand, menu halves toggle, menu with icons and counts, a
 * live list that opens and closes, and a notice card at the bottom. All
 * content comes in through props. `collapsed` shows icons only.
 */
export function Sidebar({
  brand,
  items,
  badges,
  side,
  onSideChange,
  showSideToggle,
  list,
  notice,
  collapsed,
  onToggleCollapsed,
  onClose,
  navLabel,
}: {
  brand: { mark: string; name: string; subtitle: string };
  items: NavItem[];
  badges: Partial<Record<string, { count: number; tone: Tone; label: string }>>;
  side: NavSide;
  onSideChange: (s: NavSide) => void;
  showSideToggle: boolean;
  list?: { title: string; items: SidebarListItem[]; loading?: boolean; empty: string; onViewAll?: () => void };
  notice?: SidebarNotice | null;
  collapsed?: boolean;
  /** Desktop only: shrink to icons. */
  onToggleCollapsed?: () => void;
  /** Drawer only: close the drawer. */
  onClose?: () => void;
  navLabel: string;
}) {
  const [listOpen, setListOpen] = useState(true);
  const listId = useId();
  const groups = items.reduce<{ group: string; items: NavItem[] }[]>((acc, i) => {
    const g = acc.find((x) => x.group === i.group);
    if (g) g.items.push(i);
    else acc.push({ group: i.group, items: [i] });
    return acc;
  }, []);

  return (
    <div className={cx(sh.sidebarInner, collapsed && sh.collapsed)}>
      <div className={sh.brandRow}>
        <span className={sh.brandMark} aria-hidden="true">
          {brand.mark}
        </span>
        <span className={sh.brandText}>
          <span className={sh.brandName}>{brand.name}</span>
          <span className={sh.brandSub}>{brand.subtitle}</span>
        </span>
        {onClose ? (
          <IconButton icon="close" label="Close menu" variant="ghost" onClick={onClose} />
        ) : onToggleCollapsed ? (
          <IconButton
            icon={collapsed ? 'chevronRight' : 'chevronLeft'}
            label={collapsed ? 'Expand menu' : 'Collapse menu'}
            variant="ghost"
            small
            className={sh.collapseButton}
            onClick={onToggleCollapsed}
          />
        ) : null}
      </div>

      {showSideToggle && !collapsed && (
        <SegmentedControl
          label="Menu section"
          block
          value={side}
          onChange={onSideChange}
          options={(Object.keys(navSides) as NavSide[]).map((k) => ({ value: k, label: navSides[k].label }))}
        />
      )}

      <nav className={sh.nav} aria-label={navLabel}>
        {groups.map((g) => (
          <div key={g.group || 'top'} className={sh.navGroup}>
            {g.group && !collapsed && <span className={sh.groupLabel}>{g.group}</span>}
            <ul className={sh.navList}>
              {g.items.map((i) => {
                const b = badges[i.to];
                return (
                  <li key={i.to}>
                    <NavLink
                      to={i.to}
                      end={i.to === '/'}
                      title={collapsed ? i.label : undefined}
                      aria-label={b ? `${i.label}, ${b.label}` : undefined}
                      className={({ isActive }) => cx(sh.navItem, isActive && sh.navActive)}
                    >
                      <Icon name={i.icon} />
                      <span className={sh.navLabel}>{i.label}</span>
                      {b && b.count > 0 && (
                        <Badge
                          count={collapsed ? undefined : b.count}
                          tone={b.tone}
                          className={collapsed ? sh.navDot : sh.navBadge}
                        />
                      )}
                    </NavLink>
                  </li>
                );
              })}
            </ul>
          </div>
        ))}
      </nav>

      {list && !collapsed && (
        <section className={sh.listSection}>
          <button
            type="button"
            className={sh.listHead}
            aria-expanded={listOpen}
            aria-controls={listId}
            onClick={() => setListOpen((o) => !o)}
          >
            <span className={sh.listTitle}>{list.title}</span>
            {!list.loading && <Badge count={list.items.length} tone={list.items.length ? 'danger' : 'neutral'} />}
            <Icon name={listOpen ? 'chevronUp' : 'chevronDown'} size="sm" />
          </button>
          <div id={listId} hidden={!listOpen}>
            {list.loading ? (
              <div className={sh.listLoading} aria-busy="true">
                <Skeleton />
                <Skeleton width="70%" />
              </div>
            ) : list.items.length === 0 ? (
              <p className={sh.listEmpty}>{list.empty}</p>
            ) : (
              <ul className={sh.listItems}>
                {list.items.slice(0, 5).map((it) => (
                  <li key={it.id}>
                    <button type="button" className={sh.listItem} onClick={it.onSelect}>
                      <Avatar name={it.name} size="sm" tone={it.tone} />
                      <span className={sh.listText}>
                        <span className={sh.listLabel}>{it.label}</span>
                        <span className={sh.listMeta}>{it.meta}</span>
                      </span>
                      <Icon name="chevronRight" size="sm" />
                    </button>
                  </li>
                ))}
                {list.items.length > 5 && list.onViewAll && (
                  <li>
                    <button type="button" className={sh.listMore} onClick={list.onViewAll}>
                      View all {list.items.length}
                    </button>
                  </li>
                )}
              </ul>
            )}
          </div>
        </section>
      )}

      {notice && !collapsed && (
        <aside className={cx(sh.notice, sh[`notice-${notice.tone}`])} aria-label={notice.title}>
          <span className={sh.noticeIcon}>
            <Icon name={notice.icon} />
          </span>
          <strong className={sh.noticeTitle}>{notice.title}</strong>
          <p className={sh.noticeBody}>{notice.body}</p>
        </aside>
      )}
    </div>
  );
}
