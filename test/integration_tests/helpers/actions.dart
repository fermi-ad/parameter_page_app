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

Future<void> waitForMainPageToLoad(tester) async {
  await pumpUntilFound(tester, find.byKey(const Key("parameter_page_layout")));
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

Future<void> waitForSettingDataToLoad(tester, {required String forDRF}) async {
  final settingFinder = find.byKey(Key("parameter_settingdisplay_$forDRF"));
  await pumpUntilFound(tester, settingFinder);
}

Future<void> waitForSettingErrorToBeReturned(tester,
    {required String forDRF}) async {
  final settingFinder = find.byKey(Key("parameter_settingerror_$forDRF"));
  await pumpUntilFound(tester, settingFinder);
}

Future<void> waitForUndoToDisplay(tester, {required String forDRF}) async {
  final settingFinder = find.byKey(Key("parameter_settingundo_$forDRF"));
  await pumpUntilFound(tester, settingFinder);
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

Future<void> submitSetting(tester,
    {required String forDRF, required String newValue}) async {
  await tester.enterText(
      find.descendant(
          of: find.byKey(Key("parameter_setting_$forDRF")),
          matching: find.byType(TextFormField)),
      newValue);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<void> undoSetting(tester, {required String forDRF}) async {
  await tester.tap(find.byKey(Key("parameter_settingundo_$forDRF")));
  await tester.pumpAndSettle();
}

Future<void> cancelSetting(tester, {required String forDRF}) async {
  await tester.tap(find.descendant(
      of: find.byKey(Key("parameter_setting_$forDRF")),
      matching: find.byIcon(Icons.cancel)));
  await tester.pumpAndSettle();
}