import 'package:equatable/equatable.dart';

/// Visual kind of a notification — drives the icon + colour in the UI.
enum NotificationKind { rideComplete, promo, topUp, onTime, general }

/// Time grouping for the notifications list.
enum NotificationSection { today, earlier }

class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.section,
    required this.title,
    required this.body,
    this.unread = false,
  });

  final String id;
  final NotificationKind kind;
  final NotificationSection section;
  final String title;
  final String body;
  final bool unread;

  AppNotification copyWith({bool? unread}) => AppNotification(
        id: id,
        kind: kind,
        section: section,
        title: title,
        body: body,
        unread: unread ?? this.unread,
      );

  @override
  List<Object?> get props => [id, kind, section, title, body, unread];
}
