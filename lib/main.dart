import 'package:flutter/material.dart';
import 'package:test_notifications/service/time_zone.dart';

import 'package:test_notifications/ui/home/widgets/home_screen_container.dart';
import 'package:test_notifications/service/local_notification.dart';
import 'package:test_notifications/ui/core/themes/theme.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await TimeZoneService.instance.init();
  await LocalNotificationService.instance.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: .dark,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt')
      ],
      home: const HomeScreenContainer(),
    );
  }
}