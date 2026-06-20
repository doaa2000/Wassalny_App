import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/app_colors.dart';
import 'map_style.dart';

/// Display modes for [MapView], mirroring the design component variants.
enum MapVariant {
  /// Home screen: nearby taxis + the user's location.
  idle,

  /// Confirm / driver-assigned: the planned route with pickup & drop-off pins.
  route,

  /// Live tracking: the route plus the driver's car along it.
  tracking,
}

/// A real Google Map centred on Cairo. For [MapVariant.route] and
/// [MapVariant.tracking] it draws a pickup → drop-off polyline with markers so
/// the booking screens keep their route preview. The public API is unchanged
/// (`MapView({variant})`) so every screen that used the old stylized map keeps
/// working without edits.
class MapView extends StatefulWidget {
  const MapView({super.key, this.variant = MapVariant.idle});

  final MapVariant variant;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // Sample Cairo coordinates used until live trip geometry is wired in.
  static const LatLng _pickup = LatLng(30.0444, 31.2357); // Downtown Cairo
  static const LatLng _dropoff = LatLng(30.0626, 31.2497); // Zamalek-ish

  static const LatLng _cairoCenter = LatLng(30.0500, 31.2400);

  GoogleMapController? _controller;

  bool get _showRoute => widget.variant != MapVariant.idle;

  Set<Marker> _buildMarkers() {
    if (!_showRoute) return const {};
    return {
      Marker(
        markerId: const MarkerId('pickup'),
        position: _pickup,
        infoWindow: const InfoWindow(title: 'Pickup'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: _dropoff,
        infoWindow: const InfoWindow(title: 'Drop-off'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
  }

  Set<Polyline> _buildPolylines() {
    if (!_showRoute) return const {};
    return {
      // Soft shadow line under the main route for a little depth.
      Polyline(
        polylineId: const PolylineId('route_shadow'),
        points: const [_pickup, _dropoff],
        color: Colors.black.withOpacity(0.12),
        width: 11,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
      const Polyline(
        polylineId: PolylineId('route'),
        points: [_pickup, _dropoff],
        color: AppColors.primary,
        width: 6,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };
  }

  CameraPosition get _initialCamera {
    if (_showRoute) {
      return const CameraPosition(target: _pickup, zoom: 13.5);
    }
    return const CameraPosition(target: _cairoCenter, zoom: 13);
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    // Frame both points when a route is shown.
    if (_showRoute) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          _pickup.latitude < _dropoff.latitude ? _pickup.latitude : _dropoff.latitude,
          _pickup.longitude < _dropoff.longitude ? _pickup.longitude : _dropoff.longitude,
        ),
        northeast: LatLng(
          _pickup.latitude > _dropoff.latitude ? _pickup.latitude : _dropoff.latitude,
          _pickup.longitude > _dropoff.longitude ? _pickup.longitude : _dropoff.longitude,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 64));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialCamera,
      onMapCreated: _onMapCreated,
      style: wassalnyMapStyle,
      markers: _buildMarkers(),
      polylines: _buildPolylines(),
      // Kept off until a location-permission flow is wired in; flip to true
      // once geolocator requests ACCESS_FINE_LOCATION at runtime.
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      // The booking sheets sit on top of the map; padding keeps Google's
      // attribution visible above them.
      padding: const EdgeInsets.only(bottom: 24),
    );
  }
}
