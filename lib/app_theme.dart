import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_notifications/home.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({
    super.key, 
    required this.appTitle
  });

  final String appTitle;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Notifications',
      themeMode: .light,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        inputDecorationTheme: InputDecorationTheme(
          filled: true
        )
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        inputDecorationTheme: InputDecorationTheme(
          filled: true
        )
      ),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('pt')
      ],
      home: const HomePage(),
    );
  }
}