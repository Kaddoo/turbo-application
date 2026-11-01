import { useEffect, useRef, useState } from 'react';

/** Shared across tabs so working in one tab keeps the others signed in. A timestamp only. */
const ACTIVITY_KEY = 'admin.lastActivity';
/** Write the shared timestamp at most this often. */
const SHARE_EVERY_MS = 10_000;

function readShared(): number {
  try {
    return Number(localStorage.getItem(ACTIVITY_KEY)) || 0;
  } catch {
    return 0;
  }
}
function writeShared(at: number) {
  try {
    localStorage.setItem(ACTIVITY_KEY, String(at));
  } catch {
    /* storage blocked: this tab times out on its own activity */
  }
}

/** Idle sign-out after 15 minutes, with a warning at 14 (prompts/02). */
export function useIdleTimer(onIdle: () => void, idleMs = 15 * 60_000, warnMs = 14 * 60_000) {
  const [warning, setWarning] = useState(false);
  const last = useRef(Date.now());
  const shared = useRef(0);
  useEffect(() => {
    const bump = () => {
      const now = Date.now();
      last.current = now;
      setWarning(false);
      if (now - shared.current > SHARE_EVERY_MS) {
        shared.current = now;
        writeShared(now);
      }
    };
    const events = ['mousemove', 'keydown', 'pointerdown', 'scroll'] as const;
    events.forEach((e) => window.addEventListener(e, bump, { passive: true }));
    bump();
    const timer = setInterval(() => {
      const idle = Date.now() - Math.max(last.current, readShared());
      if (idle >= idleMs) onIdle();
      else if (idle >= warnMs) setWarning(true);
      else setWarning(false);
    }, 5_000);
    return () => {
      events.forEach((e) => window.removeEventListener(e, bump));
      clearInterval(timer);
    };
  }, [onIdle, idleMs, warnMs]);
  return {
    warning,
    stayActive: () => {
      const now = Date.now();
      last.current = now;
      shared.current = now;
      writeShared(now);
      setWarning(false);
    },
  };
}
