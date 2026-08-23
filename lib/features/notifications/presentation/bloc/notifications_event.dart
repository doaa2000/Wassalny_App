part of 'notifications_bloc.dart';

/// Base type for all notification events.
sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// Load the notification list.
final class NotificationsRequested extends NotificationsEvent {
  const NotificationsRequested();
}

/// The rider tapped a notification — mark it as read.
final class NotificationTapped extends NotificationsEvent {
  const NotificationTapped(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// The rider tapped "Mark all read".
final class NotificationsMarkAllRead extends NotificationsEvent {
  const NotificationsMarkAllRead();
}
