import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Extract Parameters from Text Paste', () {
    testWidgets(
        'Paste a string of ACNET devices, multiple entries added to page',
        (WidgetTester tester) async {},
        semanticsEnabled: false);

    testWidgets('Paste a string of EPICS PVs, multiple entries added to page',
        (WidgetTester tester) async {},
        semanticsEnabled: false);

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
