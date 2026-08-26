import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/new_password_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/booking/presentation/pages/confirm_ride_page.dart';
import '../../features/booking/presentation/pages/driver_assigned_page.dart';
import '../../features/booking/presentation/pages/finding_driver_page.dart';
import '../../features/booking/presentation/pages/search_page.dart';
import '../../features/booking/presentation/pages/trip_completed_page.dart';
import '../logging/presentation/log_viewer_page.dart';
import '../../features/onboarding/presentation/pages/location_permission_page.dart';
import '../../features/profile/presentation/pages/about_us_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_intro_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/places/presentation/pages/saved_places_page.dart';
import '../../features/profile/presentation/pages/personal_info_page.dart';
import '../../features/shell/presentation/main_shell.dart';
import '../services/supabase_service.dart';
import 'app_routes.dart';

/// Maps route names to pages. A single generator keeps navigation declarative
/// and makes the app flow easy to follow.
class AppRouter {
  AppRouter._();

  /// Routes reachable with no session at all — everything else redirects to
  /// [AppRoutes.welcome] if the app somehow has zero session (this should be
  /// rare since bootstrap always establishes at least an anonymous one when
  /// Supabase is configured, but guards against reaching a protected route
  /// before that finishes, or with Supabase unreachable).
  static const Set<String> _publicRoutes = {
    AppRoutes.welcome,
    AppRoutes.onboarding,
    AppRoutes.location,
    AppRoutes.login,
    AppRoutes.signup,
    AppRoutes.otp,
    AppRoutes.forgot,
    AppRoutes.newPassword,
    AppRoutes.about,
    AppRoutes.logs,
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String? name = settings.name;

    // Guest checkout is intentional (an anonymous session still counts), so
    // this only blocks the case of literally no session existing yet.
    final bool needsGuard = name != null &&
        !_publicRoutes.contains(name) &&
        SupabaseService.instance.isConfigured &&
        !SupabaseService.instance.hasAnySession;

    final RouteSettings effectiveSettings =
        needsGuard ? const RouteSettings(name: AppRoutes.welcome) : settings;

    final builder = _builderFor(effectiveSettings);
    return MaterialPageRoute(builder: builder, settings: effectiveSettings);
  }

  static WidgetBuilder _builderFor(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return (_) => const OnboardingIntroPage();
      case AppRoutes.location:
        return (_) => const LocationPermissionPage();
      case AppRoutes.login:
        return (_) => const LoginPage();
      case AppRoutes.signup:
        return (_) => const SignupPage();
      case AppRoutes.otp:
        final String email = (settings.arguments as String?) ?? '';
        return (_) => OtpPage(email: email);
      case AppRoutes.forgot:
        return (_) => const ForgotPasswordPage();
      case AppRoutes.newPassword:
        return (_) => const NewPasswordPage();
      case AppRoutes.main:
        return (_) => const MainShell();
      case AppRoutes.search:
        return (_) => const SearchPage();
      case AppRoutes.confirm:
        return (_) => const ConfirmRidePage();
      case AppRoutes.finding:
        return (_) => const FindingDriverPage();
      case AppRoutes.assigned:
        return (_) => const DriverAssignedPage();
      case AppRoutes.completed:
        return (_) => const TripCompletedPage();
      case AppRoutes.logs:
        return (_) => const LogViewerPage();
      case AppRoutes.about:
        return (_) => const AboutUsPage();
      case AppRoutes.savedPlaces:
        return (_) => const SavedPlacesPage();
      case AppRoutes.personalInfo:
        return (_) => const PersonalInfoPage();
      case AppRoutes.welcome:
      default:
        return (_) => const WelcomePage();
    }
  }
}
