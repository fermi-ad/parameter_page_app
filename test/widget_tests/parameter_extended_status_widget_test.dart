import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/dpm_service.dart';
import 'package:parameter_page/widgets/parameter_extended_status_widget.dart';

void main() {
  DigitalStatus allBits = DigitalStatus(
      refId: 0,
      cycle: 0,
      timestamp: DateTime(2023),
      extendedStatus: [
        const ExtendedStatusAttribute(
            description: "Henk On/Off",
            value: "1",
            valueText: "On",
            color: StatusColor.green),
        const ExtendedStatusAttribute(
            description: "Ready???",
            value: "1",
            valueText: "Always",
            color: StatusColor.green),
        const ExtendedStatusAttribute(
            description: "Remote Henk",
            value: "0",
            valueText: "L",
            color: StatusColor.blue),
        const ExtendedStatusAttribute(
            description: "Polarity",
            value: "0",
            valueText: "Mono",
            color: StatusColor.red),
        const ExtendedStatusAttribute(
            description: " test 2",
            value: "0",
            valueText: "good",
            color: StatusColor.green),
        const ExtendedStatusAttribute(
            description: "testtest",
            value: "0",
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
            value: "1",
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
      required Color valueColor,
      required String value}) {
    final bitRowFinder = find
        .byKey(Key("parameter_extendeddigitalstatus_${forDRF}_bit$bitNumber"));
    expect(bitRowFinder, findsOneWidget);

    expect(find.descendant(of: bitRowFinder, matching: find.text(description)),
        findsOneWidget);

    expect(find.descendant(of: bitRowFinder, matching: find.text(valueText)),
        findsOneWidget);

    expect(find.descendant(of: bitRowFinder, matching: find.text(value)),
        findsOneWidget);

    final displayValueTextFinder =
        find.descendant(of: bitRowFinder, matching: find.text(valueText));
    expect(displayValueTextFinder, findsOneWidget);
    final displayValueText = tester.widget<Text>(displayValueTextFinder);
    expect(displayValueText.style.color, valueColor);
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
    });
  });
}
