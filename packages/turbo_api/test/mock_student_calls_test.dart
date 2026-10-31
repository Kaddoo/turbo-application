// Every call the student app makes in phase 1, answered by the Prism mock and
// decoded by the generated client. Start the mock first: `npm run mock`.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_api/turbo_api.dart';

void main() {
  const base = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:4010');
  late TurboClient client;

  setUpAll(() async {
    try {
      await (await HttpClient().getUrl(Uri.parse(base))).close();
    } on SocketException {
      fail('Mock not running at $base. Run `npm run mock` first.');
    }
    client = TurboClient(baseUrl: base, appVersion: 'ios/0.0.1', accessToken: () => 'mock-token');
  });

  final point = GeoPoint(lat: 5.74, lng: 0.066);

  test('app config and legal', () async {
    expect((await client.api.getMetaApi().getAppConfig()).data!.minVersion.ios, isNotEmpty);
    expect((await client.api.getMetaApi().getLegalVersions()).data!.termsVersion, isNotEmpty);
  });

  test('sign-in calls', () async {
    final challenge = (await client.api.getAuthApi().requestOtp(
          otpRequest: OtpRequest(phone: '+233241234567', role: OtpRequestRoleEnum.student, deviceId: 'd'),
        ))
        .data!;
    expect(challenge.resendInSeconds, isNonNegative);
    final tokens = (await client.api.getAuthApi().verifyOtp(
          otpVerify: OtpVerify(
            phone: '+233241234567',
            code: '123456',
            role: OtpVerifyRoleEnum.student,
            clientType: OtpVerifyClientTypeEnum.mobile,
          ),
        ))
        .data!;
    expect(tokens.accessToken, isNotEmpty);
    final refreshed = (await client.api.getAuthApi().refreshTokens(refreshRequest: RefreshRequest(refreshToken: 'x'))).data!;
    expect(refreshed.accessToken, isNotEmpty);
  });

  test('profile, verification, saved places, wallet', () async {
    expect((await client.api.getStudentApi().getMe()).data!.verificationStatus, isNotNull);
    expect((await client.api.getVerificationApi().getMyVerification()).data!.status, isNotNull);
    expect((await client.api.getStudentApi().listSavedPlaces()).data!.data, isNotNull);
    expect((await client.api.getWalletApi().getWallet()).data!.availablePesewas, isNonNegative);
  });

  test('uploads and verification submit', () async {
    final slot = (await client.api.getUploadsApi().createUpload(
          uploadRequest: UploadRequest(
            purpose: UploadRequestPurposeEnum.ghanaCardFront,
            contentType: UploadRequestContentTypeEnum.imageSlashJpeg,
            sizeBytes: 1000,
          ),
        ))
        .data!;
    expect(slot.uploadId, isNotEmpty);
    final state = (await client.api.getVerificationApi().submitVerification(
          verificationSubmission: VerificationSubmission(
            fullName: 'Ama Mensah',
            studentIdNumber: 'CU/1',
            ghanaCardNumber: 'GHA-123456789-0',
            ghanaCardFrontUploadId: slot.uploadId,
            ghanaCardBackUploadId: slot.uploadId,
            studentIdUploadId: slot.uploadId,
            selfieUploadId: slot.uploadId,
          ),
        ))
        .data!;
    expect(state.status, isNotNull);
  });

  test('service area and quote', () async {
    final area = (await client.api.getServiceAreaApi().getServiceArea()).data!;
    expect(area.maxTripDistanceMeters, isPositive);
    final quote = (await client.api.getRidesApi().createQuote(
          quoteRequest: QuoteRequest(pickup: Location(point: point), dropoff: Location(point: point)),
        ))
        .data!;
    expect(quote.wallet.availablePesewas, isNonNegative);
  });
}
