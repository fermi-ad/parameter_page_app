import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/mult_entry_widget.dart';

void main() {
  group("MultEntryWidget", () {
    testWidgets('showAlarmDetails false, alarm details are not displayed',
        (WidgetTester tester) async {
      // Given nothing...
      // When I instantiate and display a MultEntryWidget with n: 0 and description "test mult"
      await tester.binding.setSurfaceSize(const Size(2560, 1440));
      Scaffold scaffold = const Scaffold(
          body: MultEntryWidget(description: "test mult", numberOfEntries: 0));
      MaterialApp app = MaterialApp(home: scaffold);
      await tester.pumpWidget(app);

      // Then the text displayed is "mult:0 test mult"
      expect(find.text("mult:0 test mult"), findsOneWidget);
    });
  });
}
