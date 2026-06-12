import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Typography scale for the app, all based on the Plus Jakarta Sans family used
/// in the design. Screens reference these named styles instead of building
/// [TextStyle]s inline.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'PlusJakartaSans';

  static const TextStyle _base = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.ink,
    height: 1.2,
  );

  /// 30 / 800 — hero headline (welcome screen).
  static final TextStyle display = _base.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.12,
  );

  /// 28 / 800 — auth screen titles.
  static final TextStyle h1 = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
  );

  /// 27 / 800 — secondary large titles (onboarding, otp, forgot).
  static final TextStyle h2 = _base.copyWith(
    fontSize: 27,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.15,
  );

  /// 24 / 800 — page titles (wallet, history, notifications).
  static final TextStyle h3 = _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  /// 20 / 800 — bottom-sheet titles.
  static final TextStyle title = _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
  );

  /// 18 / 800 — sub titles / app-bar headings.
  static final TextStyle titleSm = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
  );

  /// 16.5 / 700 — primary button label.
  static final TextStyle button = _base.copyWith(
    fontSize: 16.5,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
  );

  /// 16 / 800 — strong inline value.
  static final TextStyle bodyStrong = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  /// 15 / 600 — input text.
  static final TextStyle input = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  /// 14.5 / 600 — default body copy.
  static final TextStyle body = _base.copyWith(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// 14 / 700 — list item titles.
  static final TextStyle listTitle = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// 13.5 / 600 — small body.
  static final TextStyle bodySm = _base.copyWith(
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// 12.5 / 700 — field labels.
  static final TextStyle label = _base.copyWith(
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
  );

  /// 12 / 600 — captions / meta.
  static final TextStyle caption = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textTertiary,
  );

  /// 11.5 / 700 — micro meta.
  static final TextStyle micro = _base.copyWith(
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
  );

  /// 12.5 / 800 — uppercase section labels.
  static final TextStyle sectionLabel = _base.copyWith(
    fontSize: 12.5,
    fontWeight: FontWeight.w800,
    color: AppColors.textTertiary,
    letterSpacing: 0.4,
  );
}
