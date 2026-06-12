import 'package:equatable/equatable.dart';

/// Visual kind of a notification — drives the icon + colour in the UI.
enum NotificationKind { rideComplete, promo, topUp, onTime }

/// Time grouping for the notifications list.
enum NotificationSection { today, earlier }

class AppNotification extends Equatable {
  const AppNotification({
    required this.kind,
    required this.section,
    required this.title,
    required this.body,
    this.unread = false,
  });

  final NotificationKind kind;
  final NotificationSection section;
  final String title;
  final String body;
  final bool unread;

  @override
  List<Object?> get props => [kind, section, title, body, unread];
}
