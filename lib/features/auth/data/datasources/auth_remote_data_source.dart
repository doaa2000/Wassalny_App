import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/app_user.dart';

/// The ONLY auth file that talks to Supabase.
///
/// When Supabase isn't configured (UI-only mode, no `--dart-define`) the methods
/// fall back to a demo user so the existing flow keeps working offline.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._service);

  final SupabaseService _service;

  AppUser _map(User u) => AppUser(
        id: u.id,
        email: u.email ?? '',
        fullName: u.userMetadata?['full_name'] as String?,
        phone: (u.phone != null && u.phone!.isNotEmpty) ? u.phone : null,
      );

  AppUser _demo(String email, [String? name]) =>
      AppUser(id: 'demo-user', email: email, fullName: name ?? 'Demo Rider');

  Future<AppUser> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    if (!_service.isConfigured) return _demo(email, fullName);
    final AuthResponse res = await _service.client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'role': 'passenger'},
    );
    final User? user = res.user;
    if (user == null) throw const AuthException('Sign up failed');
    return _map(user);
  }

  Future<AppUser> login({required String email, required String password}) async {
    if (!_service.isConfigured) return _demo(email);
    final AuthResponse res =
        await _service.client.auth.signInWithPassword(email: email, password: password);
    final User? user = res.user;
    if (user == null) throw const AuthException('Login failed');
    return _map(user);
  }

  Future<void> logout() async {
    if (!_service.isConfigured) return;
    await _service.client.auth.signOut();
  }

  AppUser? currentUser() {
    if (!_service.isConfigured) return null;
    final User? u = _service.client.auth.currentUser;
    // An anonymous session is not a "real" login — keep the login screen for it.
    if (u == null || u.isAnonymous) return null;
    return _map(u);
  }

  /// Updates the rider's name and/or phone. The name goes through Supabase
  /// Auth's own metadata (`updateUser`); the phone is written to the
  /// `profiles` table directly — Auth's own `phone` field requires an OTP
  /// verification flow this app doesn't implement, so `profiles.phone` (a
  /// plain, unverified column per the shared schema) is the honest place to
  /// store a rider-entered number instead.
  Future<AppUser> updateProfile({String? fullName, String? phone}) async {
    if (!_service.isConfigured) {
      final AppUser? current = currentUser();
      return AppUser(
        id: current?.id ?? 'demo-user',
        email: current?.email ?? '',
        fullName: fullName ?? current?.fullName,
        phone: phone ?? current?.phone,
      );
    }

    if (fullName != null) {
      await _service.client.auth
          .updateUser(UserAttributes(data: {'full_name': fullName}));
    }

    final String? userId = _service.client.auth.currentUser?.id;
    if (phone != null && userId != null) {
      await _service.client.from('profiles').update({'phone': phone}).eq('id', userId);
    }

    final User? refreshed = _service.client.auth.currentUser;
    if (refreshed == null) throw const AuthException('Not signed in');
    final AppUser mapped = _map(refreshed);
    // auth.User doesn't carry profiles.phone, so overlay it from what we
    // just wrote (or keep whatever was already showing).
    return AppUser(
      id: mapped.id,
      email: mapped.email,
      fullName: mapped.fullName,
      phone: phone ?? mapped.phone,
    );
  }

  /// Sends a 6-digit recovery code to [email]. Requires the Supabase
  /// project's "Reset Password" email template to include `{{ .Token }}`
  /// (not just the magic-link URL) — see Authentication → Email Templates.
  Future<void> requestPasswordReset(String email) async {
    if (!_service.isConfigured) return;
    await _service.client.auth.resetPasswordForEmail(email);
  }

  /// Verifies the recovery code the rider received by email. On success this
  /// starts a recovery session, which [setNewPassword] then uses.
  Future<void> verifyPasswordResetCode({
    required String email,
    required String code,
  }) async {
    if (!_service.isConfigured) return;
    await _service.client.auth.verifyOTP(
      type: OtpType.recovery,
      email: email,
      token: code,
    );
  }

  /// Sets a new password for the rider — must be called right after a
  /// successful [verifyPasswordResetCode], while the recovery session from
  /// that step is still active.
  Future<void> setNewPassword(String newPassword) async {
    if (!_service.isConfigured) return;
    await _service.client.auth.updateUser(UserAttributes(password: newPassword));
  }
}
