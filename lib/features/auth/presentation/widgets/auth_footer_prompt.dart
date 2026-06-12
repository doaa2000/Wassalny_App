import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Inline "prompt + link" used at the bottom of the auth screens
/// (e.g. "New to Wassalny? Create account").
class AuthFooterPrompt extends StatelessWidget {
  const AuthFooterPrompt({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: prompt,
          style: AppTextStyles.body.copyWith(fontSize: 14, height: 1.2),
          children: [
            TextSpan(
              text: action,
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
                height: 1.2,
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
