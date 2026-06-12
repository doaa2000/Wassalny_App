import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'nav_event.dart';
part 'nav_state.dart';

/// Tracks the selected tab index for the main shell so any descendant
/// (e.g. the profile menu) can switch tabs by dispatching [NavTabSelected].
class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(const NavState()) {
    on<NavTabSelected>(_onTabSelected);
  }

  void _onTabSelected(NavTabSelected event, Emitter<NavState> emit) {
    emit(NavState(index: event.index));
  }
}
