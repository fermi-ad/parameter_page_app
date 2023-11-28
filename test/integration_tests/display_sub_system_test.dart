import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Sub-system', () {
    testWidgets(
        'Open Test Page 2, sub-page navigation should show we are on Sub-system 1',
        (WidgetTester tester) async {
      // Given the parameter page is started
      await startParameterPageApp(tester);

      // When I open Test Page 2
      await navigateToOpenPage(tester);
      await openParameterPage(tester, withTitle: "Test Page 2");

      // Then the sub-system navigation is visible
      assertSubSystemNavigationIsVisible(true);

      // ... and we are currently on Sub-system 1
      assertCurrentSubSystemIs("Sub-system 1");
    }, semanticsEnabled: false);
  });
}

void assertSubSystemNavigationIsVisible(bool bool) {
  expect(find.byKey(const Key("subsystemnavigation")), findsOneWidget);
}
