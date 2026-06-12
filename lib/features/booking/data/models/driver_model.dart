import '../../domain/entities/driver.dart';

/// Data-layer representation of [Driver]. In a real app this would deserialize
/// from JSON; here it carries the dummy catalogue used to drive the UI.
class DriverModel extends Driver {
  const DriverModel({
    required super.id,
    required super.name,
    required super.firstName,
    required super.initials,
    required super.rating,
    required super.rides,
    required super.car,
    required super.plate,
    required super.tier,
    required super.tag,
    required super.etaMinutes,
    required super.price,
    required super.carColorValue,
    required super.avatarStartValue,
    required super.avatarEndValue,
    required super.recommended,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map) => DriverModel(
        id: map['id'] as int,
        name: map['name'] as String,
        firstName: map['firstName'] as String,
        initials: map['initials'] as String,
        rating: map['rating'] as String,
        rides: map['rides'] as String,
        car: map['car'] as String,
        plate: map['plate'] as String,
        tier: map['tier'] as String,
        tag: map['tag'] as String,
        etaMinutes: map['etaMinutes'] as int,
        price: map['price'] as String,
        carColorValue: map['carColorValue'] as int,
        avatarStartValue: map['avatarStartValue'] as int,
        avatarEndValue: map['avatarEndValue'] as int,
        recommended: map['recommended'] as bool,
      );
}
