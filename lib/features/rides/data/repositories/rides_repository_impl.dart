import '../../domain/entities/ride_history.dart';
import '../../domain/repositories/rides_repository.dart';

/// Dummy ride history matching the design.
class RidesRepositoryImpl implements RidesRepository {
  @override
  List<RideHistory> getRides() => const [
        RideHistory(
          dateTime: 'Today · 18:24',
          status: RideStatus.completed,
          from: 'Qusair Fort',
          to: 'Sirena Beach',
          price: 'EGP 86',
          distance: '14.2 km',
        ),
        RideHistory(
          dateTime: 'Mar 8 · 14:02',
          status: RideStatus.completed,
          from: 'El Qusair Souq',
          to: 'El Qusair Port',
          price: 'EGP 74',
          distance: '11.0 km',
        ),
        RideHistory(
          dateTime: 'Mar 2 · 21:40',
          status: RideStatus.cancelled,
          from: 'El Qusair General Hospital',
          to: 'Marsa Alam Road',
          price: 'EGP 0',
          distance: '—',
        ),
      ];
}
