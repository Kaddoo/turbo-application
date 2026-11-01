import js from '@eslint/js';
import { defineConfig } from 'eslint/config';
import reactHooks from 'eslint-plugin-react-hooks';
import globals from 'globals';
import tseslint from 'typescript-eslint';

/**
 * Import rules keep the layers apart:
 *   pages    -> features, components, hooks
 *   features -> services, components, hooks, state, utils, types (never another feature)
 *   services -> types and utils only, no React
 * Only services/http.ts may import openapi-fetch. Use the @/ alias, not ../ chains.
 */
const everywhere = [{ group: ['../*'], message: 'Use the @/ alias instead of ../ paths.' }];
const noHttpClient = {
  name: 'openapi-fetch',
  message: 'Only src/services/http.ts talks HTTP. Call a service instead.',
};
const restrict = (patterns, paths = [noHttpClient]) => ({
  'no-restricted-imports': ['error', { paths, patterns: [...everywhere, ...patterns] }],
});

export default defineConfig(
  { ignores: ['dist', 'src/types/schema.d.ts'] },
  js.configs.recommended,
  tseslint.configs.recommended,
  {
    files: ['**/*.{ts,tsx}'],
    languageOptions: { globals: globals.browser },
    plugins: { 'react-hooks': reactHooks },
    rules: {
      'react-hooks/rules-of-hooks': 'error',
      'react-hooks/exhaustive-deps': 'warn',
      // `const { secret: _drop, ...rest } = x` is how a field is left out on purpose.
      '@typescript-eslint/no-unused-vars': ['error', { ignoreRestSiblings: true }],
      // Nothing is printed to the console: it is how tokens, codes and phone numbers end up in logs.
      'no-console': 'error',
      ...restrict([]),
    },
  },
  {
    files: ['src/pages/**'],
    rules: restrict([
      { group: ['@/services/*', '@/services'], message: 'Pages compose features; features call services.' },
    ]),
  },
  {
    files: ['src/features/**'],
    rules: restrict([
      {
        group: ['@/features/*', '@/features/**'],
        message: 'Features never import another feature. Move shared code to components, hooks or utils.',
      },
      { group: ['@/pages/*'], message: 'Features never import pages.' },
    ]),
  },
  {
    files: ['src/services/**'],
    rules: restrict(
      [
        {
          group: [
            '@/features/*',
            '@/pages/*',
            '@/components',
            '@/components/*',
            '@/hooks',
            '@/hooks/*',
            '@/state/*',
            '@/app/*',
          ],
          message: 'Services depend only on types and utils.',
        },
      ],
      [
        noHttpClient,
        { name: 'react', message: 'Services never import React.' },
        { name: '@tanstack/react-query', message: 'Services never import React Query.' },
      ],
    ),
  },
  {
    files: ['src/services/http.ts'],
    rules: restrict([], [{ name: 'react', message: 'Services never import React.' }]),
  },
  {
    // The geist package does not export its font files, so they are imported by path.
    files: ['src/brand/brand.ts'],
    rules: { 'no-restricted-imports': 'off' },
  },
  {
    files: ['test/**', '*.config.{js,ts}', 'vite.config.ts', 'vitest.live.config.ts'],
    languageOptions: { globals: { ...globals.browser, ...globals.node } },
  },
);
