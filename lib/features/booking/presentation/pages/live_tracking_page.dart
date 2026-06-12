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
import '../bloc/booking_bloc.dart';
import '../utils/driver_presentation.dart';
import '../widgets/sheet_handle.dart';

/// Live trip tracking: the driving map plus an ETA banner, SOS button and a
/// trip-progress sheet.
class LiveTrackingPage extends StatelessWidget {
  const LiveTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8ECEF),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final driver = state.selectedDriver;
          if (driver == null) return const SizedBox.shrink();

          return Stack(
            children: [
              const Positioned.fill(
                child: MapView(variant: MapVariant.tracking),
              ),
              Positioned(
                top: 0,
                left: 18,
                right: 18,
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      Expanded(child: _ArrivingCard()),
                      const SizedBox(width: 10),
                      _SosButton(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(26)),
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
                      children: [
                        const SheetHandle(),
                        const _ProgressBar(),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            GradientAvatar(
                              initials: driver.initials,
                              gradient: driver.avatarGradient,
                              size: 52,
                              radius: 16,
                              fontSize: 18,
                            ),
                            const SizedBox(width: 13),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(driver.name,
                                      style: AppTextStyles.listTitle
                                          .copyWith(fontSize: 15.5)),
                                  Text('${driver.car} · ${driver.plate}',
                                      style: AppTextStyles.caption),
                                ],
                              ),
                            ),
                            const RoundIconButton(
                              icon: Icons.call_rounded,
                              size: 46,
                              radius: 14,
                              background: AppColors.primary,
                              iconColor: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            RoundIconButton(
                              icon: Icons.chat_bubble_outline_rounded,
                              size: 46,
                              radius: 14,
                              background: AppColors.surface,
                              iconColor: AppColors.primary,
                              border: Border.all(
                                  color: AppColors.border, width: 1.5),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          label: AppStrings.completeTripDemo,
                          color: AppColors.ink,
                          glow: false,
                          height: 54,
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, AppRoutes.completed),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
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

class _ArrivingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.35),
            blurRadius: 26,
            offset: const Offset(0, 10),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppStrings.arrivingIn,
                  style: AppTextStyles.caption.copyWith(fontSize: 11.5)),
              Text(AppStrings.arrivingValue,
                  style: AppTextStyles.bodyStrong.copyWith(fontSize: 17)),
            ],
          ),
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.peach,
            ),
            child: const Icon(Icons.navigation_rounded,
                size: 20, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.danger,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.danger.withOpacity(0.6),
            blurRadius: 24,
            offset: const Offset(0, 10),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Text(AppStrings.sos,
          style: AppTextStyles.micro
              .copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _seg(1),
        _seg(1),
        _seg(0.55),
        _seg(0),
      ],
    );
  }

  Widget _seg(double fill) {
    return Expanded(
      child: Container(
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            stops: [fill, fill],
            colors: const [AppColors.primary, Color(0xFFE5DACB)],
          ),
        ),
      ),
    );
  }
}
