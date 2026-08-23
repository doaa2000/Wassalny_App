import '../entities/ride_history.dart';

abstract class RidesRepository {
  Future<List<RideHistory>> getRides();
}