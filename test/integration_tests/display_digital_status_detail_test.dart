import 'dart:ui';

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
      assertOnOffStatus(
          forDRF: "G:AMANDA",
          isCharacter: ".",
          withColor: const Color(0x0000ff00));
      //  ... and ready/tripped characters are displayed
      //  ... and remote/local characters are displayed
      //  ... and positive/negative characters are displayed
    });

    testWidgets(
        'Tapping paramter with no digital status, should not do anything',
        (tester) async {
      // Given the test page is loaded
      //   and the 'G:AMANDA' device is on the page in row 1
      app.main();
      await tester.pumpAndSettle();
      assertParametersAreOnPage(["G:AMANDA"]);

      // When I tap the M:OUTTMP row
      await tapPageEntry(tester, atRowIndex: 2);

      // Then nothing happens
      assertConfirmDeleteDialog(isVisible: false);
    });
  });
}
