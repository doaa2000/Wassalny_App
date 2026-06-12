import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../utils/app_shadows.dart';

/// A white rounded surface with the standard soft card shadow. The base
/// building block for the many list/section cards in the app.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = AppDimens.rCard,
    this.border,
    this.shadow = true,
    this.color = AppColors.surface,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final BoxBorder? border;
  final bool shadow;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: shadow ? AppShadows.card : null,
      ),
      child: child,
    );
  }
}
