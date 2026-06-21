import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/app_strings.dart';
import 'core/di/app_dependencies.dart';
import 'core/logging/logging.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';

void main() => runGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();

      // Bring up logging first so everything below (including failures during
      // startup) is captured to file and console.
      await bootstrapLogging();
      appLogger.logInfo('App starting', feature: 'Bootstrap');

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
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: initialRoute,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
