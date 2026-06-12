import '../entities/driver.dart';
import '../entities/fare_line.dart';
import '../entities/payment_method.dart';

/// Contract for sourcing the booking-flow data. The presentation layer depends
/// on this abstraction, not on the concrete (dummy) implementation.
abstract class BookingRepository {
  List<Driver> getNearbyDrivers();
  List<PaymentMethod> getPaymentMethods();
  List<FareLine> getFareBreakdown();
}
