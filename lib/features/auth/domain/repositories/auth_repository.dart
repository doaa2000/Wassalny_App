import '../entities/app_user.dart';

/// Auth contract. The presentation layer depends only on this — never on
/// Supabase directly.
abstract class AuthRepository {
  Future<AppUser> signUp({
    required String email,
    required String password,
    String? fullName,
  });

  Future<AppUser> login({required String email, required String password});

  Future<void> logout();

  /// The currently signed-in user (null when signed out).
  AppUser? currentUser();

  /// Updates the signed-in user's editable profile fields. Pass only the
  /// fields that changed — omitted ones are left as-is.
  Future<AppUser> updateProfile({String? fullName, String? phone});
}
