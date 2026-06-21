import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported app languages and the globally-current locale.
///
/// The current locale is a process-wide [ValueNotifier] so the string table
/// ([AppStrings] via [AppTranslations]) can read it without a BuildContext,
/// while the app wraps `MaterialApp` in a listener to rebuild on change.
class AppLocale {
  AppLocale._();

  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');
  static const Locale spanish = Locale('es');

  static const List<Locale> supported = [english, arabic, spanish];

  /// Drives the whole app's locale. UI rebuilds when this changes.
  static final ValueNotifier<Locale> notifier = ValueNotifier<Locale>(english);

  /// Current language code ('en' | 'ar' | 'es') read by the string table.
  static String get lang => notifier.value.languageCode;

  static const String _prefsKey = 'app_locale';

  /// Loads the saved locale (call once at startup, before runApp).
  static Future<void> load() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? code = prefs.getString(_prefsKey);
      if (code != null) {
        notifier.value = supported.firstWhere(
          (l) => l.languageCode == code,
          orElse: () => english,
        );
      }
    } catch (_) {
      // Preferences unavailable — keep the default (English).
    }
  }

  /// Switches and persists the locale.
  static Future<void> set(Locale locale) async {
    if (notifier.value.languageCode == locale.languageCode) return;
    notifier.value = locale;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, locale.languageCode);
    } catch (_) {
      // Best-effort persistence.
    }
  }

  /// The language's own name, for the language picker.
  static String nativeName(String code) => switch (code) {
        'ar' => 'العربية',
        'es' => 'Español',
        _ => 'English',
      };
}
