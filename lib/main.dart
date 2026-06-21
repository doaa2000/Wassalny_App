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
      runApp(const WassalnyApp());
    });

class WassalnyApp extends StatelessWidget {
  const WassalnyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.welcome,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
