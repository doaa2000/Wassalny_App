import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_strings.dart';
import 'core/di/app_dependencies.dart';
import 'core/localization/app_locale.dart';
import 'core/logging/logging.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() => runGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
      // Bring up logging first so everything below (including failures during
      // startup) is captured to file and console.
      await bootstrapLogging();
      appLogger.logInfo('App starting', feature: 'Bootstrap');

      // Restore the saved language before the first frame.
      await AppLocale.load();

      try {
        await SupabaseService.instance.initialize();
      } catch (e, s) {
        appLogger.logError('Supabase init failed', feature: 'Bootstrap', error: e, stackTrace: s);
      }

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );

      // Skip onboarding/login when a real session already exists so the login
      // screen never flashes for an already-signed-in rider.
      final bool loggedIn = SupabaseService.instance.hasRealSession;
      appLogger.logInfo('Start route: ${loggedIn ? 'main' : 'welcome'}',
          feature: 'Bootstrap');
      runApp(WassalnyApp(
        initialRoute: loggedIn ? AppRoutes.main : AppRoutes.welcome,
      ));
    });

class WassalnyApp extends StatelessWidget {
  const WassalnyApp({super.key, this.initialRoute = AppRoutes.welcome});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      // Rebuild the whole app (and flip RTL for Arabic) whenever the language
      // changes. Strings follow AppLocale via AppStrings getters.
      child: ValueListenableBuilder<Locale>(
        valueListenable: AppLocale.notifier,
        builder: (context, locale, _) => MaterialApp(
          // Rebuild the whole navigator (fresh routes that re-read AppStrings)
          // when the language changes. The blocs above — including the tab
          // state — live in AppDependencies, so the current tab is preserved.
          key: ValueKey<String>(locale.languageCode),
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: locale,
          supportedLocales: AppLocale.supported,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: initialRoute,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
