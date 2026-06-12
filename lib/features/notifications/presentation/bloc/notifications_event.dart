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
