import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Digital Status Detail', () {
    testWidgets(
        'Parameter with no digitial status, should display nothing in the status colum',
        (tester) async {
      // Given the test page is loaded
      //   and a device with no digital status ('M:OUTTMP') is on the page
      app.main();
      await tester.pumpAndSettle();
      assertParametersAreOnPage(["M:OUTTMP@e,02"]);

      // Then nothing is display in the digitial status column
      assertBasicStatus(forDRF: "M:OUTTMP@e,02", isVisible: false);
    });

    testWidgets(
        'Parameter with digital status, should display all four basic status characters',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I wait for the parametr data to update
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then on/off characters are displayed
      assertBasicStatus(forDRF: "G:AMANDA", isVisible: true);
      assertOnOffStatus(tester,
          forDRF: "G:AMANDA", isCharacter: ".", withColor: Colors.green);

      //  ... and ready/tripped characters are displayed
      assertReadyTrippedStatus(tester,
          forDRF: "G:AMANDA", isCharacter: "T", withColor: Colors.red);

      //  ... and remote/local characters are displayed
      assertRemoteLocalStatus(tester,
          forDRF: "G:AMANDA", isCharacter: "L", withColor: Colors.blue);

      //  ... and positive/negative characters are displayed
      assertPositiveNegativeStatus(tester,
          forDRF: "G:AMANDA", isCharacter: "T", withColor: Colors.pink);
    });

    testWidgets(
        'Tapping paramter with no digital status, should not do anything',
        (tester) async {
      // Given the test page is loaded
      //   and the 'G:AMANDA' device is on the page in row 1
      app.main();
      await tester.pumpAndSettle();
      assertParametersAreOnPage(["G:AMANDA"]);
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // When I tap the M:OUTTMP row
      await tapPageEntry(tester, atRowIndex: 2);

      // Then nothing happens
      assertConfirmDeleteDialog(isVisible: false);
    });

    testWidgets('Parameter with no digital status, does not have expand icon',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await tester.pumpAndSettle();

      // When I wait for the parametr data to update
      await waitForDataToLoadFor(tester, "M:OUTTMP@e,02");

      // Then the option to expand the row to display digital status is not present
      assertExpandDigitalStatusIcon(forDRF: "M:OUTTMP@e,02", isVisible: false);
    });
  });
}
