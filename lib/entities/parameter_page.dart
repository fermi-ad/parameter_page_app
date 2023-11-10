import 'package:flutter/foundation.dart';
import 'package:parameter_page/entities/page_entry.dart';

const Map<String, List<PageEntry>> initialPageEntries = {"Tab 1": []};

class ParameterPage {
  String? id;

  set title(String newTitle) {
    _enforceEditMode();
    _title = newTitle;
  }

  String get title {
    return _title;
  }

  List<String> get tabTitles {
    return _entries.keys.toList();
  }

  String get currentTab {
    return _currentTab;
  }

  ParameterPage([List<PageEntry>? entries])
      : _entries = {"Tab 1": List<PageEntry>.from(entries ?? [])},
        _savedEntries = {"Tab 1": List<PageEntry>.from(entries ?? [])};

  ParameterPage.fromQueryResult(
      {required this.id,
      required String title,
      required Map<String, dynamic> queryResult})
      : _entries = initialPageEntries,
        _savedEntries = initialPageEntries {
    _entries = _buildEntriesMapFromQueryResult(queryResult);
    _savedEntries = _deepCopyEntries(_entries);

    _currentTab = _entries.keys.first;

    _title = title;
    _savedTitle = title;
  }

  void add(PageEntry entry) {
    _enforceEditMode();
    _entries[_currentTab]!.add(entry);
  }

  void addAll(List<PageEntry> entry) {
    _enforceEditMode();
    _entries[_currentTab]!.addAll(entry);
  }

  void _enforceEditMode() {
    if (!_editing) {
      throw Exception(
          "Can not modify a ParameterPage when edit mode is disabled.");
    }
  }

  List<PageEntry> entriesAsList({String? forTab}) {
    if (forTab != null) {
      if (!_entries.containsKey(forTab)) {
        throw Exception("entriesAsList failure - Invalid tab title");
      }
      return _entries[forTab]!;
    } else {
      return _entries[currentTab]!;
    }
  }

  int numberOfEntries({String? forTab}) {
    String tab = forTab ?? _currentTab;

    return _entries[tab]!.length;
  }

  bool editing() {
    return _editing;
  }

  void enableEditing() {
    _editing = true;
    _undoEntries = _deepCopyEntries(_entries);
    _undoTitle = _title;
  }

  void disableEditing() {
    _editing = false;
  }

  void toggleEditing() {
    _editing ? disableEditing() : enableEditing();
  }

  void cancelEditing() {
    _entries = _deepCopyEntries(_undoEntries);
    _title = _undoTitle;
    _editing = false;
  }

  void reorderEntry({required int atIndex, required int toIndex}) {
    _enforceEditMode();

    if (atIndex < toIndex) {
      toIndex -= 1;
    }
    final PageEntry entry = _entries[_currentTab]!.removeAt(atIndex);
    _entries[_currentTab]!.insert(toIndex, entry);
  }

  void removeEntry({required int at}) {
    _enforceEditMode();

    _entries[_currentTab]!.removeAt(at);
  }

  void clearAll() {
    _enforceEditMode();

    _entries[_currentTab] = [];
  }

  void commit() {
    _savedEntries = _deepCopyEntries(_entries);
    _savedTitle = title;
  }

  bool get isDirty {
    return title != _savedTitle || !_entriesEqual(_savedEntries);
  }

  void createTab({String? title}) {
    _enforceEditMode();
    _entries[title ?? _generateNewTabTitle()] = [];
  }

  void deleteTab({required String title}) {
    _enforceEditMode();
    _enforceAtLeastOneTab();

    if (currentTab == title) {
      _switchToAdjacentTab();
    }

    _entries.remove(title);
  }

  void renameTab({required String withTitle, required String to}) {
    _enforceEditMode();
    if (withTitle != currentTab) {
      _entries[to] = _entries[withTitle]!;
      _entries.remove(withTitle);
    } else {
      _renameCurrentTab(to);
    }
  }

  void _renameCurrentTab(String to) {
    _entries[to] = _entries[_currentTab]!;
    final oldTab = _currentTab;
    _currentTab = to;
    _entries.remove(oldTab);
  }

  void _switchToAdjacentTab() {
    final tabIndex = tabTitles.indexOf(currentTab);
    String switchToTab = (tabIndex == tabTitles.length - 1)
        ? tabTitles[tabIndex - 1]
        : tabTitles[tabIndex + 1];
    switchTab(to: switchToTab);
  }

  void _enforceAtLeastOneTab() {
    if (_entries.length == 1) {
      throw Exception("Could not delete the only tab on the page");
    }
  }

  String _generateNewTabTitle() {
    return "Tab ${tabTitles.length + 1}";
  }

  void switchTab({required String to}) {
    if (!_entries.keys.contains(to)) {
      throw Exception("switchTab failure - tab does not exist");
    }
    _currentTab = to;
  }

  Map<String, List<PageEntry>> _buildEntriesMapFromQueryResult(
      Map<String, dynamic> queryResult) {
    Map<String, List<PageEntry>> ret = {};
    for (final tabData in queryResult["tabs"]) {
      final entries = tabData["entries"];
      if (entries.length == 0) {
        ret[tabData["title"]] = [];
      } else {
        ret[tabData["title"]] =
            _buildEntriesListFromQueryResult(tabData["entries"]);
      }
    }
    return ret;
  }

  List<PageEntry> _buildEntriesListFromQueryResult(
      List<Map<String, dynamic>> queryResult) {
    List<PageEntry> ret = [];
    for (final entryData in queryResult) {
      ret.add(_hydratePageEntry(from: entryData));
    }

    return ret;
  }

  Map<String, List<PageEntry>> _deepCopyEntries(
      Map<String, List<PageEntry>> from) {
    Map<String, List<PageEntry>> ret = {};
    for (String tab in from.keys) {
      ret[tab] = List<PageEntry>.from(from[tab]!);
    }
    return ret;
  }

  bool _entriesEqual(Map<String, List<PageEntry>> compareTo) {
    if (_entries.length != compareTo.length) {
      return false;
    }

    for (String tab in _entries.keys) {
      if (!compareTo.containsKey(tab)) {
        return false;
      }
      if (!listEquals(_entries[tab]!, compareTo[tab]!)) {
        return false;
      }
    }

    return true;
  }

  PageEntry _hydratePageEntry({required Map<String, dynamic> from}) {
    switch (from["type"]) {
      case "Comment":
      case "Comments":
        return CommentEntry(from["text"]!, id: from["entryid"]);

      case "Parameter":
        return ParameterEntry(from["text"], id: from["entryid"]);

      case "Expression":
        return CommentEntry(from["text"]!, id: from["entryid"]);

      default:
        throw UnimplementedError("Unexpected PageEntry type");
    }
  }

  Map<String, List<PageEntry>> _entries = initialPageEntries;

  Map<String, List<PageEntry>> _undoEntries = initialPageEntries;

  Map<String, List<PageEntry>> _savedEntries = initialPageEntries;

  String _title = "New Parameter Page";

  String _undoTitle = "New Parameter Page";

  String _savedTitle = "New Parameter Page";

  String _currentTab = "Tab 1";

  bool _editing = false;
}
