import 'package:dio/dio.dart';

import '../domain/app_logger.dart';

/// Logs HTTP traffic and failures for any [Dio] instance it's attached to.
///
/// The Wassalny app talks to Supabase (which uses its own client), so this is
/// provided as a ready-to-use module: add it to any Dio instance with
/// `dio.interceptors.add(DioLoggingInterceptor(AppLoggerImpl.instance));`.
class DioLoggingInterceptor extends Interceptor {
  DioLoggingInterceptor(this._logger, {this.logRequests = true});

  final AppLogger _logger;

  /// Log successful requests/responses at INFO. Turn off to record only errors.
  final bool logRequests;

  static const String _feature = 'Dio';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequests) {
      _logger.logInfo('→ ${options.method} ${options.uri}', feature: _feature);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (logRequests) {
      _logger.logInfo(
        '← ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
        feature: _feature,
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final RequestOptions req = err.requestOptions;
    final int? status = err.response?.statusCode;
    _logger.logError(
      'API error ${status ?? ''} ${req.method} ${req.uri} (${err.type.name})',
      feature: _feature,
      error: err.response?.data ?? err.message ?? err,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }
}
