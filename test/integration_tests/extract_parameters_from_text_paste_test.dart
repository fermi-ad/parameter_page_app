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

      // When I paste "I:BEAM R:BEAM B:DCCT"
      await addANewEntry(tester, "I:BEAM R:BEAM B:DCCT");

      // Then the ACNET devices are added to the page
      assertParametersAreOnPage(["I:BEAM", "R:BEAM", "B:DCCT"]);
    }, semanticsEnabled: false);

    testWidgets(
        'Paste a string with text and devices, entries added and text is discarded',
        (WidgetTester tester) async {},
        semanticsEnabled: false);

    testWidgets(
        'Paste a string with only text, whole string added as a comment',
        (WidgetTester tester) async {},
        semanticsEnabled: false);

    testWidgets(
        'Paste a hard comment with ACNET devices and EPICS PVs, whole string added as a comment',
        (WidgetTester tester) async {},
        semanticsEnabled: false);
  });
}
