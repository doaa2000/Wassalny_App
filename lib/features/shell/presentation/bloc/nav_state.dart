part of 'nav_bloc.dart';

/// Main-shell state: the currently selected tab index.
class NavState extends Equatable {
  const NavState({this.index = 0});

  final int index;

  @override
  List<Object?> get props => [index];
}
