import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

/// Reads the rider's real notifications from the backend (empty in UI-only
/// mode, via [NotificationsNoopDataSource]).
class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(this._remote);

  final NotificationsRemoteDataSource _remote;

  @override
  Future<List<AppNotification>> getNotifications() => _remote.getNotifications();

  @override
  Future<void> markAsRead(String id) => _remote.markAsRead(id);

  @override
  Future<void> markAllRead() => _remote.markAllRead();
}
