import 'package:flutter/foundation.dart';
import 'package:parameter_page/entities/page_entry.dart';

class _SubSystem {
  String title;

  List<_Tab> tabs;

  int currentTabIndex = 0;

  _SubSystem({this.title = "Sub-system n", this.tabs = const <_Tab>[]});
}

class _Tab {
  String title;

  List<_SubPage> subPages;

  int currentSubPage = 0;

  _Tab({this.title = "Tab n", this.subPages = const <_SubPage>[]});
}

class _SubPage {
  String title;

  List<PageEntry> entries;

  _SubPage({this.title = "", this.entries = const <PageEntry>[]});
}

List<_SubSystem> _initialPageStructure = [
  _SubSystem(title: "Sub-system 1", tabs: [
    _Tab(title: "Tab 1", subPages: [_SubPage(title: "", entries: [])])
  ])
];

class ParameterPage {
  String? id;

  set title(String newTitle) {
    _enforceEditMode();
    _title = newTitle;
  }

  String get title {
    return _title;
  }

  List<String> get subSystemTitles {
    return ["Sub-system 1"];
  }

  List<String> get tabTitles {
    return _pageData[_currentSubSystemIndex]
        .tabs
        .map((_Tab tab) => tab.title)
        .toList();
  }

  String get currentTab {
    return _pageData[_currentSubSystemIndex].tabs[currentTabIndex].title;
  }

  int get currentTabIndex {
    return _pageData[_currentSubSystemIndex].currentTabIndex;
  }

  int get subPageIndex {
    return _pageData[_currentSubSystemIndex]
            .tabs[currentTabIndex]
            .currentSubPage +
        1;
  }

  int get numberOfSubPages {
    return _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages
        .length;
  }

  String get subPageTitle {
    return _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages[subPageIndex - 1]
        .title;
  }

  set subPageTitle(String newTitle) {
    _enforceEditMode();
    _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages[subPageIndex - 1]
        .title = newTitle;
  }

  List<String> get subPageDirectory {
    return _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages
        .map((_SubPage subPage) => subPage.title)
        .toList();
  }

  bool get editing {
    return _editing;
  }

  bool get isDirty {
    return title != _savedTitle || !_entriesEqual(_savedPageData);
  }

  ParameterPage([List<PageEntry>? entries])
      : _pageData = [
          _SubSystem(title: "Sub-system 1", tabs: [
            _Tab(title: "Tab 1", subPages: [
              _SubPage(title: "", entries: List<PageEntry>.from(entries ?? []))
            ])
          ])
        ],
        _savedPageData = [
          _SubSystem(title: "Sub-system 1", tabs: [
            _Tab(title: "Tab 1", subPages: [
              _SubPage(title: "", entries: List<PageEntry>.from(entries ?? []))
            ])
          ])
        ];

  ParameterPage.fromQueryResult(
      {required this.id,
      required String title,
      required Map<String, dynamic> queryResult})
      : _pageData = _initialPageStructure,
        _savedPageData = _initialPageStructure {
    _pageData = _buildEntriesMapFromQueryResult(queryResult);
    _savedPageData = _deepCopyEntries(_pageData);

    _currentSubSystemIndex = 0;

    _title = title;
    _savedTitle = title;
  }

  void add(PageEntry entry) {
    _enforceEditMode();

    _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages[subPageIndex - 1]
        .entries
        .add(entry);
  }

  void addAll(List<PageEntry> entries) {
    _enforceEditMode();
    _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages[subPageIndex - 1]
        .entries
        .addAll(entries);
  }

  List<PageEntry> entriesAsList() {
    return _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages[subPageIndex - 1]
        .entries;
  }

  List<PageEntry> entriesAsListFrom(
      {required String tab, required int subPage}) {
    final tabIndex = _findIndex(forTab: tab);
    return _pageData[0].tabs[tabIndex].subPages[subPage - 1].entries;
  }

  int numberOfEntries({String? forTab}) {
    int tabIndex = forTab != null
        ? _findIndex(forTab: forTab)
        : _pageData[_currentSubSystemIndex].currentTabIndex;

    return _pageData[_currentSubSystemIndex]
        .tabs[tabIndex]
        .subPages[subPageIndex - 1]
        .entries
        .length;
  }

