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
    /*
    final QueryOptions options = QueryOptions(
      document: gql(deletepagetitle),
      variables: <String, dynamic>{
        'pageid': withPageId,
      },
    );

    final QueryResult result = await client.value.query(options);
    //final dynamic data = result.data;

    if (result.hasException) {
      Logger().e(result.exception);
      onFailure.call(
          "The request to delete a parameter page returned an exception.  Please refer to the developer console for more detail.");
    } else {
      onSuccess.call();
    } //else
    */
    return Future.error("deletePage not implemented");
  }

  @override
  Future<void> savePage(
      {required String id, required ParameterPage page}) async {
    try {
      final persistedPageStructure = await _fetchPageStructure(forPageId: id);

      await _updateEachSubPage(
          inPageStructure: persistedPageStructure, withPage: page);
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

  Future<void> _updateEachSubPage(
      {required Map<String, dynamic> inPageStructure,
      required ParameterPage withPage}) async {
    final persistedSubPages =
        inPageStructure['sub_systems'][0]['tabs'][0]['sub_pages'];

    for (int subPageIndex = 0;
        subPageIndex != withPage.subPageCount(forTab: "Tab 1");
        subPageIndex++) {
      String subPageId;

      if (subPageIndex >= persistedSubPages.length) {
        subPageId = await _createANewSubPage(
            onTab: inPageStructure['sub_systems'][0]['tabs'][0]['subsystabid'],
            atIndex: subPageIndex);
      } else {
        subPageId = persistedSubPages[subPageIndex]['tabpageid'];

        _deleteAllEntries(
            fromSubPageId: subPageId,
            entries: persistedSubPages[subPageIndex]['entries']);
      }

      await _saveEntries(
          id: subPageId,
          newEntries: withPage.entriesAsListFrom(
              tab: "Tab 1", subPage: subPageIndex + 1));
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
          "The request to add entries to a parameter page returned an exception.  Please refer to the developer console for more detail.");
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
