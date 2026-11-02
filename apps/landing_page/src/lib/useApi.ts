"use client";

import { useEffect, useSyncExternalStore } from "react";
import { HAS_API, type Resource } from "./api";
import type { ApiProblem } from "./problems";

/**
 * State of one read. After a successful load, a later failed refresh keeps the
 * data and records the problem, so a section never empties itself.
 */
export type Load<T> =
  | { status: "loading" }
  | { status: "ok"; data: T; refreshing: boolean; problem?: ApiProblem }
  | { status: "error"; problem: ApiProblem };

const initial = <T,>(): Load<T> => (HAS_API ? { status: "loading" } : { status: "error", problem: { kind: "not_configured" } });

/**
 * One shared cache entry per resource. Every section that reads the same
 * endpoint shares one request and one answer. The request is cancelled when
 * the last section using it unmounts (the visitor navigated away). The answer
 * is reused until the API's max-age runs out.
 */
class Query<T> {
  private snap: Load<T> = initial<T>();
  private readonly server: Load<T> = this.snap;
  private fetchedAt = 0;
  private maxAgeMs = 0;
  private ctrl: AbortController | null = null;
  private readonly listeners = new Set<() => void>();

  constructor(private readonly res: Resource<T>) {}

  get = () => this.snap;
  getServer = () => this.server;

  subscribe = (listener: () => void) => {
    this.listeners.add(listener);
    this.refreshIfStale();
    return () => {
      this.listeners.delete(listener);
      if (!this.listeners.size) this.ctrl?.abort();
    };
  };

  refreshIfStale = () => {
    if (HAS_API && Date.now() - this.fetchedAt >= this.maxAgeMs) this.load();
  };

  retry = () => {
    if (this.snap.status === "error") this.set({ status: "loading" });
    this.load();
  };

  private load() {
    if (this.ctrl || !HAS_API) return;
    const ctrl = new AbortController();
    this.ctrl = ctrl;
    if (this.snap.status === "ok") this.set({ ...this.snap, refreshing: true });
    void this.res.load(ctrl.signal).then((r) => {
      if (this.ctrl === ctrl) this.ctrl = null;
      const current = this.snap;
      if (r.ok) {
        this.fetchedAt = Date.now();
        this.maxAgeMs = r.maxAgeMs;
        this.set({ status: "ok", data: r.data, refreshing: false });
      } else if (r.problem.kind === "cancelled") {
        if (current.status === "ok") this.set({ ...current, refreshing: false });
      } else if (current.status === "ok") {
        this.set({ ...current, refreshing: false, problem: r.problem });
      } else {
        this.set({ status: "error", problem: r.problem });
      }
    });
  }

  private set(next: Load<T>) {
    this.snap = next;
    this.listeners.forEach((l) => l());
  }
}

const queries = new Map<string, Query<unknown>>();

function queryFor<T>(res: Resource<T>): Query<T> {
  let q = queries.get(res.key) as Query<T> | undefined;
  if (!q) {
    q = new Query(res);
    queries.set(res.key, q as Query<unknown>);
  }
  return q;
}

/**
 * Reads a resource. Refetches when the tab comes back into view and the cached
 * answer is older than its max-age, and on `refreshEveryMs` while visible.
 */
export function useApi<T>(res: Resource<T>, opts: { refreshEveryMs?: number } = {}): Load<T> & { retry: () => void } {
  const q = queryFor(res);
  const snap = useSyncExternalStore(q.subscribe, q.get, q.getServer);
  const every = opts.refreshEveryMs;
  useEffect(() => {
    if (!HAS_API) return;
    const wake = () => {
      if (document.visibilityState === "visible") q.refreshIfStale();
    };
    window.addEventListener("focus", wake);
    document.addEventListener("visibilitychange", wake);
    const timer = every ? window.setInterval(wake, every) : undefined;
    return () => {
      window.removeEventListener("focus", wake);
      document.removeEventListener("visibilitychange", wake);
      if (timer) window.clearInterval(timer);
    };
  }, [q, every]);
  return { ...snap, retry: q.retry };
}
