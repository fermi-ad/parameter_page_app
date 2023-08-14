import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Display Digital Status Detail', () {
    testWidgets(
        'Parameter with no digitial status, should display nothing in the status colum',
        (tester) async {
      // Given the test page is loaded
      //   and a device with no digital status ('M:OUTTMP') is on the page
      app.main();
      await navigateToTestPage1(tester);
      assertParametersAreOnPage(["M:OUTTMP@e,02"]);

      // Then nothing is display in the digitial status column
      assertBasicStatus(forDRF: "M:OUTTMP@e,02", isVisible: false);
    });

    testWidgets(
        'Parameter with digital status, should display all four basic status characters',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await navigateToTestPage1(tester);

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
      await navigateToTestPage1(tester);
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
      await navigateToTestPage1(tester);

      // When I wait for the parametr data to update
      await waitForDataToLoadFor(tester, "M:OUTTMP@e,02");

      // Then the option to expand the row to display digital status is not present
      assertExpandDigitalStatusIcon(forDRF: "M:OUTTMP@e,02", isVisible: false);
    });

    testWidgets('Parameter with digital status, does have expand icon',
        (tester) async {
      // Given the test page is loaded
      app.main();
      await navigateToTestPage1(tester);

      // When I wait for the parametr data to update
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // Then the option to expand the row to display digital status is present for G:AMANDA
      assertExpandDigitalStatusIcon(forDRF: "G:AMANDA", isVisible: true);
    });

    testWidgets('Click expand icon, displays extended status', (tester) async {
      // Given the test page is loaded and data for G:AMANDA is loaded
      app.main();
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // When I expand the parameter to display extended digital status
      await expandDigitalStatus(tester, forDRF: "G:AMANDA");
      await waitForExtendedStatusDataToLoadFor(tester, "G:AMANDA");

      // Then the expand button is now a collapse button
      assertCollapseDigitalStatusIcon(forDRF: "G:AMANDA", isVisible: true);

      // ... and the extended digitial status is displayed
      assertExtendedDigitalStatusDisplay(tester,
          forDRF: "G:AMANDA",
          isVisible: true,
          hasDescriptions: [
            "Henk On/Off",
            "Ready???",
            "Remote Henk",
            "Polarity",
            " test 2",
            "testtest",
            "..."
          ],
          hasDisplayValues: [
            "On",
            "Always",
            "L",
            "Mono",
            " good",
            "GOOD",
            "..."
          ],
          hasBinaryValues: [
            "1",
            "1",
            "0",
            "0",
            "0",
            "0",
            "0"
          ],
          hasColors: [
            Colors.green,
            Colors.green,
            Colors.blue,
            Colors.red,
            Colors.green,
            Colors.green,
            Colors.grey
          ]);
    });

    testWidgets('Collapse extended status, hides extended status',
        (tester) async {
      // Given the test page is loaded and data for G:AMANDA is loaded
      app.main();
      await navigateToTestPage1(tester);
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // ... and the extended digital status is expanded
      await expandDigitalStatus(tester, forDRF: "G:AMANDA");
      await waitForExtendedStatusDataToLoadFor(tester, "G:AMANDA");
      assertExtendedDigitalStatusDisplay(tester,
          forDRF: "G:AMANDA", isVisible: true);

      // When I tap the collapse button
      await collapseDigitalStatus(tester, forDRF: "G:AMANDA");

      // Then the collapse button is replaced with the expand button
      assertExpandDigitalStatusIcon(forDRF: "G:AMANDA", isVisible: true);

      // ... and the extended digital status is hidden
      assertExtendedDigitalStatusDisplay(tester,
          forDRF: "G:AMANDA", isVisible: false);
    });
  });
}
