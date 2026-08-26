part of 'notifications_bloc.dart';

/// Base type for all notification events.
sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

/// Load the notification list once (no live updates after this).
final class NotificationsRequested extends NotificationsEvent {
  const NotificationsRequested();
}

/// Subscribe to the rider's notifications via Supabase Realtime — the list
/// updates instantly whenever a row is inserted/changed on the backend, no
/// manual reload needed. Re-dispatching this (e.g. after switching accounts)
/// cancels any previous subscription and starts a fresh one.
final class NotificationsSubscriptionRequested extends NotificationsEvent {
  const NotificationsSubscriptionRequested();
}

/// Internal: a new snapshot arrived from the realtime subscription.
final class _NotificationsStreamUpdated extends NotificationsEvent {
  const _NotificationsStreamUpdated(this.items);

  final List<AppNotification> items;

  @override
  List<Object?> get props => [items];
}

/// Internal: the realtime subscription errored out.
final class _NotificationsStreamFailed extends NotificationsEvent {
  const _NotificationsStreamFailed();
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
