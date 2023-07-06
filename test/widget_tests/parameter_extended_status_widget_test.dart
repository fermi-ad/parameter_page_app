import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/dpm_service.dart';
import 'package:parameter_page/widgets/parameter_extended_status_widget.dart';

void main() {
  DigitalStatus singleBitStatus = DigitalStatus(
      refId: 0,
      cycle: 0,
      timestamp: DateTime(2023),
      extendedStatus: [
        const ExtendedStatusAttribute(
            description: "Henk On/Off", value: "On", color: StatusColor.green)
      ]);
  void assertBitDisplayShows(
      {required int bitNumber,
      required String description,
      required String valueText,
      required Color valueColor,
      required String value}) {}
  group("ParameterExtendedStatusWidget", () {
    testWidgets('First test...', (WidgetTester tester) async {
      // Given a ParameterExtendedStatusWidget instantiated for a device called G:AMANDA with 1 bit defined
      final app = MaterialApp(
          home: Scaffold(
              body: ParameterExtendedStatusWidget(
                  drf: "G:AMANDA", digitalStatus: singleBitStatus)));

      // When I display the extended status
      await tester.pumpWidget(app);

      // Then an entry for bit 0 is displayed...
      assertBitDisplayShows(
          bitNumber: 0,
          description: "Henk On/Off",
          valueText: "On",
          valueColor: Colors.green,
          value: "1");
    });
  });
}
