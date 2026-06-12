import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/tags.dart';

/// The small floating "driver preview" card used decoratively on the onboarding
/// screen (avatar + name + price + a coloured tag).
class PreviewDriverCard extends StatelessWidget {
  const PreviewDriverCard({
    super.key,
    required this.initials,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
  });

  final String initials;
  final Gradient gradient;
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final Color tagBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.3),
            blurRadius: 36,
            offset: const Offset(0, 18),
            spreadRadius: -18,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(initials,
                style: AppTextStyles.bodyStrong.copyWith(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.listTitle),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          StatusTag(label: tag, color: tagColor, background: tagBg),
        ],
      ),
    );
  }
}
