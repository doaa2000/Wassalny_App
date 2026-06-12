import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_buttons.dart';

/// Asks for location access before entering the app.
class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({super.key});

  void _goLogin(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.login);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              SizedBox(
                width: 170,
                height: 170,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.18),
                            AppColors.primary.withOpacity(0),
                          ],
                          stops: const [0, 0.7],
                        ),
                      ),
                    ),
                    Container(
                      width: 118,
                      height: 118,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFBBDCEC), width: 2),
                      ),
                    ),
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.7),
                            blurRadius: 34,
                            offset: const Offset(0, 18),
                            spreadRadius: -12,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.location_on,
                          color: Colors.white, size: 40),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(AppStrings.enableLocationTitle,
                  textAlign: TextAlign.center, style: AppTextStyles.h3),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  AppStrings.enableLocationSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(height: 1.55),
                ),
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                label: AppStrings.allowLocation,
                onPressed: () => _goLogin(context),
                leading: const Icon(Icons.my_location,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(height: 12),
              GhostButton(
                label: AppStrings.enterManually,
                onPressed: () => _goLogin(context),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
