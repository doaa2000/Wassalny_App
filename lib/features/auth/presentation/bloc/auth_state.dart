part of 'auth_bloc.dart';

enum AuthStatus { unknown, loading, authenticated, unauthenticated, failure }

/// Separate lifecycle for the "Personal Info" edit screen — kept apart from
/// [AuthStatus] so saving a profile edit never re-triggers the login/signup
/// screens' "authenticated"/"failure" navigation listeners.
enum ProfileUpdateStatus { idle, loading, success, failure }

/// Separate lifecycle for the "Forgot password" flow (request code → verify
/// code → set new password) — kept apart from [AuthStatus] for the same
/// reason as [ProfileUpdateStatus].
enum PasswordResetStatus { idle, loading, codeSent, codeVerified, done, failure }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.error,
    this.profileUpdateStatus = ProfileUpdateStatus.idle,
    this.profileError,
    this.passwordResetStatus = PasswordResetStatus.idle,
    this.passwordResetError,
  });

  final AuthStatus status;
  final AppUser? user;
  final String? error;
  final ProfileUpdateStatus profileUpdateStatus;
  final String? profileError;
  final PasswordResetStatus passwordResetStatus;
  final String? passwordResetError;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? error,
    ProfileUpdateStatus? profileUpdateStatus,
    String? profileError,
    PasswordResetStatus? passwordResetStatus,
    String? passwordResetError,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      profileUpdateStatus: profileUpdateStatus ?? this.profileUpdateStatus,
      profileError: profileError,
      passwordResetStatus: passwordResetStatus ?? this.passwordResetStatus,
      passwordResetError: passwordResetError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        error,
        profileUpdateStatus,
        profileError,
        passwordResetStatus,
        passwordResetError,
      ];
}
