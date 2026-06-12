import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/app_shadows.dart';

/// A square, rounded icon button used throughout the app: back buttons,
/// map controls, and the call / chat / share actions.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 42,
    this.radius = 13,
    this.background = AppColors.background,
    this.iconColor = AppColors.ink,
    this.iconSize = 20,
    this.border,
    this.shadow = false,
  });

  /// Convenience constructor for the standard cream back button.
  const RoundIconButton.back({
    super.key,
    this.onPressed,
    this.size = 42,
    this.radius = 13,
  })  : icon = Icons.chevron_left_rounded,
        background = AppColors.background,
        iconColor = AppColors.ink,
        iconSize = 24,
        border = null,
        shadow = false;

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double radius;
  final Color background;
  final Color iconColor;
  final double iconSize;
  final BoxBorder? border;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius),
          border: border,
          boxShadow: shadow ? AppShadows.floating : null,
        ),
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }
}
