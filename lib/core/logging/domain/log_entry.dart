import 'log_level.dart';

/// A single structured log record. Pure domain model — no IO, no Flutter.
///
/// The on-disk representation is produced by [format] so the storage layer
/// stays dumb (it only appends strings).
class LogEntry {
  LogEntry({
    required this.level,
    required this.feature,
    required this.message,
    this.error,
    this.stackTrace,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// When the event happened (local time).
  final DateTime timestamp;

  /// Severity.
  final LogLevel level;

  /// The area of the app that produced it, e.g. `Booking`, `Auth`, `Dio`.
  final String feature;

  /// Human-readable description.
  final String message;

  /// Optional originating error/exception object.
  final Object? error;

  /// Optional stack trace captured at the failure site.
  final StackTrace? stackTrace;

  /// One-line header used for both console and file output.
  String get header =>
      '${timestamp.toIso8601String()} [${level.label}] [$feature] $message'
      '${error != null ? ' | $error' : ''}';

  /// Full multi-line representation written to the log file.
  String format() {
    final buffer = StringBuffer(header);
    if (stackTrace != null) {
      buffer
        ..writeln()
        ..write(stackTrace);
    }
    return buffer.toString();
  }
}
