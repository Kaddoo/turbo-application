import {
  createContext, useCallback, useContext, useEffect, useId, useRef, useState,
  type ButtonHTMLAttributes, type InputHTMLAttributes, type ReactNode, type SelectHTMLAttributes,
  type TextareaHTMLAttributes,
} from 'react';
import { formatDateTime, formatPesewas, formatRelative } from '../lib/format';
import { problemMessage } from '../lib/problems';
import s from './ui.module.css';

const cx = (...c: (string | false | null | undefined)[]) => c.filter(Boolean).join(' ');

type Variant = 'primary' | 'secondary' | 'danger' | 'ghost';

export function Button({
  variant = 'secondary', small, busy, className, children, disabled, ...rest
}: ButtonHTMLAttributes<HTMLButtonElement> & { variant?: Variant; small?: boolean; busy?: boolean }) {
  return (
    <button
      type="button"
      className={cx(s.button, s[variant], small && s.small, className)}
      disabled={disabled || busy}
      aria-busy={busy || undefined}
      {...rest}
    >
      {busy ? 'Working…' : children}
    </button>
  );
}

interface FieldProps { label: string; hint?: string; error?: string }

function Field({ label, hint, error, id, children }: FieldProps & { id: string; children: ReactNode }) {
  return (
    <div className={s.field}>
      <label className={s.label} htmlFor={id}>{label}</label>
      {children}
      {error ? <span className={s.error} id={`${id}-err`}>{error}</span> : hint ? <span className={s.hint}>{hint}</span> : null}
    </div>
  );
}

export function TextField({ label, hint, error, ...rest }: FieldProps & InputHTMLAttributes<HTMLInputElement>) {
  const id = useId();
  return (
    <Field id={id} label={label} hint={hint} error={error}>
      <input id={id} className={s.input} aria-invalid={error ? true : undefined}
        aria-describedby={error ? `${id}-err` : undefined} {...rest} />
    </Field>
  );
}

export function TextArea({ label, hint, error, ...rest }: FieldProps & TextareaHTMLAttributes<HTMLTextAreaElement>) {
  const id = useId();
  return (
    <Field id={id} label={label} hint={hint} error={error}>
      <textarea id={id} className={s.input} aria-invalid={error ? true : undefined} {...rest} />
    </Field>
  );
}

export function Select({
  label, hint, error, options, ...rest
}: FieldProps & SelectHTMLAttributes<HTMLSelectElement> & { options: { value: string; label: string }[] }) {
  const id = useId();
  return (
    <Field id={id} label={label} hint={hint} error={error}>
      <select id={id} className={s.input} {...rest}>
        {options.map((o) => <option key={o.value} value={o.value}>{o.label}</option>)}
      </select>
    </Field>
  );
}

export type Tone = 'neutral' | 'success' | 'warning' | 'danger' | 'accent';

/** Status is never colour alone: the chip always carries its word. */
export function Chip({ tone = 'neutral', children }: { tone?: Tone; children: ReactNode }) {
  return <span className={cx(s.chip, s[`tone-${tone}`])}><span>{children}</span></span>;
}

export function Money({ pesewas }: { pesewas: number | null | undefined }) {
  return <span className={s.num}>{pesewas == null ? '—' : formatPesewas(pesewas)}</span>;
}

/** Relative time with the exact Accra time on hover. */
export function When({ iso, exact }: { iso: string | null | undefined; exact?: boolean }) {
  if (!iso) return <span className={s.muted}>—</span>;
  return (
    <time dateTime={iso} title={formatDateTime(iso)}>
      {exact ? formatDateTime(iso) : formatRelative(iso)}
    </time>
  );
}

export function Card({ title, children, actions }: { title?: string; children: ReactNode; actions?: ReactNode }) {
  return (
    <section className={s.card}>
      {(title || actions) && (
        <div className={s.pageHeader} style={{ marginBottom: 12 }}>
          {title && <h2 className={s.cardTitle} style={{ margin: 0 }}>{title}</h2>}
          {actions && <div className={s.actions}>{actions}</div>}
        </div>
      )}
      {children}
    </section>
  );
}

