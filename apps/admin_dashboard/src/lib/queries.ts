import { useInfiniteQuery, useMutation, useQueryClient, type QueryKey } from '@tanstack/react-query';
import type { Schemas } from '../api/client';

type PageInfo = Schemas['PageInfo'];

/** List envelopes use `data` (0.1) or `items` (0.2). Both carry an optional cursor page. */
type ListEnvelope<T> = { data?: T[]; items?: T[]; page?: PageInfo };

export const PAGE_SIZE = 25;

/** Cursor-paginated list with "Load more". */
export function useCursorList<T>(key: QueryKey, fetchPage: (cursor: string | undefined) => Promise<ListEnvelope<T>>, enabled = true) {
  const q = useInfiniteQuery({
    queryKey: key,
    enabled,
    initialPageParam: undefined as string | undefined,
    queryFn: ({ pageParam }) => fetchPage(pageParam),
    getNextPageParam: (last) => (last.page?.hasMore && last.page.nextCursor ? last.page.nextCursor : undefined),
  });
  const rows = q.data?.pages.flatMap((p) => p.data ?? p.items ?? []);
  return {
    rows,
    loading: q.isPending && enabled,
    error: q.error,
    refetch: () => void q.refetch(),
    hasMore: q.hasNextPage,
    loadMore: () => void q.fetchNextPage(),
    loadingMore: q.isFetchingNextPage,
  };
}

/** Mutation that refreshes the given query keys afterwards. */
export function useAction<TVars, TResult>(run: (v: TVars) => Promise<TResult>, invalidate: QueryKey[] = []) {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: run,
    onSuccess: () => Promise.all(invalidate.map((k) => qc.invalidateQueries({ queryKey: k }))),
  });
}
