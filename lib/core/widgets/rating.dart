import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_shadows.dart';

/// A small white badge showing a star and rating value, designed to overlap the
/// bottom-right corner of a driver avatar.
class RatingPill extends StatelessWidget {
  const RatingPill({super.key, required this.rating, this.fontSize = 10.5});

  final String rating;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: AppShadows.floating,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 12, color: AppColors.gold),
          const SizedBox(width: 2),
          Text(
            rating,
            style: AppTextStyles.micro.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive five-star rating row used on the "Trip completed" screen.
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 36,
    this.spacing = 10,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final double size;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final n = i + 1;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: GestureDetector(
            onTap: () => onChanged(n),
            child: Icon(
              Icons.star_rounded,
              size: size,
              color: n <= value ? AppColors.gold : AppColors.border,
            ),
          ),
        );
      }),
    );
  }
}
