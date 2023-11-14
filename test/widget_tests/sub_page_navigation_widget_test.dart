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
      _assertCurrentSubPage(isSetTo: 2);
    });
  });
}

void _assertCurrentSubPage({required int isSetTo}) {
  expect(
      find.descendant(
          of: find.byKey(const Key("subpagenavigation-current-subpage")),
          matching: find.text("$isSetTo")),
      findsOneWidget);
}
