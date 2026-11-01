import { turboBrand } from '../brand/brand';

/**
 * User-visible text. The product name only ever comes from the brand layer.
 * Copy rules: plain English, short, no exclamation marks (prompts/00).
 */
export const strings = {
  appName: turboBrand.appName,
  navLabel: 'Main navigation',
  environment: (env: string) => `${env} environment`,
  signedOutTitle: 'Sign in to continue',
  signedOutBody: `Staff sign-in for ${turboBrand.appName} operations.`,
};
