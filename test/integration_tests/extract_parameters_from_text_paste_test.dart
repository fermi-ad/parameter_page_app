import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Extract Parameters from Text Paste', () {
    testWidgets(
        'Paste a string of ACNET devices, multiple entries added to page',
        (WidgetTester tester) async {
      // Given I have created a new page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I paste "I:BEAM R:BEAM B:DCCT"
      await addANewEntry(tester, "I:BEAM R:BEAM B:DCCT");

      // Then the ACNET devices are added to the page
      assertParametersAreOnPage(["I:BEAM", "R:BEAM", "B:DCCT"]);
    }, semanticsEnabled: false);

    testWidgets('Paste a string of EPICS PVs, multiple entries added to page',
        (WidgetTester tester) async {
      // Given I have created a new page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I paste "AN:EPICS:PV ANOTHER:EPICS PROCESS:VARIABLE"
      await addANewEntry(tester, "AN:EPICS:PV ANOTHER:EPICS PROCESS:VARIABLE");

      // Then the PVs are added to the page
      assertParametersAreOnPage(
          ["AN:EPICS:PV", "ANOTHER:EPICS", "PROCESS:VARIABLE"]);
    }, semanticsEnabled: false);

    testWidgets(
        'Paste a string with text and devices, entries added and text is discarded',
        (WidgetTester tester) async {
      // Given I have created a new page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I paste "AN:EPICS:PV next to ANOTHER:EPICS PROCESS:VARIABLE with some text at the end."
      await addANewEntry(tester,
          "AN:EPICS:PV next to ANOTHER:EPICS PROCESS:VARIABLE with some text at the end.");

      // Then the PVs are added to the page
      assertParametersAreOnPage(
          ["AN:EPICS:PV", "ANOTHER:EPICS", "PROCESS:VARIABLE"]);

      // ... but not the text
      assertNumberOfEntriesOnPageIs(3);
    }, semanticsEnabled: false);

    testWidgets(
        'Paste a string with only text, whole string added as a comment',
        (WidgetTester tester) async {
      // Given I have created a new page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I paste...
      await addANewEntry(tester, "Just a string of plain text.");

      // Then the PVs are added to the page
      assertIsOnPage(comment: "Just a string of plain text.");
    }, semanticsEnabled: false);

    testWidgets(
        'Paste a hard comment with ACNET devices and EPICS PVs, whole string added as a comment',
        (WidgetTester tester) async {
      // Given I have created a new page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I paste...
      await addANewEntry(tester,
          "!Just a string of plain text with AN:EPICS:PV and A:ACNETDEV.");

      // Then the comment is added by itself
      assertNumberOfEntriesOnPageIs(1);
      assertIsOnPage(
          comment:
              "Just a string of plain text with AN:EPICS:PV and A:ACNETDEV.");
    }, semanticsEnabled: false);
  });
}
