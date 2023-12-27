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
    final QueryOptions options = QueryOptions(
      document: gql(queryAllPageTitles),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to fetch a list of parameter pages returned an exception.  Please refer to the developer console for more detail.");
    } else {
      List<dynamic> titles = [];
      titles = result.data?['allPageTitles'];
      return titles;
    }
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
    final QueryOptions options = QueryOptions(
      document: gql(addDefaultPageTree),
      variables: <String, dynamic>{
        'title': withTitle,
      },
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to create a parameter page returned an exception.  Please refer to the developer console for more detail.");
    } else {
      return result.data?['newParamPage']['pageid'];
    } //else
  }

  @override
  Future<void> deletePage(
      {required String withPageId,
      required Function(String errorMessage) onFailure,
      required Function() onSuccess}) async {
    final QueryOptions options = QueryOptions(
      document: gql(removeTree),
      variables: <String, dynamic>{
        'treeid': withPageId,
      },
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      onFailure.call(
          "The request to delete a parameter page returned an exception.  Please refer to the developer console for more detail.");
    } else {
      onSuccess.call();
    } //else
  }

  @override
  Future<void> savePage(
      {required String id, required ParameterPage page}) async {
    try {
      final persistedPageStructure = await _fetchPageStructure(forPageId: id);

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
    /*
    final QueryOptions options = QueryOptions(
      document: gql(updatepagetitle),
      variables: <String, dynamic>{'pageid': id, 'title': newTitle},
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to rename a parameter page returned an exception.  Please refer to the developer console for more detail.");
    } else {
      return newTitle;
    }
    */
    return Future.error("renamePage not implemented");
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
          _renameTab(id: persistedTab['subsystabid'], newTitle: tabName);
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
    final QueryOptions options = QueryOptions(
      document: gql(addTabBranch),
      variables: {
        'title': withTitle,
        "seqnum": atIndex + 1,
        "subsysid": onSubSystem
      },
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to create a new tab returned an exception.  Please refer to the developer console for more detail.");
    } else {
      return result.data!['newSubsysTabBranch'];
    }
  }

  Future<void> _renameTab(
      {required String id, required String newTitle}) async {
    final QueryOptions options = QueryOptions(
      document: gql(updateSubjectTitles),
      variables: {
        'subjType': "tab",
        'subjTitles': [
          {'subjectid': id, 'title': newTitle}
        ]
      },
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to rename the tab returned an exception.  Please refer to the developer console for more detail.");
    } else {
      if (result.data?['code'] == -1) {
        Logger().e(
            "updateSubjectTitles returned with a failure, message: ${result.data?["message"]}");
        return Future.error(
            "The request to rename the tab returned an exception.  Please refer to the developer console for more detail.");
      }
    }
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

  Future<void> _deleteSubPage({required String id}) async {
    final QueryOptions options = QueryOptions(
      document: gql(deleteSubjects),
      variables: <String, dynamic>{
        'subjType': "subpage",
        'subjIds': [id]
      },
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to delete a parameter page returned an exception.  Please refer to the developer console for more detail.");
    }
  }

  Future<void> _renameSubPage(
      {required String id, required String newTitle}) async {
    final QueryOptions options = QueryOptions(
      document: gql(updateSubjectTitles),
      variables: {
        'subjType': "subpage",
        'subjTitles': [
          {'subjectid': id, 'title': newTitle}
        ]
      },
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to rename the sub-page returned an exception.  Please refer to the developer console for more detail.");
    } else {
      if (result.data?['code'] == -1) {
        Logger().e(
            "updateSubjectTitles returned with a failure, message: ${result.data?["message"]}");
        return Future.error(
            "The request to rename the sub-page returned an exception.  Please refer to the developer console for more detail.");
      }
    }
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

  Future<String> _createANewSubPage(
      {required String onTab, required int atIndex}) async {
    final QueryOptions options = QueryOptions(
      document: gql(addSubPage),
      variables: {'title': "", "seqnum": atIndex + 1, "subsystabid": onTab},
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to create a new sub-page returned an exception.  Please refer to the developer console for more detail.");
    } else {
      return result.data!['newTabPage']['tabpageid'];
    }
  }

  Future<void> _saveEntries(
      {required String id, required List<PageEntry> newEntries}) async {
    final mergeList = _generateEntryMergeList(subPageId: id, from: newEntries);
    final QueryOptions options = QueryOptions(
      document: gql(mergeEntries),
      variables: {'mrgEntries': mergeList},
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to add entries to a parameter page returned an exception.  Please refer to the developer console for more detail.");
    } else {
      if (result.data?['code'] == -1) {
        Logger().e(
            "mrgEntries returned with a failure, message: ${result.data?["message"]}");
        return Future.error(
            "The request to add entries to a parameter page returned an exception.  Please refer to the developer console for more detail.");
      }
    }
  }

  Future<void> _deleteEntries(
      {required String fromSubPage, required List<int> atPositions}) async {
    if (atPositions.isEmpty) {
      return;
    }

    final QueryOptions options = QueryOptions(
      document: gql(deleteEntries),
      variables: {
        'delEntries': atPositions
            .map((int position) =>
                {"tabpageid": fromSubPage, "position": position})
            .toList()
      },
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to delete old page entries returned an exception.  Please refer to the developer console for more detail.");
    }
  }

  Future<Map<String, dynamic>> _fetchPageStructure(
      {required String forPageId}) async {
    final QueryOptions options = QueryOptions(
      document: gql(queryOnePageTree),
      variables: <String, dynamic>{'pageid': forPageId},
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to fetch a parameter page returned an exception.  Please refer to the developer console for more detail.");
    } else {
      return result.data?['onePageTree'];
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
