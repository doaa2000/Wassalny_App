import '../../domain/entities/ride_history.dart';
import '../../domain/repositories/rides_repository.dart';

/// Dummy ride history matching the design.
class RidesRepositoryImpl implements RidesRepository {
  @override
  List<RideHistory> getRides() => const [
        RideHistory(
          dateTime: 'Today · 18:24',
          status: RideStatus.completed,
          from: 'Tahrir Square',
          to: 'Cairo Festival City',
          price: 'EGP 86',
          distance: '14.2 km',
        ),
        RideHistory(
          dateTime: 'Mar 8 · 14:02',
          status: RideStatus.completed,
          from: 'Maadi, Road 9',
          to: 'Zamalek, 26 July St',
          price: 'EGP 74',
          distance: '11.0 km',
        ),
        RideHistory(
          dateTime: 'Mar 2 · 21:40',
          status: RideStatus.cancelled,
          from: 'Nasr City',
          to: 'Heliopolis',
          price: 'EGP 0',
          distance: '—',
        ),
      ];
}
