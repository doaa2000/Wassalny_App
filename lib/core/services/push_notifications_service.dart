import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../logging/logging.dart';
import '../navigation/app_navigator.dart';
import '../router/app_routes.dart';
import 'supabase_service.dart';

/// Runs in a separate isolate when a push arrives while the app is fully
/// terminated or backgrounded. Must be a top-level function (not a method)
/// per the firebase_messaging plugin's requirements, and must be registered
/// via [FirebaseMessaging.onBackgroundMessage] before `runApp`.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // A standard FCM "notification" payload is already shown by the OS without
  // any app code running. This hook is a placeholder for future data-only
  // background processing (e.g. silently refreshing local state).
}

/// Wraps Firebase Cloud Messaging: permission request, device-token
/// registration (saved to Supabase so the backend/Edge Function knows where
/// to deliver a push), and showing/handling notifications while the rider
/// has the app open.
class PushNotificationsService {
  PushNotificationsService._();
  static final PushNotificationsService instance = PushNotificationsService._();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'wassalny_default',
    'Wassalny notifications',
    description: 'Ride updates, offers, and account alerts',
    importance: Importance.high,
  );

  bool _initialized = false;

  /// Call once at app startup, after `Firebase.initializeApp`.
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await FirebaseMessaging.instance
          .requestPermission(alert: true, badge: true, sound: true);

      await _local
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      await _local.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: (response) => _openNotifications(),
      );

      // Foreground: FCM doesn't auto-show a system tray banner on Android
      // while the app is open, so display one ourselves.
      FirebaseMessaging.onMessage.listen((message) {
        final RemoteNotification? notification = message.notification;
        if (notification == null) return;
        _local.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
        );
      });

      // Rider tapped a push while the app was backgrounded.
      FirebaseMessaging.onMessageOpenedApp.listen((_) => _openNotifications());

      // App was fully closed and opened via tapping a push.
      final RemoteMessage? initial =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null) _openNotifications();
    } catch (e, s) {
      // Push setup is best-effort — a failure here shouldn't block the app
      // from starting, it just means no push notifications this session.
      appLogger.logWarning('Push notifications setup failed',
          feature: 'Push', error: e, stackTrace: s);
    }
  }

  void _openNotifications() {
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
    // Lands back on the app's main shell; the rider still taps the
    // Notifications tab themselves — deep-linking straight into a specific
    // tab would need NavBloc wiring this pass doesn't cover yet.
  }

  /// Fetches this device's FCM token and saves it against [userId] so the
  /// backend knows where to deliver pushes for that rider. Also keeps the
  /// saved token fresh if FCM rotates it later.
  Future<void> registerDeviceToken(String userId) async {
    if (!SupabaseService.instance.isConfigured) return;
    try {
      final String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _saveToken(userId, token);
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        _saveToken(userId, newToken);
      });
    } catch (e, s) {
      // Best-effort — a missing push token shouldn't block the rider from
      // using the app; they just won't get push notifications.
      appLogger.logWarning('Could not register device token',
          feature: 'Push', error: e, stackTrace: s);
    }
  }

  Future<void> _saveToken(String userId, String token) async {
    await SupabaseService.instance.client.from('device_tokens').upsert(
      {
        'user_id': userId,
        'token': token,
        'platform': Platform.isIOS ? 'ios' : 'android',
      },
      onConflict: 'token',
    );
  }
}
