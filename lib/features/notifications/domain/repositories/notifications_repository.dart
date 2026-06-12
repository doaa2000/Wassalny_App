import '../entities/app_notification.dart';

abstract class NotificationsRepository {
  List<AppNotification> getNotifications();
}
