import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';

void assertIsOnPage({required String comment}) {
  expect(find.text(comment), findsOneWidget);
}

void assertIsNotOnPage({required String comment}) {
  expect(find.text(comment), findsNothing);
}

void assertParametersAreOnPage(List<String> parameters) {
  for (var parameter in parameters) {
    expect(find.text(parameter), findsOneWidget);
  }
}

void assertParametersAreNotOnPage(List<String> parameters) {
  for (var parameter in parameters) {
    expect(find.text(parameter), findsNothing);
  }
}

void assertParameterHasDetails(String parameter,
    {String? description,
    String? settingValue,
    String? settingUnits,
    String? readingValue,
    String? readingUnits}) {
  final row = find.byKey(Key("parameter_row_$parameter"));

  final parameterFinder = find.text(parameter);
  expect(find.descendant(of: row, matching: parameterFinder), findsOneWidget);

  if (description != null) {
    final descriptionFinder = find.text(description);
    expect(
        find.descendant(of: row, matching: descriptionFinder), findsOneWidget);
  }

  if (readingValue != null) {
    final readingValueFinder = find.text(readingValue);
    expect(
        find.descendant(of: row, matching: readingValueFinder), findsOneWidget);
  }

  if (readingUnits != null) {
    final reading = find.byKey(Key("parameter_reading_$parameter"));
    expect(find.descendant(of: reading, matching: find.text(readingUnits)),
        findsOneWidget);
  }

  if (settingValue != null) {
    final settingFinder =
        find.byKey(Key("parameter_settingdisplay_$parameter"));
    expect(
        find.descendant(of: settingFinder, matching: find.text(settingValue)),
        findsOneWidget);
  }

  if (settingUnits != null) {
    final setting = find.byKey(Key("parameter_setting_$parameter"));
    expect(find.descendant(of: setting, matching: find.text(settingUnits)),
        findsOneWidget);
  }
}

void assertAlarmValues(
    {required String forDRF,
    required String nominal,
    required String tolerance,
    required String min,
    required String max}) {
  assertAlarmDetails(forDRF: forDRF, areVisible: true);
  expect(
      find.descendant(
          of: find.byKey(Key("parameter_alarm_nominal_$forDRF")),
          matching: find.text(nominal)),
      findsOneWidget);
}

void assertAlarmDetails({required String forDRF, required bool areVisible}) {
  expect(find.byKey(Key("parameter_alarm_nominal_$forDRF")),
      areVisible ? findsOneWidget : findsNothing);
  expect(find.byKey(Key("parameter_alarm_tolerance_$forDRF")),
      areVisible ? findsOneWidget : findsNothing);
  expect(find.byKey(Key("parameter_alarm_min_$forDRF")),
      areVisible ? findsOneWidget : findsNothing);
  expect(find.byKey(Key("parameter_alarm_max_$forDRF")),
      areVisible ? findsOneWidget : findsNothing);
}

void assertParameterIsInRow(String parameter, int isInRow) {
  final rowFinder = find.byType(PageEntryWidget);
  final row = rowFinder.evaluate().isEmpty ? null : rowFinder.at(isInRow);

  if (row == null) {
    fail("No parameter found at row #$isInRow");
  }

  expect(
      find.descendant(of: row, matching: find.text(parameter)), findsOneWidget,
      reason:
          "expected $parameter in row $isInRow but something else was there.");
}

void assertEditModeCancelButton({required bool isVisible}) {
  expect(find.byKey(const Key("cancel_edit_mode_button")),
      isVisible ? findsOneWidget : findsNothing);
}

void assertClearAllButton({required bool isVisible}) {
  expect(find.byKey(const Key("clear_all_entries_button")),
      isVisible ? findsOneWidget : findsNothing);
}

void assertNumberOfEntriesOnPageIs(int n) {
  final finder = find.byType(PageEntryWidget);
  expect(finder.evaluate().length, n);
}

void assertConfirmDeleteDialog({required bool isVisible}) {
  expect(find.text("Are you sure you want to delete this row?"),
      isVisible ? findsOneWidget : findsNothing);
}

