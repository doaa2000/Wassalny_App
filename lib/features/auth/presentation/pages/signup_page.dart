import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../widgets/auth_footer_prompt.dart';
import '../widgets/phone_prefix.dart';

/// Account creation screen.
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 12, 26, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundIconButton.back(onPressed: () => Navigator.pop(context)),
              const SizedBox(height: 22),
              Text(AppStrings.createAccount, style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text(AppStrings.signupSubtitle, style: AppTextStyles.body),
              const SizedBox(height: 24),
              const AppTextField(
                label: AppStrings.fullName,
                initialValue: 'Layla Mansour',
              ),
              const SizedBox(height: 16),
              const AppTextField(
                label: AppStrings.phoneNumber,
                prefix: PhonePrefix(),
                initialValue: '100 234 5678',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              const AppTextField(
                label: AppStrings.password,
                initialValue: 'password',
                obscure: true,
              ),
              const SizedBox(height: 18),
              const _TermsRow(),
              const SizedBox(height: 22),
              PrimaryButton(
                label: AppStrings.createAccount,
                onPressed: () => Navigator.pushNamed(context, AppRoutes.otp),
              ),
              const SizedBox(height: 18),
              Center(
                child: AuthFooterPrompt(
                  prompt: AppStrings.alreadyHaveAccount,
                  action: AppStrings.login,
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          margin: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: AppStrings.agreePrefix,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12.5,
                height: 1.5,
              ),
              children: [
                _link(AppStrings.termsOfService),
                const TextSpan(text: AppStrings.and),
                _link(AppStrings.privacyPolicy),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextSpan _link(String text) => TextSpan(
        text: text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      );
}
