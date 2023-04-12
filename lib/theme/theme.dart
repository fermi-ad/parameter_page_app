// Stolen from - https://codingwitht.com/how-to-use-theme-in-flutter-light-dark-theme/
import 'package:flutter/material.dart';
import 'package:parameter_page/theme/text_theme.dart';

class GlobalAppTheme {
  GlobalAppTheme._();

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    textTheme: GlobalTextTheme.lightTextTheme,
    appBarTheme: const AppBarTheme(),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    textTheme: GlobalTextTheme.darkTextTheme,
    appBarTheme: const AppBarTheme(),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(),
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
    useMaterial3: true,
  );
}