void assertConfirmThrowAwayDialog({required bool isVisible}) {
  expect(
      find.text(
          "This page has unsaved changes that will be discarded.  Do you wish to continue?"),
      isVisible ? findsOneWidget : findsNothing);
}

void assertDisplaySettingsShowAlarmDetails({required bool isOn}) {
  final displayAlarmDetailsTile =
      find.byKey(const Key("display_settings_tile_alarm_details"));
  expect(
      find.descendant(
          of: displayAlarmDetailsTile,
          matching: find
              .text("Show Parameter Alarm Details (${isOn ? "on" : "off"})")),
      findsOneWidget);
}

void assertDisplaySettingsUnits({required String isSetTo}) {
  final displayUnitsTile = find.byKey(const Key("display_settings_tile_units"));
  expect(find.descendant(of: displayUnitsTile, matching: find.text(isSetTo)),
      findsOneWidget);
}

void assertDisplaySettings({required bool isVisible}) {
  expect(find.byKey(const Key("display_settings_appbar")),
      isVisible ? findsOneWidget : findsNothing);
}

void assertBasicStatus({required String forDRF, required bool isVisible}) {
  expect(find.byKey(Key("parameter_basicstatus_$forDRF")),
      isVisible ? findsOneWidget : findsNothing);
}

void assertOnOffStatus(tester,
    {required String forDRF,
    required String isCharacter,
    required Color withColor}) {
  _assertBasicStatusCharacter(tester,
      forDRF: forDRF,
      forType: "onoff",
      isCharacter: isCharacter,
      withColor: withColor);
}

void _assertBasicStatusCharacter(tester,
    {required String forDRF,
    required String forType,
    required String isCharacter,
    required Color withColor}) {
  final onOffFinder =
      find.byKey(Key("parameter_basicstatus_${forType}_$forDRF"));
  expect(onOffFinder, findsOneWidget);

  final onOffCharacterFinder =
      find.descendant(of: onOffFinder, matching: find.text(isCharacter));
  expect(onOffCharacterFinder, findsOneWidget);

  final characterText = tester.widget<Text>(onOffCharacterFinder);
  expect(characterText.style.color, withColor);
}

void assertReadyTrippedStatus(tester,
    {required String forDRF,
    required String isCharacter,
    required Color withColor}) {
  _assertBasicStatusCharacter(tester,
      forDRF: forDRF,
      forType: "readytripped",
      isCharacter: isCharacter,
      withColor: withColor);
}

void assertRemoteLocalStatus(tester,
    {required String forDRF,
    required String isCharacter,
    required Color withColor}) {
  _assertBasicStatusCharacter(tester,
      forDRF: forDRF,
      forType: "remotelocal",
      isCharacter: isCharacter,
      withColor: withColor);
}

void assertPositiveNegativeStatus(tester,
    {required String forDRF,
    required String isCharacter,
    required Color withColor}) {
  _assertBasicStatusCharacter(tester,
      forDRF: forDRF,
      forType: "positivenegative",
      isCharacter: isCharacter,
      withColor: withColor);
}

void assertExpandDigitalStatusIcon(
    {required String forDRF, required bool isVisible}) {
  final row = find.byKey(Key("parameter_row_$forDRF"));

  final expandIconFinder = find.byIcon(Icons.expand_more);
  expect(find.descendant(of: row, matching: expandIconFinder),
      isVisible ? findsOneWidget : findsNothing);
}

void assertCollapseDigitalStatusIcon(
    {required String forDRF, required bool isVisible}) {
  final row = find.byKey(Key("parameter_row_$forDRF"));

  final collapseIconFinder = find.byIcon(Icons.expand_less);
  expect(find.descendant(of: row, matching: collapseIconFinder),
      isVisible ? findsOneWidget : findsNothing);
}

