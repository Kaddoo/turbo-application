import { cx } from './cx';
import s from './ui.module.css';

/**
 * Line icons drawn on a 24-unit grid with `currentColor`, so they take the
 * text colour of whatever holds them. Decorative by default: the control that
 * holds an icon carries the accessible name.
 */
const paths = {
  overview: 'M4 13h6V4H4zM14 20h6v-9h-6zM4 20h6v-3H4zM14 7h6V4h-6z',
  verification: 'M12 3l7 3v5c0 4.5-3 8.3-7 10-4-1.7-7-5.5-7-10V6zM9 12l2 2 4-4',
  students: 'M3 9l9-5 9 5-9 5zM7 11.5V16c0 1.4 2.2 3 5 3s5-1.6 5-3v-4.5M21 9v6',
  drivers: 'M12 3a9 9 0 100 18 9 9 0 000-18zM12 9a3 3 0 100 6 3 3 0 000-6zM3.5 10.5L9 12M20.5 10.5L15 12M12 15v6',
  vehicles: 'M5 16l1.5-6.5A2 2 0 018.4 8h7.2a2 2 0 011.9 1.5L19 16M4 16h16v3H4zM7 19v2M17 19v2M7.5 13h.01M16.5 13h.01',
  liveMap: 'M9 4L3 6.5v13.5l6-2.5 6 2.5 6-2.5V4l-6 2.5zM9 4v13.5M15 6.5V20',
  rides: 'M6 19a2 2 0 100-4 2 2 0 000 4zM18 9a2 2 0 100-4 2 2 0 000 4zM6 15V9a4 4 0 014-4h2M18 9v6a4 4 0 01-4 4h-2',
  announcements: 'M4 10v4h3l6 4V6L7 10zM17 9a4 4 0 010 6M19.5 6.5a7.5 7.5 0 010 11',
  topups: 'M3 7h15a3 3 0 013 3v7a3 3 0 01-3 3H6a3 3 0 01-3-3zM3 7l12-3v3M16 13.5h.01',
  adjustments: 'M4 6h10M18 6h2M4 12h4M12 12h8M4 18h12M20 18h0M16 4v4M10 10v4M18 16v4',
  reconciliation: 'M12 4v16M5 8h14M7 8l-3 7a3 3 0 006 0zM17 8l-3 7a3 3 0 006 0zM8 20h8',
  support:
    'M12 3a9 9 0 100 18 9 9 0 000-18zM12 8a4 4 0 100 8 4 4 0 000-8zM5.6 5.6l3.6 3.6M14.8 14.8l3.6 3.6M18.4 5.6l-3.6 3.6M9.2 14.8l-3.6 3.6',
  incidents: 'M12 4L2.5 20h19zM12 10v4M12 17h.01',
  shifts: 'M4 6h16v14H4zM4 10h16M8 3v4M16 3v4M8 14h3',
  attendance: 'M12 3a9 9 0 100 18 9 9 0 000-18zM12 7v5l3 2',
  salary: 'M3 7h18v10H3zM12 9.5a2.5 2.5 0 100 5 2.5 2.5 0 000-5zM6 10v4M18 10v4',
  configuration:
    'M12 9a3 3 0 100 6 3 3 0 000-6zM19 12a7 7 0 00-.1-1.2l2-1.5-2-3.5-2.4 1a7 7 0 00-2-1.2L14 3h-4l-.5 2.6a7 7 0 00-2 1.2l-2.4-1-2 3.5 2 1.5A7 7 0 005 12a7 7 0 00.1 1.2l-2 1.5 2 3.5 2.4-1a7 7 0 002 1.2L10 21h4l.5-2.6a7 7 0 002-1.2l2.4 1 2-3.5-2-1.5c.1-.4.1-.8.1-1.2z',
  staff: 'M9 11a4 4 0 100-8 4 4 0 000 8zM2 21v-1a6 6 0 0112 0v1M16 3.5a4 4 0 010 7.5M18 14a6 6 0 014 6v1',
  auditLog: 'M6 3h9l4 4v14H6zM14 3v5h5M9 12h7M9 16h7',
  account: 'M12 12a4 4 0 100-8 4 4 0 000 8zM4 21a8 8 0 0116 0',
  lock: 'M6 11h12v10H6zM8 11V7a4 4 0 0 1 8 0v4',
  bell: 'M6 16V11a6 6 0 0112 0v5l2 2H4zM10 21h4',
  search: 'M11 4a7 7 0 100 14 7 7 0 000-14zM20 20l-4-4',
  menu: 'M4 7h16M4 12h16M4 17h16',
  close: 'M6 6l12 12M18 6L6 18',
  chevronDown: 'M6 9l6 6 6-6',
  chevronUp: 'M6 15l6-6 6 6',
  chevronLeft: 'M15 6l-6 6 6 6',
  chevronRight: 'M9 6l6 6-6 6',
  sort: 'M8 10l4-4 4 4M8 14l4 4 4-4',
  arrowUpRight: 'M7 17L17 7M8 7h9v9',
  arrowUp: 'M12 19V5M6 11l6-6 6 6',
  arrowDown: 'M12 5v14M6 13l6 6 6-6',
  plus: 'M12 5v14M5 12h14',
  refresh: 'M20 12a8 8 0 01-14.3 4.9M4 12a8 8 0 0114.3-4.9M18 3v4h-4M6 21v-4h4',
  filter: 'M4 5h16l-6 7.5V19l-4 2v-8.5z',
  chart: 'M4 20V4M4 20h16M8 16v-5M12 16V8M16 16v-3',
  more: 'M5 12h.01M12 12h.01M19 12h.01',
  check: 'M5 12.5l4.5 4.5L19 7',
  info: 'M12 3a9 9 0 100 18 9 9 0 000-18zM12 11v5M12 8h.01',
  warning: 'M12 4L2.5 20h19zM12 10v4M12 17h.01',
  danger: 'M12 3a9 9 0 100 18 9 9 0 000-18zM12 8v5M12 16h.01',
  success: 'M12 3a9 9 0 100 18 9 9 0 000-18zM8 12l3 3 5-5',
  signOut: 'M15 4h4v16h-4M10 8l-4 4 4 4M6 12h10',
  inbox: 'M4 13l2.5-8h11l2.5 8v6H4zM4 13h5l1 2h4l1-2h5',
  external: 'M14 4h6v6M20 4l-9 9M18 14v6H4V6h6',
} as const;

export type IconName = keyof typeof paths;

export function Icon({
  name,
  size = 'md',
  className,
}: {
  name: IconName;
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}) {
  return (
    <svg
      className={cx(s.icon, s[`icon-${size}`], className)}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={1.75}
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
      focusable="false"
    >
      <path d={paths[name]} />
    </svg>
  );
}
