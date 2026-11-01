import 'package:test/test.dart';
import 'package:turbo_api_generated/turbo_api_generated.dart';


/// tests for AuthApi
void main() {
  final instance = TurboApiGenerated().getAuthApi();

  group(AuthApi, () {
    // Set a password from an invite link
    //
    // **Access:** Public.  The invite email carries a single-use token valid for 72 hours. Returns the MFA enrolment to scan. Login stays closed until MFA is confirmed.
    //
    //Future<MfaEnrollment> acceptStaffInvite(InviteAccept inviteAccept) async
    test('test acceptStaffInvite', () async {
      // TODO
    });

    // Staff login with email and password
    //
    // **Access:** Public.  All staff must have MFA. Returns 401 `mfa_required` when `totpCode` is missing or wrong. Five failed attempts lock the account for 15 minutes (429 `account_locked`). An account that has not finished its invite cannot log in.
    //
    //Future<AuthTokens> adminLogin(AdminLogin adminLogin) async
    test('test adminLogin', () async {
      // TODO
    });

    // Confirm MFA enrolment and sign in
    //
    // **Access:** Public (enrolment token).  First valid TOTP code finishes enrolment and returns tokens.
    //
    //Future<AuthTokens> confirmStaffMfa(MfaConfirm mfaConfirm) async
    test('test confirmStaffMfa', () async {
      // TODO
    });

    // Request a password reset email
    //
    // **Access:** Public.  Always 202, whether or not the email exists (no enumeration).
    //
    //Future forgotStaffPassword(PasswordForgot passwordForgot) async
    test('test forgotStaffPassword', () async {
      // TODO
    });

    // Revoke the current session
    //
    // **Access:** any.
    //
    //Future logout() async
    test('test logout', () async {
      // TODO
    });

    // Rotate the refresh token and get a new access token
    //
    // **Access:** Public.  Mobile clients send `refreshToken` in the body. Web clients send the httpOnly cookie and an empty body. Refresh tokens rotate on every call; reuse of an old one revokes the whole session.
    //
    //Future<AuthTokens> refreshTokens({ RefreshRequest refreshRequest }) async
    test('test refreshTokens', () async {
      // TODO
    });

    // Register or update a push token
    //
    // **Access:** any.
    //
    //Future registerDevice(DeviceRegistration deviceRegistration) async
    test('test registerDevice', () async {
      // TODO
    });

    // Send a one-time code by SMS
    //
    // **Access:** Public.  Only +233 numbers are accepted. Limits apply per phone number, per IP and per device. When the daily SMS ceiling (`smsDailyLimit`) is hit, returns 503 `sms_budget_exceeded` and staff are alerted. Send an `Idempotency-Key` (optional, so older apps keep working), a new one for each tap on \"send code\". A retry of the same tap with the same key within 10 minutes returns the first answer and sends **no** second SMS; the key is scoped to the phone number. The same key with a different body is 409 `idempotency_key_reused`. A new key is a deliberate resend: the 30 second cooldown and the hourly limits still apply to it.
    //
    //Future<OtpChallenge> requestOtp(OtpRequest otpRequest, { String idempotencyKey }) async
    test('test requestOtp', () async {
      // TODO
    });

    // Set a new password from a reset link
    //
    // **Access:** Public.  Single-use token valid for 1 hour. Revokes every session of that staff user. MFA is still required at next login.
    //
    //Future resetStaffPassword(PasswordReset passwordReset) async
    test('test resetStaffPassword', () async {
      // TODO
    });

    // Remove a push token (call on logout)
    //
    // **Access:** any.
    //
    //Future unregisterDevice(String deviceId) async
    test('test unregisterDevice', () async {
      // TODO
    });

    // Exchange a code for tokens
    //
    // **Access:** Public.  Creates the student or driver account on first successful verification. Drivers must already exist (created by an admin); an unknown driver number returns 403.
    //
    //Future<AuthTokens> verifyOtp(OtpVerify otpVerify) async
    test('test verifyOtp', () async {
      // TODO
    });

  });
}
