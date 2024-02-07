import 'package:flutter/material.dart';
import 'package:parameter_page/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';

import 'actions.dart';

Future<void> startParameterPageApp(WidgetTester tester) async {
  await _setScreenToWide(tester);
  app.main();
  await tester.pumpAndSettle();
  await pumpUntilFound(tester, find.text("Welcome!"));
}

Future<void> _setScreenToWide(WidgetTester tester) async {
  tester.binding.setSurfaceSize(const Size(2560, 1440));
}
