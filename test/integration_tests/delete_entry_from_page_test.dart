import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Delete Entry from Page', () {
    testWidgets('Confirm no, should not delete entry', (tester) async {
      // Given the test page is loaded and the 'G:AMANDA' device is on the page
      app.main();
      await tester.pumpAndSettle();
      assertParametersAreOnPage(["G:AMANDA"]);

      // When I attempt to delete the parameter entry but select No from the confirmation dialog...
      await whenIDeleteParameter(tester, "G:AMANDA", confirm: false);

      // Then the parameter is still on the page
      assertParametersAreOnPage(["G:AMANDA"]);
    });

    testWidgets('Confirm yes, should delete entry', (tester) async {
      // Given the test page is loaded and the 'G:AMANDA' device is on the page
      app.main();
      await tester.pumpAndSettle();
      assertParametersAreOnPage(["G:AMANDA"]);

      // When I delete the parameter entry...
      await whenIDeleteParameter(tester, "G:AMANDA");

      // Then the parameter should be removed from the page
      assertParametersAreNotOnPage(["G:AMANDA"]);
    });
  });
}
