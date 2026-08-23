import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/ride_history.dart';
import '../../domain/repositories/rides_repository.dart';

part 'rides_event.dart';
part 'rides_state.dart';

/// Loads the ride history and applies the active filter tab.
class RidesBloc extends Bloc<RidesEvent, RidesState> {
  RidesBloc(this._repository) : super(const RidesState()) {
    on<RidesRequested>(_onRequested);
    on<RidesFilterChanged>(_onFilterChanged);
  }

  final RidesRepository _repository;

  Future<void> _onRequested(RidesRequested event, Emitter<RidesState> emit) async {
    emit(state.copyWith(status: RidesStatus.loading));
    try {
      final rides = await _repository.getRides();
      emit(state.copyWith(status: RidesStatus.success, rides: rides));
    } catch (e) {
      emit(state.copyWith(
        status: RidesStatus.failure,
        errorMessage: 'تعذر تحميل الرحلات. حاول مرة أخرى.',
      ));
    }
  }

  void _onFilterChanged(RidesFilterChanged event, Emitter<RidesState> emit) {
    emit(state.copyWith(filter: event.filter));
  }
}