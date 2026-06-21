/// Public surface of the logging module. Import this single file:
///
/// ```dart
/// import 'package:wassalny/core/logging/logging.dart';
///
/// appLogger.logError('Trip request failed', feature: 'Booking', error: e, stackTrace: s);
/// ```
library;

import 'app_logger_impl.dart';
import 'domain/app_logger.dart';

export 'app_logger_impl.dart';
export 'domain/app_logger.dart';
export 'domain/log_entry.dart';
export 'domain/log_level.dart';
export 'logging_bootstrap.dart';
export 'network/dio_logging_interceptor.dart';
export 'observers/app_bloc_observer.dart';

/// Process-wide logger. Available after `bootstrapLogging()` runs in `main`.
AppLogger get appLogger => AppLoggerImpl.instance;
