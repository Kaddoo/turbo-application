import type { Schemas } from '@/types';
import { ApiError } from '@/utils/problems';
import { api, call, send, UPLOAD_TIMEOUT_MS } from './http';

type UploadPurpose = Schemas['UploadRequest']['purpose'];
type UploadContentType = Schemas['UploadRequest']['contentType'];

/**
 * The type to declare for a file. Browsers often report CSV as '' or
 * 'application/vnd.ms-excel'; the API wants 'text/csv' (contract 0.2.2, for
 * `provider_statement` only).
 */
export function uploadContentType(file: File): UploadContentType {
  if (/\.csv$/i.test(file.name)) return 'text/csv' as UploadContentType;
  return file.type as UploadContentType;
}

/**
 * Signed upload (docs/api-integration.md §5): ask for a slot, PUT the raw
 * bytes with exactly the declared Content-Type and no auth header, and only
 * hand back the uploadId once storage has accepted the file.
 */
export async function uploadFile(purpose: UploadPurpose, file: File): Promise<string> {
  const contentType = uploadContentType(file);
  const slot = await call(api.POST('/uploads', { body: { purpose, contentType, sizeBytes: file.size } }));
  const res = await send(
    slot.uploadUrl,
    { method: slot.method, body: file, headers: { ...slot.headers, 'Content-Type': contentType } },
    UPLOAD_TIMEOUT_MS,
  );
  if (!res.ok) throw new ApiError(res.status, null);
  return slot.uploadId;
}
