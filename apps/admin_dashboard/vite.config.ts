/// <reference types="vitest/config" />
import { defineConfig, loadEnv } from 'vite';
import react from '@vitejs/plugin-react';
import { fileURLToPath } from 'node:url';

export default defineConfig(({ mode }) => {
  // Dev only, never bundled (no VITE_ prefix). Prism mock on :4010 by default;
  // the real API runs on :3000 (docs/api-integration.md §1).
  const target = loadEnv(mode, process.cwd(), '').API_PROXY_TARGET || 'http://localhost:4010';
  return {
    plugins: [react()],
    resolve: { alias: { '@': fileURLToPath(new URL('./src', import.meta.url)) } },
    server: {
      port: 5173,
      // Same-origin API in development: no CORS, and the SameSite=Strict refresh
      // cookie lands on this origin. Its path and domain are rewritten so the
      // browser sends it back to /api/auth/refresh.
      proxy: {
        '/api': {
          target,
          changeOrigin: true,
          rewrite: (p) => p.replace(/^\/api/, ''),
          cookiePathRewrite: { '*': '/' },
          cookieDomainRewrite: { '*': '' },
        },
      },
    },
    test: {
      environment: 'jsdom',
      include: ['test/**/*.test.{ts,tsx}'],
    },
  };
});
