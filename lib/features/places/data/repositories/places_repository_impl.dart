import '../../domain/entities/saved_place.dart';
import '../../domain/repositories/places_repository.dart';
import '../datasources/places_remote_data_source.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  PlacesRepositoryImpl(this._remote);

  final PlacesRemoteDataSource _remote;

  @override
  Future<List<SavedPlace>> getAll() => _remote.getAll();

  @override
  Future<SavedPlace> add({required String label, required String address, double? lat, double? lng}) =>
      _remote.add(label: label, address: address, lat: lat, lng: lng);

  @override
  Future<void> rename({required String id, required String label}) =>
      _remote.rename(id: id, label: label);

  @override
  Future<void> remove(String id) => _remote.remove(id);
}