  void enableEditing() {
    _editing = true;
    _undoPageData = _deepCopyEntries(_pageData);
    _undoTitle = _title;
  }

  void disableEditing() {
    _editing = false;
  }

  void toggleEditing() {
    _editing ? disableEditing() : enableEditing();
  }

  void cancelEditing() {
    _pageData = _deepCopyEntries(_undoPageData);
    _title = _undoTitle;
    _editing = false;
  }

  void commit() {
    _savedPageData = _deepCopyEntries(_pageData);
    _savedTitle = title;
  }

  void reorderEntry({required int atIndex, required int toIndex}) {
    _enforceEditMode();

    if (atIndex < toIndex) {
      toIndex -= 1;
    }
    final PageEntry entry = _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages[subPageIndex - 1]
        .entries
        .removeAt(atIndex);
    _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages[subPageIndex - 1]
        .entries
        .insert(toIndex, entry);
  }

  void removeEntry({required int at}) {
    _enforceEditMode();

    _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages[subPageIndex - 1]
        .entries
        .removeAt(at);
  }

  void clearAll() {
    _enforceEditMode();

    _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages[subPageIndex - 1]
        .entries = [];
  }

  void createTab({String? title}) {
    _enforceEditMode();

    final newTabTitle = title ?? _generateNewTabTitle();
    _pageData[_currentSubSystemIndex].tabs.add(
        _Tab(title: newTabTitle, subPages: [_SubPage(title: "", entries: [])]));

    switchTab(to: newTabTitle);
  }

  void deleteTab({required String title}) {
    _enforceEditMode();
    _enforceAtLeastOneTab();

    final tabIndex = _findIndex(forTab: title);

    if (currentTabIndex == tabIndex) {
      _switchToAdjacentTab();
    }

    _pageData[_currentSubSystemIndex].tabs.removeAt(tabIndex);

    if (_pageData[_currentSubSystemIndex].currentTabIndex > tabIndex) {
      _pageData[_currentSubSystemIndex].currentTabIndex--;
    }
  }

  void renameTab({required String withTitle, required String to}) {
    _enforceEditMode();

    _pageData[_currentSubSystemIndex]
        .tabs[_findIndex(forTab: withTitle)]
        .title = to;
  }

  void switchTab({required String to}) {
    if (!tabTitles.contains(to)) {
      throw Exception("switchTab failure - tab does not exist");
    }
    _pageData[_currentSubSystemIndex].currentTabIndex = _findIndex(forTab: to);
  }

  int subPageCount({required String forTab}) {
    return _pageData[_currentSubSystemIndex]
        .tabs[_findIndex(forTab: forTab)]
        .subPages
        .length;
  }

  void incrementSubPage() {
    if (subPageIndex != numberOfSubPages) {
      switchSubPage(to: subPageIndex + 1);
    }
  }

  void decrementSubPage() {
    if (subPageIndex > 1) {
      switchSubPage(to: subPageIndex - 1);
    }
  }

  void switchSubPage({required int to}) {
    if (to < 1 || to > numberOfSubPages) {
      throw Exception('Attempt to switch to an invalid sub-page');
    }
    _pageData[_currentSubSystemIndex].tabs[currentTabIndex].currentSubPage =
        to - 1;
  }

  void createSubPage() {
    _enforceEditMode();

    _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages
        .add(_SubPage(title: "", entries: []));

    _pageData[_currentSubSystemIndex].tabs[currentTabIndex].currentSubPage =
        _pageData[_currentSubSystemIndex]
                .tabs[currentTabIndex]
                .subPages
                .length -
            1;
  }

  void deleteSubPage() {
    _enforceEditMode();

    _enforceAtLeastOneSubPage();

    _pageData[_currentSubSystemIndex]
        .tabs[currentTabIndex]
        .subPages
        .removeAt(subPageIndex - 1);

    if (subPageIndex - 1 ==
        _pageData[_currentSubSystemIndex]
            .tabs[currentTabIndex]
            .subPages
            .length) {
      decrementSubPage();
    }
  }

