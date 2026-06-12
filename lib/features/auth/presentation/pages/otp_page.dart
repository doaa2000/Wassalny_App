import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/round_icon_button.dart';

/// 4-digit phone verification screen.
class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  static const _digits = ['5', '8', '2', ''];

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
                child: const Icon(Icons.dialpad_rounded,
                    color: AppColors.primary, size: 30),
              ),
              const SizedBox(height: 20),
              Text(AppStrings.verifyNumberTitle, style: AppTextStyles.h2),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: '${AppStrings.verifyNumberSubtitle}\n',
                  style: AppTextStyles.body,
                  children: [
                    TextSpan(
                      text: AppStrings.demoPhone,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  for (var i = 0; i < _digits.length; i++) ...[
                    _OtpBox(digit: _digits[i], active: i == 0),
                    if (i != _digits.length - 1) const SizedBox(width: 14),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  text: AppStrings.didntGetCode,
                  style: AppTextStyles.bodySm,
                  children: [
                    TextSpan(
                      text: AppStrings.resendIn,
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.textFaint,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: AppStrings.verify,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.main,
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({required this.digit, required this.active});

  final String digit;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 64 / 70,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.peach : AppColors.background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: active ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
          child: Text(
            digit,
            style: AppTextStyles.h2.copyWith(fontSize: 28),
          ),
        ),
      ),
    );
  }
}
