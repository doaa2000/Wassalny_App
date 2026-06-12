import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// A labelled input field matching the design: a small bold label above a
/// cream rounded container with an optional leading icon.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.icon,
    this.prefix,
    this.initialValue,
    this.hintText,
    this.obscure = false,
    this.keyboardType,
    this.controller,
    this.highlighted = false,
    this.fontWeight = FontWeight.w600,
  });

  final String? label;
  final Widget? icon;
  final Widget? prefix;
  final String? initialValue;
  final String? hintText;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  /// When true the field gets the active terracotta border + peach fill used
  /// for the focused "drop-off" input on the search screen.
  final bool highlighted;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    final field = Container(
      height: AppDimens.inputHeight,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.peach : AppColors.background,
        borderRadius: BorderRadius.circular(AppDimens.rMd),
        border: highlighted
            ? Border.all(color: AppColors.primary, width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 10)],
          if (prefix != null) ...[prefix!, const SizedBox(width: 10)],
          Expanded(
            child: TextField(
              controller: controller ??
                  (initialValue != null
                      ? TextEditingController(text: initialValue)
                      : null),
              obscureText: obscure,
              keyboardType: keyboardType,
              cursorColor: AppColors.primary,
              style: AppTextStyles.input.copyWith(fontWeight: fontWeight),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: AppTextStyles.input.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!, style: AppTextStyles.label),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}
