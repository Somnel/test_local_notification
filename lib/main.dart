import 'package:flutter/material.dart';
import 'package:test_notifications/app_theme.dart';
import 'package:test_notifications/home.dart';
import 'package:test_notifications/service/local_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.instance.init();

  runApp(const AppTheme(appTitle: 'Test Local Notification', child: HomePage()));
}