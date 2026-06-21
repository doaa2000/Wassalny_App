import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/app_logger.dart';

/// Routes BLoC lifecycle into the logger. Errors are always captured; state
/// changes are logged at INFO only when [verbose] is on (keeps files small in
/// production).
class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this._logger, {this.verbose = false});

  final AppLogger _logger;
  final bool verbose;

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.logError(
      'Unhandled error in ${bloc.runtimeType}',
      feature: bloc.runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    if (verbose) {
      _logger.logInfo(
        '${change.currentState.runtimeType} -> ${change.nextState.runtimeType}',
        feature: bloc.runtimeType.toString(),
      );
    }
    super.onChange(bloc, change);
  }
}
