import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_avatar.dart';
import '../../../../core/widgets/map/map_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../../core/widgets/route_timeline.dart';
import '../../domain/entities/fare_line.dart';
import '../cubit/booking_cubit.dart';
import '../utils/driver_presentation.dart';
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
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          final driver = state.selectedDriver;
          if (driver == null) return const SizedBox.shrink();

          return Stack(
            children: [
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 240,
                child: MapView(variant: MapVariant.route),
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
                      const _RouteSummary(),
                      const SizedBox(height: 16),
                      _ChosenDriverRow(
                        initials: driver.initials,
                        gradient: driver.avatarGradient,
                        name: driver.name,
                        subtitle: '${driver.tier} · ${driver.car}',
                        onChange: () => Navigator.pop(context),
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
                                context.read<BookingCubit>().setPayment(m.id),
                          ),
                        ),
                      ),
                      const SizedBox(height: 11),
                      Text(AppStrings.fareBreakdown,
                          style: AppTextStyles.label.copyWith(fontSize: 13)),
                      const SizedBox(height: 4),
                      ...state.fareLines.map((l) => FareRow(line: l)),
                      FareRow(
                        line: FareLine(
                            label: 'Total',
                            amount: driver.price,
                            isTotal: true),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label:
                            '${AppStrings.confirmRideAction} · ${driver.price}',
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.finding),
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

class _RouteSummary extends StatelessWidget {
  const _RouteSummary();

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
                  _point(AppStrings.pickup, AppStrings.currentLocation),
                  const SizedBox(height: 12),
                  _point(AppStrings.dropoff, AppStrings.dropoffPlace),
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

class _ChosenDriverRow extends StatelessWidget {
  const _ChosenDriverRow({
    required this.initials,
    required this.gradient,
    required this.name,
    required this.subtitle,
    required this.onChange,
  });

  final String initials;
  final Gradient gradient;
  final String name;
  final String subtitle;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          GradientAvatar(
            initials: initials,
            gradient: gradient,
            size: 50,
            radius: 16,
            fontSize: 18,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: AppTextStyles.listTitle.copyWith(fontSize: 15)),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          GestureDetector(
            onTap: onChange,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.peach,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(AppStrings.change,
                  style: AppTextStyles.micro.copyWith(
                      color: AppColors.primaryDark, fontSize: 12.5)),
            ),
          ),
        ],
      ),
    );
  }
}
