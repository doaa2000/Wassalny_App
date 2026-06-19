import 'package:equatable/equatable.dart';

/// A passenger's saved/favorite address.
class SavedPlace extends Equatable {
  const SavedPlace({
    required this.id,
    required this.label,
    required this.address,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String label;
  final String address;
  final double? latitude;
  final double? longitude;

  @override
  List<Object?> get props => [id, label, address];
}
