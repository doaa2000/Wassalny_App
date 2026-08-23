import 'package:wassalny/core/services/supabase_service.dart';

/// Fetches the signed-in passenger's trip history from Supabase.
class RidesRemoteDataSource {
  RidesRemoteDataSource(this._service);

  final SupabaseService _service;

  /// Raw trip rows belonging to the current passenger, most recent first.
  /// Mapping into the domain `RideHistory` entity happens in the repository.
  Future<List<Map<String, dynamic>>> fetchRides() async {
    final String? passengerId = _service.currentUserId;
    if (passengerId == null) return const [];

    final List<Map<String, dynamic>> rows = await _service.client
        .from('trips')
        .select()
        .eq('passenger_id', passengerId)
        .order('created_at', ascending: false);

    return rows;
  }
}