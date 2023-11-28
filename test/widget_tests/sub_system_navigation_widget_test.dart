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

    testWidgets(
        'Open sub-system directory, presents each sub-system from the page',
        (WidgetTester tester) async {
      // Given a SubSystemNavigationWidget rendered for a ParameterPage with 3 sub-systems
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createSubSystem();
      page.createSubSystem();

      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubSystemNavigationWidget(wide: true, page: page)));
      await tester.pumpWidget(app);

      // When I open the sub-system directory
      await _openSubSystemDirectory(tester);

      // Then the sub-system directory is displayed
      _assertSubSystemDirectory(
          contains: ["Sub-system 1", "Sub-system 2", "Sub-system 3"]);
    });
  });
}

Future<void> _openSubSystemDirectory(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key("subsystemnavigation")));
  await tester.pumpAndSettle();
}

void _assertSubSystemDirectory({required List<String> contains}) {
  for (final subSystemTitle in contains) {
    expect(
        find.descendant(
            of: find.byKey(const Key("subsystemnavigation")),
            matching: find.text(subSystemTitle)),
        findsOneWidget);
  }
}

void _assertCurrentSubSystemIs(String title) {
  expect(
      find.descendant(
          of: find.byKey(const Key("subsystemnavigation")),
          matching: find.text(title)),
      findsOneWidget);
}
