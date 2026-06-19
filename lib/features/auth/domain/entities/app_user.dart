import 'package:equatable/equatable.dart';

/// The authenticated passenger account.
class AppUser extends Equatable {
  const AppUser({required this.id, required this.email, this.fullName});

  final String id;
  final String email;
  final String? fullName;

  @override
  List<Object?> get props => [id, email, fullName];
}