void assertExtendedDigitalStatusDisplay(tester,
    {required String forDRF,
    required bool isVisible,
    List<String>? hasDescriptions,
    List<String>? hasDisplayValues,
    List<String>? hasBinaryValues,
    List<Color>? hasColors}) {
  final extendedDigitalStatusFinder =
      find.byKey(Key("parameter_extendeddigitalstatus_$forDRF"));

  expect(
      extendedDigitalStatusFinder, isVisible ? findsOneWidget : findsNothing);

  if (hasDescriptions != null) {
    for (int i = 0; i != hasDescriptions.length; i++) {
      final bitDetailFinder =
          find.byKey(Key("parameter_extendeddigitalstatus_${forDRF}_bit$i"));
      expect(
          find.descendant(
              of: bitDetailFinder, matching: find.text(hasDescriptions[i])),
          findsAtLeastNWidgets(1));
    }
  }

  if (hasDisplayValues != null) {
    for (int i = 0; i != hasDisplayValues.length; i++) {
      final bitDetailFinder =
          find.byKey(Key("parameter_extendeddigitalstatus_${forDRF}_bit$i"));
      expect(
          find.descendant(
              of: bitDetailFinder, matching: find.text(hasDisplayValues[i])),
          findsAtLeastNWidgets(1));
    }
  }

  if (hasBinaryValues != null) {
    for (int i = 0; i != hasBinaryValues.length; i++) {
      final bitDetailFinder =
          find.byKey(Key("parameter_extendeddigitalstatus_${forDRF}_bit$i"));
      expect(
          find.descendant(
              of: bitDetailFinder, matching: find.text(hasBinaryValues[i])),
          findsOneWidget);
    }
  }

  if (hasColors != null && hasDisplayValues != null) {
    for (int i = 0; i != hasColors.length; i++) {
      final bitDetailFinder =
          find.byKey(Key("parameter_extendeddigitalstatus_${forDRF}_bit$i"));
      final displayValueTextFinder = find.descendant(
          of: bitDetailFinder, matching: find.text(hasDisplayValues[i]));
      expect(displayValueTextFinder, findsAtLeastNWidgets(1));
      final displayValueText = tester.firstWidget<Text>(displayValueTextFinder);
      expect(displayValueText.style.color, hasColors[i]);
    }
  }
}

void assertOpenPage({required bool isVisible}) {
  expect(find.byKey(const Key("open_page_appbar")),
      isVisible ? findsOneWidget : findsNothing);

  expect(find.text("Open Parameter Page"),
      isVisible ? findsOneWidget : findsNothing);
}

void assertUndo(
    {required String forDRF, required bool isVisible, String? isValue}) {
  expect(find.byKey(Key("parameter_settingundo_$forDRF")),
      isVisible ? findsOneWidget : findsNothing);
  if (isVisible && isValue != null) {
    expect(
        find.descendant(
            of: find.byKey(Key("parameter_settingundo_$forDRF")),
            matching: find.text(isValue)),
        findsOneWidget);
  }
}

void assertSettingError(
    {required String forDRF,
    required bool isVisible,
    int? facilityCode,
    int? errorCode}) {
  expect(find.byKey(Key("parameter_settingerror_$forDRF")),
      isVisible ? findsOneWidget : findsNothing);

  if (isVisible && facilityCode != null && errorCode != null) {
    expect(
        find.descendant(
            of: find.byKey(Key("parameter_setting_$forDRF")),
            matching: find.text("$facilityCode $errorCode")),
        findsOneWidget);
  }
}

void assertSettingTextInput({required String forDRF, required bool isVisible}) {
  expect(find.byKey(Key("parameter_settinginput_$forDRF")),
      isVisible ? findsOneWidget : findsNothing);
}

void assertCommandButtons(
    {required bool areVisible,
    required String forDRF,
    required List<String> withText}) {
  for (String commandText in withText) {
    expect(
        find.descendant(
            of: find.byKey(Key("parameter_commands_$forDRF")),
            matching: find.text(commandText)),
        areVisible ? findsOneWidget : findsNothing);
  }
}

void assertOpenPageList({required List<String> containsTitles}) {
  for (String title in containsTitles) {
    expect(
        find.descendant(
            of: find.byKey(const Key("open_page_pages_listview")),
            matching: find.text(title)),
        findsOneWidget);
  }
}
