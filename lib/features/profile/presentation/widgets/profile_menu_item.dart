import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A row in the profile settings list: an icon chip, a label and either a
/// trailing chevron, a value, or nothing (for destructive actions like logout).
class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.trailingValue,
    this.showChevron = true,
    this.destructive = false,
    this.showDivider = true,
    this.iconBg = AppColors.primary,
    this.iconColor = AppColors.primaryDark,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? trailingValue;
  final bool showChevron;
  final bool destructive;
  final bool showDivider;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final labelColor = destructive ? AppColors.danger : AppColors.ink;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.divider))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 19, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: AppTextStyles.body.copyWith(
                      color: labelColor, fontWeight: FontWeight.w700)),
            ),
            if (trailingValue != null)
              Text(trailingValue!,
                  style: AppTextStyles.bodySm
                      .copyWith(color: AppColors.textTertiary)),
            if (showChevron && !destructive)
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(Icons.chevron_right_rounded,
                    size: 20, color: AppColors.chevron),
              ),
          ],
        ),
      ),
    );
  }
}
