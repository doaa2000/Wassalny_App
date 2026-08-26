part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Emitted once on startup to resolve any existing session.
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthSignUpRequested extends AuthEvent {
  const AuthSignUpRequested({required this.email, required this.password, this.fullName});

  final String email;
  final String password;
  final String? fullName;

  @override
  List<Object?> get props => [email, password, fullName];
}

final class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// The rider saved changes on the Personal Info screen. Only non-null fields
/// are updated — leave a field null to keep its current value unchanged.
final class AuthProfileUpdateRequested extends AuthEvent {
  const AuthProfileUpdateRequested({this.fullName, this.phone});

  final String? fullName;
  final String? phone;

  @override
  List<Object?> get props => [fullName, phone];
}

/// Step 1 of "Forgot password": send a recovery code to [email].
final class PasswordResetRequested extends AuthEvent {
  const PasswordResetRequested(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

/// Step 2: verify the code the rider received by email.
final class PasswordResetCodeVerified extends AuthEvent {
  const PasswordResetCodeVerified({required this.email, required this.code});

  final String email;
  final String code;

  @override
  List<Object?> get props => [email, code];
}

/// Step 3: set the new password (must follow a successful
/// [PasswordResetCodeVerified]).
final class PasswordResetCompleted extends AuthEvent {
  const PasswordResetCompleted(this.newPassword);

  final String newPassword;

  @override
  List<Object?> get props => [newPassword];
}

/// Resets the password-reset sub-state back to idle — dispatched when the
/// rider leaves the flow (e.g. taps back), so returning to it later starts
/// clean.
final class PasswordResetStateCleared extends AuthEvent {
  const PasswordResetStateCleared();
}
