import { useMutation, useQueryClient, type QueryKey } from '@tanstack/react-query';

/** Mutation that refreshes the given query keys afterwards. */
export function useAction<TVars, TResult>(run: (v: TVars) => Promise<TResult>, invalidate: QueryKey[] = []) {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: run,
    onSuccess: () => Promise.all(invalidate.map((k) => qc.invalidateQueries({ queryKey: k }))),
  });
}
