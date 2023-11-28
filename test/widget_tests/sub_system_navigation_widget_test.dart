import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/widgets/sub_system_navigation_widget.dart';

void main() {
  group("SubSystemNavigationWidget", () {
    testWidgets('Current sub-system indicator, shows the current sub-system',
        (WidgetTester tester) async {
      // Given a ParameterPage with two sub-systems
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createSubSystem();

      // ... and the current sub-system is Sub-system 1
      page.switchSubSystem(to: "Sub-system 1");

      // When I render a SubSystemNavigationWidget for the page
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubSystemNavigationWidget(wide: true, page: page)));
      await tester.pumpWidget(app);

      // Then the current sub-system indicator shows Sub-system 1
      _assertCurrentSubSystemIs("Sub-system 1");
    });
  });
}

void _assertCurrentSubSystemIs(String title) {
  expect(
      find.descendant(
          of: find.byKey(const Key("subsystemnavigation")),
          matching: find.text(title)),
      findsOneWidget);
}
