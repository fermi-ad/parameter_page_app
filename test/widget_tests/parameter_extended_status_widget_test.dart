import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:parameter_page/widgets/parameter_extended_status_widget.dart';

void main() {
  DigitalStatus emptyBits = DigitalStatus(
      refId: 0,
      cycle: 0,
      timestamp: DateTime(2023),
      extendedStatus: [
        const ExtendedStatusAttribute(
          value: 1,
        ),
        const ExtendedStatusAttribute(
          value: 1,
        ),
        const ExtendedStatusAttribute(
          value: 0,
        ),
        const ExtendedStatusAttribute(
          value: 0,
        ),
        const ExtendedStatusAttribute(
          value: 0,
        ),
        const ExtendedStatusAttribute(
          value: 0,
        )
      ]);

  DigitalStatus allBits = DigitalStatus(
      refId: 0,
      cycle: 0,
      timestamp: DateTime(2023),
      extendedStatus: [
        const ExtendedStatusAttribute(
            description: "Henk On/Off",
            value: 1,
            valueText: "On",
            color: StatusColor.green),
        const ExtendedStatusAttribute(
            description: "Ready???",
            value: 1,
            valueText: "Always",
            color: StatusColor.green),
        const ExtendedStatusAttribute(
            description: "Remote Henk",
            value: 0,
            valueText: "L",
            color: StatusColor.blue),
        const ExtendedStatusAttribute(
            description: "Polarity",
            value: 0,
            valueText: "Mono",
            color: StatusColor.red),
        const ExtendedStatusAttribute(
            description: " test 2",
            value: 0,
            valueText: " good",
            color: StatusColor.green),
        const ExtendedStatusAttribute(
            description: "testtest",
            value: 0,
            valueText: "GOOD",
            color: StatusColor.green)
      ]);

  DigitalStatus singleBit = DigitalStatus(
      refId: 0,
      cycle: 0,
      timestamp: DateTime(2023),
      extendedStatus: [
        const ExtendedStatusAttribute(
            description: "Henk On/Off",
            value: 1,
            valueText: "On",
            color: StatusColor.green)
      ]);

  void assertNumberOfBitsDisplayed({required String forDRF, required int isN}) {
    final digitalStatusFinder =
        find.byKey(Key("parameter_extendeddigitalstatus_$forDRF"));
    final finder =
        find.descendant(of: digitalStatusFinder, matching: find.byType(Row));
    expect(finder.evaluate().length, isN);
  }

  void assertBitDetails(tester,
      {required String forDRF,
      required int bitNumber,
      required String description,
      required String valueText,
      Color? valueColor,
      required String value}) {
    final bitRowFinder = find
        .byKey(Key("parameter_extendeddigitalstatus_${forDRF}_bit$bitNumber"));
    expect(bitRowFinder, findsOneWidget);

    expect(find.descendant(of: bitRowFinder, matching: find.text(description)),
        findsAtLeastNWidgets(1));

    expect(find.descendant(of: bitRowFinder, matching: find.text(valueText)),
        findsAtLeastNWidgets(1));

    expect(find.descendant(of: bitRowFinder, matching: find.text(value)),
        findsOneWidget);

    final displayValueTextFinder =
        find.descendant(of: bitRowFinder, matching: find.text(valueText));
    expect(displayValueTextFinder, findsAtLeastNWidgets(1));

    if (valueColor != null) {
      final displayValueText = tester.firstWidget<Text>(displayValueTextFinder);
      expect(displayValueText.style.color, valueColor);
    }
  }

  group("ParameterExtendedStatusWidget", () {
    testWidgets(
        'Parameter with a single bit of extended status, shows 1 row of detail',
        (WidgetTester tester) async {
      // Given a ParameterExtendedStatusWidget instantiated for a device called G:AMANDA with 1 bit defined
      final app = MaterialApp(
          home: Scaffold(
              body: ParameterExtendedStatusWidget(
                  drf: "G:AMANDA", digitalStatus: singleBit)));

      // When I display the extended status
      await tester.pumpWidget(app);

      // Then only one bit is displayed
      assertNumberOfBitsDisplayed(forDRF: "G:AMANDA", isN: 1);

      // ... and the details of bit 0 are...
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 0,
          description: "Henk On/Off",
          valueText: "On",
          valueColor: Colors.green,
          value: "1");
    });

    testWidgets(
        'Parameter with 6 bits of extended status, shows 6 rows of detail',
        (WidgetTester tester) async {
      // Given a ParameterExtendedStatusWidget instantiated for a device called G:AMANDA with 1 bit defined
      final app = MaterialApp(
          home: Scaffold(
              body: ParameterExtendedStatusWidget(
                  drf: "G:AMANDA", digitalStatus: allBits)));

      // When I display the extended status
      await tester.pumpWidget(app);

      // Then only one bit is displayed
      assertNumberOfBitsDisplayed(forDRF: "G:AMANDA", isN: 6);

      // ... and the details of bit 0 are...
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 0,
          description: "Henk On/Off",
          valueText: "On",
          valueColor: Colors.green,
          value: "1");
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 1,
          description: "Ready???",
          valueText: "Always",
          valueColor: Colors.green,
          value: "1");
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 2,
          description: "Remote Henk",
          valueText: "L",
          valueColor: Colors.blue,
          value: "0");
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 3,
          description: "Polarity",
          valueText: "Mono",
          valueColor: Colors.red,
          value: "0");
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 4,
          description: " test 2",
          valueText: " good",
          valueColor: Colors.green,
          value: "0");
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 5,
          description: "testtest",
          valueText: "GOOD",
          valueColor: Colors.green,
          value: "0");
    });

    testWidgets(
        'Parameter with 6 empty bits of extended status, shows dots for descriptions',
        (WidgetTester tester) async {
      // Given a ParameterExtendedStatusWidget instantiated for a device called G:AMANDA with undefined bits
      final app = MaterialApp(
          home: Scaffold(
              body: ParameterExtendedStatusWidget(
                  drf: "G:AMANDA", digitalStatus: emptyBits)));

      // When I display the extended status
      await tester.pumpWidget(app);

      // Then the description and value text show dots and the color is grey
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 0,
          description: "...",
          valueText: "...",
          value: "1");
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 1,
          description: "...",
          valueText: "...",
          value: "1");
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 2,
          description: "...",
          valueText: "...",
          value: "0");
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 3,
          description: "...",
          valueText: "...",
          value: "0");
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 4,
          description: "...",
          valueText: "...",
          value: "0");
      assertBitDetails(tester,
          forDRF: "G:AMANDA",
          bitNumber: 5,
          description: "...",
          valueText: "...",
          value: "0");
    });
  });
}
