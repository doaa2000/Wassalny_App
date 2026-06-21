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
    this.interactivePickup = false,
    this.onPickupMoved,
  });

  final MapVariant variant;

  /// Real trip endpoints. When null, sample Cairo points are used so the map
  /// still renders a preview.
  final LatLng? pickup;
  final LatLng? dropoff;

  /// In [MapVariant.idle], show a fixed centre pin and let the rider move the
  /// map under it to set their pickup — inDrive-style.
  final bool interactivePickup;

  /// Fires with the map's centre when the rider stops panning (only when
  /// [interactivePickup] is on).
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
  /// fight the rider's panning afterwards).
  bool _centeredOnPickup = false;

  /// Last camera centre, and whether the latest move came from a user gesture
  /// (so we only commit a pickup the rider actually chose, not initial/animated
  /// settles).
  LatLng? _cameraTarget;
  bool _userMoved = false;

  bool get _showRoute => widget.variant != MapVariant.idle;
  bool get _interactivePickup =>
      widget.variant == MapVariant.idle && widget.interactivePickup;

  void _onCameraMoveStarted() => _userMoved = true;

  void _onCameraMove(CameraPosition position) => _cameraTarget = position.target;

  void _onCameraIdle() {
    if (_userMoved && _cameraTarget != null) {
      _userMoved = false;
      widget.onPickupMoved?.call(_cameraTarget!);
    }
  }

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
    // Interactive pickup uses a fixed Flutter overlay pin (see build), not a
    // Google marker, so the map slides freely beneath it.
    if (_interactivePickup) return const {};
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
    // Push the camera focus up over the home booking sheet so the centre pin
    // lands in the visible area; elsewhere just clear Google's attribution.
    const double bottomInset = 300;
    final GoogleMap map = GoogleMap(
      initialCameraPosition: _initialCamera,
      onMapCreated: _onMapCreated,
      onCameraMoveStarted: _interactivePickup ? _onCameraMoveStarted : null,
      onCameraMove: _interactivePickup ? _onCameraMove : null,
      onCameraIdle: _interactivePickup ? _onCameraIdle : null,
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
      padding: EdgeInsets.only(bottom: _interactivePickup ? bottomInset : 24),
    );

    if (!_interactivePickup) return map;

    // Fixed centre pin overlaid at the camera's focal point (centre of the
    // area above [bottomInset]). IgnorePointer so it never blocks panning.
    return Stack(
      children: [
        map,
        const Positioned.fill(
          child: IgnorePointer(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Align(
                alignment: Alignment.center,
                child: _CenterPin(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Fixed map pin: a teardrop whose tip points at the exact map centre.
class _CenterPin extends StatelessWidget {
  const _CenterPin();

  @override
  Widget build(BuildContext context) {
    // Pin content (circle + stem + dot) is ~62px tall with the tip at the
    // bottom. Padding the same amount below pushes the tip to the widget's
    // vertical centre, which Align then places on the exact map centre.
    return Padding(
      padding: const EdgeInsets.only(bottom: 62),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.my_location_rounded, color: Colors.white, size: 20),
          ),
          Container(width: 2.5, height: 14, color: AppColors.primary),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
