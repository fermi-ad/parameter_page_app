// This is the base widget for the app. It's only purpose is to provide
// consistent theme settings to the rest of the app. All apps using this
// base widget will have a similar look-and-feel.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parameter_page/theme/color_schemes.dart';

class FermiControlsApp extends StatelessWidget {
  final String title;
  final GoRouter router;

  const FermiControlsApp(
      {required this.title, required this.router, super.key});

  // Return the MaterialApp widget which will define the look-and-feel for the
  // application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: title,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      routerConfig: router,
    );
  }
}
