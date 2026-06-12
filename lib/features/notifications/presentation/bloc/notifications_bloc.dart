import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// Loads and exposes the notification list.
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc(this._repository) : super(const NotificationsState()) {
    on<NotificationsRequested>(_onRequested);
  }

  final NotificationsRepository _repository;

  void _onRequested(
      NotificationsRequested event, Emitter<NotificationsState> emit) {
    emit(NotificationsState(items: _repository.getNotifications()));
  }
}
