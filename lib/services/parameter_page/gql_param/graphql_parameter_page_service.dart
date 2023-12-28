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
  Future<void> deletePage(
      {required String withPageId,
      required Function(String errorMessage) onFailure,
      required Function() onSuccess}) async {
    return _doGraphQL(
            query: removeTree,
            withVariables: {
              'treeid': withPageId,
            },
            whatItIs: "delete a parameter page")
        .then((result) => onSuccess.call());
  }

  @override
  Future<void> savePage(
      {required String id, required ParameterPage page}) async {
    try {
      final persistedPageStructure = await _fetchPageStructure(forPageId: id);

      await _deleteExtraTabs(
          withPage: page,
          persistedTabs: persistedPageStructure['sub_systems'][0]['tabs']);

      await _updateEachTab(
          withPage: page,
          persistedTabs: persistedPageStructure['sub_systems'][0]['tabs'],
          subSystemId: persistedPageStructure['sub_systems'][0]['subsysid']);
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
      required String subSystemId}) async {
    for (int tabIndex = 0; tabIndex != withPage.tabTitles.length; tabIndex++) {
      final tabName = withPage.tabTitles[tabIndex];

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
          forTab: tabName);

      await _updateEachSubPage(
          persistedTabId: persistedTab['subsystabid'],
          persistedSubPages:
              persistedTab['sub_pages'] ?? persistedTab['tabpagelist'],
          withPage: withPage,
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

  Future<void> _deleteExtraSubPages(
      {required List<dynamic> persistedSubPages,
      required ParameterPage withPage,
      required String forTab}) async {
    for (int subPageIndex = 0;
        subPageIndex != persistedSubPages.length;
        subPageIndex++) {
      if (subPageIndex > withPage.subPageCount(forTab: forTab) - 1) {
        final subPageId = persistedSubPages[subPageIndex]["tabpageid"];
        final entries = persistedSubPages[subPageIndex]['entries'];
        await _deleteAllEntries(fromSubPageId: subPageId, entries: entries);
        await _deleteSubPage(id: subPageId);
      }
    }
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

  Future<void> _updateEachSubPage(
      {required String persistedTabId,
      required List<dynamic> persistedSubPages,
      required ParameterPage withPage,
      required String forTab}) async {
    for (int subPageIndex = 0;
        subPageIndex != withPage.subPageCount(forTab: forTab);
        subPageIndex++) {
      String subPageId;

      if (subPageIndex >= persistedSubPages.length) {
        subPageId = await _createANewSubPage(
            onTab: persistedTabId, atIndex: subPageIndex);
      } else {
        subPageId = persistedSubPages[subPageIndex]['tabpageid'];

        await _deleteAllEntries(
            fromSubPageId: subPageId,
            entries: persistedSubPages[subPageIndex]['entries'] ?? []);
      }

      await _saveEntries(
          id: subPageId,
          newEntries: withPage.entriesAsListFrom(
              tab: forTab, subPage: subPageIndex + 1));

      final subPageTitle =
          withPage.subPageTitleFor(tab: forTab, subPageIndex: subPageIndex + 1);
      final subPageTitleShouldBeUpdated =
          subPageIndex >= persistedSubPages.length ||
              subPageTitle != persistedSubPages[subPageIndex]['title'];
      if (subPageTitleShouldBeUpdated) {
        await _renameSubPage(id: subPageId, newTitle: subPageTitle);
      }
    }
  }

  Future<void> _deleteSubPages({required Map<String, dynamic> fromTab}) async {
    for (Map<String, dynamic> subPage in fromTab['sub_pages']) {
      await _deleteAllEntries(
          fromSubPageId: subPage['tabpageid'],
          entries: subPage['pageentrylist'] ?? subPage['entries']);

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

  Future<String> _createANewSubPage(
      {required String onTab, required int atIndex}) async {
    return _doGraphQL(
            query: addSubPage,
            withVariables: {
              'title': "",
              "seqnum": atIndex + 1,
              "subsystabid": onTab
            },
            whatItIs: "create a new sub-page")
        .then((result) => result.data!['newTabPage']['tabpageid']);
  }

  Future<void> _saveEntries(
      {required String id, required List<PageEntry> newEntries}) async {
    return _doGraphQL(
            query: mergeEntries,
            withVariables: {
              'mrgEntries':
                  _generateEntryMergeList(subPageId: id, from: newEntries)
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

  Future _deleteAllEntries(
      {required String fromSubPageId, required List<dynamic> entries}) async {
    List<int> deleteFromPositions = [];
    for (final entry in entries) {
      deleteFromPositions.add(entry['position']);
    }

    await _deleteEntries(
        fromSubPage: fromSubPageId, atPositions: deleteFromPositions);
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
      {required String subPageId, required List<PageEntry> from}) {
    int n = 0;
    return from
        .map((entry) => {
              'tabpageid': subPageId,
              'position': n += 1,
              'text_new': entry.entryText(),
              'type_new': entry.typeAsString
            })
        .toList();
  }
}
