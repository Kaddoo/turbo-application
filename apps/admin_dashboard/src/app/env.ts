/** Environment name set at build time (VITE_APP_ENV). Production shows no badge. */
export const appEnv: string = (import.meta.env.VITE_APP_ENV ?? 'local').toLowerCase();
export const showEnvBadge = appEnv !== 'production';
