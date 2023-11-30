import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/widgets/sub_system_navigation_widget.dart';

import '../integration_tests/helpers/actions.dart';
import '../integration_tests/helpers/assertions.dart';

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
      assertCurrentSubSystemIs("Sub-system 1");
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
      await openSubSystemDirectory(tester);

      // Then the sub-system directory is displayed
      _assertSubSystemDirectory(
          contains: ["Sub-system 1", "Sub-system 2", "Sub-system 3"]);
    });

    testWidgets('Select sub-system from directory, onSelected is called',
        (WidgetTester tester) async {
      // Given a ParameterPage with 2 sub-systems
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createSubSystem();

      // ... and a SubSystemNavigationWidget has been rendered and provided a onSelected call-back
      String? selectedSubSystemTitle;
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: Center(
                  child: SubSystemNavigationWidget(
                      wide: true,
                      page: page,
                      onSelected: (String subSystemTitle) =>
                          selectedSubSystemTitle = subSystemTitle))));
      await tester.pumpWidget(app);

      // When I open the sub-system directory and select Sub-system 1
      await switchSubSystem(tester, to: "Sub-system 1");

      // Then the onSelected callback is called with the selected sub-system title
      expect(selectedSubSystemTitle, "Sub-system 1");
    });

    testWidgets('Not in edit mode, actions menu button is hidden',
        (WidgetTester tester) async {
      // Given a ParameterPage that's not in edit mode
      ParameterPage page = ParameterPage();

      // When I render the SubSystemNavigationWidget
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubSystemNavigationWidget(wide: true, page: page)));
      await tester.pumpWidget(app);

      // Then the actions button is hidden
      _assertSubSystemActionsButton(isVisible: false);
    });

    testWidgets('In edit mode, actions menu button is displayed',
        (WidgetTester tester) async {
      // Given a ParameterPage that's in edit mode
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // When I render the SubSystemNavigationWidget
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubSystemNavigationWidget(wide: true, page: page)));
      await tester.pumpWidget(app);

      // Then the actions button is displayed
      _assertSubSystemActionsButton(isVisible: true);
    });

    testWidgets('Tap add sub-system, onNewSubSystem called',
        (WidgetTester tester) async {
      // Given a ParameterPage in edit mode
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // ... and a SubSystemNavigationWidget has been rendered with a call-back registered for onNewSubSystem
      bool onNewSubSystemCalled = false;
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubSystemNavigationWidget(
                  wide: true,
                  page: page,
                  onNewSubSystem: () => onNewSubSystemCalled = true)));
      await tester.pumpWidget(app);

      // When I tap the new button
      await newSubSystem(tester);

      // Then the onNewSubSystem call-back is invoked
      expect(onNewSubSystemCalled, true);
    });

    testWidgets(
        'Rename sub-system, onTitleChanged called with new sub-system title',
        (WidgetTester tester) async {
      // Given a ParameterPage in edit mode
      ParameterPage page = ParameterPage();
      page.enableEditing();

      // ... and a SubSystemNavigationWidget has been rendered with a call-back registered for onTitleChanged
      String? newTitle;
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubSystemNavigationWidget(
                  wide: true,
                  page: page,
                  onTitleChanged: (String title) => newTitle = title)));
      await tester.pumpWidget(app);

      // When I edit the sub-system title
      await changeSubSystemTitle(tester, to: "New sub-system title");

      // Then the onTitleChanged call-back is invoked and passed the new sub-system title
      expect(newTitle, "New sub-system title");
    });
  });
}

void _assertSubSystemActionsButton({required bool isVisible}) {
  expect(
      find.descendant(
          of: find.byKey(const Key("subsystemnavigation")),
          matching: find.byIcon(Icons.add)),
      isVisible ? findsOneWidget : findsNothing);
  expect(
      find.descendant(
          of: find.byKey(const Key("subsystemnavigation")),
          matching: find.byIcon(Icons.delete)),
      isVisible ? findsOneWidget : findsNothing);
  expect(
      find.descendant(
          of: find.byKey(const Key("subsystemnavigation")),
          matching: find.byIcon(Icons.edit)),
      isVisible ? findsOneWidget : findsNothing);
}

void _assertSubSystemDirectory({required List<String> contains}) {
  for (final subSystemTitle in contains) {
    expect(
        find.descendant(
            of: find.byKey(const Key("subsystemnavigation")),
            matching: find.text(subSystemTitle)),
        findsAtLeastNWidgets(1));
  }
}
