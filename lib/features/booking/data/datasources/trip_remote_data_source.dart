import '../../../../core/services/supabase_service.dart';

/// Creates a ride request in the backend. Returns the new trip id (or null when
/// running without a backend).
abstract class TripRemoteDataSource {
  Future<String?> requestTrip({
    required String pickupAddress,
    required String dropoffAddress,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
    required String paymentMethod,
    num? price,
  });
}

/// Supabase implementation: inserts a `requested` trip for the signed-in rider.
/// This is the row the Captain app receives live via Realtime.
class TripSupabaseDataSource implements TripRemoteDataSource {
  const TripSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<String?> requestTrip({
    required String pickupAddress,
    required String dropoffAddress,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
    required String paymentMethod,
    num? price,
  }) async {
    final String? passengerId = _service.currentUserId;
    if (passengerId == null) {
      throw StateError('No passenger session — cannot create a trip.');
    }
    final Map<String, dynamic> row = await _service.client
        .from('trips')
        .insert({
          'passenger_id': passengerId,
          'pickup_address': pickupAddress,
          'destination_address': dropoffAddress,
          'pickup_latitude': pickupLat,
          'pickup_longitude': pickupLng,
          'destination_latitude': dropoffLat,
          'destination_longitude': dropoffLng,
          'status': 'requested',
          'payment_method': paymentMethod,
          'trip_price': price,
        })
        .select('id')
        .single();
    return row['id']?.toString();
  }
}

/// Used in UI-only mode (no Supabase credentials): does nothing.
class TripNoopDataSource implements TripRemoteDataSource {
  const TripNoopDataSource();

  @override
  Future<String?> requestTrip({
    required String pickupAddress,
    required String dropoffAddress,
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
    required String paymentMethod,
    num? price,
  }) async =>
      null;
}
