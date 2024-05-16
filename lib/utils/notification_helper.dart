import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: IOSInitializationSettings(),
    );
    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id', 
      'channel_name', 
      channelDescription: 'channel_description', // channelDescription adlı named arguent kullanılıyor.
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: IOSNotificationDetails(),
    );
    await _notificationsPlugin.show(0, title, body, notificationDetails);
  }
}
