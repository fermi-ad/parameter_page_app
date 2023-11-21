import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/widgets/sub_page_navigation_widget.dart';

import '../integration_tests/helpers/actions.dart';
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

    testWidgets('edit mode disabled, new and delete buttons are hidden',
        (WidgetTester tester) async {
      // Given a ParameterPage that is not in edit mode
      ParameterPage page = ParameterPage();

      // When I render the SubPageNavigationWidget
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SubPageNavigationWidget(page: page)));
      await tester.pumpWidget(app);

      // Then the new and delete buttons are not displayed
      expect(find.text('New Sub-Page'), findsNothing);
      expect(find.text('Delete Sub-Page'), findsNothing);
    });

    testWidgets('Title indicator, displays the title of the current sub-page',
        (WidgetTester tester) async {
      // Given a ParameterPage with 2 sub-pages, each with a distinct title
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.subPageTitle = "Sub-page 1 Title";
      page.createSubPage();
      page.subPageTitle = "Sub-page 2 Title";
      page.disableEditing();

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
      await navigateSubPageForward(tester);

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
      await navigateSubPageBackwards(tester);

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
      await openSubPageDirectory(tester);

      // Then the sub-page directory is presented to the user
      assertSubPageDirectory(
          contains: ["Sub-Page One", "Sub-Page Two", "Sub-Page Three"]);
    });

    testWidgets(
        'Open sub-page directory, all sub-pages are presented with blank pages',
        (WidgetTester tester) async {
      // Given a SubPageNavigationWidget has been rendered for a ParameterPage containing 3 sub-pages
      // ... and some of the sub-pages have blank titles
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createSubPage();
      page.createSubPage();
      page.subPageTitle = "Sub-Page Three";

      MaterialApp app = MaterialApp(
          home: Scaffold(body: SubPageNavigationWidget(page: page)));
      await tester.pumpWidget(app);

      // When I open the sub-page directory
      await openSubPageDirectory(tester);

      // Then the sub-page directory is presented to the user
      assertSubPageDirectory(contains: ["", "", "Sub-Page Three"]);
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
      await navigateSubPageUsingDirectory(tester,
          toSubPageWithTitle: "Sub-Page Two");

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
      await navigateDirectlyToSubpage(tester, withIndex: '2');

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
      await navigateDirectlyToSubpage(tester, withIndex: '4');

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
      await navigateDirectlyToSubpage(tester, withIndex: "four");

      // Then the onSelected callback is not invoked
      expect(selectedIndex, null);
    });

    testWidgets('Only one sub-page, hide sub-page directory',
        (WidgetTester tester) async {
      // Given a ParameterPage with only 1 sub-page
      ParameterPage page = ParameterPage();

      // When I render the SubPageNavigationWidget
      MaterialApp app = MaterialApp(
          home: Scaffold(body: SubPageNavigationWidget(page: page)));
      await tester.pumpWidget(app);

      // Then the sub-page directory is not visible
      assertExpandSubPageDirectory(isVisible: false);
    });

    testWidgets('Create sub-page, calls onNewSubPage',
        (WidgetTester tester) async {
      // Given a ParameterPage with 1 sug-page
      ParameterPage page = ParameterPage();

      // ... and editing mode is enabled
      page.enableEditing();

      // ... and I have rendered a SubPageNavigationWidget with an onNewSubPage call-back registered
      bool onNewSubPageCalled = false;
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubPageNavigationWidget(
                  page: page, onNewSubPage: () => onNewSubPageCalled = true)));
      await tester.pumpWidget(app);

      // When I create a new sub-page
      await createNewSubPage(tester);

      // Then the onNewSubPage call-back is called
      expect(onNewSubPageCalled, true);
    });

    testWidgets('Delete sub-page, calls onDeleteSubPage',
        (WidgetTester tester) async {
      // Given a ParameterPage with 2 sub-pages
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.createSubPage();

      // ... and I have rendered a SubPageNavigationWidget with an onDeleteSubPage call-back registered
      bool onDeleteSubPageCalled = false;
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubPageNavigationWidget(
                  page: page,
                  onDeleteSubPage: () => onDeleteSubPageCalled = true)));
      await tester.pumpWidget(app);

      // When I delete the current sub-page
      await deleteSubPage(tester);

      // Then the onDeleteSubPage call-back is called
      expect(onDeleteSubPageCalled, true);
    });

    testWidgets('Editing enabled, sub-page title is editable',
        (WidgetTester tester) async {
      // Given a ParameterPage with a sub-page titled "Sub-Page One"
      ParameterPage page = ParameterPage();
      page.enableEditing();
      page.subPageTitle = "Sub-Page One";

      // When I render the SubPageNavigationWidget
      MaterialApp app = MaterialApp(
          home: Scaffold(
              body: SubPageNavigationWidget(
        page: page,
      )));
      await tester.pumpWidget(app);

      // Then the sub-page title is in a textfield
      expect(
          find.descendant(
              of: find.byKey(const Key("subpagenavigation-subpage-title")),
              matching: find.descendant(
                  of: find.byType(TextField),
                  matching: find.text("Sub-Page One"))),
          findsOneWidget);
    });
  });
}
