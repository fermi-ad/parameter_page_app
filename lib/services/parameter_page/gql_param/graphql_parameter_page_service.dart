import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import 'package:parameter_page/entities/page_entry.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/services/parameter_page/gql_param/mutations.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';

import '../../../gqlconnect.dart';
import 'queries.dart';

class GraphQLParameterPageService extends ParameterPageService {
  @override
  Future<List<dynamic>> fetchPages() async {
    return _doGraphQL(
            query: queryAllPageTitles,
            withVariables: {},
            whatItIs: "fetch a list of parameter pages")
        .then((result) {
      List<dynamic> titles = [];
      titles = result.data?['allPageTitles'];
      return titles;
    });
  }

  @override
  Future<ParameterPage> fetchPage({required String id}) async {
    return _fetchPageStructure(forPageId: id).catchError((error) {
      return error;
    }).then((pageStructure) {
      return ParameterPage.fromQueryResult(
          id: pageStructure['pageid'],
          title: pageStructure['title'],
          queryResult: pageStructure);
    });
  }

  @override
  Future<String> createPage({required String withTitle}) async {
    return _doGraphQL(
            query: addDefaultPageTree,
            withVariables: {
              'title': withTitle,
            },
            whatItIs: "create a parameter page")
        .then((result) => result.data?['newParamPage']['pageid']);
  }

  @override
  Future<void> deletePage({required String withPageId}) async {
    await _doGraphQL(
        query: removeTree,
        withVariables: {
          'treeid': withPageId,
        },
        whatItIs: "delete a parameter page");
  }

  @override
  Future<void> savePage(
      {required String id, required ParameterPage page}) async {
    try {
      final persistedPageStructure = await _fetchPageStructure(forPageId: id);

      await _deleteExtraSubSystems(
          withPage: page,
          persistedSubSystems: persistedPageStructure['sub_systems']);

      await _updateEachSubSystem(
          withPage: page,
          persistedSubSystems: persistedPageStructure['sub_systems'],
          pageId: id);
    } catch (e) {
      Logger().e(e.toString());
      return Future.error("savePage failure");
    }
  }

  @override
  Future<String> renamePage(
      {required String id, required String newTitle}) async {
    return _doGraphQL(
            query: updateSubjectTitles,
            withVariables: {
              'subjType': "parampage",
              'subjTitles': [
                {'subjectid': id, 'title': newTitle}
              ]
            },
            whatItIs: "rename a parameter page")
        .then((result) {
      if (result.data?['code'] == -1) {
        Logger().e(
            "updateSubjectTitles returned with a failure, message: ${result.data?["message"]}");
        return Future.error(
            "The request to rename the parameter page returned an exception.  Please refer to the developer console for more detail.");
      }

      return newTitle;
    });
  }

  Future<void> _deleteExtraSubSystems(
      {required List<dynamic> persistedSubSystems,
      required ParameterPage withPage}) async {
    for (int subSysIndex = 0;
        subSysIndex != persistedSubSystems.length;
        subSysIndex++) {
      if (subSysIndex >= withPage.subSystemTitles.length) {
        await _deleteSubSystem(subSystem: persistedSubSystems[subSysIndex]);
      }
    }
  }

  Future<void> _updateEachSubSystem(
      {required List<dynamic> persistedSubSystems,
      required ParameterPage withPage,
      required String pageId}) async {
    for (int subSystemIndex = withPage.subSystemTitles.length - 1;
        subSystemIndex >= 0;
        subSystemIndex--) {
      final title = withPage.subSystemTitles[subSystemIndex];
      final Map<String, dynamic> persistedSubSystem;

      if (subSystemIndex >= persistedSubSystems.length) {
        persistedSubSystem = await _createANewSubSystem(
            onPageId: pageId, withTitle: title, atIndex: subSystemIndex);
      } else {
        persistedSubSystem = persistedSubSystems[subSystemIndex];
        if (title != persistedSubSystem["title"]) {
          await _renameSubSystem(
              id: persistedSubSystem["subsysid"], newTitle: title);
        }
      }

      await _deleteExtraTabs(
          withPage: withPage, persistedTabs: persistedSubSystem['tabs']);

      await _updateEachTab(
          withPage: withPage,
          forSubSystem: title,
          persistedTabs: persistedSubSystem['tabs'],
          subSystemId: persistedSubSystem['subsysid']);
    }
  }

