import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._();
  final _plugin = FlutterLocalNotificationsPlugin();

  LocalNotificationService._();

  static LocalNotificationService get instance {
    return _instance;
  }

  

  Future<void> init() async {
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher'
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid
    );

    await _plugin.initialize(settings: initSettings);

    const androidChannel = AndroidNotificationChannel(
      'default_channel', 
      'Default',
      description: 'Default Test',
      importance: Importance.high
    );
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel);
  }

  NotificationDetails get androidDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel', 
        'Default',
        channelDescription: 'Default Test',
        importance: Importance.high,
        priority: Priority.high
      )
    );
  }

  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: androidDetails
    );
  }
}