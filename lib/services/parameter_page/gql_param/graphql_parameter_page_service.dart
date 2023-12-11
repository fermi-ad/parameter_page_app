import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
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
      {required String id,
      required ParameterPage page,
      required Function() onSuccess}) async {
    String subPageId;
    try {
      final persistedPageStructure = await _fetchPageStructure(forPageId: id);

      subPageId = persistedPageStructure['sub_systems'][0]['tabs'][0]
          ['sub_pages'][0]['tabpageid'];

      List<int> deleteFromPositions = [];
      for (final entry in persistedPageStructure['sub_systems'][0]['tabs'][0]
          ['sub_pages'][0]['entries']) {
        deleteFromPositions.add(entry['position']);
      }
      await _deleteEntries(
          fromSubPage: subPageId, atPositions: deleteFromPositions);
    } catch (e) {
      return Future.error("savePage failure");
    }

    final QueryOptions options = QueryOptions(
      document: gql(mergeEntries),
      variables: {
        'mrgEntries': _generateEntryMergeList(subPageId: subPageId, from: page)
      },
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
      onSuccess.call();
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

/*
  List<Map<String, dynamic>> _generateDeleteEntryList(
      {required ParameterPage from}) {
    List<Map<String, dynamic>> ret = [];
    for (PageEntry entry in from.entriesAsList()) {
      if (entry.id != null) {
        ret.add({"entryid": entry.id});
      }
    }
    return ret;
  }
*/

  List<Map<String, dynamic>> _generateEntryMergeList(
      {required String subPageId, required ParameterPage from}) {
    int n = 0;
    return from
        .entriesAsList()
        .map((entry) => {
              'tabpageid': subPageId,
              'position': n += 1,
              'text_new': entry.entryText(),
              'type_new': entry.typeAsString
            })
        .toList();
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

  @override
  Future<ParameterPage> fetchPage({required String id}) async {
    final QueryOptions options = QueryOptions(
      document: gql(queryOnePageTree),
      variables: <String, dynamic>{'pageid': id},
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      Logger().e(result.exception);
      return Future.error(
          "The request to fetch a parameter page returned an exception.  Please refer to the developer console for more detail.");
    } else {
      return ParameterPage.fromQueryResult(
          id: result.data?['onePageTree']['pageid'],
          title: result.data?['onePageTree']['title'],
          queryResult: result.data?['onePageTree']);
    }
  }
}
