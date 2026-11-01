import { useId, useState, type ReactElement, type ReactNode } from 'react';
import s from './ui.module.css';

/**
 * Short hint shown on hover and on keyboard focus, linked with
 * aria-describedby. Never the only place important information lives.
 */
export function Tooltip({ text, children }: { text: ReactNode; children: ReactElement }) {
  const id = useId();
  const [show, setShow] = useState(false);
  return (
    <span
      className={s.tooltipAnchor}
      aria-describedby={id}
      onMouseEnter={() => setShow(true)}
      onMouseLeave={() => setShow(false)}
      onFocus={() => setShow(true)}
      onBlur={() => setShow(false)}
      onKeyDown={(e) => e.key === 'Escape' && setShow(false)}
    >
      {children}
      <span role="tooltip" id={id} className={s.tooltip} hidden={!show}>
        {text}
      </span>
    </span>
  );
}