  String subPageTitleFor({required String tab, required int subPageIndex}) {
    return _pageData[_currentSubSystemIndex]
        .tabs[_findIndex(forTab: tab)]
        .subPages[subPageIndex - 1]
        .title;
  }

  void _enforceEditMode() {
    if (!_editing) {
      throw Exception(
          "Can not modify a ParameterPage when edit mode is disabled.");
    }
  }

  void _enforceAtLeastOneTab() {
    if (_pageData[_currentSubSystemIndex].tabs.length == 1) {
      throw Exception("Could not delete the only tab on the page");
    }
  }

  void _enforceAtLeastOneSubPage() {
    if (_pageData[_currentSubSystemIndex]
            .tabs[currentTabIndex]
            .subPages
            .length ==
        1) {
      throw Exception("Could not delete the only sub-page on the page");
    }
  }

  int _findIndex({required String forTab}) {
    for (int i = 0; i != _pageData[_currentSubSystemIndex].tabs.length; i++) {
      if (_pageData[_currentSubSystemIndex].tabs[i].title == forTab) {
        return i;
      }
    }

    throw Exception("Invalid tab");
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

  List<_SubSystem> _buildEntriesMapFromQueryResult(
      Map<String, dynamic> queryResult) {
    List<_SubSystem> ret = [_SubSystem(title: "Sub-system 1", tabs: [])];
    for (final tabData in queryResult["tabs"]) {
      List<_SubPage> subPages = [];

      for (final subPageData in tabData["sub-pages"]) {
        final entries = subPageData["entries"];
        if (entries.length == 0) {
          subPages.add(_SubPage(title: "", entries: []));
        } else {
          subPages.add(_SubPage(
              title: subPageData["title"] ?? "",
              entries:
                  _buildEntriesListFromQueryResult(subPageData["entries"])));
        }
      }

      ret[0].tabs.add(_Tab(title: tabData["title"], subPages: subPages));
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

  List<_SubSystem> _deepCopyEntries(List<_SubSystem> from) {
    List<_SubSystem> ret = [];
    for (_SubSystem fromSubSystem in from) {
      _SubSystem toSubSystem = _SubSystem(title: fromSubSystem.title, tabs: []);
      for (_Tab fromTab in fromSubSystem.tabs) {
        _Tab toTab = _Tab(title: fromTab.title, subPages: []);
        for (int i = 0; i != fromTab.subPages.length; i++) {
          toTab.subPages.add(_SubPage(
              title: fromTab.subPages[i].title,
              entries: List<PageEntry>.from(fromTab.subPages[i].entries)));
        }
        toSubSystem.tabs.add(toTab);
      }
      ret.add(toSubSystem);
    }
    return ret;
  }

  bool _entriesEqual(List<_SubSystem> compareTo) {
    if (_pageData.length != compareTo.length) {
      return false;
    }

    for (int i = 0; i != _pageData.length; i++) {
      if (_pageData[i].title != compareTo[i].title) {
        return false;
      }

      if (_pageData[i].tabs.length != compareTo[i].tabs.length) {
        return false;
      }

      for (int j = 0; j != _pageData[i].tabs.length; j++) {
        if (_pageData[i].tabs[j].title != compareTo[i].tabs[j].title) {
          return false;
        }

        if (_pageData[i].tabs[j].subPages.length !=
            compareTo[i].tabs[j].subPages.length) {
          return false;
        }

        for (int k = 0; k != _pageData[i].tabs[j].subPages.length; k++) {
          if (_pageData[i].tabs[j].subPages[k].title !=
              compareTo[i].tabs[j].subPages[k].title) {
            return false;
          }
          if (!listEquals(_pageData[i].tabs[j].subPages[k].entries,
              compareTo[i].tabs[j].subPages[k].entries)) {
            return false;
          }
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

  List<_SubSystem> _pageData = _initialPageStructure;

  List<_SubSystem> _undoPageData = _initialPageStructure;

  List<_SubSystem> _savedPageData = _initialPageStructure;

  String _title = "New Parameter Page";

  String _undoTitle = "New Parameter Page";

  String _savedTitle = "New Parameter Page";

  int _currentSubSystemIndex = 0;

  bool _editing = false;
}
