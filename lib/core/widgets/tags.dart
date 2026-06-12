import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';

/// A small coloured status/label pill (e.g. "Completed", "Recommended",
/// "Default", "Premium").
class StatusTag extends StatelessWidget {
  const StatusTag({
    super.key,
    required this.label,
    required this.color,
    required this.background,
    this.fontSize = 11,
  });

  final String label;
  final Color color;
  final Color background;
  final double fontSize;

  /// Green "Completed" tag.
  const StatusTag.completed(String label, {Key? key})
      : this(
          key: key,
          label: label,
          color: AppColors.successDark,
          background: AppColors.successBg,
        );

  /// Red "Cancelled" tag.
  const StatusTag.cancelled(String label, {Key? key})
      : this(
          key: key,
          label: label,
          color: AppColors.danger,
          background: AppColors.dangerBg,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// A selectable filter / tab chip. Switches between the filled terracotta
/// active state and the muted resting state.
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.restingColor = AppColors.background,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color restingColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : restingColor,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.onPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
