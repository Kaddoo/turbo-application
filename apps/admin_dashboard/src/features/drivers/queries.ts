import { useQuery } from '@tanstack/react-query';
import { PAGE_SIZE, useAction, useCursorList } from '@/hooks';
import { driverDocuments } from '@/services/driverDocuments';
import { drivers } from '@/services/drivers';
import { uploadFile } from '@/services/uploads';
import type { AccountStatus, Body, Schemas } from '@/types';

export const driverKeys = {
  all: ['drivers'],
  list: (status: string, duty: string) => ['drivers', status, duty],
  detail: (id: string) => ['driver', id],
  expiringDocs: ['expiring-docs'],
  salaryProfile: (id: string) => ['salary-profile', id],
};

/** Empty filter values mean "any". */
export function useDrivers(status: string, duty: string) {
  return useCursorList(driverKeys.list(status, duty), (cursor) =>
    drivers.list({
      status: (status || undefined) as AccountStatus | undefined,
      dutyStatus: (duty || undefined) as 'on_duty' | 'off_duty' | undefined,
      cursor,
      limit: PAGE_SIZE,
    }),
  );
}

export function useExpiringDocuments() {
  return useQuery({ queryKey: driverKeys.expiringDocs, queryFn: () => driverDocuments.expiring({ withinDays: 30 }) });
}

export function useDriver(id: string) {
  return useQuery({ queryKey: driverKeys.detail(id), queryFn: () => drivers.get(id) });
}

/** No profile yet is a 404, so it is not retried. */
export function useSalaryProfile(id: string) {
  return useQuery({ queryKey: driverKeys.salaryProfile(id), retry: false, queryFn: () => drivers.salaryProfile(id) });
}

export function useCreateDriver() {
  return useAction((body: Body<'/admin/drivers', 'post'>) => drivers.create(body), [driverKeys.all]);
}

export function useUpdateDriver(id: string) {
  return useAction(
    (body: Body<'/admin/drivers/{id}', 'patch'>) => drivers.update(id, body),
    [driverKeys.detail(id), driverKeys.all],
  );
}

/** Uploads the file first, then attaches it to the driver. */
export function useAddDriverDocument(id: string) {
  return useAction(
    async ({
      type,
      expiresOn,
      file,
    }: {
      type: Schemas['DriverDocumentCreate']['type'];
      expiresOn: string;
      file: File;
    }) => {
      const uploadId = await uploadFile('driver_document', file);
      return drivers.addDocument(id, { type, uploadId, ...(expiresOn ? { expiresOn } : {}) });
    },
    [driverKeys.detail(id), driverKeys.expiringDocs],
  );
}

export function useSaveSalaryProfile(id: string) {
  return useAction(
    (body: Body<'/admin/drivers/{id}/salary-profile', 'put'>) => drivers.setSalaryProfile(id, body),
    [driverKeys.salaryProfile(id)],
  );
}
