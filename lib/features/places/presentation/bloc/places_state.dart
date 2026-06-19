part of 'places_bloc.dart';

enum PlacesStatus { initial, loading, ready, failure }

class PlacesState extends Equatable {
  const PlacesState({
    this.status = PlacesStatus.initial,
    this.places = const [],
    this.error,
  });

  final PlacesStatus status;
  final List<SavedPlace> places;
  final String? error;

  PlacesState copyWith({PlacesStatus? status, List<SavedPlace>? places, String? error}) {
    return PlacesState(
      status: status ?? this.status,
      places: places ?? this.places,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, places, error];
}
