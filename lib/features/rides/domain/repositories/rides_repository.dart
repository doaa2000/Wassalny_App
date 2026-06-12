import '../entities/ride_history.dart';

abstract class RidesRepository {
  List<RideHistory> getRides();
}
