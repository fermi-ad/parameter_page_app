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
        'Assign knobbing proportion to parameters and save page, proportions are persisted',
        (WidgetTester tester) async {
      // This test might belong with Knob Parameter
    }, semanticsEnabled: false);

    testWidgets(
        'Knob a single parameter inside of a mult, only that parameter changes',
        (WidgetTester tester) async {},
        semanticsEnabled: false);

    testWidgets('Save new page containing mults, mults are persisted',
        (WidgetTester tester) async {},
        semanticsEnabled: false);

    testWidgets('Add mults to existing page and save, mults are persisted',
        (WidgetTester tester) async {},
        semanticsEnabled: false);
  });
}
