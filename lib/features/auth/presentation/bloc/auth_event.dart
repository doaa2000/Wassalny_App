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
