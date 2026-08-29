import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_shadows.dart';

/// The primary call-to-action button used across the app — a solid, rounded
/// pill with an optional glow and leading/trailing icon.
///
/// Defaults match the terracotta brand button; pass [color] for the dark
/// variant (`#2B2420`) seen on "Track your ride" / "Complete trip".
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.primary,
    this.foreground = AppColors.primaryDark,
    this.height = AppDimens.buttonHeight,
    this.leading,
    this.trailing,
    this.glow = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color foreground;
  final double height;
  final Widget? leading;
  final Widget? trailing;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppDimens.rLg),
            boxShadow: glow ? AppShadows.primaryGlow(color) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 8)],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.button.copyWith(color: foreground),
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
