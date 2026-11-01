import { Avatar, Icon, Menu } from '@/components';
import sh from './shell.module.css';

/** Avatar, email, role badge and name; opens Account and Sign out. `compact` shows the avatar only. */
export function UserMenu({
  name,
  email,
  role,
  compact,
  onAccount,
  onSignOut,
}: {
  name: string;
  email: string;
  role: string;
  compact?: boolean;
  onAccount: () => void;
  onSignOut: () => void;
}) {
  return (
    <Menu
      label="Account menu"
      align={compact ? 'end' : 'start'}
      header={
        compact ? (
          <div className={sh.menuHeader}>
            <strong>{name}</strong>
            <span className={sh.muted}>{role}</span>
          </div>
        ) : undefined
      }
      items={[
        { key: 'account', label: 'Account and security', icon: 'account', onSelect: onAccount },
        { key: 'out', label: 'Sign out', icon: 'signOut', danger: true, onSelect: onSignOut },
      ]}
      renderTrigger={(t) => (
        <button type="button" className={compact ? sh.userCompact : sh.user} aria-label={`${name}, ${role}`} {...t}>
          <Avatar name={name} size="md" />
          {!compact && (
            <>
              <span className={sh.userText}>
                <span className={sh.userTop}>
                  <span className={sh.userEmail}>{email}</span>
                  <span className={sh.roleBadge}>{role}</span>
                </span>
                <span className={sh.userName}>{name}</span>
              </span>
              <Icon name="chevronDown" size="sm" />
            </>
          )}
        </button>
      )}
    />
  );
}
