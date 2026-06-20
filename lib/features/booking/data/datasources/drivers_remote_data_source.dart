import '../../../../core/services/supabase_service.dart';
import '../models/driver_model.dart';

/// Loads real, online, approved drivers near a point via the `nearby_drivers`
/// RPC and maps them into the UI's [DriverModel]. The chosen driver's
/// `profileId` is later used to assign the trip directly to them.
class DriversRemoteDataSource {
  const DriversRemoteDataSource(this._service);

  final SupabaseService _service;

  // A small palette so real-driver cards still look like the design.
  static const List<List<int>> _palette = [
    [0xFFC45B2E, 0xFFC45B2E, 0xFFD9743F],
    [0xFF2C3A45, 0xFFF0A04B, 0xFFE07B39],
    [0xFF0F1A24, 0xFF0E9D9A, 0xFF0B7A78],
    [0xFF1B2A4A, 0xFF6C8BE0, 0xFF4D6FD0],
  ];

  Future<List<DriverModel>> nearbyDrivers({
    required double lat,
    required double lng,
  }) async {
    final dynamic res = await _service.client.rpc(
      'nearby_drivers',
      params: {'p_lat': lat, 'p_lng': lng, 'p_radius_km': 15},
    );
    final List<Map<String, dynamic>> rows =
        (res as List).map((e) => (e as Map).cast<String, dynamic>()).toList();

    int i = 0;
    return rows.map((r) => _toDriver(r, i++)).toList();
  }

  DriverModel _toDriver(Map<String, dynamic> r, int index) {
    final String name = (r['full_name'] as String?)?.trim().isNotEmpty == true
        ? r['full_name'] as String
        : 'Driver';
    final double distanceKm = (r['distance_km'] as num?)?.toDouble() ?? 1;
    final num rating = (r['rating'] as num?) ?? 0;
    final int trips = (r['total_trips'] as num?)?.toInt() ?? 0;
    final String tier = _tier(r['vehicle_type'] as String?);
    final List<int> colors = _palette[index % _palette.length];

    return DriverModel(
      id: index,
      profileId: r['profile_id']?.toString(),
      name: name,
      firstName: name.split(' ').first,
      initials: _initials(name),
      rating: rating.toStringAsFixed(2),
      rides: trips.toString(),
      car: tier,
      plate: '—',
      tier: 'Wassalny ${_tierShort(r['vehicle_type'] as String?)}',
      tag: index == 0 ? 'Nearest' : '',
      etaMinutes: (distanceKm * 2.5).round().clamp(1, 30).toInt(),
      price: 'EGP ${(20 + distanceKm * 8).round()}',
      carColorValue: colors[0],
      avatarStartValue: colors[1],
      avatarEndValue: colors[2],
      recommended: index == 0,
    );
  }

  /// Maps a `trip_driver` RPC row (the captain who accepted) into a [DriverModel]
  /// for the tracking screens. Has no distance, so ETA/price are left neutral.
  DriverModel fromAssignedRow(Map<String, dynamic> r) {
    final String name = (r['full_name'] as String?)?.trim().isNotEmpty == true
        ? r['full_name'] as String
        : 'Driver';
    final num rating = (r['rating'] as num?) ?? 0;
    final int trips = (r['total_trips'] as num?)?.toInt() ?? 0;
    final String model = (r['vehicle_model'] as String?)?.trim().isNotEmpty == true
        ? r['vehicle_model'] as String
        : _tier(r['vehicle_type'] as String?);
    final String plate = (r['plate_number'] as String?)?.trim().isNotEmpty == true
        ? r['plate_number'] as String
        : '—';
    final List<int> colors = _palette[0];

    return DriverModel(
      id: 0,
      profileId: r['profile_id']?.toString(),
      name: name,
      firstName: name.split(' ').first,
      initials: _initials(name),
      rating: rating.toStringAsFixed(2),
      rides: trips.toString(),
      car: model,
      plate: plate,
      tier: 'Wassalny ${_tierShort(r['vehicle_type'] as String?)}',
      tag: '',
      etaMinutes: 3,
      price: '—',
      carColorValue: colors[0],
      avatarStartValue: colors[1],
      avatarEndValue: colors[2],
      recommended: false,
    );
  }

  String _tier(String? vt) => switch (vt) {
        'comfort' => 'Comfort sedan',
        'suv' => 'SUV',
        'van' => 'Van',
        'motorbike' => 'Motorbike',
        _ => 'Economy',
      };

  String _tierShort(String? vt) => switch (vt) {
        'comfort' => 'Comfort',
        'suv' => 'SUV',
        'van' => 'Van',
        'motorbike' => 'Bike',
        _ => 'Go',
      };

  String _initials(String name) {
    final List<String> parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'D';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
