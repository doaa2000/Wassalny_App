import 'package:supabase_flutter/supabase_flutter.dart';

/// Single seam to the Supabase backend.
///
/// The whole app is unaware of Supabase except through this service. Credentials
/// are injected at build time (`--dart-define`); when absent the app stays in
/// UI-only mode and trip requests become no-ops.
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  static const String _url = String.fromEnvironment('SUPABASE_URL');
  static const String _anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  SupabaseClient? _client;

  bool get isConfigured => _url.isNotEmpty && _anonKey.isNotEmpty;

  SupabaseClient get client {
    final SupabaseClient? c = _client;
    if (c == null) {
      throw StateError('Supabase is not configured (run with --dart-define).');
    }
    return c;
  }

  /// The current (passenger) auth user id — needed as `passenger_id` and to
  /// satisfy the RLS policy on the `trips` table.
  String? get currentUserId => _client?.auth.currentUser?.id;

  /// True when a real (non-anonymous) user is signed in. An anonymous session
  /// (used so a guest can create trips) does NOT count — onboarding/login is
  /// only skipped for a genuine email login/signup.
  bool get hasRealSession {
    final User? u = _client?.auth.currentUser;
    return u != null && !u.isAnonymous;
  }

  /// Initializes the client and ensures a passenger session exists. Uses an
  /// anonymous sign-in so a rider can create trips without a full login flow
  /// (enable "Anonymous sign-ins" in Supabase → Authentication → Providers).
  Future<void> initialize() async {
    if (!isConfigured) return;
    await Supabase.initialize(url: _url, anonKey: _anonKey);
    _client = Supabase.instance.client;

    if (_client!.auth.currentUser == null) {
      try {
        await _client!.auth.signInAnonymously();
      } catch (_) {
        // Anonymous sign-ins disabled — trip creation will require a real login.
      }
    }
  }
}
