/// Centralised route names. Using constants avoids stringly-typed navigation
/// scattered across the app.
class AppRoutes {
  AppRoutes._();

  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String location = '/location';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String forgot = '/forgot';

  // Main tabbed shell (home / rides / wallet / alerts / profile).
  static const String main = '/main';

  // Booking flow (pushed full-screen over the shell).
  static const String search = '/search';
  static const String drivers = '/drivers';
  static const String confirm = '/confirm';
  static const String finding = '/finding';
  static const String assigned = '/assigned';
  static const String tracking = '/tracking';
  static const String completed = '/completed';
}
