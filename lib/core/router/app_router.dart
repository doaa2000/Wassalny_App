import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/booking/presentation/pages/confirm_ride_page.dart';
import '../../features/booking/presentation/pages/driver_assigned_page.dart';
import '../../features/booking/presentation/pages/driver_select_page.dart';
import '../../features/booking/presentation/pages/finding_driver_page.dart';
import '../../features/booking/presentation/pages/live_tracking_page.dart';
import '../../features/booking/presentation/pages/search_page.dart';
import '../../features/booking/presentation/pages/trip_completed_page.dart';
import '../logging/presentation/log_viewer_page.dart';
import '../../features/onboarding/presentation/pages/location_permission_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_intro_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/places/data/datasources/places_remote_data_source.dart';
import '../../features/places/data/repositories/places_repository_impl.dart';
import '../../features/places/presentation/bloc/places_bloc.dart';
import '../../features/places/presentation/pages/saved_places_page.dart';
import '../../features/shell/presentation/main_shell.dart';
import '../services/supabase_service.dart';
import 'app_routes.dart';

/// Maps route names to pages. A single generator keeps navigation declarative
/// and makes the app flow easy to follow.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = _builderFor(settings.name);
    return MaterialPageRoute(builder: builder, settings: settings);
  }

  static WidgetBuilder _builderFor(String? name) {
    switch (name) {
      case AppRoutes.onboarding:
        return (_) => const OnboardingIntroPage();
      case AppRoutes.location:
        return (_) => const LocationPermissionPage();
      case AppRoutes.login:
        return (_) => const LoginPage();
      case AppRoutes.signup:
        return (_) => const SignupPage();
      case AppRoutes.otp:
        return (_) => const OtpPage();
      case AppRoutes.forgot:
        return (_) => const ForgotPasswordPage();
      case AppRoutes.main:
        return (_) => const MainShell();
      case AppRoutes.search:
        return (_) => const SearchPage();
      case AppRoutes.drivers:
        return (_) => const DriverSelectPage();
      case AppRoutes.confirm:
        return (_) => const ConfirmRidePage();
      case AppRoutes.finding:
        return (_) => const FindingDriverPage();
      case AppRoutes.assigned:
        return (_) => const DriverAssignedPage();
      case AppRoutes.tracking:
        return (_) => const LiveTrackingPage();
      case AppRoutes.completed:
        return (_) => const TripCompletedPage();
      case AppRoutes.logs:
        return (_) => const LogViewerPage();
      case AppRoutes.savedPlaces:
        return (_) => BlocProvider(
              create: (_) => PlacesBloc(
                PlacesRepositoryImpl(
                  PlacesRemoteDataSource(SupabaseService.instance),
                ),
              )..add(const PlacesLoaded()),
              child: const SavedPlacesPage(),
            );
      case AppRoutes.welcome:
      default:
        return (_) => const WelcomePage();
    }
  }
}
