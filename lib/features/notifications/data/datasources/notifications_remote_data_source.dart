import '../../../../core/services/supabase_service.dart';
import '../../domain/entities/app_notification.dart';

/// Reads and updates the signed-in rider's notifications from the backend.
abstract class NotificationsRemoteDataSource {
  Future<List<AppNotification>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllRead();
}

/// Supabase implementation. Column names beyond `type`/`is_read`/`data`
/// (documented in the schema audit) are read defensively — if a column like
/// `title` turns out not to exist on the real table, this falls back to a
/// generic per-type label instead of throwing.
class NotificationsSupabaseDataSource implements NotificationsRemoteDataSource {
  const NotificationsSupabaseDataSource(this._service);

  final SupabaseService _service;

  @override
  Future<List<AppNotification>> getNotifications() async {
    final String? userId = _service.currentUserId;
    if (userId == null) return const [];

    final List<dynamic> rows = await _service.client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return rows
        .cast<Map<String, dynamic>>()
        .map(_toNotification)
        .toList(growable: false);
  }

  @override
  Future<void> markAsRead(String id) async {
    await _service.client.from('notifications').update({'is_read': true}).eq('id', id);
  }

  @override
  Future<void> markAllRead() async {
    final String? userId = _service.currentUserId;
    if (userId == null) return;
    await _service.client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }

  AppNotification _toNotification(Map<String, dynamic> row) {
    final String type = (row['type'] as String?) ?? '';
    final NotificationKind kind = _kindFor(type);

    final Map<String, dynamic>? data = row['data'] as Map<String, dynamic>?;
    final String title = (row['title'] as String?) ??
        (data?['title'] as String?) ??
        _defaultTitleFor(kind);
    final String body = (row['body'] as String?) ??
        (row['message'] as String?) ??
        (data?['body'] as String?) ??
        '';

    final String? rawDate = row['created_at'] as String?;
    final DateTime? createdAt = rawDate == null ? null : DateTime.tryParse(rawDate);
    final NotificationSection section = _sectionFor(createdAt);

    return AppNotification(
      id: (row['id'] ?? '').toString(),
      kind: kind,
      section: section,
      title: title,
      body: body,
      unread: !((row['is_read'] as bool?) ?? false),
    );
  }

  NotificationKind _kindFor(String type) {
    switch (type) {
      case 'trip_completed':
      case 'ride_complete':
      case 'ride_completed':
        return NotificationKind.rideComplete;
      case 'promo':
      case 'promotion':
        return NotificationKind.promo;
      case 'wallet_topup':
      case 'top_up':
      case 'topup':
        return NotificationKind.topUp;
      case 'on_time':
      case 'reminder':
        return NotificationKind.onTime;
      default:
        return NotificationKind.general;
    }
  }

  String _defaultTitleFor(NotificationKind kind) {
    switch (kind) {
      case NotificationKind.rideComplete:
        return 'Your ride is complete';
      case NotificationKind.promo:
        return 'Offer';
      case NotificationKind.topUp:
        return 'Wallet update';
      case NotificationKind.onTime:
        return 'Reminder';
      case NotificationKind.general:
        return 'Notification';
    }
  }

  NotificationSection _sectionFor(DateTime? dt) {
    if (dt == null) return NotificationSection.earlier;
    final DateTime now = DateTime.now();
    final DateTime local = dt.toLocal();
    final bool isToday =
        local.year == now.year && local.month == now.month && local.day == now.day;
    return isToday ? NotificationSection.today : NotificationSection.earlier;
  }
}

/// UI-only mode (no Supabase): no notifications to show.
class NotificationsNoopDataSource implements NotificationsRemoteDataSource {
  const NotificationsNoopDataSource();

  @override
  Future<List<AppNotification>> getNotifications() async => const [];

  @override
  Future<void> markAsRead(String id) async {}

  @override
  Future<void> markAllRead() async {}
}
