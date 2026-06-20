import '../entities/driver.dart';
import '../entities/fare_line.dart';
import '../entities/payment_method.dart';

/// Contract for sourcing the booking-flow data. The presentation layer depends
/// on this abstraction, not on the concrete (dummy) implementation.
abstract class BookingRepository {
  /// Real online drivers (via `nearby_drivers`) when connected, else the demo
  /// catalogue. A real driver carries a `profileId` used to assign the trip.
  Future<List<Driver>> fetchNearbyDrivers();
  List<PaymentMethod> getPaymentMethods();
  List<FareLine> getFareBreakdown();

  /// Creates a ride request in the backend and returns the new trip id
  /// (null when running without a backend). The Captain app receives it live.
  /// When [driverId] is set, the trip is assigned to that specific driver;
  /// otherwise it's broadcast to all nearby online drivers.
  Future<String?> requestTrip({
    required String pickupAddress,
    required String dropoffAddress,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
    required String paymentMethod,
    num? price,
    String? driverId,
  });

  /// Live stream of a trip's status (for the rider's tracking screens).
  Stream<String> watchTrip(String tripId);

  /// The driver who accepted the trip (null while unassigned or offline).
  Future<Driver?> fetchAssignedDriver(String tripId);
}
