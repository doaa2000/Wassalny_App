import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/service_area.dart';

/// Thin wrapper around device GPS (geolocator) and reverse geocoding
/// (geocoding). Keeps permission handling in one place so the picker and any
/// future live-tracking code share the same logic.
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  /// The service area's default city centre, used as a safe fallback when
  /// GPS is unavailable.
  static const LatLng fallback = ServiceArea.defaultCenter;

  /// Ensures location services are on and permission is granted, returning the
  /// device's current position — or `null` if it can't be obtained.
  Future<LatLng?> currentLatLng() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return null;
      }

      final Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      return LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      return null;
    }
  }

  /// Best-effort human-readable address for a point. Falls back to the raw
  /// coordinates when the platform geocoder has nothing.
  Future<String> addressOf(LatLng p) async {
    try {
      final List<Placemark> marks =
          await placemarkFromCoordinates(p.latitude, p.longitude);
      if (marks.isNotEmpty) {
        final Placemark m = marks.first;
        // Build the most descriptive name available, most-specific first:
        // a POI/landmark name or street, then the district and the city.
        // De-duplicate (a field is often repeated as `name` and `street`).
        final seen = <String>{};
        final parts = <String?>[
          m.name,
          m.thoroughfare,
          m.subLocality,
          m.locality,
          m.administrativeArea,
        ]
            .where((s) => s != null && s.trim().isNotEmpty)
            .map((s) => s!.trim())
            // Drop entries that are just a number (e.g. a bare house number).
            .where((s) => !RegExp(r'^[0-9\s-]+$').hasMatch(s))
            .where((s) => seen.add(s.toLowerCase()))
            .toList();
        if (parts.isNotEmpty) return parts.take(3).join('، ');
      }
    } catch (_) {
      // Geocoding unavailable (e.g. no network) — fall through.
    }
    return '${p.latitude.toStringAsFixed(5)}, ${p.longitude.toStringAsFixed(5)}';
  }
}
