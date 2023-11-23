import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/assertions.dart';
import 'helpers/actions.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Add Parameter to Page', () {
    testWidgets('Enter edit mode, focus should be on the NewEntryEditor',
        (tester) async {
      // Given I am on the landing page
      await startParameterPageApp(tester);

      // When I create a new page
      await createNewParameterPage(tester);

      // Then the focus should be on the NewEntryEditor text field
      assertNewEntryEditorHasFocus(tester);
    });

    testWidgets('Add a parameter, focus return to the NewEntryEditor',
        (tester) async {
      // Given a new page has been created
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // When I add a parameter
      await addANewEntry(tester, 'Z:BDCCT');

      // Then the focus should return to the NewEntryEditor text field
      assertNewEntryEditorHasFocus(tester);
    });

    testWidgets(
        'Submit ACNET parameter, should appear at the bottom of the page',
        (tester) async {
      // Given the test page is loaded and I am in edit mode
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await enterEditMode(tester);

      // When I add a new ACNET parameter...
      await addANewEntry(tester, 'Z:BDCCT');
      await exitEditMode(tester);
      await waitForDataToLoadFor(tester, "Z:BDCCT");

      // Then the new parameter is added to the page
      assertParameterIsInRow("Z:BDCCT", 10);
      assertParameterHasDetails("Z:BDCCT",
          description: "device description",
          settingValue: "50.00",
          readingValue: "100.0");
    });

    testWidgets('Submit EPICS PV, should appear at the bottom of the page',
        (tester) async {
      // Given the test page is loaded and I am in edit mode
      await startParameterPageApp(tester);
      await navigateToTestPage1(tester);
      await enterEditMode(tester);

      // When I add a new ACNET parameter...
      await addANewEntry(tester, 'AN:EPICS:PV');
      await exitEditMode(tester);
      await waitForDataToLoadFor(tester, "AN:EPICS:PV");

      // Then the new parameter is added to the page
      assertParameterIsInRow("AN:EPICS:PV", 10);
      assertParameterHasDetails("AN:EPICS:PV",
          description: "device description",
          settingValue: "50.00",
          readingValue: "100.0");
    });
  });
}
