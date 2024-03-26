import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Knob Parameters in Unison (Mults)', () {
    testWidgets('Tap mult, mult is enabled for knobbing',
        (WidgetTester tester) async {});

    testWidgets(
        'Tap another mult while knobbing a different mult, tapped mult is enabled and previous mult is disabled',
        (WidgetTester tester) async {});

    testWidgets(
        'Assign knobbing proportion to parameter, displayed below setting value',
        (WidgetTester tester) async {
      // This test might belong with Knob Parameter
    });

    testWidgets(
        'Knob parameter with proportion up multiple steps, proportion applied to each step',
        (WidgetTester tester) async {
      // This test might belong with Knob Parameter
    });

    testWidgets(
        'Assign knobbing proportion to parameters and save page, proportions are persisted',
        (WidgetTester tester) async {
      // This test might belong with Knob Parameter
    });

    testWidgets(
        'Add entries to an empty mult, display entries inside of new mult',
        (WidgetTester tester) async {});

    testWidgets('Remove mult, parameters are ungrouped',
        (WidgetTester tester) async {});

    testWidgets(
        'Knob mult without proportions up multiple steps, parameters increment in unison',
        (WidgetTester tester) async {});

    testWidgets(
        'Knob mult without proportions down multiple steps, parameters decrement in unison',
        (WidgetTester tester) async {});

    testWidgets(
        'Knob mult with proportions up multiple steps, parameters increment in unison according to proportions',
        (WidgetTester tester) async {});

    testWidgets(
        'Knob mult with proportions down multiple steps, parameters decrement in unison according according to proportions',
        (WidgetTester tester) async {});

    testWidgets('Save new page containing mults, mults are persisted',
        (WidgetTester tester) async {});

    testWidgets('Add mults to existing page and save, mults are persisted',
        (WidgetTester tester) async {});
  });
}
