import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/map/map_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../../core/widgets/route_timeline.dart';
import '../../domain/entities/fare_line.dart';
import '../bloc/booking_bloc.dart';
import '../widgets/fare_row.dart';
import '../widgets/payment_option_tile.dart';
import '../widgets/sheet_handle.dart';

/// "Confirm your ride": route summary, chosen driver, payment method and the
/// fare breakdown.
class ConfirmRidePage extends StatelessWidget {
  const ConfirmRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final int fare = _estimateFare(state.pickup, state.destination);
          final String fareText = 'EGP $fare';

          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 240,
                child: MapView(
                  variant: MapVariant.route,
                  pickup: state.pickup,
                  dropoff: state.destination,
                ),
              ),
              Positioned(
                top: 0,
                left: 18,
                child: SafeArea(
                  bottom: false,
                  child: RoundIconButton(
                    icon: Icons.chevron_left_rounded,
                    iconSize: 24,
                    size: 44,
                    radius: 14,
                    background: AppColors.surface,
                    shadow: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Positioned(
                top: 218,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(26)),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                    children: [
                      const SheetHandle(),
                      Text(AppStrings.confirmRide, style: AppTextStyles.title),
                      const SizedBox(height: 14),
                      _RouteSummary(
                        pickup: state.pickupAddress ?? AppStrings.currentLocation,
                        dropoff: state.destinationAddress ?? AppStrings.dropoffPlace,
                      ),
                      const SizedBox(height: 20),
                      Text(AppStrings.paymentMethod,
                          style: AppTextStyles.label.copyWith(fontSize: 13)),
                      const SizedBox(height: 10),
                      ...state.paymentMethods.map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: PaymentOptionTile(
                            method: m,
                            selected: m.id == state.selectedPaymentId,
                            onTap: () =>
                                context.read<BookingBloc>().add(BookingPaymentChanged(m.id)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 11),
                      FareRow(
                        line: FareLine(
                            label: AppStrings.estimatedTotal,
                            amount: fareText,
                            isTotal: true),
                      ),
                      Text(
                        AppStrings.fareNote,
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: '${AppStrings.requestRide} · $fareText',
                        onPressed: () {
                          final String pid = state.selectedPaymentId;
                          final String method =
                              (pid == 'cash' || pid == 'wallet' || pid == 'card')
                                  ? pid
                                  : 'cash';
                          // Broadcast the request (no driver_id) so every online
                          // captain receives it live and the first to accept
                          // takes the trip — inDrive-style.
                          final pickup = state.pickup ??
                              const LatLng(30.0444, 31.2357);
                          final dropoff = state.destination ??
                              const LatLng(30.0566, 31.3300);
                          context.read<BookingBloc>().add(
                                BookingRideRequested(
                                  pickupAddress:
                                      state.pickupAddress ?? 'Current location',
                                  dropoffAddress:
                                      state.destinationAddress ?? 'Destination',
                                  pickupLat: pickup.latitude,
                                  pickupLng: pickup.longitude,
                                  dropoffLat: dropoff.latitude,
                                  dropoffLng: dropoff.longitude,
                                  paymentMethod: method,
                                  price: fare,
                                  driverId: null, // broadcast to all online drivers
                                ),
                              );
                          Navigator.pushNamed(context, AppRoutes.finding);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Rough fare estimate from the straight-line distance between the two points:
/// a base fare plus a per-km rate, with a sensible minimum. Tunable later.
int _estimateFare(LatLng? pickup, LatLng? dropoff) {
  if (pickup == null || dropoff == null) return 25;
  final double meters = Geolocator.distanceBetween(
    pickup.latitude,
    pickup.longitude,
    dropoff.latitude,
    dropoff.longitude,
  );
  final double km = meters / 1000;
  final double fare = 15 + km * 7; // EGP 15 base + 7/km
  return fare.clamp(20, 100000).round();
}

class _RouteSummary extends StatelessWidget {
  const _RouteSummary({required this.pickup, required this.dropoff});

  final String pickup;
  final String dropoff;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: RouteTimeline(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _point(AppStrings.pickup, pickup),
                  const SizedBox(height: 12),
                  _point(AppStrings.dropoff, dropoff),
                ],
              ),
            ),
            Text('24 min\n14.2 km',
                textAlign: TextAlign.right,
                style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
          ],
        ),
      ),
    );
  }

  Widget _point(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.micro.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
          Text(value,
              style: AppTextStyles.listTitle.copyWith(fontSize: 14)),
        ],
      );
}
