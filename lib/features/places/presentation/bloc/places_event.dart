part of 'places_bloc.dart';

sealed class PlacesEvent extends Equatable {
  const PlacesEvent();

  @override
  List<Object?> get props => [];
}

final class PlacesLoaded extends PlacesEvent {
  const PlacesLoaded();
}

final class PlaceAdded extends PlacesEvent {
  const PlaceAdded({required this.label, required this.address, this.lat, this.lng});

  final String label;
  final String address;
  final double? lat;
  final double? lng;

  @override
  List<Object?> get props => [label, address, lat, lng];
}

final class PlaceRenamed extends PlacesEvent {
  const PlaceRenamed({required this.id, required this.label});

  final String id;
  final String label;

  @override
  List<Object?> get props => [id, label];
}

final class PlaceRemoved extends PlacesEvent {
  const PlaceRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
