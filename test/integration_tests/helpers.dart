import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pump();

    final found = tester.any(finder);
    if (found) {
      timerDone = true;
    }
  }
  timer.cancel();
}

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
    final settingValueFinder = find.text(settingValue);
    expect(
        find.descendant(of: row, matching: settingValueFinder), findsOneWidget);
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
}

void assertUndo(
    {required String forDRF, required bool isVisible, String? isValue}) {}

void assertSettingTextInput({required String forDRF, required bool isVisible}) {
  expect(find.byKey(Key("parameter_settinginput_$forDRF")),
      isVisible ? findsOneWidget : findsNothing);
}

Future<void> waitForDataToLoadFor(tester, parameter) async {
  final readingFinder = find.byKey(Key("parameter_reading_$parameter"));
  await pumpUntilFound(tester, readingFinder);

  final settingFinder = find.byKey(Key("parameter_setting_$parameter"));
  await pumpUntilFound(tester, settingFinder);
}

Future<void> waitForExtendedStatusDataToLoadFor(tester, parameter) async {
  final extendedStatusFinder =
      find.byKey(Key("parameter_extendeddigitalstatus_$parameter"));
  await pumpUntilFound(tester, extendedStatusFinder);
}

Future<void> enterEditMode(tester) async {
  await tester.tap(find.byKey(const Key("enable_edit_mode_button")));
  await tester.pumpAndSettle();
}

Future<void> exitEditMode(tester) async {
  await tester.tap(find.byKey(const Key("enable_edit_mode_button")));
  await tester.pumpAndSettle();
}

Future<void> cancelEditMode(tester) async {
  await tester.tap(find.byKey(const Key("cancel_edit_mode_button")));
  await tester.pumpAndSettle();
}

Future<void> deleteRow(tester,
    {required int index, bool confirm = true}) async {
  final trashCansFinder = find.byIcon(Icons.delete);

  await pumpUntilFound(tester, trashCansFinder);

  if (trashCansFinder.evaluate().isEmpty) {
    fail("No delete buttons found.");
  }

  final rowHandleFinder =
      trashCansFinder.evaluate().isEmpty ? null : trashCansFinder.at(index);

  if (rowHandleFinder == null) {
    fail("No delete buttons found at index $index.");
  }

  await tester.tap(rowHandleFinder);
  await tester.pumpAndSettle();

  if (confirm) {
    await tester.tap(find.text("OK"));
  } else {
    await tester.tap(find.text("Cancel"));
  }

  await tester.pumpAndSettle();
}

Future<void> addANewComment(tester, String comment) async {
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('add-entry-textfield')), comment);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<void> addANewParameter(tester, String parameter) async {
  await tester.pumpAndSettle();
  await tester.enterText(
      find.byKey(const Key('add-entry-textfield')), parameter);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<void> moveRowAtIndexNRowsUp(tester, int rowIndex, int nRowsUp) async {
  final handlesFinder = find.byIcon(Icons.drag_handle);

  await pumpUntilFound(tester, handlesFinder);

  if (handlesFinder.evaluate().isEmpty) {
    fail("No drag handles found.");
  }

  final rowHandleFinder =
      handlesFinder.evaluate().isEmpty ? null : handlesFinder.at(rowIndex);

  if (rowHandleFinder == null) {
    fail("No drag handles found at index $rowIndex.");
  }

  final dragOffset = Offset(0.0, -(nRowsUp * 40.0));
  await tester.drag(rowHandleFinder, dragOffset);
  await tester.pumpAndSettle();
}

Future<void> moveRowAtIndexNRowsDown(
    tester, int rowIndex, int nRowsDown) async {
  return await moveRowAtIndexNRowsUp(tester, rowIndex, -nRowsDown);
}

Future<void> clearAll(tester) async {
  await tester.tap(find.byKey(const Key("clear_all_entries_button")));
  await tester.pumpAndSettle();
}

Future<void> newPage(tester, {bool? confirmDiscardChanges}) async {
  await _openMainMenu(tester);
  await tester.tap(find.text("New Page"));
  await tester.pumpAndSettle();

  if (confirmDiscardChanges != null) {
    if (confirmDiscardChanges) {
      await tester.tap(find.text("Continue"));
    } else {
      await tester.tap(find.text("Cancel"));
    }
    await tester.pumpAndSettle();
  }
}

Future<void> navigateToDisplaySettings(tester) async {
  await tester.tap(find.byKey(const Key("display_settings_button")));
  await tester.pumpAndSettle();
}

Future<void> navigateBackwards(tester) async {
  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();
}

Future<void> changeDisplaySettingsUnits(tester, {required String to}) async {
  await tester.tap(find.byKey(const Key("display_settings_tile_units")));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key("display_settings_tile_units_menuitem_$to")));
  await tester.pumpAndSettle();
}

Future<void> toggleShowAlarmDetails(tester) async {
  await tester
      .tap(find.byKey(const Key("display_settings_tile_alarm_details")));
  await tester.pumpAndSettle();
}

Future<void> tapPageEntry(tester, {required int atRowIndex}) async {
  final rowsFinder = find.byType(PageEntryWidget);

  await pumpUntilFound(tester, rowsFinder);

  if (rowsFinder.evaluate().isEmpty) {
    fail("No page entries found.");
  }

  final rowFinder =
      rowsFinder.evaluate().isEmpty ? null : rowsFinder.at(atRowIndex);

  await tester.tap(rowFinder);
}

Future<void> expandDigitalStatus(tester, {required String forDRF}) async {
  await tester.tap(find.byKey(Key("parameter_expanddigitalstatus_$forDRF")));
  await tester.pumpAndSettle();
}

Future<void> collapseDigitalStatus(tester, {required String forDRF}) async {
  await tester.tap(find.byKey(Key("parameter_collapsedigitalstatus_$forDRF")));
  await tester.pumpAndSettle();
}

Future<void> navigateToOpenPage(tester) async {
  await _openMainMenu(tester);
  await tester.tap(find.text('Open Page'));
  await tester.pumpAndSettle();
}

Future<void> _openMainMenu(tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
}

Future<void> tapSetting(tester, {required String forDRF}) async {
  await tester.tap(find.byKey(Key("parameter_setting_$forDRF")));
  await tester.pumpAndSettle();
}
