import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/service_area.dart';
import '../../../../core/logging/logging.dart';
import '../../domain/entities/driver.dart';
import '../../domain/entities/fare_line.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_local_data_source.dart';
import '../datasources/drivers_remote_data_source.dart';
import '../datasources/trip_remote_data_source.dart';

/// Concrete [BookingRepository]: payment/fare data comes from the in-memory
/// source; drivers come from `nearby_drivers` (with a demo fallback); ride
/// requests are sent to the backend trip data source.
class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._local, this._tripRemote, [this._driversRemote]);

  final BookingLocalDataSource _local;
  final TripRemoteDataSource _tripRemote;
  final DriversRemoteDataSource? _driversRemote;

  @override
  Future<List<Driver>> fetchNearbyDrivers() async {
    // Real online drivers near the service area's default city (placeholder
    // coords until the map picker feeds real lat/lng).
    final DriversRemoteDataSource? remote = _driversRemote;
    if (remote != null) {
      try {
        final List<Driver> real = await remote.nearbyDrivers(
          lat: ServiceArea.defaultCenter.latitude,
          lng: ServiceArea.defaultCenter.longitude,
        );
        if (real.isNotEmpty) return real;
      } catch (e, s) {
        appLogger.logWarning('nearby_drivers failed; using demo catalogue',
            feature: 'Booking', error: e, stackTrace: s);
      }
    }
    return _local.nearbyDrivers();
  }

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
    String? driverId,
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
      driverId: driverId,
    );
  }

  @override
  Stream<String> watchTrip(String tripId) => _tripRemote.watchTrip(tripId);

  @override
  Future<Driver?> fetchAssignedDriver(String tripId) async {
    final DriversRemoteDataSource? remote = _driversRemote;
    if (remote == null) return null;
    try {
      final Map<String, dynamic>? row =
          await _tripRemote.assignedDriverRow(tripId);
      if (row == null) return null;
      return remote.fromAssignedRow(row);
    } catch (e, s) {
      appLogger.logError('fetchAssignedDriver failed',
          feature: 'Booking', error: e, stackTrace: s);
      return null;
    }
  }

  @override
  Stream<LatLng?> watchDriverLocation(String tripId) =>
      _tripRemote.watchDriverLocation(tripId);
}
