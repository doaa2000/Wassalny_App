/// Spacing, radius and sizing tokens.
///
/// The design uses a fairly tight rhythm; these constants keep that rhythm
/// consistent and remove "magic numbers" from widget code.
class AppDimens {
  AppDimens._();

  // ---- Spacing scale ----
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s10 = 10;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s22 = 22;
  static const double s24 = 24;
  static const double s26 = 26;
  static const double s30 = 30;
  static const double s36 = 36;

  // ---- Corner radii ----
  static const double rChip = 9;
  static const double rSm = 12;
  static const double rMd = 15;
  static const double rLg = 18;
  static const double rXl = 22;
  static const double rCard = 20;
  static const double rSheet = 26;
  static const double rSheetTall = 30;

  // ---- Standard component sizes ----
  static const double buttonHeight = 58;
  static const double buttonHeightSm = 54;
  static const double inputHeight = 54;
  static const double iconButton = 42;

  // ---- Screen padding ----
  static const double screenH = 20; // default horizontal page padding
  static const double bottomNavSafe = 110; // bottom padding when nav is present
}
