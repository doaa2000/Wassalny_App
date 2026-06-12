import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';
import '../widgets/auth_footer_prompt.dart';
import '../widgets/social_button.dart';

/// Email / phone login screen.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _login(BuildContext context) => Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.main,
        (route) => false,
      );

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
              Text(AppStrings.welcomeBack, style: AppTextStyles.h1),
              const SizedBox(height: 6),
              Text(AppStrings.loginSubtitle, style: AppTextStyles.body),
              const SizedBox(height: 26),
              const AppTextField(
                label: AppStrings.emailOrPhone,
                icon: Icon(Icons.mail_outline_rounded,
                    size: 19, color: AppColors.textFaint),
                initialValue: 'layla.m@gmail.com',
              ),
              const SizedBox(height: 16),
              const AppTextField(
                label: AppStrings.password,
                icon: Icon(Icons.lock_outline_rounded,
                    size: 19, color: AppColors.textFaint),
                initialValue: 'password',
                obscure: true,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.forgot),
                  child: Text(
                    AppStrings.forgotPassword,
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              PrimaryButton(
                label: AppStrings.login,
                onPressed: () => _login(context),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(AppStrings.orContinueWith,
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textFaint)),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 22),
              const Row(
                children: [
                  Expanded(
                    child: SocialButton(
                      label: AppStrings.google,
                      glyph: BrandGlyph(
                          icon: Icons.g_mobiledata_rounded,
                          color: Color(0xFF4285F4)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: SocialButton(
                      label: AppStrings.apple,
                      glyph: BrandGlyph(
                          icon: Icons.apple, color: AppColors.ink),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: AuthFooterPrompt(
                  prompt: AppStrings.newToWassalny,
                  action: AppStrings.createAccount,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
