import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/app_strings.dart';
import 'core/di/app_dependencies.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.instance.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const WassalnyApp());
}

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
