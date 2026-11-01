import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vitest/config';

/** Live checks against a real API (test/live). Never part of `npm test`. */
export default defineConfig({
  resolve: { alias: { '@': fileURLToPath(new URL('./src', import.meta.url)) } },
  test: {
    environment: 'node',
    include: ['test/live/**/*.live.ts'],
    testTimeout: 30_000,
    sequence: { concurrent: false },
  },
});
