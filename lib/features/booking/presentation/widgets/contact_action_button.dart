import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A vertical icon + label action button used for Call / Chat / Share. The
/// primary (filled) variant is used for "Call".
class ContactActionButton extends StatelessWidget {
  const ContactActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.filled = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : AppColors.primary;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: filled ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: filled
                ? null
                : Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: fg),
              const SizedBox(height: 2),
              Text(label,
                  style: AppTextStyles.listTitle.copyWith(
                      color: filled ? Colors.white : AppColors.ink,
                      fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
