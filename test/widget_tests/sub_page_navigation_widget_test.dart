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
      MaterialApp app = MaterialApp(home: SubPageNavigationWidget(page: page));
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
      MaterialApp app = MaterialApp(home: SubPageNavigationWidget(page: page));
      await tester.pumpWidget(app);

      // Then the number of sub-pages is 3
      _assertNumberOfSubPagesIs(3);
    });
  });
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
