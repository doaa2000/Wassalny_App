import 'package:equatable/equatable.dart';

/// A driver/vehicle option the rider can choose from.
///
/// Pure domain model — colours are stored as ARGB ints so this layer stays free
/// of any Flutter/UI dependency. The presentation layer maps them to real
/// `Color`/`Gradient` objects.
class Driver extends Equatable {
  const Driver({
    required this.id,
    required this.name,
    required this.firstName,
    required this.initials,
    required this.rating,
    required this.rides,
    required this.car,
    required this.plate,
    required this.tier,
    required this.tag,
    required this.etaMinutes,
    required this.price,
    required this.carColorValue,
    required this.avatarStartValue,
    required this.avatarEndValue,
    required this.recommended,
  });

  final int id;
  final String name;
  final String firstName;
  final String initials;
  final String rating;
  final String rides;
  final String car;
  final String plate;
  final String tier;
  final String tag;
  final int etaMinutes;
  final String price;

  /// Vehicle body colour for the side illustration (ARGB).
  final int carColorValue;

  /// Avatar gradient endpoints (ARGB).
  final int avatarStartValue;
  final int avatarEndValue;

  /// The first / top option which gets the green "Recommended" tag styling.
  final bool recommended;

  @override
  List<Object?> get props => [id];
}
