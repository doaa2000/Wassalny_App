import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/map/map_style.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';

/// The place the rider confirmed on the map.
class PickedPlace {
  const PickedPlace(this.latLng, this.address);
  final LatLng latLng;
  final String address;
}

/// Full-screen map picker: the rider pans the map under a fixed centre pin and
/// confirms. The centre is reverse-geocoded to show a readable address. Returns
/// a [PickedPlace] via [Navigator.pop].
class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({
    super.key,
    required this.title,
    this.initial,
    this.useCurrentLocation = true,
  });

  /// Header label, e.g. "Set pickup" / "Set destination".
  final String title;

  /// Where to centre the map initially. When null (and [useCurrentLocation]),
  /// the device GPS position is used, falling back to Cairo.
  final LatLng? initial;

  /// Try to centre on the device location when [initial] is null.
  final bool useCurrentLocation;

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final LocationService _location = LocationService.instance;

  GoogleMapController? _controller;
  LatLng _center = LocationService.fallback;
  String _address = '…';
  bool _resolving = false;
  bool _ready = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    LatLng start = widget.initial ?? LocationService.fallback;
    if (widget.initial == null && widget.useCurrentLocation) {
      final LatLng? here = await _location.currentLatLng();
      if (here != null) start = here;
    }
    if (!mounted) return;
    setState(() {
      _center = start;
      _ready = true;
    });
    _resolveAddress(start);
  }

  void _onCameraMove(CameraPosition pos) {
    _center = pos.target;
  }

  /// Tapping anywhere on the map drops the pin there (inDrive-style). The
  /// camera animation triggers [_onCameraIdle], which resolves the address.
  Future<void> _onMapTap(LatLng p) async {
    _center = p;
    await _controller?.animateCamera(CameraUpdate.newLatLng(p));
  }

  void _onCameraIdle() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _resolveAddress(_center);
    });
  }

  Future<void> _resolveAddress(LatLng p) async {
    setState(() => _resolving = true);
    final String a = await _location.addressOf(p);
    if (!mounted) return;
    setState(() {
      _address = a;
      _resolving = false;
    });
  }

  Future<void> _goToMyLocation() async {
    final LatLng? here = await _location.currentLatLng();
    if (here == null || _controller == null) return;
    await _controller!.animateCamera(CameraUpdate.newLatLngZoom(here, 16));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          if (_ready)
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: _center, zoom: 16),
                style: wassalnyMapStyle,
                onMapCreated: (c) => _controller = c,
                onCameraMove: _onCameraMove,
                onCameraIdle: _onCameraIdle,
                onTap: _onMapTap,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          // Fixed centre pin (sits slightly above the exact centre so its tip
          // points at the chosen coordinate).
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 36),
              child: _CenterPin(),
            ),
          ),

          // Back button + title.
          Positioned(
            top: 0,
            left: 18,
            right: 18,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    RoundIconButton(
                      icon: Icons.chevron_left_rounded,
                      iconSize: 24,
                      size: 44,
                      radius: 14,
                      background: AppColors.surface,
                      shadow: true,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A0F1A24),
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(widget.title, style: AppTextStyles.titleSm),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // "My location" button, just above the confirm sheet.
          Positioned(
            right: 18,
            bottom: 168,
            child: RoundIconButton(
              icon: Icons.my_location_rounded,
              iconColor: AppColors.primary,
              background: AppColors.surface,
              size: 48,
              radius: 16,
              shadow: true,
              onPressed: _goToMyLocation,
            ),
          ),

          // Address + confirm sheet.
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1F0F1A24),
                    blurRadius: 28,
                    offset: Offset(0, -8),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.pickerHint,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.place_rounded,
                            size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _resolving ? AppStrings.locating : _address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.listTitle.copyWith(fontSize: 14.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      label: AppStrings.confirm,
                      onPressed: () => Navigator.pop(
                        context,
                        PickedPlace(_center, _address),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CenterPin extends StatelessWidget {
  const _CenterPin();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
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
          child: const Icon(Icons.person_pin_circle_rounded,
              color: Colors.white, size: 20),
        ),
        Container(
          width: 2,
          height: 14,
          color: AppColors.primary,
        ),
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
