import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Thin wrapper around device GPS (geolocator) and reverse geocoding
/// (geocoding). Keeps permission handling in one place so the picker and any
/// future live-tracking code share the same logic.
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  /// Cairo, used as a safe default when GPS is unavailable.
  static const LatLng fallback = LatLng(30.0444, 31.2357);

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
        final parts = <String?>[
          m.street,
          m.subLocality,
          m.locality,
        ].where((s) => s != null && s.trim().isNotEmpty).toList();
        if (parts.isNotEmpty) return parts.join('، ');
      }
    } catch (_) {
      // Geocoding unavailable (e.g. no network) — fall through.
    }
    return '${p.latitude.toStringAsFixed(5)}, ${p.longitude.toStringAsFixed(5)}';
  }
}
