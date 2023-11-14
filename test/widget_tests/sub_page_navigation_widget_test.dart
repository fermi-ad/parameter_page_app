import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/entities/parameter_page.dart';

class SubPageNavigationWidget extends StatelessWidget {
  const SubPageNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        key: const Key("subpagenavigation-current-subpage"),
        child: const Text("2"));
  }
}

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
      MaterialApp app = const MaterialApp(home: SubPageNavigationWidget());
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
