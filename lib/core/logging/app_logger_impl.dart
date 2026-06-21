import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

import 'domain/app_logger.dart';
import 'domain/log_entry.dart';
import 'domain/log_level.dart';
import 'domain/log_storage.dart';

/// Default [AppLogger]: fans every entry out to two sinks —
///   1. the developer console (only in debug/profile, via `dart:developer`), and
///   2. a rotating file via [LogStorage] (always).
///
/// Exposed as a process-wide singleton ([instance]) because the global error
/// handlers (FlutterError, PlatformDispatcher) and the [BlocObserver] live
/// outside the widget tree and need to reach it without a BuildContext.
class AppLoggerImpl implements AppLogger {
  AppLoggerImpl(this._storage);

  final LogStorage _storage;

  static AppLoggerImpl? _instance;

  /// The bootstrapped singleton. Throws if accessed before [bootstrap].
  static AppLoggerImpl get instance {
    final AppLoggerImpl? i = _instance;
    if (i == null) {
      throw StateError('AppLogger used before bootstrap(). Call bootstrapLogging() in main().');
    }
    return i;
  }

  /// Whether the logger has been initialised.
  static bool get isReady => _instance != null;

  /// Creates the logger, initialises its storage and registers the singleton.
  static Future<AppLoggerImpl> bootstrap(LogStorage storage) async {
    final AppLoggerImpl logger = AppLoggerImpl(storage);
    await storage.init();
    _instance = logger;
    return logger;
  }

  @override
  void logInfo(String message,
          {String feature = 'App', Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.info, message, feature, error, stackTrace);

  @override
  void logWarning(String message,
          {String feature = 'App', Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.warning, message, feature, error, stackTrace);

  @override
  void logError(String message,
          {String feature = 'App', Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.error, message, feature, error, stackTrace);

  void _log(LogLevel level, String message, String feature, Object? error,
      StackTrace? stackTrace) {
    final LogEntry entry = LogEntry(
      level: level,
      feature: feature,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
    _toConsole(entry);
    // Fire-and-forget; FileLogStorage serializes and never throws.
    _storage.append(entry.format());
  }

  void _toConsole(LogEntry entry) {
    // Keep release builds quiet on the console; the file sink still records.
    if (kReleaseMode) return;
    developer.log(
      entry.header,
      name: 'Wassalny.${entry.feature}',
      level: _consoleLevel(entry.level),
      error: entry.error,
      stackTrace: entry.stackTrace,
    );
  }

  // dart:developer uses dart:logging numeric levels (INFO 800 / WARNING 900 /
  // SEVERE 1000).
  int _consoleLevel(LogLevel level) => switch (level) {
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      };

  // --- Export / sharing ------------------------------------------------------

  /// All retained log files, newest first.
  Future<List<File>> logFiles() => _storage.logFiles();

  /// The active log file (handy to read in a debug screen).
  Future<File?> currentLogFile() => _storage.currentFile();

  /// Opens the OS share sheet with every retained log file attached.
  Future<void> shareLogs() async {
    final List<File> files = await _storage.logFiles();
    if (files.isEmpty) return;
    await Share.shareXFiles(
      files.map((f) => XFile(f.path)).toList(),
      subject: 'Wassalny logs',
    );
  }
}
