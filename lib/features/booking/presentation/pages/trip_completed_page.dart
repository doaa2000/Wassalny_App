import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_avatar.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/rating.dart';
import '../../domain/entities/driver.dart';
import '../bloc/booking_bloc.dart';
import '../utils/driver_presentation.dart';

/// Trip summary + rating + tip screen shown after the ride completes.
class TripCompletedPage extends StatelessWidget {
  const TripCompletedPage({super.key});

  static const _tips = [0, 5, 10, 20];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final driver = state.activeDriver;
          if (driver == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.brandSweep,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        const SizedBox(height: 28),
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 14),
                        Text(AppStrings.arrivedTitle,
                            style:
                                AppTextStyles.h3.copyWith(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(
                          'Hope you enjoyed your ride with ${driver.firstName}.',
                          style: AppTextStyles.bodySm.copyWith(
                              color: Colors.white.withOpacity(0.88)),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                  child: Column(
                    children: [
                      _StatsCard(price: driver.price),
                      const SizedBox(height: 14),
                      _RateCard(driver: driver),
                      const SizedBox(height: 18),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppStrings.addTip,
                            style: AppTextStyles.label.copyWith(fontSize: 13)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          for (var i = 0; i < _tips.length; i++) ...[
                            _TipChip(
                              value: _tips[i],
                              selected: state.tip == _tips[i],
                              onTap: () =>
                                  context.read<BookingBloc>().add(BookingTipChanged(_tips[i])),
                            ),
                            if (i != _tips.length - 1) const SizedBox(width: 9),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        height: 52,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 1.5),
                        ),
                        child: TextField(
                          cursorColor: AppColors.primary,
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.ink, fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: AppStrings.leaveReview,
                            hintStyle: AppTextStyles.body
                                .copyWith(fontSize: 14, color: AppColors.textTertiary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      PrimaryButton(
                        label: AppStrings.submitDone,
                        onPressed: () {
                          context.read<BookingBloc>().add(const BookingTripReset());
                          Navigator.popUntil(
                              context, ModalRoute.withName(AppRoutes.main));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 12),
            spreadRadius: -20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat('14.2', 'km'),
          _divider(),
          _stat('24', 'min'),
          _divider(),
          _stat(price, 'total · Wallet', highlight: true),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 34, color: AppColors.border);

  Widget _stat(String value, String label, {bool highlight = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
            style: AppTextStyles.bodyStrong.copyWith(
              fontSize: highlight ? 18 : 21,
              color: highlight ? AppColors.primary : AppColors.ink,
            )),
        Text(label,
            style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
      ],
    );
  }
}

class _RateCard extends StatelessWidget {
  const _RateCard({required this.driver});

  final Driver driver;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 12),
            spreadRadius: -20,
          ),
        ],
      ),
      child: Column(
        children: [
          GradientAvatar(
            initials: driver.initials,
            gradient: driver.avatarGradient,
            size: 58,
            radius: 18,
            fontSize: 20,
          ),
          const SizedBox(height: 10),
          Text('Rate ${driver.name}',
              style: AppTextStyles.bodyStrong.copyWith(fontSize: 16)),
          const SizedBox(height: 2),
          Text(AppStrings.howWasTrip, style: AppTextStyles.bodySm),
          const SizedBox(height: 14),
          BlocBuilder<BookingBloc, BookingState>(
            buildWhen: (a, b) => a.rating != b.rating,
            builder: (context, state) => StarRating(
              value: state.rating,
              onChanged: (v) => context.read<BookingBloc>().add(BookingRatingChanged(v)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipChip extends StatelessWidget {
  const _TipChip({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.peach : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: 1.5,
            ),
          ),
          child: Text(
            value == 0 ? 'No tip' : 'EGP $value',
            style: AppTextStyles.bodySm.copyWith(
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.primaryDark : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
