import { formatPesewas } from '@/utils/format';
import s from './ui.module.css';

export function Money({ pesewas }: { pesewas: number | null | undefined }) {
  return <span className={s.num}>{pesewas == null ? '—' : formatPesewas(pesewas)}</span>;
}
