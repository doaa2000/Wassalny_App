import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_logger_impl.dart';
import 'data/file_log_storage.dart';
import 'observers/app_bloc_observer.dart';

/// One-call setup for the whole logging system. Wires:
///   * the file-backed [AppLoggerImpl] singleton,
///   * `FlutterError.onError`        → framework errors,
///   * `PlatformDispatcher.onError`  → uncaught async/platform errors,
///   * `Bloc.observer`               → BLoC errors.
///
/// Call it before `runApp` (inside the same `runZonedGuarded` zone — see
/// [runGuarded]) so startup failures are captured too.
Future<AppLoggerImpl> bootstrapLogging({bool verboseBloc = false}) async {
  final AppLoggerImpl logger = await AppLoggerImpl.bootstrap(FileLogStorage());

  // 1. Flutter framework / widget build errors.
  final FlutterExceptionHandler? previousOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.logError(
      details.summary.toString(),
      feature: details.library ?? 'Flutter',
      error: details.exception,
      stackTrace: details.stack,
    );
    if (previousOnError != null) {
      previousOnError(details);
    } else {
      FlutterError.presentError(details);
    }
  };

  // 2. Uncaught errors outside the Flutter framework (async gaps, platform).
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    logger.logError(
      'Uncaught platform error',
      feature: 'Platform',
      error: error,
      stackTrace: stack,
    );
    return true; // handled — don't crash the isolate.
  };

  // 3. Every BLoC/Cubit error in the app.
  Bloc.observer = AppBlocObserver(logger, verbose: verboseBloc);

  return logger;
}

/// Runs [body] inside a guarded zone so even synchronous startup crashes and
/// stray async errors reach the logger. Use as the entry point of `main`.
void runGuarded(FutureOr<void> Function() body) {
  runZonedGuarded<Future<void>>(
    () async => body(),
    (Object error, StackTrace stack) {
      if (AppLoggerImpl.isReady) {
        AppLoggerImpl.instance.logError(
          'Uncaught zone error',
          feature: 'Zone',
          error: error,
          stackTrace: stack,
        );
      } else {
        // Logger not up yet — last resort.
        debugPrint('Pre-logger crash: $error\n$stack');
      }
    },
  );
}
