import { useId, useState } from 'react';
import { NavLink } from 'react-router';
import {
  Badge,
  Icon,
  IconButton,
  IconTile,
  SegmentedControl,
  Skeleton,
  cx,
  type IconName,
  type TileTone,
  type Tone,
} from '@/components';
import { navSides, type NavItem, type NavSide } from '@/app/routes';
import sh from './shell.module.css';

export interface SidebarListItem {
  id: string;
  icon: IconName;
  tone: TileTone;
  /** Small coloured line ("Asset Ethereum"). */
  caption: string;
  /** Main line ("Amount $7,699.00"). */
  value: string;
  onSelect: () => void;
}

export interface SidebarNotice {
  icon: IconName;
  title: string;
  body: string;
  tone: Tone;
  onSelect?: () => void;
}

/**
 * The left column, after the reference design: brand row, menu halves toggle,
 * a flat menu with icons and soft count badges, a live list that opens and
 * closes, and a one-line notice card at the bottom. Content comes in through
 * props. `collapsed` shows icons only.
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
  list?: {
    title: string;
    icon: IconName;
    items: SidebarListItem[];
    loading?: boolean;
    empty: string;
    onViewAll?: () => void;
  };
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
            icon={collapsed ? 'chevronRight' : 'sort'}
            label={collapsed ? 'Expand menu' : 'Collapse menu'}
            variant="ghost"
            small
            onClick={onToggleCollapsed}
          />
        ) : null}
      </div>

      {showSideToggle && !collapsed && (
        <div className={sh.toggleRow}>
          <SegmentedControl
            label="Menu section"
            block
            value={side}
            onChange={onSideChange}
            options={(Object.keys(navSides) as NavSide[]).map((k) => ({ value: k, label: navSides[k].label }))}
          />
        </div>
      )}

      <nav className={sh.nav} aria-label={navLabel}>
        <ul className={sh.navList}>
          {items.map((i) => {
            const b = badges[i.to];
            return (
              <li key={i.to}>
                <NavLink
                  to={i.to}
                  end={i.to === '/'}
                  title={collapsed ? i.label : undefined}
                  aria-label={b?.count ? `${i.label}, ${b.label}` : undefined}
                  className={({ isActive }) => cx(sh.navItem, isActive && sh.navActive)}
                >
                  <Icon name={i.icon} size="sm" />
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

        {list && !collapsed && (
          <section className={sh.listSection} aria-label={list.title}>
            <button
              type="button"
              className={sh.navItem}
              aria-expanded={listOpen}
              aria-controls={listId}
              onClick={() => setListOpen((o) => !o)}
            >
              <Icon name={list.icon} size="sm" />
              <span className={cx(sh.navLabel, sh.listTitle)}>{list.title}</span>
              {!list.loading && list.items.length > 0 && (
                <Badge count={list.items.length} tone="danger" className={sh.navBadgeInline} />
              )}
              <Icon name={listOpen ? 'chevronUp' : 'chevronDown'} size="sm" className={sh.listChevron} />
            </button>
            <div id={listId} hidden={!listOpen} className={sh.listBody}>
              {list.loading ? (
                <div className={sh.listLoading} aria-busy="true">
                  <Skeleton />
                  <Skeleton width="70%" />
                </div>
              ) : list.items.length === 0 ? (
                <p className={sh.listEmpty}>{list.empty}</p>
              ) : (
                <ul className={sh.listItems}>
                  {list.items.slice(0, 4).map((it) => (
                    <li key={it.id}>
                      <button type="button" className={sh.listItem} onClick={it.onSelect}>
                        <IconTile icon={it.icon} tone={it.tone} size="sm" />
                        <span className={sh.listText}>
                          <span className={cx(sh.listCaption, sh[`listCaption-${it.tone}`])}>{it.caption}</span>
                          <span className={sh.listValue}>{it.value}</span>
                        </span>
                      </button>
                    </li>
                  ))}
                  {list.items.length > 4 && list.onViewAll && (
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
      </nav>

      {notice && !collapsed && (
        <button
          type="button"
          className={cx(sh.notice, sh[`notice-${notice.tone}`])}
          onClick={notice.onSelect}
          disabled={!notice.onSelect}
        >
          <Icon name={notice.icon} className={sh.noticeIcon} />
          <span className={sh.noticeText}>
            <span className={sh.noticeTitle}>{notice.title}</span>
            <span className={sh.noticeBody}>{notice.body}</span>
          </span>
        </button>
      )}
    </div>
  );
}
