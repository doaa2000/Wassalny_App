import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'app_text_styles.dart';

/// Builds the global [ThemeData] for Wassalny.
///
/// The design is a single light theme built on the cream canvas and terracotta
/// brand colour, so the app exposes one [theme].
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      primaryColor: AppColors.primary,
      textTheme: base.textTheme.apply(
        fontFamily: AppTextStyles.fontFamily,
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      splashColor: AppColors.primary.withOpacity(0.06),
      highlightColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
