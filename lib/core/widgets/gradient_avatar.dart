import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A rounded-square avatar filled with a gradient and the person's initials.
/// Driver and rider avatars across the app use this.
class GradientAvatar extends StatelessWidget {
  const GradientAvatar({
    super.key,
    required this.initials,
    required this.gradient,
    this.size = 42,
    this.radius = 14,
    this.fontSize = 15,
  });

  final String initials;
  final Gradient gradient;
  final double size;
  final double radius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        initials,
        style: AppTextStyles.bodyStrong.copyWith(
          color: AppColors.onPrimary,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
