import 'package:flutter/material.dart';
import 'page/entry.dart';
import 'page/page.dart';

void main() {
  runApp(const FermiApp(
    title: "Parameter Page",
    child: BaseWidget(title: 'Parameter Page'),
  ));
}

// This is the base widget for the app. It's only purpose is to provide
// consistent theme settings to the rest of the app. All apps using this
// base widget will have a similar look-and-feel.

class FermiApp extends StatelessWidget {
  final String title;
  final Widget child;

  const FermiApp({required this.title, required this.child, super.key});

  // Return the MaterialApp widget which will define the look-and-feel for the
  // application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: child,
    );
  }
}

class BaseWidget extends StatelessWidget {
  const BaseWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(
            child: PageWidget([
          ParameterEntry("M:OUTTMP@e,02"),
          CommentEntry("This is our first comment!"),
          ParameterEntry("G:AMANDA"),
          ParameterEntry("PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE"),
        ]))); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
