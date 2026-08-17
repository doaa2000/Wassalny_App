import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A city (or town) where ride requests are currently served, defined as a
/// circle around its centre.
class ServiceCity {
  const ServiceCity({
    required this.name,
    required this.center,
    required this.radiusKm,
  });

  final String name;
  final LatLng center;
  final double radiusKm;

  bool contains(LatLng point) {
    final double meters = Geolocator.distanceBetween(
      center.latitude,
      center.longitude,
      point.latitude,
      point.longitude,
    );
    return meters <= radiusKm * 1000;
  }
}

/// Where Wassalny currently has driver coverage. A pickup or destination
/// outside every city here has no captains to match against — the booking
/// flow checks this before letting the rider reach the "finding driver"
/// screen, which otherwise has no timeout and would spin forever.
///
/// To add a new city once coverage expands there, add an entry to [cities] —
/// no other code needs to change.
class ServiceArea {
  ServiceArea._();

  /// El Qusair town centre — also used as the app's default map position.
  static const LatLng defaultCenter = LatLng(26.1039, 34.2793);

  static const List<ServiceCity> cities = [
    ServiceCity(name: 'El Qusair', center: defaultCenter, radiusKm: 20),
  ];

  static bool contains(LatLng point) =>
      cities.any((city) => city.contains(point));
}
