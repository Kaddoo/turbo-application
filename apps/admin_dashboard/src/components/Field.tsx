import {
  useId,
  type InputHTMLAttributes,
  type ReactNode,
  type SelectHTMLAttributes,
  type TextareaHTMLAttributes,
} from 'react';
import s from './ui.module.css';

interface FieldProps {
  label: string;
  hint?: string;
  error?: string;
}

function Field({ label, hint, error, id, children }: FieldProps & { id: string; children: ReactNode }) {
  return (
    <div className={s.field}>
      <label className={s.label} htmlFor={id}>
        {label}
      </label>
      {children}
      {error ? (
        <span className={s.error} id={`${id}-err`}>
          {error}
        </span>
      ) : hint ? (
        <span className={s.hint}>{hint}</span>
      ) : null}
    </div>
  );
}

export function TextField({ label, hint, error, ...rest }: FieldProps & InputHTMLAttributes<HTMLInputElement>) {
  const id = useId();
  return (
    <Field id={id} label={label} hint={hint} error={error}>
      <input
        id={id}
        className={s.input}
        aria-invalid={error ? true : undefined}
        aria-describedby={error ? `${id}-err` : undefined}
        {...rest}
      />
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
  label,
  hint,
  error,
  options,
  ...rest
}: FieldProps & SelectHTMLAttributes<HTMLSelectElement> & { options: { value: string; label: string }[] }) {
  const id = useId();
  return (
    <Field id={id} label={label} hint={hint} error={error}>
      <select id={id} className={s.input} {...rest}>
        {options.map((o) => (
          <option key={o.value} value={o.value}>
            {o.label}
          </option>
        ))}
      </select>
    </Field>
  );
}
