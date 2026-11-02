"use client";

import { useEffect, useState } from "react";

export type Load<T> = { status: "loading" } | { status: "ok"; data: T } | { status: "error" };

const HAS_API = Boolean(process.env.PUBLIC_API_BASE_URL);

/** Runs a read-only API getter once. With no API configured it resolves to "error" synchronously. */
export function useApi<T>(getter: () => Promise<T | null>, isUsable: (d: T) => boolean = () => true): Load<T> {
  const [state, setState] = useState<Load<T>>(HAS_API ? { status: "loading" } : { status: "error" });
  useEffect(() => {
    if (!HAS_API) return;
    let live = true;
    getter().then((d) => {
      if (live) setState(d && isUsable(d) ? { status: "ok", data: d } : { status: "error" });
    });
    return () => {
      live = false;
    };
    // getter/isUsable are module-level functions at every call site
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);
  return state;
}
