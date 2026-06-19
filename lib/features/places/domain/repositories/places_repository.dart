import '../entities/saved_place.dart';

/// CRUD contract for the passenger's saved places.
abstract class PlacesRepository {
  Future<List<SavedPlace>> getAll();
  Future<SavedPlace> add({required String label, required String address, double? lat, double? lng});
  Future<void> rename({required String id, required String label});
  Future<void> remove(String id);
}
