import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Owns all authentication logic. The UI dispatches events and renders state;
/// it never touches the repository or Supabase directly.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthLoginRequested>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthProfileUpdateRequested>(_onProfileUpdate);
    add(const AuthStarted());
  }

  final AuthRepository _repo;

  void _onStarted(AuthStarted e, Emitter<AuthState> emit) {
    final AppUser? user = _repo.currentUser();
    emit(user == null
        ? const AuthState(status: AuthStatus.unauthenticated)
        : AuthState(status: AuthStatus.authenticated, user: user));
  }

  Future<void> _onSignUp(AuthSignUpRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final AppUser user =
          await _repo.signUp(email: e.email, password: e.password, fullName: e.fullName);
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } on AuthException catch (err) {
      emit(state.copyWith(status: AuthStatus.failure, error: err.message));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.failure, error: 'Sign up failed. Please try again.'));
    }
  }

  Future<void> _onLogin(AuthLoginRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final AppUser user = await _repo.login(email: e.email, password: e.password);
      emit(AuthState(status: AuthStatus.authenticated, user: user));
    } on AuthException catch (err) {
      emit(state.copyWith(status: AuthStatus.failure, error: err.message));
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.failure, error: 'Login failed. Please try again.'));
    }
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter<AuthState> emit) async {
    await _repo.logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _onProfileUpdate(
      AuthProfileUpdateRequested e, Emitter<AuthState> emit) async {
    emit(state.copyWith(profileUpdateStatus: ProfileUpdateStatus.loading));
    try {
      final AppUser updated =
          await _repo.updateProfile(fullName: e.fullName, phone: e.phone);
      emit(state.copyWith(
        user: updated,
        profileUpdateStatus: ProfileUpdateStatus.success,
      ));
    } catch (_) {
      emit(state.copyWith(
        profileUpdateStatus: ProfileUpdateStatus.failure,
        profileError: 'Could not update your profile. Please try again.',
      ));
    }
  }
}
