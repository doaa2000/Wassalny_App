part of 'notifications_bloc.dart';

enum NotificationsStatus { initial, loading, ready, failure }

/// Notifications screen state: the list of items to display.
class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.items = const [],
    this.error,
  });

  final NotificationsStatus status;
  final List<AppNotification> items;
  final String? error;

  /// Count of unread items — drives the badge on the bottom-nav icon.
  int get unreadCount => items.where((n) => n.unread).length;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? items,
    String? error,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, error];
}
