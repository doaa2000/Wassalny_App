import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// Loads and exposes the notification list, and lets the rider mark items
/// (or everything) as read.
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc(this._repository) : super(const NotificationsState()) {
    on<NotificationsRequested>(_onRequested);
    on<NotificationTapped>(_onTapped);
    on<NotificationsMarkAllRead>(_onMarkAllRead);
  }

  final NotificationsRepository _repository;

  Future<void> _onRequested(
      NotificationsRequested event, Emitter<NotificationsState> emit) async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    try {
      final items = await _repository.getNotifications();
      emit(state.copyWith(status: NotificationsStatus.ready, items: items));
    } catch (_) {
      emit(state.copyWith(
        status: NotificationsStatus.failure,
        error: 'تعذّر تحميل الإشعارات. حاولي مرة أخرى.',
      ));
    }
  }

  Future<void> _onTapped(
      NotificationTapped event, Emitter<NotificationsState> emit) async {
    // Optimistic: flip it to read locally right away, then persist.
    final updated = [
      for (final n in state.items)
        if (n.id == event.id) n.copyWith(unread: false) else n,
    ];
    emit(state.copyWith(items: updated));
    try {
      await _repository.markAsRead(event.id);
    } catch (_) {
      // Not worth surfacing an error for a background read-receipt — the
      // item just stays marked read locally until the next full reload.
    }
  }

  Future<void> _onMarkAllRead(
      NotificationsMarkAllRead event, Emitter<NotificationsState> emit) async {
    final updated = [for (final n in state.items) n.copyWith(unread: false)];
    emit(state.copyWith(items: updated));
    try {
      await _repository.markAllRead();
    } catch (_) {
      // Same as above — silent best-effort.
    }
  }
}
