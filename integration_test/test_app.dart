import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wassalny/core/constants/app_strings.dart';
import 'package:wassalny/core/di/app_dependencies.dart';
import 'package:wassalny/core/localization/app_locale.dart';
import 'package:wassalny/core/logging/logging.dart';
import 'package:wassalny/core/navigation/app_navigator.dart';
import 'package:wassalny/core/router/app_router.dart';
import 'package:wassalny/core/router/app_routes.dart';
import 'package:wassalny/core/services/supabase_service.dart';
import 'package:wassalny/core/theme/app_theme.dart';
import 'package:wassalny/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wassalny/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:wassalny/firebase_options.dart';
import 'package:wassalny/main.dart' show WassalnyApp;

/// نسخة من bootstrap بتاع main() بس بحماية أكبر للأخطاء، مخصصة للتيست فقط.
Future<void> testMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase محمي دلوقتي - لو فشل، التيست يكمل من غيره
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e, s) {
    debugPrint('Firebase init failed in test env: $e');
  }

  await bootstrapLogging();
  await AppLocale.load();

  try {
    await SupabaseService.instance.initialize();
  } catch (e, s) {
    debugPrint('Supabase init failed in test env: $e');
  }

  final bool loggedIn = SupabaseService.instance.hasRealSession;

  runApp(WassalnyApp(
    initialRoute: loggedIn ? AppRoutes.main : AppRoutes.welcome,
  ));
}