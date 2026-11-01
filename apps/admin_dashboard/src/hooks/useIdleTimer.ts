import { useEffect, useRef, useState } from 'react';

/** Idle sign-out after 15 minutes, with a warning at 14 (prompts/02). */
export function useIdleTimer(onIdle: () => void, idleMs = 15 * 60_000, warnMs = 14 * 60_000) {
  const [warning, setWarning] = useState(false);
  const last = useRef(Date.now());
  useEffect(() => {
    const bump = () => {
      last.current = Date.now();
      setWarning(false);
    };
    const events = ['mousemove', 'keydown', 'pointerdown', 'scroll'] as const;
    events.forEach((e) => window.addEventListener(e, bump, { passive: true }));
    const timer = setInterval(() => {
      const idle = Date.now() - last.current;
      if (idle >= idleMs) onIdle();
      else if (idle >= warnMs) setWarning(true);
    }, 5_000);
    return () => {
      events.forEach((e) => window.removeEventListener(e, bump));
      clearInterval(timer);
    };
  }, [onIdle, idleMs, warnMs]);
  return {
    warning,
    stayActive: () => {
      last.current = Date.now();
      setWarning(false);
    },
  };
}
