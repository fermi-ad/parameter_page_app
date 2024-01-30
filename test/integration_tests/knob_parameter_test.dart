import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Knob Parameter', () {
    testWidgets(
        'Knobbing disabled for device, knobbing controls are not displayed',
        (WidgetTester tester) async {});

    testWidgets('Knobbing enabled for device, knobbing controls are visible',
        (WidgetTester tester) async {});

    testWidgets('Knob up one step, setting is incremented by one step size',
        (WidgetTester tester) async {});

    testWidgets('Knob up n steps, setting is incremented by n * step size',
        (WidgetTester tester) async {});

    testWidgets('Knob down n steps, setting is decremented by n * step size',
        (WidgetTester tester) async {});
  });
}
