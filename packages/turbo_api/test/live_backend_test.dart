// Decodes the real backend's answers with the generated client. Skipped unless
// a backend runs at API_BASE_URL (default http://localhost:3000, started with
// tools/backend-local.sh) in development mode, where the sign-in code is 123456.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:turbo_api/turbo_api.dart';

Future<TurboClient?> signIn(String base, String phone, OtpRequestRoleEnum role) async {
  final anon = TurboClient(baseUrl: base, appVersion: 'ios/9.9.9');
  try {
    await anon.api.getAuthApi().requestOtp(otpRequest: OtpRequest(phone: phone, role: role, deviceId: 'live-test'));
  } catch (e) {
    final p = problemOf(e);
    // A code was asked for less than 30 s ago; the fixed code still works.
    if (p.code != 'otp_rate_limited') rethrow;
  }
  final tokens = (await anon.api.getAuthApi().verifyOtp(
            otpVerify: OtpVerify(
              phone: phone,
              code: '123456',
              role: role == OtpRequestRoleEnum.driver ? OtpVerifyRoleEnum.driver : OtpVerifyRoleEnum.student,
              clientType: OtpVerifyClientTypeEnum.mobile,
              acceptedTermsVersion: '1.0',
              acceptedPrivacyVersion: '1.0',
            ),
          ))
      .data!;
  return TurboClient(baseUrl: base, appVersion: 'ios/9.9.9', accessToken: () => tokens.accessToken);
}

void main() {
  const base = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');
  var up = false;

  setUpAll(() async {
    try {
      final r = await (await HttpClient().getUrl(Uri.parse('$base/health'))).close();
      up = r.statusCode == 200;
    } catch (_) {
      up = false;
    }
  });

  test('driver answers decode', () async {
    if (!up) {
      markTestSkipped('no backend at $base');
      return;
    }
    final c = (await signIn(base, '+233200000002', OtpRequestRoleEnum.driver))!;
    final api = c.api.getDriverApi();
    expect((await api.getDriverProfile()).data!.fullName, isNotEmpty);
    await api.getCurrentDriverRide(); // 204 when there is no ride
    expect((await api.listDriverRides()).data!.data, isNotNull);
    expect((await api.listMyShifts()).data!.data, isNotNull);
    expect((await api.listMyAttendance()).data!.data, isNotNull);
    expect((await api.listMySalaryPayments()).data!.data, isNotNull);
    expect((await c.api.getStudentApi().listSessions()).data!.items, isNotEmpty);
  });

  test('student answers decode', () async {
    if (!up) {
      markTestSkipped('no backend at $base');
      return;
    }
    final c = (await signIn(base, '+233241110003', OtpRequestRoleEnum.student))!;
    final api = c.api.getStudentApi();
    expect((await api.getMe()).data!.phone, isNotEmpty);
    expect((await c.api.getWalletApi().getWallet()).data!.currency, isNotNull);
    expect((await c.api.getWalletApi().listWalletTransactions()).data!.data, isNotNull);
    expect((await c.api.getRidesApi().listMyRides()).data!.data, isNotNull);
    expect((await c.api.getServiceAreaApi().getServiceArea()).data!.pickupPoints, isNotNull);
    expect((await api.listTrustedContacts()).data!.data, isNotNull);
    expect((await api.listSavedPlaces()).data!.data, isNotNull);
    expect((await c.api.getSupportApi().listMySupportTickets()).data!.data, isNotNull);
    expect((await c.api.getMetaApi().getAppConfig()).data!.minVersion.ios, isNotEmpty);
  });
}
