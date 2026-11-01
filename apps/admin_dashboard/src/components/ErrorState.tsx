import { problemMessage } from '@/utils/problems';
import { Button } from './Button';
import { cx } from './cx';
import { Icon } from './Icon';
import s from './ui.module.css';

/** A failed load. The message comes from the problem `code`, never the server's own text. */
export function ErrorState({ error, onRetry, compact }: { error: unknown; onRetry?: () => void; compact?: boolean }) {
  return (
    <div className={cx(s.state, compact && s.stateCompact)} role="alert">
      <span className={cx(s.stateIcon, s.stateIconDanger)}>
        <Icon name="danger" />
      </span>
      <p className={s.stateTitle}>{problemMessage(error)}</p>
      {onRetry && (
        <Button small icon="refresh" onClick={onRetry}>
          Try again
        </Button>
      )}
    </div>
  );
}
