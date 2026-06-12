import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the selected tab index for the main shell. Kept tiny and local to the
/// shell so any descendant (e.g. the profile menu) can switch tabs.
class NavCubit extends Cubit<int> {
  NavCubit() : super(0);

  void go(int index) => emit(index);
}
