import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../../../../core/widgets/secondary_buttons.dart';

/// Password reset request screen.
class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 12, 26, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundIconButton.back(onPressed: () => Navigator.pop(context)),
              const SizedBox(height: 24),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.peach,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.lock_reset_rounded,
                    color: AppColors.primary, size: 30),
              ),
              const SizedBox(height: 20),
              Text(AppStrings.forgotTitle, style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text(AppStrings.forgotSubtitle, style: AppTextStyles.body),
              const SizedBox(height: 26),
              const AppTextField(
                label: AppStrings.emailAddress,
                icon: Icon(Icons.mail_outline_rounded,
                    size: 19, color: AppColors.textFaint),
                initialValue: 'layla.m@gmail.com',
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: AppStrings.sendResetCode,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.otp),
              ),
              const SizedBox(height: 12),
              GhostButton(
                label: AppStrings.backToLogin,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
