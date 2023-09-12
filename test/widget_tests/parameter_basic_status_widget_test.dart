import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/services/dpm/dpm_service.dart';
import 'package:parameter_page/widgets/parameter_basic_status_widget.dart';

void main() {
  final allBasicStatus = DigitalStatus(
      refId: 0,
      cycle: 0,
      timestamp: DateTime(2023),
      onOff:
          const BasicStatusAttribute(character: ".", color: StatusColor.green),
      readyTripped:
          const BasicStatusAttribute(character: "T", color: StatusColor.red),
      remoteLocal:
          const BasicStatusAttribute(character: "L", color: StatusColor.blue),
      positiveNegative: const BasicStatusAttribute(
          character: "T", color: StatusColor.magenta));

  final readyTrippedBasicStatus = DigitalStatus(
    refId: 0,
    cycle: 0,
    timestamp: DateTime(2023),
    readyTripped:
        const BasicStatusAttribute(character: ".", color: StatusColor.green),
  );

  void assertBasicStatus(tester,
      {required String forDRF,
      required String property,
      required bool isVisible,
      String? characterIs,
      Color? withColor}) {
    final propertyFinder =
        find.byKey(Key("parameter_basicstatus_${property}_$forDRF"));
    expect(propertyFinder, isVisible ? findsOneWidget : findsNothing);

    if (characterIs != null) {
      final characterFinder =
          find.descendant(of: propertyFinder, matching: find.text(characterIs));
      expect(characterFinder, findsOneWidget);

      if (withColor != null) {
        final characterText = tester.widget<Text>(characterFinder);
        expect(characterText.style.color, withColor);
      }
    }
  }

  void assertBasicStatusLabels({required bool areVisible}) {
    expect(find.text("On/Off: "), areVisible ? findsOneWidget : findsNothing);
    expect(find.text("Ready/Tripped: "),
        areVisible ? findsOneWidget : findsNothing);
    expect(find.text("Remote/Local: "),
        areVisible ? findsOneWidget : findsNothing);
    expect(find.text("Positive/Negative: "),
        areVisible ? findsOneWidget : findsNothing);
  }

  group("ParameterBasicStatusWidget", () {
    testWidgets(
        'Ready/Tripped basic status present, displays Ready/Tripped and nothing else',
        (WidgetTester tester) async {
      // Given a ParameterBasicStatusWidget instantiated for a device called G:AMANDA with only ready/tripped basic status
      final app = MaterialApp(
          home: Scaffold(
              body: ParameterBasicStatusWidget(
                  drf: "G:AMANDA", digitalStatus: readyTrippedBasicStatus)));
      // When I display the basic status
      await tester.pumpWidget(app);

      // Then all of the attributes are displayed along with their labels
      assertBasicStatus(tester,
          forDRF: "G:AMANDA", property: "onoff", isVisible: false);
      assertBasicStatus(tester,
          forDRF: "G:AMANDA",
          property: "readytripped",
          isVisible: true,
          characterIs: ".",
          withColor: Colors.green);
      assertBasicStatus(tester,
          forDRF: "G:AMANDA", property: "remotelocal", isVisible: false);
      assertBasicStatus(tester,
          forDRF: "G:AMANDA", property: "positivenegative", isVisible: false);
    });
    testWidgets('All attributes present, display all attributes',
        (WidgetTester tester) async {
      // Given a ParameterBasicStatusWidget instantiated for a device called G:AMANDA with all of it's basic status properties filled in
      final app = MaterialApp(
          home: Scaffold(
              body: ParameterBasicStatusWidget(
                  drf: "G:AMANDA", digitalStatus: allBasicStatus)));
      // When I display the basic status
      await tester.pumpWidget(app);

      // Then all of the attributes are displayed
      assertBasicStatus(tester,
          forDRF: "G:AMANDA",
          property: "onoff",
          isVisible: true,
          characterIs: ".",
          withColor: Colors.green);
      assertBasicStatus(tester,
          forDRF: "G:AMANDA",
          property: "readytripped",
          isVisible: true,
          characterIs: "T",
          withColor: Colors.red);
      assertBasicStatus(tester,
          forDRF: "G:AMANDA",
          property: "remotelocal",
          isVisible: true,
          characterIs: "L",
          withColor: Colors.blue);
      assertBasicStatus(tester,
          forDRF: "G:AMANDA",
          property: "positivenegative",
          isVisible: true,
          characterIs: "T",
          withColor: Colors.pink);
      assertBasicStatusLabels(areVisible: true);
    });

    testWidgets('When wide = false, labels are displayed',
        (WidgetTester tester) async {
      // Given a ParameterBasicStatusWidget instantiated for a device called G:AMANDA
      // with all of it's basic status properties filled in
      // and wide set to false
      final app = MaterialApp(
          home: Scaffold(
              body: ParameterBasicStatusWidget(
                  drf: "G:AMANDA",
                  digitalStatus: allBasicStatus,
                  wide: false)));

      // When I display the basic status
      await tester.pumpWidget(app);

      // Then all of the attributes are displayed
      // ... and the attribute labels are visible
      assertBasicStatusLabels(areVisible: true);
    });
  });
}
