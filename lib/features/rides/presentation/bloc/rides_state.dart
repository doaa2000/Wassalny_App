part of 'rides_bloc.dart';

/// Tabs on the ride-history screen.
enum RidesFilter { all, completed, cancelled }

/// Loading lifecycle for the ride-history screen.
enum RidesStatus { initial, loading, success, failure }

/// Ride-history screen state: the full list plus the active filter.
class RidesState extends Equatable {
  const RidesState({
    this.status = RidesStatus.initial,
    this.rides = const [],
    this.filter = RidesFilter.all,
    this.errorMessage,
  });

  final RidesStatus status;
  final List<RideHistory> rides;
  final RidesFilter filter;
  final String? errorMessage;

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

  RidesState copyWith({
    RidesStatus? status,
    List<RideHistory>? rides,
    RidesFilter? filter,
    String? errorMessage,
  }) =>
      RidesState(
        status: status ?? this.status,
        rides: rides ?? this.rides,
        filter: filter ?? this.filter,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, rides, filter, errorMessage];
}