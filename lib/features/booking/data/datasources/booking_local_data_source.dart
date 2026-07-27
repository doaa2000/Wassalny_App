import '../../domain/entities/fare_line.dart';
import '../../domain/entities/payment_method.dart';
import '../models/driver_model.dart';

/// In-memory source of the booking-flow demo data, matching the design exactly.
class BookingLocalDataSource {
  List<DriverModel> nearbyDrivers() => const [
        DriverModel(
          id: 0,
          name: 'Ahmed Hassan',
          firstName: 'Ahmed',
          initials: 'AH',
          rating: '4.9',
          rides: '2,140',
          car: 'Toyota Corolla',
          plate: 'RST 4821',
          tier: 'Wassalny Go',
          tag: 'Recommended',
          etaMinutes: 3,
          price: 'EGP 86',
          carColorValue: 0xFFC45B2E,
          avatarStartValue: 0xFFC45B2E,
          avatarEndValue: 0xFFD9743F,
          recommended: true,
        ),
        DriverModel(
          id: 1,
          name: 'Mostafa Kamel',
          firstName: 'Mostafa',
          initials: 'MK',
          rating: '4.8',
          rides: '1,705',
          car: 'Hyundai Elantra',
          plate: 'LMN 7390',
          tier: 'Wassalny Comfort',
          tag: 'Comfort',
          etaMinutes: 5,
          price: 'EGP 124',
          carColorValue: 0xFF2C3A45,
          avatarStartValue: 0xFFF0A04B,
          avatarEndValue: 0xFFE07B39,
          recommended: false,
        ),
        DriverModel(
          id: 2,
          name: 'Karim El-Sayed',
          firstName: 'Karim',
          initials: 'KE',
          rating: '4.95',
          rides: '3,012',
          car: 'Mercedes E-Class',
          plate: 'QDM 1180',
          tier: 'Wassalny Premium',
          tag: 'Top rated',
          etaMinutes: 7,
          price: 'EGP 232',
          carColorValue: 0xFF0F1A24,
          avatarStartValue: 0xFF0E9D9A,
          avatarEndValue: 0xFF0B7A78,
          recommended: false,
        ),
        DriverModel(
          id: 3,
          name: 'Omar Farouk',
          firstName: 'Omar',
          initials: 'OF',
          rating: '4.7',
          rides: '980',
          car: 'Toyota Hiace',
          plate: 'WSL 5567',
          tier: 'Wassalny XL',
          tag: 'Group',
          etaMinutes: 6,
          price: 'EGP 160',
          carColorValue: 0xFF22B07D,
          avatarStartValue: 0xFF22B07D,
          avatarEndValue: 0xFF179C6C,
          recommended: false,
        ),
      ];

  // Wallet/card are disabled for now — cash only until online payments launch.
  List<PaymentMethod> paymentMethods() => const [
        PaymentMethod(
          id: 'cash',
          label: 'Cash',
          sub: 'Pay driver directly',
          type: PaymentType.cash,
        ),
      ];

  List<FareLine> fareBreakdown() => const [
        FareLine(label: 'Base fare', amount: 'EGP 25.00'),
        FareLine(label: 'Distance (14.2 km)', amount: 'EGP 49.00'),
        FareLine(label: 'Time (24 min)', amount: 'EGP 9.00'),
        FareLine(label: 'Booking fee', amount: 'EGP 3.00'),
        FareLine(label: 'Promo WSL10', amount: '– EGP 0.00', isDiscount: true),
      ];
}
