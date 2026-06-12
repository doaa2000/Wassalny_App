import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/page_progress_dots.dart';
import '../../../../core/widgets/painters/car_mark_icon.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/preview_driver_card.dart';

/// Second onboarding screen showcasing the "compare drivers" value prop.
class OnboardingIntroPage extends StatelessWidget {
  const OnboardingIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 22, 0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                  child: Text(
                    AppStrings.skip,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [AppColors.peach, Color(0xFFF3DDC9)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      top: 40,
                      left: 24,
                      right: 24,
                      child: PreviewDriverCard(
                        initials: 'AH',
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ),
                        title: 'Ahmed · 4.9 ★',
                        subtitle: '3 min · EGP 86',
                        tag: 'Cheapest',
                        tagColor: AppColors.primaryDark,
                        tagBg: AppColors.peach,
                      ),
                    ),
                    Positioned(
                      top: 130,
                      left: 44,
                      right: 14,
                      child: Transform.rotate(
                        angle: 2 * 3.1415926 / 180,
                        child: const PreviewDriverCard(
                          initials: 'KE',
                          gradient: LinearGradient(
                            colors: [Color(0xFF0E9D9A), AppColors.teal],
                          ),
                          title: 'Karim · 4.95 ★',
                          subtitle: '7 min · EGP 232',
                          tag: 'Premium',
                          tagColor: AppColors.teal,
                          tagBg: AppColors.tealBg,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 34,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow.withOpacity(0.3),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                                spreadRadius: -16,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const CarMarkIcon(
                              size: 52, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 24, 30, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageProgressDots(count: 3, activeIndex: 1),
                  const SizedBox(height: 18),
                  Text(AppStrings.onboardingTitle,
                      style: AppTextStyles.h2.copyWith(fontSize: 27)),
                  const SizedBox(height: 10),
                  Text(AppStrings.onboardingSubtitle, style: AppTextStyles.body),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    label: AppStrings.continueLabel,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.location),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
