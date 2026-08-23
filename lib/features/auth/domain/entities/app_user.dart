import 'package:equatable/equatable.dart';

/// The authenticated passenger account.
class AppUser extends Equatable {
  const AppUser({required this.id, required this.email, this.fullName, this.phone});

  final String id;
  final String email;
  final String? fullName;
  final String? phone;

  @override
  List<Object?> get props => [id, email, fullName, phone];
}
