import { type ReactNode } from 'react';
import type { Schemas } from '@/types';
import { formatPesewas } from '@/utils/format';
import { Icon } from './Icon';
import s from './wallet.module.css';

/**
 * A wallet, drawn like one: a payment card with the spendable amount showing from the
 * top of a stitched leather-style pocket, and the held and total money in the pocket.
 */
export function WalletCard({
  wallet,
  holder,
  reference,
  footer,
}: {
  wallet: Schemas['Wallet'];
  /** Name printed on the card. */
  holder: string;
  /** Short id, shown as "•••• 1234". */
  reference?: string;
  /** Under the pocket: a hint, or buttons. */
  footer?: ReactNode;
}) {
  const total = Math.max(wallet.balancePesewas, 0);
  const heldShare = total > 0 ? Math.min(100, Math.round((wallet.reservedPesewas / total) * 100)) : 0;
  const owed = wallet.owedPesewas ?? 0;
  return (
    <section className={s.wallet} aria-label="Wallet">
      <div className={s.card}>
        <div className={s.cardTop}>
          <span className={s.cardLabel}>Wallet</span>
          <span className={s.cardLabel}>{wallet.currency}</span>
        </div>
        <div className={s.cardMid}>
          <span className={s.chip} aria-hidden="true" />
          <svg className={s.contactless} viewBox="0 0 24 24" width="28" height="28" aria-hidden="true">
            <path
              d="M8 6c2.5 3.5 2.5 8.5 0 12M12 4c3.5 4.5 3.5 11.5 0 16M16 2c4.5 5.5 4.5 14.5 0 20"
              fill="none"
              stroke="currentColor"
              strokeWidth="1.8"
              strokeLinecap="round"
            />
          </svg>
        </div>
        <div className={s.available}>
          <span className={s.cardLabel}>Available to spend</span>
          <span className={s.amount}>{formatPesewas(wallet.availablePesewas)}</span>
        </div>
        <div className={s.holder}>
          <span>{holder}</span>
          {reference && <span className={s.reference}>•••• {reference}</span>}
        </div>
      </div>

      <div className={s.pocket}>
        <span className={s.snap} aria-hidden="true">
          <Icon name="lock" size="sm" />
        </span>
        <div
          className={s.split}
          data-empty={total === 0}
          role="img"
          aria-label={total === 0 ? 'The wallet is empty' : `${heldShare}% of the balance is held for rides`}
        >
          <span className={s.splitHeld} style={{ width: `${heldShare}%` }} />
        </div>
        <dl className={s.figures}>
          <div className={s.figure}>
            <dt>Balance</dt>
            <dd>{formatPesewas(wallet.balancePesewas)}</dd>
          </div>
          <div className={s.figure}>
            <dt>Held for rides</dt>
            <dd>{formatPesewas(wallet.reservedPesewas)}</dd>
          </div>
        </dl>
        {owed > 0 && (
          <p className={s.owed} role="status">
            <Icon name="warning" size="sm" />
            Owes {formatPesewas(owed)} after a reversal. Booking is blocked until it is cleared.
          </p>
        )}
        {footer && <div className={s.footer}>{footer}</div>}
      </div>
    </section>
  );
}
