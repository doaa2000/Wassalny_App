import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/service_area.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_shadows.dart';
import '../../../../core/widgets/map/map_view.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../booking/presentation/bloc/booking_bloc.dart';
import '../../../places/domain/entities/saved_place.dart';
import '../../../places/presentation/bloc/places_bloc.dart';
import '../../../places/presentation/utils/add_place_flow.dart';
import '../../../shell/presentation/bloc/nav_bloc.dart';
import '../widgets/quick_place_card.dart';

/// Home tab: live map with a booking sheet (greeting, search entry, saved
/// places and nearby drivers). The map carries a draggable pickup pin
/// (inDrive-style) the rider can move to set their pickup.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Centre the pickup pin on the rider's current location when home opens.
    context.read<BookingBloc>().add(const BookingCurrentPickupRequested());
  }

  void _openSearch(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.search);

  /// Finds a saved place whose label matches [wantedLabel] (e.g. "Home"),
  /// case-insensitively — the app has no dedicated home/work type, just a
  /// free-text label, so this is how the quick-place cards recognise them.
  SavedPlace? _findByLabel(List<SavedPlace> places, String wantedLabel) {
    for (final p in places) {
      if (p.label.trim().toLowerCase() == wantedLabel.trim().toLowerCase()) {
        return p;
      }
    }
    return null;
  }

  void _onQuickPlaceTap(
      BuildContext context, SavedPlace? place, String presetLabel) {
    // No "Home"/"Work" saved yet — prompt the rider to add one, pre-filled.
    if (place == null || place.latitude == null || place.longitude == null) {
      runAddPlaceFlow(context, context.read<PlacesBloc>(),
          presetLabel: presetLabel);
      return;
    }
    final LatLng point = LatLng(place.latitude!, place.longitude!);
    if (!ServiceArea.contains(point)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(AppStrings.outsideServiceArea)));
      return;
    }
    context
        .read<BookingBloc>()
        .add(BookingDestinationSet(point, place.address));
    Navigator.pushNamed(context, AppRoutes.confirm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BlocSelector<BookingBloc, BookingState, LatLng?>(
              selector: (state) => state.pickup,
              builder: (context, pickup) => MapView(
                variant: MapVariant.idle,
                interactivePickup: true,
                pickup: pickup,
                onPickupMoved: (p) =>
                    context.read<BookingBloc>().add(BookingPickupPicked(p)),
              ),
            ),
          ),
          // Top bar.
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
                      icon: Icons.menu_rounded,
                      iconColor: AppColors.ink,
                      background: AppColors.surface,
                      size: 48,
                      radius: 16,
                      shadow: true,
                      onPressed: () =>
                          context.read<NavBloc>().add(const NavTabSelected(4)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _LocationPill()),
                    const SizedBox(width: 10),
                    RoundIconButton(
                      icon: Icons.my_location_rounded,
                      iconColor: AppColors.primaryDark,
                      background: AppColors.surface,
                      size: 48,
                      radius: 16,
                      shadow: true,
                      onPressed: () => context.read<BookingBloc>().add(
                          const BookingCurrentPickupRequested(force: true)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Booking sheet.
          Align(
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<PlacesBloc, PlacesState>(
              builder: (context, placesState) {
                final SavedPlace? home =
                    _findByLabel(placesState.places, AppStrings.placeHome);
                final SavedPlace? work =
                    _findByLabel(placesState.places, AppStrings.placeWork);
                return _BookingSheet(
                  onSearch: () => _openSearch(context),
                  homePlace: home,
                  workPlace: work,
                  onTapHome: () => _onQuickPlaceTap(
                      context, home, AppStrings.placeHome),
                  onTapWork: () => _onQuickPlaceTap(
                      context, work, AppStrings.placeWork),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.floating,
      ),
      child: Row(
        children: [
          const Icon(Icons.trip_origin, size: 15, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.pickup,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                BlocSelector<BookingBloc, BookingState, String?>(
                  selector: (state) => state.pickupAddress,
                  builder: (context, address) => Text(
                    address?.isNotEmpty == true
                        ? address!
                        : AppStrings.setPickupHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingSheet extends StatelessWidget {
  const _BookingSheet({
    required this.onSearch,
    required this.homePlace,
    required this.workPlace,
    required this.onTapHome,
    required this.onTapWork,
  });

  final VoidCallback onSearch;
  final SavedPlace? homePlace;
  final SavedPlace? workPlace;
  final VoidCallback onTapHome;
  final VoidCallback onTapWork;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Color(0x290F1A24),
            blurRadius: 40,
            offset: Offset(0, -12),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(AppStrings.greeting, style: AppTextStyles.title),
            const SizedBox(height: 2),
            Text(AppStrings.whereTo,
                style: AppTextStyles.body.copyWith(height: 1.2)),
            const SizedBox(height: 16),
            _SearchEntry(onTap: onSearch),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: QuickPlaceCard(
                    icon: Icons.home_rounded,
                    title: AppStrings.placeHome,
                    subtitle: homePlace?.address ?? AppStrings.tapToAddAddress,
                    onTap: onTapHome,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickPlaceCard(
                    icon: Icons.work_outline_rounded,
                    title: AppStrings.placeWork,
                    subtitle: workPlace?.address ?? AppStrings.tapToAddAddress,
                    onTap: onTapWork,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SearchEntry extends StatelessWidget {
  const _SearchEntry({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              size: 20,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(AppStrings.whereToShort,
                  style: AppTextStyles.input.copyWith(
                      color: AppColors.ink,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(AppStrings.setOnMap,
                  style: AppTextStyles.micro.copyWith(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
