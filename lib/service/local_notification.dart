import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;



class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._();
  final _plugin = FlutterLocalNotificationsPlugin();
  late NotificationAppLaunchDetails? _details;
  late bool _didNotificationLaunchApp;
  
  
  LocalNotificationService._();
  static LocalNotificationService get instance => _instance;

  
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

  Future<void> requestAndroidPermission() async {
    if(await isAndroidPermissionGranted()) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission() ?? false;
      await androidImplementation?.requestExactAlarmsPermission() ?? false;
    }
  }

  

  Future<void> showNotification({
    int id = 0,
    required NotificationData data
  }) async {
    await _plugin.show(
      id: id,
      title: data.title,
      body: data.body,
      notificationDetails: notificationDetails
    );
  }

  Future<void> showScheduledNotification({
    int id = 0,
    required NotificationData data,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final dateTime = data.joinTZDateTime(now);

    if(dateTime?.isAfter(now) != null) {
      await _plugin.zonedSchedule(
        id: id, 
        title: data.title,
        body: data.body,
        notificationDetails: notificationDetails, 
        scheduledDate: dateTime!,
        androidScheduleMode: .exactAllowWhileIdle
      );
    }
  }

  NotificationType show({
    required NotificationData data,
  }) {
    if(data.isTimerActive()) {
      showScheduledNotification(data: data);
      return NotificationType.scheduled;
    } else {
      showNotification(data: data);
      return NotificationType.simple;
    }
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

enum NotificationType { simple, scheduled, scheduledTimerBefore }

class NotificationData {
  String? title;
  String? body;
  TimeOfDay? timer;

  NotificationData({
    this.title,
    this.body,
    this.timer,
  });

  tz.TZDateTime? joinTZDateTime(tz.TZDateTime dateTime) {
    if(isTimerActive()) {
      return tz.TZDateTime(
        dateTime.location,
        dateTime.year,
        dateTime.month,
        dateTime.day,
        timer!.hour,
        timer!.minute,
      );
    }

    return null;
  }

  bool isTimerActive() => timer?.hour != null && timer?.minute != null;
}