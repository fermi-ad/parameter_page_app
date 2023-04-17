// Stolen from - https://codingwitht.com/how-to-use-theme-in-flutter-light-dark-theme/
import 'package:flutter/material.dart';

class GlobalTextTheme {
  static TextTheme globalTextTheme = const TextTheme(
    titleSmall: TextStyle(fontSize: 16.0),
    titleMedium: TextStyle(fontSize: 18.0),
    titleLarge: TextStyle(fontSize: 24.0),
    bodySmall: TextStyle(fontSize: 14.0),
    bodyMedium: TextStyle(fontSize: 18.0),
    bodyLarge: TextStyle(fontSize: 20.0),
  );
  static TextTheme lightTextTheme = globalTextTheme.copyWith();
  static TextTheme darkTextTheme = globalTextTheme.copyWith();
}
