import 'package:flutter/material.dart';

/// Central palette for the Wassalny app, extracted directly from the design.
///
/// Every colour used across the UI lives here so screens never hard-code hex
/// values. Names describe intent (primary / surface / danger) rather than the
/// literal colour.
class AppColors {
  AppColors._();

  // ---- Brand ----
  static const Color primary = Color(0xFFC45B2E); // terracotta
  static const Color primaryDark = Color(0xFF9A3F1C);
  static const Color primaryLight = Color(0xFFD9743F);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Soft brand surfaces used for icon chips, tags, pressed states.
  static const Color peach = Color(0xFFF7E7DC);
  static const Color peachAmber = Color(0xFFFBF1E1);

  // ---- Neutrals / text ----
  static const Color ink = Color(0xFF2B2420); // primary text
  static const Color textSecondary = Color(0xFF80736A);
  static const Color textTertiary = Color(0xFFA2958A);
  static const Color textFaint = Color(0xFFB0A498);
  static const Color chevron = Color(0xFFD2C7BB);
  static const Color disabled = Color(0xFFC7BCB0);

  // ---- Backgrounds / surfaces ----
  static const Color background = Color(0xFFF5EEE6); // cream canvas
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFEBE2D6);
  static const Color borderSoft = Color(0xFFECE3D7);
  static const Color divider = Color(0xFFF1E9DD);

  // ---- Status ----
  static const Color success = Color(0xFF22B07D);
  static const Color successDark = Color(0xFF179C6C);
  static const Color successBg = Color(0xFFE7F6EF);
  static const Color danger = Color(0xFFF0453A);
  static const Color dangerBg = Color(0xFFFDECEB);

  // ---- Accents ----
  static const Color gold = Color(0xFFF5B544); // stars
  static const Color goldText = Color(0xFFB9831F);
  static const Color teal = Color(0xFF0B7A78);
  static const Color tealBg = Color(0xFFDCF0EF);
  static const Color neutralTagBg = Color(0xFFF1F3F6);
  static const Color neutralTagText = Color(0xFF76838F);

  // ---- Phone chrome / misc ----
  static const Color phoneFrame = Color(0xFF1A1410);
  static const Color flagRed = Color(0xFFCE1126);

  // ---- Gradients ----
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient brandSweep = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary, primaryDark],
  );

  // Shared shadow colour (cool ink with low opacity).
  static const Color shadow = Color(0xFF0F1A24);
}
