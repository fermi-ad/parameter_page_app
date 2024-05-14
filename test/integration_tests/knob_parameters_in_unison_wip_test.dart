// ignore_for_file: unused_import

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

import 'helpers/actions.dart';
import 'helpers/assertions.dart';
import 'helpers/setup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Knob Parameters in Unison (Mults)', () {
    testWidgets(
        'Knob a single parameter inside of a mult, only that parameter changes',
        (WidgetTester tester) async {
      // Given a new parameter page
      await startParameterPageApp(tester);
      await createNewParameterPage(tester);

      // ... and I have create a mult:3 with three parameters
      await addANewEntry(tester, "mult:3 test mult");
      await addANewEntry(tester, "G:MULT1");
      await addANewEntry(tester, "G:MULT2");
      await addANewEntry(tester, "G:AMANDA");
      await exitEditMode(tester);

      // ... and data for G:AMANDA has been loaded
      await waitForDataToLoadFor(tester, "G:AMANDA");

      // ... and settings are enabled
      await requestSettingsPermission(tester,
          forDuration: SettingsRequestDuration.indefinitely);

      // When I tap the setting property
      await tapSetting(tester, forDRF: "G:AMANDA");
      assertSettingTextInputValue(forDRF: "G:AMANDA", isSetTo: "50.00");

      // ... and then knob up by 1 step
      await knobUp(tester, steps: 1);

      // Then the value displayed in the setting control's text field is...
      assertSettingTextInputValue(forDRF: "G:AMANDA", isSetTo: "51.00");
    }, semanticsEnabled: false);
  });
}