  Future<void> _renameSubSystem(
      {required String id, required String newTitle}) async {
    return _doGraphQL(
            query: updateSubjectTitles,
            withVariables: {
              'subjType': "subsys",
              'subjTitles': [
                {'subjectid': id, 'title': newTitle}
              ]
            },
            whatItIs: "rename a sub-system")
        .then((result) {
      if (result.data?['code'] == -1) {
        Logger().e(
            "updateSubjectTitles returned with a failure, message: ${result.data?["message"]}");
        return Future.error(
            "The request to rename the sub-system returned an exception.  Please refer to the developer console for more detail.");
      }
    });
  }

  Future<Map<String, dynamic>> _createANewSubSystem(
      {required String onPageId,
      required String withTitle,
      required int atIndex}) async {
    return _doGraphQL(
            query: addSubSysBranch,
            withVariables: {
              'title': withTitle,
              "seqnum": atIndex + 1,
              "pageid": onPageId
            },
            whatItIs: "create a new sub-system")
        .then((result) => result.data!['newSubsysBranch']);
  }

  Future<void> _deleteSubSystem(
      {required Map<String, dynamic> subSystem}) async {
    await _deleteTabs(fromSubSystem: subSystem);

    await _doGraphQL(
        query: deleteSubjects,
        withVariables: {
          'subjType': "subsys",
          'subjIds': [subSystem['subsysid']]
        },
        whatItIs: "delete a sub-system");
  }

  Future<void> _deleteTabs(
      {required Map<String, dynamic> fromSubSystem}) async {
    for (Map<String, dynamic> tab in fromSubSystem['tabs']) {
      await _deleteTab(tab: tab);
    }
  }

  Future<void> _deleteExtraTabs(
      {required List<dynamic> persistedTabs,
      required ParameterPage withPage}) async {
    for (int tabIndex = 0; tabIndex != persistedTabs.length; tabIndex++) {
      if (tabIndex >= withPage.tabTitles.length) {
        await _deleteTab(tab: persistedTabs[tabIndex]);
      }
    }
  }

  Future<void> _updateEachTab(
      {required List<dynamic> persistedTabs,
      required ParameterPage withPage,
      required String forSubSystem,
      required String subSystemId}) async {
    final tabTitles = withPage.tabTitlesFor(subSystem: forSubSystem);
    for (int tabIndex = tabTitles.length - 1; tabIndex >= 0; tabIndex--) {
      final tabName = tabTitles[tabIndex];

      dynamic persistedTab;
      if (tabIndex >= persistedTabs.length) {
        persistedTab = await _createANewTab(
            withTitle: tabName, atIndex: tabIndex, onSubSystem: subSystemId);
      } else {
        persistedTab = persistedTabs[tabIndex];

        if (tabName != persistedTab["title"]) {
          await _renameTab(id: persistedTab['subsystabid'], newTitle: tabName);
        }
      }

      await _deleteExtraSubPages(
          persistedSubPages:
              persistedTab['sub_pages'] ?? persistedTab['tabpagelist'],
          withPage: withPage,
          forSubSystem: forSubSystem,
          forTab: tabName);

      await _updateEachSubPage(
          persistedTabId: persistedTab['subsystabid'],
          persistedSubPages:
              persistedTab['sub_pages'] ?? persistedTab['tabpagelist'],
          withPage: withPage,
          forSubSystem: forSubSystem,
          forTab: tabName);
    }
  }

  Future<dynamic> _createANewTab(
      {required String withTitle,
      required int atIndex,
      required String onSubSystem}) async {
    return _doGraphQL(
            query: addTabBranch,
            withVariables: {
              'title': withTitle,
              "seqnum": atIndex + 1,
              "subsysid": onSubSystem
            },
            whatItIs: "create a new tab")
        .then((result) => result.data!['newSubsysTabBranch']);
  }

