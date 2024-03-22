import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/mult_entry_widget.dart';

void main() {
  group("MultEntryWidget", () {
    testWidgets('Create mult entry, display parameters in entry text',
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

    testWidgets(
        'Tap mult entry, background color changes to indicate that the mult is accepting input',
        (WidgetTester tester) async {
      // Given a MultEntryWidget with n = 1
      await tester.binding.setSurfaceSize(const Size(2560, 1440));
      Scaffold scaffold = const Scaffold(
          body: MultEntryWidget(
              description: "test enable mult", numberOfEntries: 1));
      MaterialApp app = MaterialApp(
          home: scaffold,
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)));
      await tester.pumpWidget(app);

      // When I tap the mult entry
      await tester.tap(find.byType(MultEntryWidget));
      await tester.pumpAndSettle();

      // Then the background changes to seconday container
      final ThemeData currentTheme = _getCurrentTheme(tester);
      final borderShape = (tester.firstWidget(find.byType(Card)) as Card).shape!
          as RoundedRectangleBorder;
      final borderColor = borderShape.side.color;
      expect(borderColor, currentTheme.colorScheme.secondaryContainer);
    });
  });
}

ThemeData _getCurrentTheme(WidgetTester tester) {
  var brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  bool isDarkMode = brightness == Brightness.dark;

  return isDarkMode
      ? tester.widget<MaterialApp>(find.byType(MaterialApp)).darkTheme!
      : tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!;
}
