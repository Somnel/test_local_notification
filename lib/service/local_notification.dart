import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._();
  final _plugin = FlutterLocalNotificationsPlugin();
  late NotificationAppLaunchDetails? _details;
  late bool _didNotificationLaunchApp;

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


    _details = await _plugin.getNotificationAppLaunchDetails();
    _didNotificationLaunchApp = _details?.didNotificationLaunchApp ?? false;
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidChannel);
  }

  Future<bool> isAndroidPermissionGranted() async {
    return await _plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.areNotificationsEnabled() 
      ?? false;
  }

  Future<bool> requestAndroidPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    return await androidImplementation?.requestNotificationsPermission() ?? false;
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
      notificationDetails: notificationDetails
    );
  }

  NotificationDetails get notificationDetails =>
    NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel', 
        'Default',
        channelDescription: 'Default Test',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker'
      )
    );

  bool didNotificationLaunchApp() => _didNotificationLaunchApp;
}