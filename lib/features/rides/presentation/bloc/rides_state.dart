part of 'rides_bloc.dart';

/// Tabs on the ride-history screen.
enum RidesFilter { all, completed, cancelled }

/// Ride-history screen state: the full list plus the active filter.
class RidesState extends Equatable {
  const RidesState({this.rides = const [], this.filter = RidesFilter.all});

  final List<RideHistory> rides;
  final RidesFilter filter;

  /// Rides visible under the active filter.
  List<RideHistory> get visibleRides {
    switch (filter) {
      case RidesFilter.all:
        return rides;
      case RidesFilter.completed:
        return rides.where((r) => r.status == RideStatus.completed).toList();
      case RidesFilter.cancelled:
        return rides.where((r) => r.status == RideStatus.cancelled).toList();
    }
  }

  RidesState copyWith({List<RideHistory>? rides, RidesFilter? filter}) =>
      RidesState(rides: rides ?? this.rides, filter: filter ?? this.filter);

  @override
  List<Object?> get props => [rides, filter];
}