export function PageHeader({ title, description, actions }: { title: string; description?: string; actions?: ReactNode }) {
  return (
    <header className={s.pageHeader}>
      <div>
        <h1 className={s.pageTitle}>{title}</h1>
        {description && <p className={s.pageDescription}>{description}</p>}
      </div>
      {actions && <div className={s.actions}>{actions}</div>}
    </header>
  );
}

export function Skeleton({ width = '100%' }: { width?: string }) {
  return <span className={s.skeleton} style={{ width }} aria-hidden="true" />;
}

export function EmptyState({ title, body, action }: { title: string; body?: string; action?: ReactNode }) {
  return (
    <div className={s.state} role="status">
      <p className={s.stateTitle}>{title}</p>
      {body && <p style={{ margin: 0 }}>{body}</p>}
      {action}
    </div>
  );
}

export function ErrorState({ error, onRetry }: { error: unknown; onRetry?: () => void }) {
  return (
    <div className={s.state} role="alert">
      <p className={s.stateTitle}>{problemMessage(error)}</p>
      {onRetry && <Button onClick={onRetry}>Try again</Button>}
    </div>
  );
}

export function Banner({ tone, children, action }: { tone: Tone; children: ReactNode; action?: ReactNode }) {
  return (
    <div className={cx(s.banner, s[`tone-${tone}`])} role={tone === 'danger' ? 'alert' : 'status'}>
      <Chip tone={tone}>{tone === 'danger' ? 'Urgent' : tone === 'warning' ? 'Warning' : 'Note'}</Chip>
      <span>{children}</span>
      {action}
    </div>
  );
}

export function Stat({ label, value, urgent, onClick, loading, error }: {
  label: string; value: ReactNode; urgent?: boolean; onClick?: () => void; loading?: boolean; error?: unknown;
}) {
  return (
    <button type="button" className={cx(s.card, s.stat, urgent && s.statUrgent)} onClick={onClick}>
      <span className={s.statLabel}>{label}</span>
      {loading ? <Skeleton width="40%" /> : error ? <span className={s.error}>{problemMessage(error)}</span>
        : <span className={s.statValue}>{value}</span>}
    </button>
  );
}

export interface Column<T> {
  header: string;
  cell: (row: T) => ReactNode;
  align?: 'right';
  width?: string;
}

export function DataTable<T>({
  columns, rows, rowKey, loading, error, onRetry, empty, onRowClick, hasMore, onLoadMore, loadingMore, label,
}: {
  columns: Column<T>[];
  rows: T[] | undefined;
  rowKey: (row: T) => string;
  loading?: boolean;
  error?: unknown;
  onRetry?: () => void;
  empty: { title: string; body?: string; action?: ReactNode };
  onRowClick?: (row: T) => void;
  hasMore?: boolean;
  onLoadMore?: () => void;
  loadingMore?: boolean;
  label: string;
}) {
  if (error && !rows?.length) return <div className={s.tableWrap}><ErrorState error={error} onRetry={onRetry} /></div>;
  if (!loading && rows && rows.length === 0) return <div className={s.tableWrap}><EmptyState {...empty} /></div>;
  return (
    <div className={s.tableWrap}>
      <table className={s.table} aria-label={label} aria-busy={loading || undefined}>
        <thead>
          <tr>{columns.map((c) => <th key={c.header} className={c.align === 'right' ? s.right : undefined} style={{ width: c.width }}>{c.header}</th>)}</tr>
        </thead>
        <tbody>
          {loading && !rows?.length
            ? Array.from({ length: 6 }, (_, i) => (
              <tr key={i}>{columns.map((c) => <td key={c.header}><Skeleton width={i % 2 ? '60%' : '80%'} /></td>)}</tr>
            ))
            : rows?.map((row) => (
              <tr
                key={rowKey(row)}
                className={onRowClick ? s.rowLink : undefined}
                tabIndex={onRowClick ? 0 : undefined}
                onClick={onRowClick ? () => onRowClick(row) : undefined}
                onKeyDown={onRowClick ? (e) => { if (e.key === 'Enter') onRowClick(row); } : undefined}
              >
                {columns.map((c) => <td key={c.header} className={c.align === 'right' ? cx(s.right, s.num) : undefined}>{c.cell(row)}</td>)}
              </tr>
            ))}
        </tbody>
      </table>
      {hasMore && (
        <div className={s.tableFooter}>
          <Button small onClick={onLoadMore} busy={loadingMore}>Load more</Button>
        </div>
      )}
    </div>
  );
}

