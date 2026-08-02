import 'package:flutter/material.dart';

abstract class AppTheme {

  static ThemeData light = ThemeData.light().copyWith(
    inputDecorationTheme: const InputDecorationTheme(filled: true)
  );

  static ThemeData dark = ThemeData.dark().copyWith(
    inputDecorationTheme: const InputDecorationTheme(
      filled: true
    )
  );
}