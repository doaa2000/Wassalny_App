part of 'rides_bloc.dart';

/// Base type for all ride-history events.
sealed class RidesEvent extends Equatable {
  const RidesEvent();

  @override
  List<Object?> get props => [];
}

/// Load the ride history.
final class RidesRequested extends RidesEvent {
  const RidesRequested();
}

/// Switch the active history filter tab.
final class RidesFilterChanged extends RidesEvent {
  const RidesFilterChanged(this.filter);

  final RidesFilter filter;

  @override
  List<Object?> get props => [filter];
}
