part of 'auth_bloc.dart';

enum AuthStatus { unknown, loading, authenticated, unauthenticated, failure }

/// Separate lifecycle for the "Personal Info" edit screen — kept apart from
/// [AuthStatus] so saving a profile edit never re-triggers the login/signup
/// screens' "authenticated"/"failure" navigation listeners.
enum ProfileUpdateStatus { idle, loading, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.error,
    this.profileUpdateStatus = ProfileUpdateStatus.idle,
    this.profileError,
  });

  final AuthStatus status;
  final AppUser? user;
  final String? error;
  final ProfileUpdateStatus profileUpdateStatus;
  final String? profileError;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? error,
    ProfileUpdateStatus? profileUpdateStatus,
    String? profileError,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      profileUpdateStatus: profileUpdateStatus ?? this.profileUpdateStatus,
      profileError: profileError,
    );
  }

  @override
  List<Object?> get props =>
      [status, user, error, profileUpdateStatus, profileError];
}
