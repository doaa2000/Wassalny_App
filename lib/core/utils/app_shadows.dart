import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Reusable shadow recipes pulled from the design's `box-shadow` values.
///
/// The design leans on soft, downward, low-opacity shadows in the cool ink
/// colour; these helpers keep that consistent across cards, sheets and floating
/// controls.
class AppShadows {
  AppShadows._();

  /// Soft elevation for small floating controls (search bar, map buttons).
  static List<BoxShadow> get floating => [
        BoxShadow(
          color: AppColors.shadow.withOpacity(0.18),
          blurRadius: 22,
          offset: const Offset(0, 8),
          spreadRadius: -8,
        ),
      ];

  /// Subtle card lift used by list cards.
  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.shadow.withOpacity(0.16),
          blurRadius: 26,
          offset: const Offset(0, 10),
          spreadRadius: -20,
        ),
      ];

  /// Upward shadow for bottom sheets that sit above content.
  static List<BoxShadow> get sheet => [
        BoxShadow(
          color: AppColors.shadow.withOpacity(0.16),
          blurRadius: 40,
          offset: const Offset(0, -12),
        ),
      ];

  /// Glow under the primary call-to-action button.
  static List<BoxShadow> primaryGlow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.55),
          blurRadius: 26,
          offset: const Offset(0, 14),
          spreadRadius: -8,
        ),
      ];
}
