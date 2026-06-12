part of 'nav_bloc.dart';

/// Base type for shell navigation events.
sealed class NavEvent extends Equatable {
  const NavEvent();

  @override
  List<Object?> get props => [];
}

/// The user selected the tab at [index].
final class NavTabSelected extends NavEvent {
  const NavTabSelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}
