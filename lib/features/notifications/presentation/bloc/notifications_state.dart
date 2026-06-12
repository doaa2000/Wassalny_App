part of 'notifications_bloc.dart';

/// Notifications screen state: the list of items to display.
class NotificationsState extends Equatable {
  const NotificationsState({this.items = const []});

  final List<AppNotification> items;

  @override
  List<Object?> get props => [items];
}
