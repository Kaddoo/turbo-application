import { useEffect, useState, type ReactNode } from 'react';
import { problemMessage } from '@/utils/problems';
import { Button } from './Button';
import { Dialog, DialogActions } from './Dialog';
import { TextField } from './Field';
import s from './ui.module.css';

/** Confirm dialog. `typeToConfirm` is only for the irreversible. */
export function ConfirmDialog({
  open,
  onClose,
  title,
  body,
  confirmLabel,
  onConfirm,
  danger,
  typeToConfirm,
  busy,
  error,
}: {
  open: boolean;
  onClose: () => void;
  title: string;
  body: ReactNode;
  confirmLabel: string;
  onConfirm: () => void;
  danger?: boolean;
  typeToConfirm?: string;
  busy?: boolean;
  error?: unknown;
}) {
  const [typed, setTyped] = useState('');
  useEffect(() => {
    if (!open) setTyped('');
  }, [open]);
  return (
    <Dialog open={open} onClose={onClose} title={title}>
      <div className={s.dialogText}>{body}</div>
      {typeToConfirm && (
        <TextField
          label={`Type ${typeToConfirm} to confirm`}
          value={typed}
          onChange={(e) => setTyped(e.target.value)}
          autoComplete="off"
        />
      )}
      {error ? (
        <p className={s.error} role="alert">
          {problemMessage(error)}
        </p>
      ) : null}
      <DialogActions>
        <Button variant="ghost" onClick={onClose}>
          Cancel
        </Button>
        <Button
          variant={danger ? 'danger' : 'primary'}
          onClick={onConfirm}
          busy={busy}
          disabled={typeToConfirm ? typed !== typeToConfirm : false}
        >
          {confirmLabel}
        </Button>
      </DialogActions>
    </Dialog>
  );
}
