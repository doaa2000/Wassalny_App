import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/service_area.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/map/map_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../../core/widgets/route_timeline.dart';
import '../bloc/booking_bloc.dart';
import '../widgets/payment_option_tile.dart';
import '../widgets/sheet_handle.dart';

/// "Confirm your ride": route summary, chosen driver, payment method and the
/// rider-editable fare.
class ConfirmRidePage extends StatefulWidget {
  const ConfirmRidePage({super.key});

  @override
  State<ConfirmRidePage> createState() => _ConfirmRidePageState();
}

class _ConfirmRidePageState extends State<ConfirmRidePage> {
  late final TextEditingController _priceController;
  int? _suggestedFare;
  String? _priceError;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  /// Seeds the field with the suggested fare the first time the route is
  /// known — after that the rider's own edits are never overwritten.
  void _seedSuggestedFare(int fare) {
    if (_suggestedFare != null) return;
    _suggestedFare = fare;
    _priceController.text = fare.toString();
  }

  int? get _enteredPrice => int.tryParse(_priceController.text.trim());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final int suggestedFare =
              _estimateFare(state.pickup, state.destination);
          _seedSuggestedFare(suggestedFare);

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
                      _PriceInput(
                        controller: _priceController,
                        suggestedFare: suggestedFare,
                        errorText: _priceError,
                        onChanged: () => setState(() => _priceError = null),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.fareNote,
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: AppStrings.requestRide,
                        onPressed: () {
                          // Floor at 60% of the suggested fare so offers stay
                          // realistic enough that a captain will accept them.
                          final int minPrice =
                              (suggestedFare * 0.6).round().clamp(15, 100000);
                          final int? entered = _enteredPrice;
                          if (entered == null || entered < minPrice) {
                            setState(() => _priceError = AppStrings.priceTooLow);
                            return;
                          }

                          final String pid = state.selectedPaymentId;
                          final String method =
                              (pid == 'cash' || pid == 'wallet' || pid == 'card')
                                  ? pid
                                  : 'cash';
                          // Broadcast the request (no driver_id) so every online
                          // captain receives it live and the first to accept
                          // takes the trip — inDrive-style. The rider's own
                          // entered price travels with it.
                          // These only apply if the rider somehow reaches this
                          // button without a route (the "Find driver" button
                          // upstream requires one) — fall back to the service
                          // area's default city rather than a hardcoded point.
                          final pickup = state.pickup ?? ServiceArea.defaultCenter;
                          final dropoff = state.destination ??
                              const LatLng(26.1161, 34.3736);
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
                                  price: entered,
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

/// The rider's own price offer, seeded with a suggested fare they can accept
/// as-is or edit. Tapping the "Suggested" chip snaps back to that estimate.
class _PriceInput extends StatelessWidget {
  const _PriceInput({
    required this.controller,
    required this.suggestedFare,
    required this.errorText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int suggestedFare;
  final String? errorText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: errorText != null
            ? Border.all(color: Colors.redAccent.withOpacity(0.6))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.yourOffer,
                    style: AppTextStyles.micro.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('EGP ', style: AppTextStyles.listTitle.copyWith(fontSize: 15)),
                    SizedBox(
                      width: 90,
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => onChanged(),
                        style: AppTextStyles.listTitle
                            .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 4),
                  Text(errorText!,
                      style: AppTextStyles.caption.copyWith(color: Colors.redAccent)),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.text = suggestedFare.toString();
              onChanged();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(AppStrings.suggestedFare,
                      style: AppTextStyles.micro.copyWith(fontSize: 10)),
                  Text('EGP $suggestedFare',
                      style: AppTextStyles.listTitle.copyWith(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
