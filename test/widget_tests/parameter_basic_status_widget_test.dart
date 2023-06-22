import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/dpm_service.dart';
import 'package:parameter_page/widgets/parameter_basic_status_widget.dart';

void main() {
  void assertBasicStatus(tester,
      {required String forDRF,
      required String property,
      required bool isVisible,
      String? characterIs,
      Color? withColor}) {
    expect(find.byKey(Key("parameter_basicstatus_$forDRF")),
        isVisible ? findsOneWidget : findsNothing);
  }

  group("ParameterBasicStatusWidget", () {
    late MaterialApp app;

    setUp(() {
      app = MaterialApp(
          home: Scaffold(
              body: ParameterBasicStatusWidget(
                  drf: "G:AMANDA",
                  digitalStatus: DigitalStatus(
                      refId: 0,
                      cycle: 0,
                      timestamp: DateTime(2023),
                      onOff: const BasicStatusAttribute(
                          character: ".", color: StatusColor.green),
                      readyTripped: const BasicStatusAttribute(
                          character: "T", color: StatusColor.red),
                      remoteLocal: const BasicStatusAttribute(
                          character: "L", color: StatusColor.blue),
                      positiveNegative: const BasicStatusAttribute(
                          character: "T", color: StatusColor.magenta)))));
    });

    testWidgets('Pass all attributes, display all attributes',
        (WidgetTester tester) async {
      // Given a ParameterBasicStatusWidget instantiated for a device called G:AMANDA with all of it's basic status properties filled in

      // When I display the basic status
      await tester.pumpWidget(app);

      // Then all of the attributes are displayed
      assertBasicStatus(tester,
          forDRF: "G:AMANDA",
          property: "onOff",
          isVisible: true,
          characterIs: ".",
          withColor: Colors.green);
      assertBasicStatus(tester,
          forDRF: "G:AMANDA",
          property: "readyTripped",
          isVisible: true,
          characterIs: "T",
          withColor: Colors.red);
      assertBasicStatus(tester,
          forDRF: "G:AMANDA",
          property: "remoteLocal",
          isVisible: true,
          characterIs: "L",
          withColor: Colors.blue);
      assertBasicStatus(tester,
          forDRF: "G:AMANDA",
          property: "positiveNegative",
          isVisible: true,
          characterIs: ".",
          withColor: Colors.pink);
    });
  });
}
