/**
 * Every request and response shape comes from the contract (`api/contract/openapi.yaml`)
 * through the generated `schema.d.ts`. Nothing here is typed by hand.
 */
import type { components, paths } from './schema';

export type { components, paths };
export type Schemas = components['schemas'];
export type Problem = Schemas['Problem'];
export type ProblemCode = Schemas['ProblemCode'];

type Method = 'get' | 'post' | 'put' | 'patch' | 'delete';

/** Query parameters of an operation, e.g. `Query<'/admin/rides', 'get'>`. */
export type Query<P extends keyof paths, M extends Method> = paths[P][M] extends { parameters: { query?: infer Q } }
  ? NonNullable<Q>
  : never;

/** JSON request body of an operation, e.g. `Body<'/admin/vehicles', 'post'>`. */
export type Body<P extends keyof paths, M extends Method> = paths[P][M] extends {
  requestBody?: { content: { 'application/json': infer B } };
}
  ? B
  : never;

// Names used across the dashboard.
export type AccountStatus = Schemas['AccountStatus'];
export type AdminLogin = Schemas['AdminLogin'];
export type AuthTokens = Schemas['AuthTokens'];
export type Incident = Schemas['Incident'];
export type MfaEnrollment = Schemas['MfaEnrollment'];
export type PageInfo = Schemas['PageInfo'];
export type PickupPoint = Schemas['PickupPoint'];
export type ReconciliationReport = Schemas['ReconciliationReport'];
export type ServiceArea = Schemas['ServiceArea'];
export type Settings = Schemas['Settings'];
export type Shift = Schemas['Shift'];
export type StaffRole = Schemas['StaffRole'];
export type StaffUser = Schemas['StaffUser'];
export type SupportTicket = Schemas['SupportTicket'];
export type Topup = Schemas['Topup'];
export type Vehicle = Schemas['Vehicle'];
export type VerificationStatus = Schemas['VerificationStatus'];
export type WalletAdjustment = Schemas['WalletAdjustment'];
