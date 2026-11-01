import s from './ui.module.css';

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
