import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ride_history.dart';
import '../../domain/repositories/rides_repository.dart';

/// Tabs on the ride-history screen.
enum RidesFilter { all, completed, cancelled }

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

class RidesCubit extends Cubit<RidesState> {
  RidesCubit(this._repository) : super(const RidesState()) {
    emit(state.copyWith(rides: _repository.getRides()));
  }

  final RidesRepository _repository;

  void setFilter(RidesFilter filter) => emit(state.copyWith(filter: filter));
}
