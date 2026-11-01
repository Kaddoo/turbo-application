import { type ReactNode } from 'react';
import s from './ui.module.css';

export function Details({ items }: { items: [string, ReactNode][] }) {
  return (
    <dl className={s.dl}>
      {items.map(([k, v]) => <div key={k} style={{ display: 'contents' }}><dt>{k}</dt><dd>{v}</dd></div>)}
    </dl>
  );
}
