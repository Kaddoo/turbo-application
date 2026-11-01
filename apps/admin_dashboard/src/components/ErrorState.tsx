import { problemMessage } from '@/utils/problems';
import { Button } from './Button';
import s from './ui.module.css';

export function ErrorState({ error, onRetry }: { error: unknown; onRetry?: () => void }) {
  return (
    <div className={s.state} role="alert">
      <p className={s.stateTitle}>{problemMessage(error)}</p>
      {onRetry && <Button onClick={onRetry}>Try again</Button>}
    </div>
  );
}
