// Writes .mock/openapi.mock.yaml: the contract (api/contract/openapi.yaml, the source) plus realistic examples where it
// has none, so the Prism mock behaves like a working backend on a phone.
// api/contract/openapi.yaml is never changed. Set MOCK_VERIFICATION to try other states.
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { networkInterfaces } from 'node:os';
import yaml from 'js-yaml';

const spec = yaml.load(readFileSync('api/contract/openapi.yaml', 'utf8'));
const s = spec.components.schemas;
const verification = process.env.MOCK_VERIFICATION ?? 'not_submitted';
const id = (n) => `0190a1b2-0000-7e4f-8a5b-${String(n).padStart(12, '0')}`;

s.AppConfig.example = {
  minVersion: { ios: '1.0.0', android: '1.0.0', web: '1.0.0' },
  maintenance: { active: false, message: null },
  bookingsPaused: false,
  pauseMessage: null,
};
s.OtpChallenge.example = { expiresInSeconds: 300, resendInSeconds: 30 };
s.LegalVersions.example = {
  termsVersion: '2026-10',
  privacyVersion: '2026-10',
  termsUrl: 'https://example.com/terms',
  privacyUrl: 'https://example.com/privacy',
};
s.Student.example = {
  id: id(1),
  phone: '+233241234567',
  fullName: 'Ama Mensah',
  email: null,
  accountStatus: 'active',
  verificationStatus: verification,
  createdAt: '2026-10-01T10:00:00Z',
  termsAcceptedVersion: '2026-10',
};
s.VerificationState.example = {
  status: verification,
  reasonCode: null,
  message: verification === 'needs_attention' ? 'The back of your card is blurry.' : null,
  submittedAt: null,
  decidedAt: null,
  canResubmit: verification === 'needs_attention' || verification === 'not_submitted',
};
s.ServiceArea.example = {
  version: 1,
  boundary: null,
  pickupPoints: [
    { id: id(11), name: 'Main gate', point: { lat: 5.7421, lng: 0.0668 }, isActive: true },
    { id: id(12), name: 'Hostel block', point: { lat: 5.7455, lng: 0.0702 }, isActive: true },
  ],
  maxTripDistanceMeters: 18000,
  fareBands: [
    { upToMeters: 3000, farePesewas: 1800 },
    { upToMeters: 6000, farePesewas: 2500 },
    { upToMeters: 12000, farePesewas: 3500 },
    { upToMeters: 18000, farePesewas: 5000 },
  ],
  operatingHours: null,
};
s.Wallet.example = { balancePesewas: 6000, reservedPesewas: 0, availablePesewas: 6000, currency: 'GHS' };
s.SavedPlaceCollection.example = {
  data: [
    { id: id(21), label: 'Hostel', location: { point: { lat: 5.7455, lng: 0.0702 }, label: 'Hostel block' } },
  ],
};

// Signed upload URLs normally point at private storage. On the mock they point
// back at this server, which accepts any PUT, so photos can be "sent".
const host =
  process.env.MOCK_HOST ??
  Object.values(networkInterfaces())
    .flat()
    .find((n) => n && n.family === 'IPv4' && !n.internal)?.address ??
  'localhost';
s.UploadSlot.example = {
  uploadId: id(31),
  uploadUrl: `http://${host}:4010/mock-upload/photo`,
  method: 'PUT',
  headers: {},
  expiresAt: '2099-01-01T00:00:00Z',
};
spec.paths['/mock-upload/{name}'] = {
  put: {
    operationId: 'mockUploadSink',
    summary: 'Mock only: stands in for private object storage',
    security: [],
    parameters: [{ name: 'name', in: 'path', required: true, schema: { type: 'string' } }],
    requestBody: {
      required: false,
      content: {
        'image/jpeg': { schema: { type: 'string', format: 'binary' } },
        'application/octet-stream': { schema: { type: 'string', format: 'binary' } },
      },
    },
    responses: { 200: { description: 'OK' } },
  },
};

mkdirSync('.mock', { recursive: true });
writeFileSync('.mock/openapi.mock.yaml', yaml.dump(spec, { lineWidth: -1, noRefs: true }));
console.log(`mock spec written (verification: ${verification})`);
