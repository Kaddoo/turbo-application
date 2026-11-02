/// <reference types="vitest/config" />
import { defineConfig, loadEnv, type Plugin } from 'vite';
import react from '@vitejs/plugin-react';
import { fileURLToPath } from 'node:url';

/** Same header the host must send in production, so dev and preview behave like it. */
const noCrawlers = (): Plugin => {
  const middleware = (_req: unknown, res: { setHeader(k: string, v: string): void }, next: () => void) => {
    res.setHeader('X-Robots-Tag', 'noindex, nofollow, noarchive, nosnippet, noimageindex, noai, noimageai');
    next();
  };
  return {
    name: 'no-crawlers',
    configureServer: (server) => void server.middlewares.use(middleware),
    configurePreviewServer: (server) => void server.middlewares.use(middleware),
  };
};

export default defineConfig(({ mode }) => {
  // Dev only, never bundled (no VITE_ prefix). Prism mock on :4010 by default;
  // the real API runs on :3000 (docs/api-integration.md §1).
  const target = loadEnv(mode, process.cwd(), '').API_PROXY_TARGET || 'http://localhost:4010';
  return {
    plugins: [react(), noCrawlers()],
    resolve: { alias: { '@': fileURLToPath(new URL('./src', import.meta.url)) } },
    server: {
      // Staging sets the refresh cookie only for allowlisted origins, and http://localhost:5173
      // is the dev one. On any other port sign-in works but a reload signs you out, so fail
      // loudly when 5173 is taken instead of moving to 5174.
      port: 5173,
      strictPort: true,
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
