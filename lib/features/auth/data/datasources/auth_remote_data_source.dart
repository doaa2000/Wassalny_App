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
    return u == null ? null : _map(u);
  }
}
