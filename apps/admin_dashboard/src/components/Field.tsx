import {
  useId,
  type InputHTMLAttributes,
  type ReactNode,
  type SelectHTMLAttributes,
  type TextareaHTMLAttributes,
} from 'react';
import { cx } from './cx';
import s from './ui.module.css';

interface FieldProps {
  label: string;
  hint?: string;
  error?: string;
}

/** Label, control, then the error (or hint). The control points at both with aria-describedby. */
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
        <span className={s.hint} id={`${id}-hint`}>
          {hint}
        </span>
      ) : null}
    </div>
  );
}

const describedBy = (id: string, hint?: string, error?: string) =>
  error ? `${id}-err` : hint ? `${id}-hint` : undefined;

export function TextField({ label, hint, error, ...rest }: FieldProps & InputHTMLAttributes<HTMLInputElement>) {
  const id = useId();
  return (
    <Field id={id} label={label} hint={hint} error={error}>
      <input
        id={id}
        className={s.input}
        aria-invalid={error ? true : undefined}
        aria-describedby={describedBy(id, hint, error)}
        {...rest}
      />
    </Field>
  );
}

export function TextArea({ label, hint, error, ...rest }: FieldProps & TextareaHTMLAttributes<HTMLTextAreaElement>) {
  const id = useId();
  return (
    <Field id={id} label={label} hint={hint} error={error}>
      <textarea
        id={id}
        className={s.input}
        aria-invalid={error ? true : undefined}
        aria-describedby={describedBy(id, hint, error)}
        {...rest}
      />
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
      <select
        id={id}
        className={cx(s.input, s.select)}
        aria-invalid={error ? true : undefined}
        aria-describedby={describedBy(id, hint, error)}
        {...rest}
      >
        {options.map((o) => (
          <option key={o.value} value={o.value}>
            {o.label}
          </option>
        ))}
      </select>
    </Field>
  );
}

/** Checkbox with its label on the right; the whole row is the target. */
export function Checkbox({
  label,
  hint,
  ...rest
}: { label: string; hint?: string } & Omit<InputHTMLAttributes<HTMLInputElement>, 'type'>) {
  const id = useId();
  return (
    <label className={s.check} htmlFor={id}>
      <input
        id={id}
        type="checkbox"
        className={s.checkInput}
        aria-describedby={hint ? `${id}-hint` : undefined}
        {...rest}
      />
      <span>
        {label}
        {hint && (
          <span className={s.hint} id={`${id}-hint`}>
            {' '}
            {hint}
          </span>
        )}
      </span>
    </label>
  );
}

/** On/off switch. Uses a checkbox with role="switch" so it reads as on or off. */
export function Switch({
  label,
  checked,
  onChange,
  disabled,
}: {
  label: string;
  checked: boolean;
  onChange: (on: boolean) => void;
  disabled?: boolean;
}) {
  const id = useId();
  return (
    <label className={s.check} htmlFor={id}>
      <input
        id={id}
        type="checkbox"
        role="switch"
        className={s.switchInput}
        checked={checked}
        disabled={disabled}
        onChange={(e) => onChange(e.target.checked)}
      />
      <span className={s.switchTrack} aria-hidden="true" />
      <span>{label}</span>
    </label>
  );
}

/**
 * Range slider with the current value in a bubble above the thumb and the
 * maximum in a chip, as on the live-refresh card.
 */
export function Slider({
  label,
  value,
  min,
  max,
  step = 1,
  onChange,
  format = String,
  disabled,
  labelHidden,
}: {
  label: string;
  value: number;
  min: number;
  max: number;
  step?: number;
  onChange: (v: number) => void;
  format?: (v: number) => string;
  disabled?: boolean;
  /** The card around the slider shows the title; the label stays for screen readers. */
  labelHidden?: boolean;
}) {
  const id = useId();
  const pct = ((value - min) / (max - min)) * 100;
  return (
    <div className={s.slider}>
      {labelHidden ? (
        <label className={s.visuallyHidden} htmlFor={id}>
          {label}
        </label>
      ) : (
        <div className={s.sliderHead}>
          <label className={s.label} htmlFor={id}>
            {label}
          </label>
          <span className={cx(s.chip, s['chip-plain'], s['tone-neutral'])}>{format(max)}</span>
        </div>
      )}
      <div className={s.sliderTrackWrap} style={{ ['--pct' as string]: `${pct}%` }}>
        <span className={s.sliderTicks} aria-hidden="true" />
        <span className={s.sliderBubble} aria-hidden="true">
          {format(value)}
        </span>
        <input
          id={id}
          type="range"
          className={s.range}
          min={min}
          max={max}
          step={step}
          value={value}
          disabled={disabled}
          aria-valuetext={format(value)}
          onChange={(e) => onChange(Number(e.target.value))}
        />
      </div>
    </div>
  );
}
