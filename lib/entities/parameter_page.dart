import 'package:flutter/foundation.dart';
import 'package:parameter_page/entities/page_entry.dart';

const Map<String, List<List<PageEntry>>> initialPageEntries = {
  "Tab 1": [[]]
};

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

  int get currentTabIndex {
    return tabTitles.indexOf(_currentTab);
  }

  int get subPageIndex {
    return _currentSubPage + 1;
  }

  int get numberOfSubPages {
    return _entries[_currentTab]!.length;
  }

  bool get editing {
    return _editing;
  }

  bool get isDirty {
    return title != _savedTitle || !_entriesEqual(_savedEntries);
  }

  ParameterPage([List<PageEntry>? entries])
      : _entries = {
          "Tab 1": [List<PageEntry>.from(entries ?? [])]
        },
        _savedEntries = {
          "Tab 1": [List<PageEntry>.from(entries ?? [])]
        };

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
    _entries[_currentTab]![_currentSubPage].add(entry);
  }

  List<PageEntry> entriesAsList({String? forTab}) {
    if (forTab != null) {
      if (!_entries.containsKey(forTab)) {
        throw Exception("entriesAsList failure - Invalid tab title");
      }
      return _entries[forTab]![_currentSubPage];
    } else {
      return _entries[currentTab]![_currentSubPage];
    }
  }

  int numberOfEntries({String? forTab}) {
    String tab = forTab ?? _currentTab;

    return _entries[tab]![_currentSubPage].length;
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

  void commit() {
    _savedEntries = _deepCopyEntries(_entries);
    _savedTitle = title;
  }

  void reorderEntry({required int atIndex, required int toIndex}) {
    _enforceEditMode();

    if (atIndex < toIndex) {
      toIndex -= 1;
    }
    final PageEntry entry =
        _entries[_currentTab]![_currentSubPage].removeAt(atIndex);
    _entries[_currentTab]![_currentSubPage].insert(toIndex, entry);
  }

  void removeEntry({required int at}) {
    _enforceEditMode();

    _entries[_currentTab]![_currentSubPage].removeAt(at);
  }

  void clearAll() {
    _enforceEditMode();

    _entries[_currentTab]![_currentSubPage] = [];
  }

  void createTab({String? title}) {
    _enforceEditMode();

    final newTabTitle = title ?? _generateNewTabTitle();
    _entries[newTabTitle] = [[]];

    switchTab(to: newTabTitle);
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

    Map<String, List<List<PageEntry>>> newEntries = {};
    for (String tabName in _entries.keys) {
      if (tabName == withTitle) {
        newEntries[to] = _entries[tabName]!;
        if (tabName == _currentTab) {
          _currentTab = to;
        }
      } else {
        newEntries[tabName] = _entries[tabName]!;
      }
    }
    _entries = newEntries;
  }

  void switchTab({required String to}) {
    if (!_entries.keys.contains(to)) {
      throw Exception("switchTab failure - tab does not exist");
    }
    _currentTab = to;
  }

  void incrementSubPage() {}

  void decrementSubPage() {}

  void createSubPage() {
    _enforceEditMode();

    _entries[currentTab]!.add([]);

    _currentSubPage = _entries[currentTab]!.length - 1;
  }

  void _enforceEditMode() {
    if (!_editing) {
      throw Exception(
          "Can not modify a ParameterPage when edit mode is disabled.");
    }
  }

  void _enforceAtLeastOneTab() {
    if (_entries.length == 1) {
      throw Exception("Could not delete the only tab on the page");
    }
  }

  void _switchToAdjacentTab() {
    final tabIndex = tabTitles.indexOf(currentTab);
    String switchToTab = (tabIndex == tabTitles.length - 1)
        ? tabTitles[tabIndex - 1]
        : tabTitles[tabIndex + 1];
    switchTab(to: switchToTab);
  }

  String _generateNewTabTitle() {
    return "Tab ${tabTitles.length + 1}";
  }

  Map<String, List<List<PageEntry>>> _buildEntriesMapFromQueryResult(
      Map<String, dynamic> queryResult) {
    Map<String, List<List<PageEntry>>> ret = {};
    for (final tabData in queryResult["tabs"]) {
      final entries = tabData["entries"];
      if (entries.length == 0) {
        ret[tabData["title"]] = [[]];
      } else {
        ret[tabData["title"]] = [
          _buildEntriesListFromQueryResult(tabData["entries"])
        ];
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

  Map<String, List<List<PageEntry>>> _deepCopyEntries(
      Map<String, List<List<PageEntry>>> from) {
    Map<String, List<List<PageEntry>>> ret = {};
    for (String tab in from.keys) {
      for (int i = 0; i != from[tab]!.length; i++) {
        ret[tab] = [];
        ret[tab]!.add(List<PageEntry>.from(from[tab]![i]));
      }
    }
    return ret;
  }

  bool _entriesEqual(Map<String, List<List<PageEntry>>> compareTo) {
    if (_entries.length != compareTo.length) {
      return false;
    }

    for (String tab in _entries.keys) {
      if (!compareTo.containsKey(tab)) {
        return false;
      }

      for (int i = 0; i != _entries[tab]!.length; i++) {
        if (!listEquals(_entries[tab]![i], compareTo[tab]![i])) {
          return false;
        }
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

  Map<String, List<List<PageEntry>>> _entries = initialPageEntries;

  Map<String, List<List<PageEntry>>> _undoEntries = initialPageEntries;

  Map<String, List<List<PageEntry>>> _savedEntries = initialPageEntries;

  String _title = "New Parameter Page";

  String _undoTitle = "New Parameter Page";

  String _savedTitle = "New Parameter Page";

  String _currentTab = "Tab 1";

  bool _editing = false;

  int _currentSubPage = 0;
}