/** Modal built on the native dialog element: focus trap and Escape for free. */
export function Dialog({ open, onClose, title, children }: {
  open: boolean; onClose: () => void; title: string; children: ReactNode;
}) {
  const ref = useRef<HTMLDialogElement>(null);
  useEffect(() => {
    const d = ref.current;
    if (!d) return;
    if (open && !d.open) d.showModal();
    if (!open && d.open) d.close();
  }, [open]);
  return (
    <dialog ref={ref} className={s.dialog} onClose={onClose} aria-labelledby={`${title}-t`}>
      {open && (
        <div className={s.dialogBody}>
          <h2 className={s.dialogTitle} id={`${title}-t`}>{title}</h2>
          {children}
        </div>
      )}
    </dialog>
  );
}

export function DialogActions({ children }: { children: ReactNode }) {
  return <div className={s.dialogActions}>{children}</div>;
}

/** Confirm dialog. `typeToConfirm` is only for the irreversible. */
export function ConfirmDialog({
  open, onClose, title, body, confirmLabel, onConfirm, danger, typeToConfirm, busy, error,
}: {
  open: boolean; onClose: () => void; title: string; body: ReactNode; confirmLabel: string;
  onConfirm: () => void; danger?: boolean; typeToConfirm?: string; busy?: boolean; error?: unknown;
}) {
  const [typed, setTyped] = useState('');
  useEffect(() => { if (!open) setTyped(''); }, [open]);
  return (
    <Dialog open={open} onClose={onClose} title={title}>
      <div className={s.dialogText}>{body}</div>
      {typeToConfirm && (
        <TextField label={`Type ${typeToConfirm} to confirm`} value={typed} onChange={(e) => setTyped(e.target.value)} autoComplete="off" />
      )}
      {error ? <p className={s.error} role="alert">{problemMessage(error)}</p> : null}
      <DialogActions>
        <Button variant="ghost" onClick={onClose}>Cancel</Button>
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

export function Tabs<T extends string>({ tabs, value, onChange }: {
  tabs: { value: T; label: string }[]; value: T; onChange: (v: T) => void;
}) {
  return (
    <div className={s.tabs} role="tablist">
      {tabs.map((t) => (
        <button key={t.value} type="button" role="tab" aria-selected={t.value === value} className={s.tab} onClick={() => onChange(t.value)}>
          {t.label}
        </button>
      ))}
    </div>
  );
}

export function Details({ items }: { items: [string, ReactNode][] }) {
  return (
    <dl className={s.dl}>
      {items.map(([k, v]) => <div key={k} style={{ display: 'contents' }}><dt>{k}</dt><dd>{v}</dd></div>)}
    </dl>
  );
}

const ToastContext = createContext<(message: string) => void>(() => {});

export function ToastProvider({ children }: { children: ReactNode }) {
  const [items, setItems] = useState<{ id: number; message: string }[]>([]);
  const show = useCallback((message: string) => {
    const id = Date.now() + Math.random();
    setItems((x) => [...x, { id, message }]);
    setTimeout(() => setItems((x) => x.filter((t) => t.id !== id)), 4000);
  }, []);
  return (
    <ToastContext.Provider value={show}>
      {children}
      <div className={s.toastRegion} role="status" aria-live="polite">
        {items.map((t) => <div key={t.id} className={s.toast}>{t.message}</div>)}
      </div>
    </ToastContext.Provider>
  );
}

export const useToast = () => useContext(ToastContext);

export const ui = s;
export { cx };
