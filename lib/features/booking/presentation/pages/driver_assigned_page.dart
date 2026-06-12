import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_avatar.dart';
import '../../../../core/widgets/map/map_view.dart';
import '../../../../core/widgets/painters/car_side_illustration.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/rating.dart';
import '../bloc/booking_bloc.dart';
import '../utils/driver_presentation.dart';
import '../widgets/contact_action_button.dart';
import '../widgets/sheet_handle.dart';

/// "Driver assigned": the matched driver's details with contact actions.
class DriverAssignedPage extends StatelessWidget {
  const DriverAssignedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final driver = state.selectedDriver;
          if (driver == null) return const SizedBox.shrink();

          return Stack(
            children: [
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 300,
                child: MapView(variant: MapVariant.route),
              ),
              Positioned(
                top: 0,
                left: 18,
                right: 18,
                child: SafeArea(
                  bottom: false,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '${driver.firstName} is arriving in ${driver.etaMinutes} min',
                        style: AppTextStyles.bodySm.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 278,
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
                      Row(
                        children: [
                          SizedBox(
                            width: 62,
                            height: 62,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                GradientAvatar(
                                  initials: driver.initials,
                                  gradient: driver.avatarGradient,
                                  size: 62,
                                  radius: 20,
                                  fontSize: 22,
                                ),
                                Positioned(
                                  bottom: -5,
                                  right: -5,
                                  child: RatingPill(rating: driver.rating),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(driver.name,
                                    style: AppTextStyles.titleSm),
                                Text('${driver.rides} rides · ${driver.tier}',
                                    style: AppTextStyles.bodySm.copyWith(
                                        color: AppColors.textTertiary,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 13),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(driver.car,
                                    style: AppTextStyles.caption
                                        .copyWith(fontSize: 12)),
                                const SizedBox(height: 2),
                                Text(driver.plate,
                                    style: AppTextStyles.bodyStrong),
                              ],
                            ),
                            const Spacer(),
                            CarSideIllustration(
                                bodyColor: driver.carColor, width: 110),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          ContactActionButton(
                            icon: Icons.call_rounded,
                            label: AppStrings.call,
                            filled: true,
                          ),
                          SizedBox(width: 10),
                          ContactActionButton(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: AppStrings.chat,
                          ),
                          SizedBox(width: 10),
                          ContactActionButton(
                            icon: Icons.share_outlined,
                            label: AppStrings.share,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      PrimaryButton(
                        label: AppStrings.trackYourRide,
                        color: AppColors.ink,
                        glow: false,
                        height: 54,
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRoutes.tracking),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => Navigator.popUntil(
                            context, ModalRoute.withName(AppRoutes.main)),
                        child: SizedBox(
                          height: 46,
                          child: Center(
                            child: Text(AppStrings.cancelRide,
                                style: AppTextStyles.listTitle
                                    .copyWith(color: AppColors.danger)),
                          ),
                        ),
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