  Future<void> _renameTab(
      {required String id, required String newTitle}) async {
    return _doGraphQL(
            query: updateSubjectTitles,
            withVariables: {
              'subjType': "tab",
              'subjTitles': [
                {'subjectid': id, 'title': newTitle}
              ]
            },
            whatItIs: "rename a tab")
        .then((result) {
      if (result.data?['code'] == -1) {
        Logger().e(
            "updateSubjectTitles returned with a failure, message: ${result.data?["message"]}");
        return Future.error(
            "The request to rename the tab returned an exception.  Please refer to the developer console for more detail.");
      }
    });
  }

  Future<void> _deleteTab({required Map<String, dynamic> tab}) async {
    await _deleteSubPages(fromTab: tab);

    await _doGraphQL(
        query: deleteSubjects,
        withVariables: {
          'subjType': "tab",
          'subjIds': [tab['subsystabid']]
        },
        whatItIs: "delete a tab");
  }

  Future<void> _deleteExtraSubPages(
      {required List<dynamic> persistedSubPages,
      required ParameterPage withPage,
      required String forSubSystem,
      required String forTab}) async {
    for (int subPageIndex = 0;
        subPageIndex != persistedSubPages.length;
        subPageIndex++) {
      if (subPageIndex >
          withPage.subPageCount(forSubSystem: forSubSystem, forTab: forTab) -
              1) {
        final subPageId = persistedSubPages[subPageIndex]["tabpageid"];
        await _deleteAllEntries(fromSubPage: persistedSubPages[subPageIndex]);
        await _deleteSubPage(id: subPageId);
      }
    }
  }

  Future<void> _updateEachSubPage(
      {required String persistedTabId,
      required List<dynamic> persistedSubPages,
      required ParameterPage withPage,
      required String forSubSystem,
      required String forTab}) async {
    for (int subPageIndex =
            withPage.subPageCount(forSubSystem: forSubSystem, forTab: forTab) -
                1;
        subPageIndex >= 0;
        subPageIndex--) {
      Map<String, dynamic> persistedSubPage;

      if (subPageIndex >= persistedSubPages.length) {
        persistedSubPage = await _createANewSubPage(
            onTab: persistedTabId, atIndex: subPageIndex);
      } else {
        persistedSubPage = persistedSubPages[subPageIndex];
      }

      await _saveEntries(
          persistedSubPage: persistedSubPage,
          newEntries: withPage.entriesAsListFrom(
              subSystem: forSubSystem, tab: forTab, subPage: subPageIndex + 1));

      final subPageTitle = withPage.subPageTitleFor(
          forSubSystem: forSubSystem,
          tab: forTab,
          subPageIndex: subPageIndex + 1);
      final subPageTitleShouldBeUpdated =
          subPageIndex >= persistedSubPages.length ||
              subPageTitle != persistedSubPage['title'];
      if (subPageTitleShouldBeUpdated) {
        await _renameSubPage(
            id: persistedSubPage['tabpageid'], newTitle: subPageTitle);
      }
    }
  }

  Future<void> _deleteSubPages({required Map<String, dynamic> fromTab}) async {
    for (Map<String, dynamic> subPage in fromTab['sub_pages']) {
      await _deleteAllEntries(fromSubPage: subPage);

      await _deleteSubPage(id: subPage['tabpageid']);
    }
  }

  Future<void> _deleteSubPage({required String id}) async {
    await _doGraphQL(
        query: deleteSubjects,
        withVariables: {
          'subjType': "subpage",
          'subjIds': [id]
        },
        whatItIs: "delete a sub-page");
  }

  Future<void> _renameSubPage(
      {required String id, required String newTitle}) async {
    return _doGraphQL(
            query: updateSubjectTitles,
            withVariables: {
              'subjType': "subpage",
              'subjTitles': [
                {'subjectid': id, 'title': newTitle}
              ]
            },
            whatItIs: "rename a sub-page")
        .then((result) {
      if (result.data?['code'] == -1) {
        Logger().e(
            "updateSubjectTitles returned with a failure, message: ${result.data?["message"]}");
        return Future.error(
            "The request to rename the sub-page returned an exception.  Please refer to the developer console for more detail.");
      }
    });
  }

