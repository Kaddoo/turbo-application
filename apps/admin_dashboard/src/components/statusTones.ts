import type { AccountStatus, VerificationStatus } from '@/types';
import type { Tone } from './Chip';

/** Chip tones for statuses that more than one feature shows. */
export const verificationTone: Record<VerificationStatus, Tone> = {
  not_submitted: 'neutral',
  pending: 'warning',
  needs_attention: 'warning',
  approved: 'success',
  rejected: 'danger',
};

export const accountTone: Record<AccountStatus, Tone> = { active: 'success', suspended: 'danger' };
