import { Icon, IconButton, cx, usePopover, type Tone } from '@/components';
import sh from './shell.module.css';

export interface Notice {
  id: string;
  tone: Tone;
  title: string;
  body?: string;
  /** Already formatted, e.g. "4 min ago". */
  time?: string;
  onSelect?: () => void;
}

const icon = { danger: 'danger', warning: 'warning', success: 'success', accent: 'info', neutral: 'info' } as const;

/** Bell with a count; opens a panel listing what needs attention. Polling feeds it (no staff push yet). */
export function NotificationBell({ items, loading }: { items: Notice[]; loading?: boolean }) {
  const p = usePopover();
  const urgent = items.some((i) => i.tone === 'danger');
  return (
    <div className={sh.anchor}>
      <IconButton
        ref={p.triggerRef}
        icon="bell"
        label="Notifications"
        round
        count={items.length || undefined}
        aria-expanded={p.open}
        aria-controls={p.panelId}
        className={cx(urgent && sh.bellUrgent)}
        onClick={p.toggle}
      />
      {p.open && (
        <div ref={p.panelRef} id={p.panelId} className={sh.notifPanel} role="dialog" aria-label="Notifications">
          <div className={sh.notifHead}>
            <strong>Notifications</strong>
            <span className={sh.notifCount}>{items.length ? `${items.length} need attention` : ''}</span>
          </div>
          {loading ? (
            <p className={sh.notifEmpty}>Checking…</p>
          ) : items.length === 0 ? (
            <p className={sh.notifEmpty}>You are all caught up.</p>
          ) : (
            <ul className={sh.notifList}>
              {items.map((n) => (
                <li key={n.id}>
                  <button
                    type="button"
                    className={sh.notifItem}
                    onClick={() => {
                      p.close(false);
                      n.onSelect?.();
                    }}
                  >
                    <span className={cx(sh.notifIcon, sh[`notif-${n.tone}`])}>
                      <Icon name={icon[n.tone]} size="sm" />
                    </span>
                    <span className={sh.notifText}>
                      <span className={sh.notifTitle}>{n.title}</span>
                      {n.body && <span className={sh.notifBody}>{n.body}</span>}
                    </span>
                    {n.time && <span className={sh.notifTime}>{n.time}</span>}
                  </button>
                </li>
              ))}
            </ul>
          )}
        </div>
      )}
    </div>
  );
}
