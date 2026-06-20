import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_shadows.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../../core/widgets/route_timeline.dart';
import '../bloc/booking_bloc.dart';
import 'location_picker_page.dart';

/// "Plan your ride": pick pickup and destination on the map, then continue to
/// the driver list. Both points feed the real trip request.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  Future<void> _pickPickup(BuildContext context) async {
    final bloc = context.read<BookingBloc>();
    final PickedPlace? place = await Navigator.push<PickedPlace>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerPage(
          title: AppStrings.pickup,
          initial: bloc.state.pickup,
        ),
      ),
    );
    if (place != null) {
      bloc.add(BookingPickupSet(place.latLng, place.address));
    }
  }

  Future<void> _pickDestination(BuildContext context) async {
    final bloc = context.read<BookingBloc>();
    final PickedPlace? place = await Navigator.push<PickedPlace>(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerPage(
          title: AppStrings.dropoff,
          // Start where the rider already is (destination, then pickup) so they
          // pan a short distance to where they're going — not from GPS.
          initial: bloc.state.destination ?? bloc.state.pickup,
          useCurrentLocation: false,
        ),
      ),
    );
    if (place != null) {
      bloc.add(BookingDestinationSet(place.latLng, place.address));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          return Column(
            children: [
              _Header(
                onBack: () => Navigator.pop(context),
                pickup: state.pickupAddress,
                destination: state.destinationAddress,
                onTapPickup: () => _pickPickup(context),
                onTapDestination: () => _pickDestination(context),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                child: PrimaryButton(
                  label: state.hasRoute
                      ? AppStrings.findDriver
                      : AppStrings.setDropoffFirst,
                  onPressed: state.hasRoute
                      ? () => Navigator.pushReplacementNamed(
                          context, AppRoutes.confirm)
                      : () => _pickDestination(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.onBack,
    required this.pickup,
    required this.destination,
    required this.onTapPickup,
    required this.onTapDestination,
  });

  final VoidCallback onBack;
  final String? pickup;
  final String? destination;
  final VoidCallback onTapPickup;
  final VoidCallback onTapDestination;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.floating,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          child: Column(
            children: [
              Row(
                children: [
                  RoundIconButton.back(onPressed: onBack),
                  const SizedBox(width: 12),
                  Text(AppStrings.planYourRide, style: AppTextStyles.titleSm),
                ],
              ),
              const SizedBox(height: 16),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 18, bottom: 18),
                      child: RouteTimeline(dotSize: 11),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          _FieldBox(
                            value: pickup,
                            hint: AppStrings.pickup,
                            highlighted: false,
                            onTap: onTapPickup,
                          ),
                          const SizedBox(height: 10),
                          _FieldBox(
                            value: destination,
                            hint: AppStrings.whereToShort,
                            highlighted: true,
                            onTap: onTapDestination,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldBox extends StatelessWidget {
  const _FieldBox({
    required this.value,
    required this.hint,
    required this.highlighted,
    required this.onTap,
  });

  final String? value;
  final String hint;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool empty = value == null || value!.trim().isEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: highlighted ? AppColors.peach : AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: highlighted
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                empty ? hint : value!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.input.copyWith(
                  fontSize: 14.5,
                  fontWeight: highlighted ? FontWeight.w700 : FontWeight.w600,
                  color: empty ? AppColors.textTertiary : AppColors.ink,
                ),
              ),
            ),
            const Icon(Icons.map_outlined, size: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
