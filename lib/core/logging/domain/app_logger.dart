/// Application-wide logging contract. The presentation/data layers depend on
/// this abstraction, never on the concrete file-backed implementation.
///
/// `feature` groups entries by area of the app (e.g. `Booking`, `Auth`). When
/// omitted the implementation falls back to a generic tag.
abstract class AppLogger {
  /// Informational breadcrumb (navigation, lifecycle, successful calls).
  void logInfo(String message, {String feature, Object? error, StackTrace? stackTrace});

  /// Recoverable problem or suspicious state.
  void logWarning(String message, {String feature, Object? error, StackTrace? stackTrace});

  /// A failure: exception, API/Dio error, crash, BLoC error, framework error.
  void logError(String message, {String feature, Object? error, StackTrace? stackTrace});
}
