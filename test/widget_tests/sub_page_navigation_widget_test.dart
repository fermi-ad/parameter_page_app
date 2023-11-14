import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/widgets/sub_page_navigation_widget.dart';

void main() {
  group("SubPageNavigationWidget", () {
    testWidgets('Current sub-page indicator, shows the current sub-page',
        (WidgetTester tester) async {
      // Given a ParameterPage with 3 sub-pages
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createSubPage();
      page.createSubPage();

      // ... and it is currently on sub-page 2
      page.switchSubPage(to: 2);

      // When I render the SubPageNavigationWidget
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SubPageNavigationWidget(page: page)));
      await tester.pumpWidget(app);

      // Then the current sub-page is 2
      _assertCurrentSubPageIs(2);
    });

    testWidgets(
        'Sub-page count indicator, displays the number of sub-pages for the current tab',
        (WidgetTester tester) async {
      // Given a ParameterPage with 3 sub-pages
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createSubPage();
      page.createSubPage();

      // When I render the SubPageNavigationWidget
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SubPageNavigationWidget(page: page)));
      await tester.pumpWidget(app);

      // Then the number of sub-pages is 3
      _assertNumberOfSubPagesIs(3);
    });

    testWidgets('Title indicator, displays the title of the current sub-page',
        (WidgetTester tester) async {
      // Given a ParameterPage with 2 sub-pages, each with a distinct title
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.subPageTitle = "Sub-page 1 Title";
      page.createSubPage();
      page.subPageTitle = "Sub-page 2 Title";

      // When I render the SubPageNavigationWidget
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SubPageNavigationWidget(page: page)));
      await tester.pumpWidget(app);

      // Then the title display is "Sub-page 2 Title"
      _assertSubPageTitleIs("Sub-page 2 Title");
    });

    testWidgets('Increment tapped, onIncrement is called',
        (WidgetTester tester) async {
      // Given a SubPageNavigationWidget has been rendered
      bool onIncrementCalled = false;
      ParameterPage page = ParameterPage();
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubPageNavigationWidget(
                  page: page, onForward: () => onIncrementCalled = true)));
      await tester.pumpWidget(app);

      // When I tap the 'increment page' button
      await _navigateForward(tester);

      // Then the onIncrement callback has been invoked
      expect(onIncrementCalled, true,
          reason: "onIncrement callback should be called");
    });

    testWidgets('Previous tapped, onPrevious is called',
        (WidgetTester tester) async {
      // Given a SubPageNavigationWidget has been rendered
      bool onPreviousCalled = false;
      ParameterPage page = ParameterPage();
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubPageNavigationWidget(
                  page: page, onBackward: () => onPreviousCalled = true)));
      await tester.pumpWidget(app);

      // When I tap the 'increment page' button
      await _navigateBackwards(tester);

      // Then the onPrevious callback has been invoked
      expect(onPreviousCalled, true,
          reason: "onPrevious callback should be called");
    });
  });
}

Future<void> _navigateBackwards(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.navigate_before));
  await tester.pumpAndSettle();
}

Future<void> _navigateForward(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.navigate_next));
  await tester.pumpAndSettle();
}

void _assertCurrentSubPageIs(int isSetTo) {
  expect(
      find.descendant(
          of: find.byKey(const Key("subpagenavigation-current-subpage")),
          matching: find.text("$isSetTo")),
      findsOneWidget);
}

void _assertNumberOfSubPagesIs(int numberOfSubPagesIs) {
  expect(
      find.descendant(
          of: find.byKey(const Key("subpagenavigation-total-subpages")),
          matching: find.text("$numberOfSubPagesIs")),
      findsOneWidget);
}

void _assertSubPageTitleIs(String title) {
  expect(
      find.descendant(
          of: find.byKey(const Key("subpagenavigation-subpage-title")),
          matching: find.text(title)),
      findsOneWidget);
}
