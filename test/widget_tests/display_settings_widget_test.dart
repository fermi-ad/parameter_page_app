import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';

void main() {
  group("DisplaySettingsWidget", () {
    late MaterialApp app;

    setUp(() {
      app = const MaterialApp(home: Scaffold(body: DisplaySettingsWidget()));
    });

    testWidgets('Title is Display Settings', (WidgetTester tester) async {
      // Given a new DisplaySettingsWidget
      await tester.pumpWidget(app);

      // Then the app bar title is visible
      expect(find.text("Display Settings"), findsOneWidget);
    });
  });
}
