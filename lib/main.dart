import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_strings.dart';
import 'core/di/app_dependencies.dart';
import 'core/localization/app_locale.dart';
import 'core/logging/logging.dart';
import 'core/navigation/app_navigator.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/services/push_notifications_service.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';


void main() => runGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
      // Must be registered before runApp, and the handler must stay a
      // top-level function (it runs in its own isolate).
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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

      // Best-effort — failures here shouldn't block startup, they just mean
      // no push notifications this session.
      await PushNotificationsService.instance.init();

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
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prev, curr) =>
            curr.user != null && prev.user?.id != curr.user?.id,
        listener: (context, state) {
          PushNotificationsService.instance.registerDeviceToken(state.user!.id);
          context.read<NotificationsBloc>().add(const NotificationsRequested());
        },
        child: ValueListenableBuilder<Locale>(
          valueListenable: AppLocale.notifier,
          builder: (context, locale, _) => MaterialApp(
            // Rebuild the whole navigator (fresh routes that re-read AppStrings)
            // when the language changes. The blocs above — including the tab
            // state — live in AppDependencies, so the current tab is preserved.
            key: ValueKey<String>(locale.languageCode),
            navigatorKey: navigatorKey,
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
      ),
    );
  }
}
