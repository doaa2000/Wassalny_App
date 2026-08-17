import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// A flat text button (no background) for tertiary actions such as
/// "I already have an account" or "Back to login".
class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = AppColors.textSecondary,
    this.height = 50,
    this.fontSize = 14.5,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

/// An outlined button with a white fill, used for the social-login row and
/// secondary card actions ("Get receipt").
class OutlineActionButton extends StatelessWidget {
  const OutlineActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
    this.height = 52,
    this.foreground = AppColors.ink,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  final double height;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.rMd),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.listTitle.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A soft "peach" pill button used for inline secondary actions such as
/// "Rebook" and "Change".
class SoftButton extends StatelessWidget {
  const SoftButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 42,
    this.radius = AppDimens.rSm,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySm.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
