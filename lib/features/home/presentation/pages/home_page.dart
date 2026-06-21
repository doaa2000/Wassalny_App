import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_shadows.dart';
import '../../../../core/widgets/map/map_view.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../booking/domain/entities/driver.dart';
import '../../../booking/presentation/bloc/booking_bloc.dart';
import '../../../shell/presentation/bloc/nav_bloc.dart';
import '../widgets/driver_mini_card.dart';
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

  // Drivers shown on the home sheet are a live preview only. Tapping any of
  // them (or "compare all") starts the booking flow — the ride is broadcast to
  // all online captains, not assigned to one upfront.
  void _openDrivers(BuildContext context, {int? select}) {
    Navigator.pushNamed(context, AppRoutes.search);
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
                  ],
                ),
              ),
            ),
          ),
          // Booking sheet.
          Align(
            alignment: Alignment.bottomCenter,
            child: _BookingSheet(
              onSearch: () => _openSearch(context),
              onCompareAll: () => _openDrivers(context),
              onPickDriver: (i) => _openDrivers(context, select: i),
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
            child: BlocSelector<BookingBloc, BookingState, String?>(
              selector: (state) => state.pickupAddress,
              builder: (context, address) => Text(
                address?.isNotEmpty == true ? address! : 'Locating your pickup…',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                ),
              ),
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
    required this.onCompareAll,
    required this.onPickDriver,
  });

  final VoidCallback onSearch;
  final VoidCallback onCompareAll;
  final ValueChanged<int> onPickDriver;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BookingBloc, BookingState, List<Driver>>(
      selector: (state) => state.drivers,
      builder: (context, drivers) => _buildSheet(context, drivers),
    );
  }

  Widget _buildSheet(BuildContext context, List<Driver> drivers) {
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
                  color: const Color(0xFFE5DACB),
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
                    title: 'Home',
                    subtitle: 'Maadi, Rd 9',
                    onTap: onSearch,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickPlaceCard(
                    icon: Icons.work_outline_rounded,
                    title: 'Work',
                    subtitle: 'Smart Village',
                    onTap: onSearch,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(AppStrings.driversNearYou,
                      style: AppTextStyles.listTitle.copyWith(fontSize: 14.5)),
                ),
                GestureDetector(
                  onTap: onCompareAll,
                  child: Text(
                    AppStrings.compareAll,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 104,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: drivers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => DriverMiniCard(
                  driver: drivers[i],
                  onTap: () => onPickDriver(i),
                ),
              ),
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
            const Icon(Icons.search_rounded, size: 20, color: AppColors.primary),
            const SizedBox(width: 11),
            Expanded(
              child: Text(AppStrings.whereToShort,
                  style: AppTextStyles.input.copyWith(
                      color: AppColors.ink, fontSize: 15.5, fontWeight: FontWeight.w600)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.peach,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(AppStrings.setOnMap,
                  style: AppTextStyles.micro.copyWith(
                      color: AppColors.primary, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
