import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/saved_place.dart';
import '../../domain/repositories/places_repository.dart';

part 'places_event.dart';
part 'places_state.dart';

/// Drives the Saved Places CRUD screen. All persistence goes through the
/// repository; the UI only dispatches events and renders state.
class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  PlacesBloc(this._repo) : super(const PlacesState()) {
    on<PlacesLoaded>(_onLoaded);
    on<PlaceAdded>(_onAdded);
    on<PlaceRenamed>(_onRenamed);
    on<PlaceRemoved>(_onRemoved);
  }

  final PlacesRepository _repo;

  Future<void> _onLoaded(PlacesLoaded e, Emitter<PlacesState> emit) async {
    emit(state.copyWith(status: PlacesStatus.loading));
    try {
      emit(state.copyWith(status: PlacesStatus.ready, places: await _repo.getAll()));
    } catch (_) {
      emit(state.copyWith(status: PlacesStatus.failure, error: 'Could not load places.'));
    }
  }

  Future<void> _onAdded(PlaceAdded e, Emitter<PlacesState> emit) async {
    try {
      await _repo.add(label: e.label, address: e.address, lat: e.lat, lng: e.lng);
      emit(state.copyWith(status: PlacesStatus.ready, places: await _repo.getAll()));
    } catch (_) {
      emit(state.copyWith(status: PlacesStatus.failure, error: 'Could not add place.'));
    }
  }

  Future<void> _onRenamed(PlaceRenamed e, Emitter<PlacesState> emit) async {
    await _repo.rename(id: e.id, label: e.label);
    emit(state.copyWith(status: PlacesStatus.ready, places: await _repo.getAll()));
  }

  Future<void> _onRemoved(PlaceRemoved e, Emitter<PlacesState> emit) async {
    await _repo.remove(e.id);
    emit(state.copyWith(status: PlacesStatus.ready, places: await _repo.getAll()));
  }
}
