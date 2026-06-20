import '../entities/driver.dart';
import '../entities/fare_line.dart';
import '../entities/payment_method.dart';

/// Contract for sourcing the booking-flow data. The presentation layer depends
/// on this abstraction, not on the concrete (dummy) implementation.
abstract class BookingRepository {
  List<Driver> getNearbyDrivers();
  List<PaymentMethod> getPaymentMethods();
  List<FareLine> getFareBreakdown();

  /// Creates a ride request in the backend and returns the new trip id
  /// (null when running without a backend). The Captain app receives it live.
  Future<String?> requestTrip({
    required String pickupAddress,
    required String dropoffAddress,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
    required String paymentMethod,
    num? price,
  });

  /// Live stream of a trip's status (for the rider's tracking screens).
  Stream<String> watchTrip(String tripId);
}
