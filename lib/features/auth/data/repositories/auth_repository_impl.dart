import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    String? fullName,
  }) =>
      _remote.signUp(email: email, password: password, fullName: fullName);

  @override
  Future<AppUser> login({required String email, required String password}) =>
      _remote.login(email: email, password: password);

  @override
  Future<void> logout() => _remote.logout();

  @override
  AppUser? currentUser() => _remote.currentUser();

  @override
  Future<AppUser> updateProfile({String? fullName, String? phone}) =>
      _remote.updateProfile(fullName: fullName, phone: phone);
}
