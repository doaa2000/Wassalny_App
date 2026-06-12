import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A white outlined social-login button (Google / Apple) with a small glyph.
class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.label,
    required this.glyph,
    this.onPressed,
  });

  final String label;
  final Widget glyph;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            glyph,
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.listTitle),
          ],
        ),
      ),
    );
  }
}

/// A simple coloured circle stand-in for a brand glyph (keeps the app free of
/// external logo assets while matching the design's footprint).
class BrandGlyph extends StatelessWidget {
  const BrandGlyph({super.key, required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Icon(icon, size: 18, color: color);
}
