import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/saved_place.dart';

/// Supabase-backed CRUD for `saved_places`. The only places file aware of
/// Supabase. Falls back to an in-memory list when the backend isn't configured
/// so the screen still works in UI-only mode.
class PlacesRemoteDataSource {
  PlacesRemoteDataSource(this._service);

  final SupabaseService _service;

  // In-memory store used only in UI-only (no Supabase) mode.
  final List<SavedPlace> _memory = <SavedPlace>[];

  static const String _table = 'saved_places';

  SavedPlace _fromRow(Map<String, dynamic> j) => SavedPlace(
        id: j['id'].toString(),
        label: j['label'] as String? ?? '',
        address: j['address'] as String? ?? '',
        latitude: (j['latitude'] as num?)?.toDouble(),
        longitude: (j['longitude'] as num?)?.toDouble(),
      );

  // READ
  Future<List<SavedPlace>> getAll() async {
    if (!_service.isConfigured) return List.unmodifiable(_memory);
    final List<Map<String, dynamic>> rows =
        await _service.client.from(_table).select().order('created_at');
    return rows.map(_fromRow).toList();
  }

  // CREATE
  Future<SavedPlace> add({
    required String label,
    required String address,
    double? lat,
    double? lng,
  }) async {
    if (!_service.isConfigured) {
      final place = SavedPlace(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        label: label,
        address: address,
        latitude: lat,
        longitude: lng,
      );
      _memory.add(place);
      return place;
    }
    final Map<String, dynamic> row = await _service.client.from(_table).insert({
      'user_id': _service.currentUserId,
      'label': label,
      'address': address,
      'latitude': lat,
      'longitude': lng,
    }).select().single();
    return _fromRow(row);
  }

  // UPDATE
  Future<void> rename({required String id, required String label}) async {
    if (!_service.isConfigured) {
      final int i = _memory.indexWhere((p) => p.id == id);
      if (i != -1) {
        final SavedPlace old = _memory[i];
        _memory[i] = SavedPlace(
          id: old.id,
          label: label,
          address: old.address,
          latitude: old.latitude,
          longitude: old.longitude,
        );
      }
      return;
    }
    await _service.client.from(_table).update({'label': label}).eq('id', id);
  }

  // DELETE
  Future<void> remove(String id) async {
    if (!_service.isConfigured) {
      _memory.removeWhere((p) => p.id == id);
      return;
    }
    await _service.client.from(_table).delete().eq('id', id);
  }
}
