import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/widgets/sub_page_navigation_widget.dart';

import '../integration_tests/helpers/assertions.dart';

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
      assertCurrentSubPageIs(2);
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
      assertNumberOfSubPagesIs(3);
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
      assertSubPageTitleIs("Sub-page 2 Title");
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

    testWidgets('Open sub-page directory, all sub-pages are presented',
        (WidgetTester tester) async {
      // Given a SubPageNavigationWidget has been rendered for a ParameterPage containing 3 sub-pages
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.subPageTitle = "Sub-Page One";
      page.createSubPage();
      page.subPageTitle = "Sub-Page Two";
      page.createSubPage();
      page.subPageTitle = "Sub-Page Three";

      MaterialApp app = MaterialApp(
          home: Scaffold(body: SubPageNavigationWidget(page: page)));
      await tester.pumpWidget(app);

      // When I open the sub-page directory
      await _openSubPageDirectory(tester);

      // Then the sub-page directory is presented to the user
      _assertSubPageDirectory(
          contains: ["Sub-Page One", "Sub-Page Two", "Sub-Page Three"]);
    });

    testWidgets('Select sub-page from directory, onSelected is called',
        (WidgetTester tester) async {
      // Given a SubPageNavigationWidget has been rendered for a ParameterPage containing 3 sub-pages
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.subPageTitle = "Sub-Page One";
      page.createSubPage();
      page.subPageTitle = "Sub-Page Two";
      page.createSubPage();
      page.subPageTitle = "Sub-Page Three";

      int? selectedIndex;
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubPageNavigationWidget(
                  page: page,
                  onSelected: (int index) => selectedIndex = index)));
      await tester.pumpWidget(app);

      // When I navigate to "Sub-Page Two" using the directory
      await _navigateUsingDirectory(tester, toSubPageWithTitle: "Sub-Page Two");

      // Then the onSelected callback is called and the selectedIndex is 2
      expect(selectedIndex, 2);
    });

    testWidgets('Enter sub-page index directly, onSelected is called',
        (WidgetTester tester) async {
      // Given a SubPageNavigationWidget has been rendered for a ParameterPage containing 3 sub-pages
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.subPageTitle = "Sub-Page One";
      page.createSubPage();
      page.subPageTitle = "Sub-Page Two";
      page.createSubPage();
      page.subPageTitle = "Sub-Page Three";

      int? selectedIndex;
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubPageNavigationWidget(
                  page: page,
                  onSelected: (int index) => selectedIndex = index)));
      await tester.pumpWidget(app);

      // When I navigate directly to sub-page 2
      await _navigateDirectlyTo(tester, subPageIndex: '2');

      // Then the onSelected callback is called and the selectedIndex is 2
      expect(selectedIndex, 2);
    });

    testWidgets('Enter invalid sub-page index, onSelected is not called',
        (WidgetTester tester) async {
      // Given a SubPageNavigationWidget has been rendered for a ParameterPage containing 3 sub-pages
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.subPageTitle = "Sub-Page One";
      page.createSubPage();
      page.subPageTitle = "Sub-Page Two";
      page.createSubPage();
      page.subPageTitle = "Sub-Page Three";

      int? selectedIndex;
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubPageNavigationWidget(
                  page: page,
                  onSelected: (int index) => selectedIndex = index)));
      await tester.pumpWidget(app);

      // When I attempt to navigate directly to an invalid sub-page index
      await _navigateDirectlyTo(tester, subPageIndex: '4');

      // Then the onSelected callback is not invoked
      expect(selectedIndex, null);
    });

    testWidgets('Enter garbage sub-page index, onSelected is not called',
        (WidgetTester tester) async {
      // Given a SubPageNavigationWidget has been rendered for a ParameterPage containing 3 sub-pages
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.subPageTitle = "Sub-Page One";
      page.createSubPage();
      page.subPageTitle = "Sub-Page Two";
      page.createSubPage();
      page.subPageTitle = "Sub-Page Three";

      int? selectedIndex;
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubPageNavigationWidget(
                  page: page,
                  onSelected: (int index) => selectedIndex = index)));
      await tester.pumpWidget(app);

      // When I attempt to navigate directly to an invalid sub-page index
      await _navigateDirectlyTo(tester, subPageIndex: "four");

      // Then the onSelected callback is not invoked
      expect(selectedIndex, null);
    });
  });
}

Future<void> _navigateDirectlyTo(WidgetTester tester,
    {required String subPageIndex}) async {
  await tester.enterText(
      find.byKey(const Key('subpagenavigation-current-index-input')),
      subPageIndex);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<void> _navigateUsingDirectory(WidgetTester tester,
    {required String toSubPageWithTitle}) async {
  await _openSubPageDirectory(tester);
  await tester.tap(find.text(toSubPageWithTitle));
  await tester.pumpAndSettle();
}

Future<void> _openSubPageDirectory(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.more_vert));
  await tester.pumpAndSettle();
}

Future<void> _navigateBackwards(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.navigate_before));
  await tester.pumpAndSettle();
}

Future<void> _navigateForward(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.navigate_next));
  await tester.pumpAndSettle();
}

void _assertSubPageDirectory({required List<String> contains}) {
  for (final title in contains) {
    expect(find.text(title), findsAtLeastNWidgets(1));
  }
}
