import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/bobbing.dart';
import '../../../../core/widgets/page_progress_dots.dart';
import '../../../../core/widgets/painters/car_mark_icon.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_buttons.dart';

/// First screen: a bold brand splash with a "Get started" call to action.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [AppColors.primaryLight, AppColors.primary, AppColors.primaryDark],
                  stops: [0, 0.52, 1],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -60,
                    right: -50,
                    child: _circle(240, 0.12),
                  ),
                  Positioned(
                    top: 120,
                    left: -70,
                    child: _circle(180, 0.10),
                  ),
                  Center(
                    child: Bobbing(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(42),
                        ),
                        alignment: Alignment.center,
                        child: const CarMarkIcon(
                          size: 86,
                          color: Colors.white,
                          wheels: true,
                          wheelColor: AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
            ),
            padding: const EdgeInsets.fromLTRB(30, 36, 30, 30),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PageProgressDots(count: 3, activeIndex: 0),
                  const SizedBox(height: 22),
                  Text(AppStrings.welcomeTitle, style: AppTextStyles.display),
                  const SizedBox(height: 12),
                  Text(AppStrings.welcomeSubtitle, style: AppTextStyles.body),
                  const SizedBox(height: 26),
                  PrimaryButton(
                    label: AppStrings.getStarted,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.onboarding),
                    trailing: const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(height: 12),
                  GhostButton(
                    label: AppStrings.haveAccount,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.login),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
        ),
      );
}
