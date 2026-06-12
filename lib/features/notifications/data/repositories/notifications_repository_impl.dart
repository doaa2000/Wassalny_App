import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

/// Dummy notifications matching the design.
class NotificationsRepositoryImpl implements NotificationsRepository {
  @override
  List<AppNotification> getNotifications() => const [
        AppNotification(
          kind: NotificationKind.rideComplete,
          section: NotificationSection.today,
          title: 'Your ride is complete',
          body: 'Trip to Cairo Festival City · EGP 86. Rate Ahmed now.',
          unread: true,
        ),
        AppNotification(
          kind: NotificationKind.promo,
          section: NotificationSection.today,
          title: '25% off your next 3 rides 🎉',
          body: 'Use code WSL25 before Sunday. T&Cs apply.',
          unread: true,
        ),
        AppNotification(
          kind: NotificationKind.topUp,
          section: NotificationSection.earlier,
          title: 'Wallet topped up',
          body: 'EGP 200 added to your Wassalny Wallet.',
        ),
        AppNotification(
          kind: NotificationKind.onTime,
          section: NotificationSection.earlier,
          title: 'Driver was on time',
          body: 'Your trip to Zamalek arrived 2 min early.',
        ),
      ];
}
