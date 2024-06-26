import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';
import 'package:parameter_page/widgets/landing_page_widget.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';
import 'package:parameter_page/widgets/parameter_page_scaffold_widget.dart';

Future<void> pumpUntilGone(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pumpAndSettle();

    final found = tester.any(finder);
    if (!found) {
      timerDone = true;
    }
  }
  timer.cancel();
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  bool timerDone = false;
  final timer = Timer(timeout, () => timerDone = true);
  while (timerDone != true) {
    await tester.pumpAndSettle();

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

  final analogAlarmFinder = find.byKey(Key("parameter_analogalarm_$parameter"));
  await pumpUntilFound(tester, analogAlarmFinder);
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

Future<void> waitForPageToBeSaved(tester) async {
  final indicatorFinder = find.byKey(const Key("page_saved_indicator"));
  await pumpUntilFound(tester, indicatorFinder);
}

Future<void> waitForPageSaveToFail(tester) async {
  final indicatorFinder = find.byKey(const Key("page_save_failed_indicator"));
  await pumpUntilFound(tester, indicatorFinder);
}

Future<void> waitForAlarmToGoAway(WidgetTester tester,
    {required String forDRF}) async {
  final parameterFinder = find.byKey(Key("parameter_analogalarm_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications_active));
  await pumpUntilGone(tester, alarmIndicatorFinder);
}

Future<void> waitForDigitalAlarmToGoAway(WidgetTester tester,
    {required String forDRF}) async {
  final parameterFinder = find.byKey(Key("parameter_digitalalarm_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications_active));
  await pumpUntilGone(tester, alarmIndicatorFinder);
}

Future<void> waitForDeviceToAlarm(WidgetTester tester,
    {required String forDRF}) async {
  final parameterFinder = find.byKey(Key("parameter_analogalarm_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications_active));
  await pumpUntilFound(tester, alarmIndicatorFinder);
}

Future<void> waitForDeviceToAlarmDigital(WidgetTester tester,
    {required String forDRF}) async {
  final parameterFinder = find.byKey(Key("parameter_digitalalarm_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications_active));
  await pumpUntilFound(tester, alarmIndicatorFinder);
}

Future<void> waitForDeviceAlarmByPassed(WidgetTester tester,
    {required String forDRF}) async {
  final parameterFinder = find.byKey(Key("parameter_analogalarm_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications_off));
  await pumpUntilFound(tester, alarmIndicatorFinder);
}

Future<void> waitForDeviceAlarmByPassedDigital(WidgetTester tester,
    {required String forDRF}) async {
  final parameterFinder = find.byKey(Key("parameter_digitalalarm_$forDRF"));
  final alarmIndicatorFinder = find.descendant(
      of: parameterFinder, matching: find.byIcon(Icons.notifications_off));
  await pumpUntilFound(tester, alarmIndicatorFinder);
}

Future<void> waitForDigitalBeamInhibitIndicator(WidgetTester tester,
    {required String forDRF}) async {
  final containerFinder =
      find.byKey(Key("parameter_digitalalarm_beaminhibit_$forDRF"));
  final indicatorFinder = find.descendant(
      of: containerFinder, matching: find.byIcon(Icons.stop_circle));
  await pumpUntilFound(tester, indicatorFinder);
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

Future<void> deleteRow(tester, {required int index}) async {
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
}

Future<void> addANewEntry(tester, String input) async {
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('new_entry_textfield')));
  await tester.enterText(find.byKey(const Key('new_entry_textfield')), input);
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
  await openMainMenu(tester);
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
  await tester.pumpAndSettle();
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
  await openMainMenu(tester);
  await tester.tap(find.text('Open Page'));
  await tester.pumpAndSettle();
}

Future<void> openMainMenu(tester) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
}

Future<void> closeMainMenu(tester) async {
  if (find.byType(LandingPageWidget).evaluate().isNotEmpty) {
    await tester.tap(find.byType(LandingPageWidget));
  } else {
    await tester.tap(find.byType(ParameterPageScaffoldWidget));
  }
  await tester.pumpAndSettle();
}

Future<void> tapSetting(tester, {required String forDRF}) async {
  await tester.tap(find.byKey(Key("parameter_settingdisplay_$forDRF")));
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

Future<void> openParameterPage(WidgetTester tester,
    {required String withTitle}) async {
  await tester.tap(find.descendant(
      of: find.byType(ListTile), matching: find.text(withTitle)));
  await tester.pumpAndSettle();
}

Future<void> saveParameterPage(WidgetTester tester) async {
  await tester.tap(
      find.descendant(of: find.byType(ListTile), matching: find.text("Save")));
  await tester.pumpAndSettle();
}

Future<void> addPage(WidgetTester tester, {required String title}) async {
  await tester.tap(find.text('<Add page title>'));
  await tester.pumpAndSettle();

  await pumpUntilFound(tester, find.byKey(const Key("add_page_title")));
  await tester.enterText(find.byKey(const Key("add_page_title")), title);
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();

  await waitForNewPageToAppearInList(tester, withTitle: title);
}

Future<void> waitForNewPageToAppearInList(WidgetTester tester,
    {required String withTitle}) async {
  await pumpUntilFound(
      tester,
      find.descendant(
          of: find.byKey(const Key("open_page_pages_listview")),
          matching: find.text(withTitle)),
      timeout: const Duration(seconds: 10));
  await tester.pumpAndSettle();
}

Future<void> deletePage(WidgetTester tester,
    {required String withTitle}) async {
  final listTileFinder =
      find.ancestor(of: find.text(withTitle), matching: find.byType(ListTile));
  final deleteIconFinder =
      find.descendant(of: listTileFinder, matching: find.byIcon(Icons.delete));
  await tester.tap(deleteIconFinder);
  await tester.pumpAndSettle();
}

Future<void> navigateToTestPage1(WidgetTester tester) async {
  await tester.tap(find.text("Open a Parameter Page"));
  await tester.pumpAndSettle();
  await openParameterPage(tester, withTitle: "Test Page 1");
  await waitForMainPageToLoad(tester);
}

Future<void> createNewParameterPage(WidgetTester tester) async {
  await tester.tap(find.text("Create a New Parameter Page"));
  await tester.pumpAndSettle();
}

Future<void> changePageTitle(WidgetTester tester, {required String to}) async {
  await tester.tap(find.byKey(const Key("page_title")));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key("page_title_textfield")), to);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<void> switchTab(WidgetTester tester, {required String to}) async {
  await tester
      .tap(find.descendant(of: find.byType(Tab), matching: find.text(to)));
  await tester.pumpAndSettle();
}

Future<void> createNewTab(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key("create_tab_button")));
  await tester.pumpAndSettle();
}

Future<void> openTabEditMenu(WidgetTester tester,
    {required String forTabWithTitle}) async {
  final tabFinder =
      find.ancestor(of: find.text(forTabWithTitle), matching: find.byType(Tab));
  await tester.tap(
      find.descendant(of: tabFinder, matching: find.byIcon(Icons.more_vert)));
  await tester.pumpAndSettle();
}

Future<void> deleteTab(WidgetTester tester,
    {required String withTitle, bool? confirm}) async {
  await openTabEditMenu(tester, forTabWithTitle: withTitle);

  await tester.tap(find.text("Delete"));
  await tester.pumpAndSettle();

  if (confirm != null) {
    await tester.tap(confirm ? find.text("Continue") : find.text("Cancel"));
    await tester.pumpAndSettle();
  }
}

Future<void> renameTab(WidgetTester tester,
    {required String withTitle, required String to}) async {
  await openTabEditMenu(tester, forTabWithTitle: withTitle);

  await tester.tap(find.text("Rename"));
  await tester.pumpAndSettle();

  await tester.enterText(find.byKey(const Key("tab_edit_rename_to")), to);
  await tester.tap(find.text("OK"));
  await tester.pumpAndSettle();
}

Future<void> navigateSubPageBackwards(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.navigate_before));
  await tester.pumpAndSettle();
}

Future<void> navigateSubPageForward(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.navigate_next));
  await tester.pumpAndSettle();
}

Future<void> navigateDirectlyToSubpage(WidgetTester tester,
    {required String withIndex}) async {
  await tester.enterText(
      find.byKey(const Key('subpagenavigation-current-index-input')),
      withIndex);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<void> openSubPageDirectory(WidgetTester tester) async {
  final parentWidgetFinder = find.byKey(const Key("subpagenavigation"));
  await tester.tap(find.descendant(
      of: parentWidgetFinder, matching: find.byIcon(Icons.expand_more)));
  await tester.pumpAndSettle();
}

Future<void> navigateSubPageUsingDirectory(WidgetTester tester,
    {required String toSubPageWithTitle}) async {
  await openSubPageDirectory(tester);
  await tester.tap(find.text(toSubPageWithTitle));
  await tester.pumpAndSettle();
}

Future<void> createNewSubPage(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key("subpagenavigation-newsubpage")));
  await tester.pumpAndSettle();
}

Future<void> deleteSubPage(WidgetTester tester, {bool? confirm}) async {
  await tester.tap(find.byKey(const Key("subpagenavigation-deletesubpage")));
  await tester.pumpAndSettle();

  if (confirm != null) {
    await tester.tap(confirm ? find.text("Continue") : find.text("Cancel"));
    await tester.pumpAndSettle();
  }
}

Future<void> changeSubPageTitle(WidgetTester tester,
    {required String to}) async {
  await tester.enterText(
      find.descendant(
          of: find.byKey(const Key('subpagenavigation-subpage-title')),
          matching: find.byType(TextField)),
      to);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
}

Future<void> switchSubSystem(WidgetTester tester, {required String to}) async {
  await openSubSystemDirectory(tester);
  await tester.tap(find.text(to).last);
  await tester.pumpAndSettle();
}

Future<void> openSubSystemDirectory(WidgetTester tester) async {
  await tester.tap(find.descendant(
      of: find.byKey(const Key("subsystemnavigation")),
      matching: find.byIcon(Icons.arrow_drop_down).first));
  await tester.pumpAndSettle();
}

Future<void> newSubSystem(WidgetTester tester) async {
  await tester.tap(find.descendant(
      of: find.byKey(const Key("subsystemnavigation")),
      matching: find.byIcon(Icons.add)));
  await tester.pumpAndSettle();
}

Future<void> changeSubSystemTitle(WidgetTester tester,
    {required String to}) async {
  await tester.tap(find.descendant(
      of: find.byKey(const Key("subsystemnavigation")),
      matching: find.byIcon(Icons.edit)));
  await tester.pumpAndSettle();

  final dialogFinder = find.byKey(const Key("rename-subsystem-dialog"));
  await tester.enterText(
      find.descendant(of: dialogFinder, matching: find.byType(TextField)), to);
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester
      .tap(find.descendant(of: dialogFinder, matching: find.text("OK")));
  await tester.pumpAndSettle();
}

Future<void> deleteSubSystem(WidgetTester tester, {bool? confirm}) async {
  await tester.tap(find.descendant(
      of: find.byKey(const Key("subsystemnavigation")),
      matching: find.byIcon(Icons.delete)));
  await tester.pumpAndSettle();

  if (confirm == true) {
    await tester.tap(find.descendant(
        of: find.byKey(const Key("subsystem-confirm-delete-dialog")),
        matching: find.text('Continue')));
    await tester.pumpAndSettle();
  } else if (confirm == false) {
    await tester.tap(find.descendant(
        of: find.byKey(const Key("subsystem-confirm-delete-dialog")),
        matching: find.text('Cancel')));
    await tester.pumpAndSettle();
  }

  await tester.pumpAndSettle();
}

Future<void> waitForSettingsPermissionRequest(WidgetTester tester) async {
  await pumpUntilGone(tester, find.text("Request pending..."));
}

Future<void> requestSettingsPermissionBeDisabled(WidgetTester tester) async {
  await requestSettingsPermission(tester,
      forDuration: SettingsRequestDuration.disabled);
}

Future<void> requestSettingsPermission(WidgetTester tester,
    {required SettingsRequestDuration forDuration}) async {
  await openSettingsPermissionMenu(tester);
  await tester.tap(find.text(forDuration.text));
  await tester.pump();
}

Future<void> openSettingsPermissionMenu(WidgetTester tester) async {
  final widgetFinder = find.byKey(const Key("settings-permission"));

  await tester.tap(find.descendant(
      of: widgetFinder, matching: find.byIcon(Icons.expand_more)));
  await tester.pumpAndSettle();
}

Future<void> toggleAnalogAlarm(WidgetTester tester,
    {required String forDRF}) async {
  await tester.tap(find.byKey(Key("parameter_analogalarm_$forDRF")));
  await tester.pumpAndSettle();
}

Future<void> toggleDigitalAlarm(WidgetTester tester,
    {required String forDRF}) async {
  await tester.tap(find.byKey(Key("parameter_digitalalarm_$forDRF")));
  await tester.pumpAndSettle();
}

Future<void> knobUp(WidgetTester tester, {required int steps}) async {
  for (int i = 0; i != steps; i++) {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.f5);
    await tester.pumpAndSettle();
    await tester.sendKeyUpEvent(LogicalKeyboardKey.f5);
    await tester.pumpAndSettle();
  }
}

Future<void> knobDown(WidgetTester tester, {required int steps}) async {
  for (int i = 0; i != steps; i++) {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.f4);
    await tester.pumpAndSettle();
    await tester.sendKeyUpEvent(LogicalKeyboardKey.f4);
    await tester.pumpAndSettle();
  }
}

Future<void> logout(WidgetTester tester) async {
  await openMainMenu(tester);

  await tester.tap(find.text("Logout"));
  await tester.pumpAndSettle();

  await closeMainMenu(tester);
}

Future<void> login(WidgetTester tester) async {
  await openMainMenu(tester);

  await tester.tap(find.text("Login"));
  await tester.pumpAndSettle();

  await closeMainMenu(tester);
}