  Future<Map<String, dynamic>> _createANewSubPage(
      {required String onTab, required int atIndex}) async {
    return _doGraphQL(
            query: addSubPage,
            withVariables: {
              'title': "",
              "seqnum": atIndex + 1,
              "subsystabid": onTab
            },
            whatItIs: "create a new sub-page")
        .then((result) => result.data!['newTabPage']);
  }

  Future<void> _saveEntries(
      {required Map<String, dynamic> persistedSubPage,
      required List<PageEntry> newEntries}) async {
    await _deleteExtraEntries(
        fromSubPage: persistedSubPage, newEntries: newEntries);

    return _doGraphQL(
            query: mergeEntries,
            withVariables: {
              'mrgEntries': _generateEntryMergeList(
                  forPersistedSubPage: persistedSubPage, from: newEntries)
            },
            whatItIs: "add entries to a sub-page")
        .then((result) {
      if (result.data?['code'] == -1) {
        Logger().e(
            "mrgEntries returned with a failure, message: ${result.data?["message"]}");
        return Future.error(
            "The request to add entries to a parameter page returned an exception.  Please refer to the developer console for more detail.");
      }
    });
  }

  Future _deleteExtraEntries(
      {required Map<String, dynamic> fromSubPage,
      required List<PageEntry> newEntries}) async {
    final List<dynamic> persistedEntries =
        _extractEntries(fromSubPage: fromSubPage);

    final List<int> extraEntries = [];
    for (int i = 0; i != persistedEntries.length; i++) {
      if (i >= newEntries.length) {
        extraEntries.add(persistedEntries[i]['position'] as int);
      }
    }

    await _deleteEntries(
        fromSubPage: fromSubPage['tabpageid'], atPositions: extraEntries);
  }

  Future _deleteAllEntries({required Map<String, dynamic> fromSubPage}) async {
    await _deleteEntries(
        fromSubPage: fromSubPage['tabpageid'],
        atPositions: _extractEntries(fromSubPage: fromSubPage)
            .map((entry) => entry['position'] as int)
            .toList());
  }

  Future<void> _deleteEntries(
      {required String fromSubPage, required List<int> atPositions}) async {
    if (atPositions.isEmpty) {
      return;
    }

    await _doGraphQL(
        query: deleteEntries,
        withVariables: {
          'delEntries': atPositions
              .map((int position) =>
                  {"tabpageid": fromSubPage, "position": position})
              .toList()
        },
        whatItIs: "delete sub-page entries");
  }

  Future<Map<String, dynamic>> _fetchPageStructure(
      {required String forPageId}) async {
    return _doGraphQL(
            query: queryOnePageTree,
            withVariables: {'pageid': forPageId},
            whatItIs: "fetch a parameter page")
        .then((result) => result.data?['onePageTree']);
  }

  Future<QueryResult> _doGraphQL(
      {required String query,
      required Map<String, dynamic> withVariables,
      required String whatItIs}) async {
    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: withVariables,
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to $whatItIs returned an exception.  Please refer to the developer console for more detail.");
    } else {
      return result;
    }
  }

  List<Map<String, dynamic>> _generateEntryMergeList(
      {required Map<String, dynamic> forPersistedSubPage,
      required List<PageEntry> from}) {
    final persistedEntries = _extractEntries(fromSubPage: forPersistedSubPage);

    int n = 0;
    return from.map((entry) {
      return n < persistedEntries.length
          ? {
              'tabpageid': forPersistedSubPage['tabpageid'],
              'text_old': persistedEntries[n]['text'],
              'text_new': entry.entryText(),
              'type_old': persistedEntries[n]['type'],
              'type_new': entry.typeAsString,
              'position': n += 1
            }
          : {
              'tabpageid': forPersistedSubPage['tabpageid'],
              'text_new': entry.entryText(),
              'type_new': entry.typeAsString,
              'position': n += 1
            };
    }).toList();
  }

  List<dynamic> _extractEntries({required Map<String, dynamic> fromSubPage}) {
    if (fromSubPage.containsKey('pageentrylist')) {
      return fromSubPage['pageentrylist'];
    } else if (fromSubPage.containsKey('entries')) {
      return fromSubPage['entries'];
    } else {
      return [];
    }
  }
}
