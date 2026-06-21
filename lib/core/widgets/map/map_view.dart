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
  const MapView({
    super.key,
    this.variant = MapVariant.idle,
    this.pickup,
    this.dropoff,
    this.draggablePickup = false,
    this.onPickupMoved,
  });

  final MapVariant variant;

  /// Real trip endpoints. When null, sample Cairo points are used so the map
  /// still renders a preview.
  final LatLng? pickup;
  final LatLng? dropoff;

  /// In [MapVariant.idle], show a draggable pickup pin the rider can drag (or
  /// tap the map) to set their pickup — inDrive-style.
  final bool draggablePickup;

  /// Fires with the new pickup position when the rider drags the pin or taps
  /// the map (only when [draggablePickup] is on).
  final ValueChanged<LatLng>? onPickupMoved;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // Sample Cairo coordinates used until live trip geometry is wired in.
  static const LatLng _defaultPickup = LatLng(30.0444, 31.2357); // Downtown
  static const LatLng _defaultDropoff = LatLng(30.0626, 31.2497); // Zamalek-ish

  static const LatLng _cairoCenter = LatLng(30.0500, 31.2400);

  LatLng get _pickup => widget.pickup ?? _defaultPickup;
  LatLng get _dropoff => widget.dropoff ?? _defaultDropoff;

  GoogleMapController? _controller;

  /// Whether we've already recentred on the first resolved pickup (so we don't
  /// fight the rider's drags afterwards).
  bool _centeredOnPickup = false;

  bool get _showRoute => widget.variant != MapVariant.idle;
  bool get _interactivePickup =>
      widget.variant == MapVariant.idle && widget.draggablePickup;

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recentre once when the pickup first resolves (e.g. GPS comes back).
    if (_interactivePickup && !_centeredOnPickup && widget.pickup != null) {
      _centeredOnPickup = true;
      _controller?.animateCamera(CameraUpdate.newLatLng(widget.pickup!));
    }
  }

  Set<Marker> _buildMarkers() {
    if (_interactivePickup) {
      return {
        Marker(
          markerId: const MarkerId('pickup_drag'),
          position: _pickup,
          draggable: true,
          onDragEnd: (pos) => widget.onPickupMoved?.call(pos),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: const InfoWindow(title: 'Pickup', snippet: 'Drag or tap the map to move'),
        ),
      };
    }
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
        points: [_pickup, _dropoff],
        color: Colors.black.withOpacity(0.12),
        width: 11,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
      Polyline(
        polylineId: const PolylineId('route'),
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
      return CameraPosition(target: _pickup, zoom: 13.5);
    }
    if (_interactivePickup && widget.pickup != null) {
      return CameraPosition(target: widget.pickup!, zoom: 16);
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
      onTap: _interactivePickup ? widget.onPickupMoved : null,
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
      // The home booking sheet covers the lower half, so push the camera focus
      // (and the centred pickup pin) up into the visible area there; elsewhere
      // just keep Google's attribution clear of the sheets.
      padding: EdgeInsets.only(bottom: _interactivePickup ? 300 : 24),
    );
  }
}
