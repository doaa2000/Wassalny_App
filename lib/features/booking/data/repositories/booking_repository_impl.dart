import '../../domain/entities/driver.dart';
import '../../domain/entities/fare_line.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_local_data_source.dart';
import '../datasources/trip_remote_data_source.dart';

/// Concrete [BookingRepository]: catalogue data comes from the in-memory source,
/// while ride requests are sent to the backend trip data source.
class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._local, this._tripRemote);

  final BookingLocalDataSource _local;
  final TripRemoteDataSource _tripRemote;

  @override
  List<Driver> getNearbyDrivers() => _local.nearbyDrivers();

  @override
  List<PaymentMethod> getPaymentMethods() => _local.paymentMethods();

  @override
  List<FareLine> getFareBreakdown() => _local.fareBreakdown();

  @override
  Future<String?> requestTrip({
    required String pickupAddress,
    required String dropoffAddress,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
    required String paymentMethod,
    num? price,
  }) {
    return _tripRemote.requestTrip(
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
      paymentMethod: paymentMethod,
      price: price,
    );
  }
}
