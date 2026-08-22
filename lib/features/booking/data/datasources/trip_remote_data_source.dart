import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    String? driverId,
  });

  /// Live stream of the trip's status (requested → accepted → arrived →
  /// in_progress → completed). Drives the rider's tracking screens.
  Stream<String> watchTrip(String tripId);

  /// Public details of the driver who accepted the trip (null while still
  /// broadcast / unassigned, or in UI-only mode).
  Future<Map<String, dynamic>?> assignedDriverRow(String tripId);

  /// Live stream of the assigned captain's GPS position for [tripId] (null
  /// until the captain starts sharing). Drives the moving car on the map.
  Stream<LatLng?> watchDriverLocation(String tripId);

  /// Marks a still-unassigned trip as cancelled by the rider — used when they
  /// tap "Cancel" while waiting, or when the search times out with no captain
  /// accepting. Without this the trip would stay `requested` forever.
  Future<void> cancelTrip(String tripId);
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
    String? driverId,
  }) async {
    final String? passengerId = _service.currentUserId;
    if (passengerId == null) {
      throw StateError('No passenger session — cannot create a trip.');
    }
    final Map<String, dynamic> row = await _service.client
        .from('trips')
        .insert({
          'passenger_id': passengerId,
          'driver_id': driverId, // null = broadcast; set = assigned to a driver
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

  @override
  Stream<String> watchTrip(String tripId) {
    return _service.client
        .from('trips')
        .stream(primaryKey: ['id'])
        .eq('id', tripId)
        .map((rows) =>
            rows.isEmpty ? 'requested' : (rows.first['status'] as String? ?? 'requested'));
  }

  @override
  Future<Map<String, dynamic>?> assignedDriverRow(String tripId) async {
    final dynamic res = await _service.client
        .rpc('trip_driver', params: {'p_trip_id': tripId});
    final List list = (res as List?) ?? const [];
    if (list.isEmpty) return null;
    return (list.first as Map).cast<String, dynamic>();
  }

  @override
  Stream<LatLng?> watchDriverLocation(String tripId) {
    return _service.client
        .from('driver_locations')
        .stream(primaryKey: ['id'])
        .eq('trip_id', tripId)
        .order('recorded_at', ascending: false)
        .limit(1)
        .map((rows) {
      if (rows.isEmpty) return null;
      final Map<String, dynamic> latest = rows.first; // most recent fix
      final double? lat = (latest['latitude'] as num?)?.toDouble();
      final double? lng = (latest['longitude'] as num?)?.toDouble();
      if (lat == null || lng == null) return null;
      return LatLng(lat, lng);
    });
  }

  @override
  Future<void> cancelTrip(String tripId) async {
    // Only cancel while still `requested` — if a captain has already
    // accepted in the meantime, leave the trip alone rather than yanking it
    // out from under them.
    await _service.client
        .from('trips')
        .update({'status': 'cancelled'})
        .eq('id', tripId)
        .eq('status', 'requested');
  }
}

/// UI-only mode (no Supabase): returns a fake id and simulates a trip
/// progressing through its statuses so the flow is demoable offline.
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
    String? driverId,
  }) async =>
      'mock-${DateTime.now().millisecondsSinceEpoch}';

  @override
  Stream<String> watchTrip(String tripId) async* {
    await Future<void>.delayed(const Duration(seconds: 3));
    yield 'accepted';
    await Future<void>.delayed(const Duration(seconds: 3));
    yield 'arrived';
    await Future<void>.delayed(const Duration(seconds: 3));
    yield 'in_progress';
    await Future<void>.delayed(const Duration(seconds: 5));
    yield 'completed';
  }

  @override
  Future<Map<String, dynamic>?> assignedDriverRow(String tripId) async => null;

  @override
  Stream<LatLng?> watchDriverLocation(String tripId) =>
      const Stream<LatLng?>.empty();

  @override
  Future<void> cancelTrip(String tripId) async {}
}
