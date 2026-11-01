import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { setDemoTransport } from '@/services/http';
import { turboBrand } from '@/brand/brand';
import { applyTheme } from '@/theme/theme';
import { SessionProvider } from '@/state/session';
import { ToastProvider } from '@/components';
import { ApiError } from '@/utils/problems';
import '@/theme/base.css';
import { App } from '@/app/App';

applyTheme(turboBrand);
document.title = `${turboBrand.appName} admin`;

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 15_000,
      // Never retry client errors (403, 404, 422); back off on the rest, including no response (status 0).
      retry: (count, err) =>
        !(err instanceof ApiError && err.status > 0 && err.status < 500 && err.status !== 429) && count < 2,
      // 429 and 503 say how long to wait (Retry-After); otherwise exponential back-off.
      retryDelay: (count, err) =>
        err instanceof ApiError && err.retryAfterSeconds
          ? Math.min(err.retryAfterSeconds, 60) * 1000
          : Math.min(1000 * 2 ** count, 30_000),
      refetchOnWindowFocus: true,
    },
  },
});

async function start() {
  // Checked inline (not via isDemo) so Vite drops the demo server from real builds.
  if (import.meta.env.VITE_APP_ENV === 'demo') {
    const { demoFetch } = await import('@/demo/server');
    setDemoTransport(demoFetch);
  }
  createRoot(document.getElementById('root')!).render(
    <StrictMode>
      <QueryClientProvider client={queryClient}>
        <SessionProvider>
          <ToastProvider>
            <App />
          </ToastProvider>
        </SessionProvider>
      </QueryClientProvider>
    </StrictMode>,
  );
}

void start();
