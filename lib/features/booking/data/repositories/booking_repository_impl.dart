import '../../domain/entities/driver.dart';
import '../../domain/entities/fare_line.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_local_data_source.dart';

/// Concrete [BookingRepository] backed by the in-memory demo data source.
class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._local);

  final BookingLocalDataSource _local;

  @override
  List<Driver> getNearbyDrivers() => _local.nearbyDrivers();

  @override
  List<PaymentMethod> getPaymentMethods() => _local.paymentMethods();

  @override
  List<FareLine> getFareBreakdown() => _local.fareBreakdown();
}
