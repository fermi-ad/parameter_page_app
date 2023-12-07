import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/services/parameter_page/gql_param/mutations.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';

import '../../../gqlconnect.dart';
import 'queries.dart';

class GraphQLParameterPageService extends ParameterPageService {
  @override
  Future<void> fetchPages(
      {required Function(String) onFailure,
      required Function(List<dynamic>) onSuccess}) async {
    final QueryOptions options = QueryOptions(
      document: gql(query_allpagetitles),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      onFailure.call("GraphQL error: ${result.exception}");
    } else {
      List<dynamic> titles = [];
      titles = result.data?['allTitles'];
      onSuccess.call(titles);
    }
  }

  @override
  Future<String> createPage({required String withTitle}) async {
    final QueryOptions options = QueryOptions(
      document: gql(add_defaultpagetree),
      variables: <String, dynamic>{
        'title': withTitle,
      },
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      return Future.error("GraphQL Error: ${result.exception}");
    } else {
      return result.data?['addTitle']['pageid'];
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
      onFailure.call("GraphQL Error: ${result.exception}");
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
    /*
    try {
      await _deleteOldEntries(page);
    } catch (e) {
      return Future.error("savePage failure");
    }

    final QueryOptions options = QueryOptions(
      document: gql(addentrylist),
      variables: {'newEntryList': _generateEntryList(pageId: id, from: page)},
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      return Future.error("GraphQL exception - ${result.exception}.");
    } else {
      onSuccess.call();
    }
    */
    return Future.error("savePage not implemented");
  }

/*
  Future<void> _deleteOldEntries(ParameterPage page) async {
    var list = _generateDeleteEntryList(from: page);
    if (list.isEmpty) {
      return;
    }

    final QueryOptions options = QueryOptions(
      document: gql(deleteentrylist),
      variables: {'delEntryList': list},
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      return Future.error("GraphQL exception - ${result.exception}.");
    }
  }

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

  List<Map<String, dynamic>> _generateEntryList(
      {required String pageId, required ParameterPage from}) {
    int n = 0;
    return from
        .entriesAsList()
        .map((entry) => {
              'pageid': pageId,
              'position': n += 1,
              'text': entry.entryText(),
              'type': entry.typeAsString
            })
        .toList();
  }
*/
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
      return Future.error("GraphQL exception - ${result.exception}.");
    } else {
      return newTitle;
    }
    */
     return Future.error("renamePage not implemented");
  }

  @override
  Future<ParameterPage> fetchPage({required String id}) async {
    final QueryOptions options = QueryOptions(
      document: gql(query_onepagetree),
      variables: <String, dynamic>{'pageid': id},
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      return Future.error("GraphQL Error: ${result.exception}");
    } else {
      return ParameterPage.fromQueryResult(
          id: result.data?['onePage']['pageid'],
          title: result.data?['onePage']['title'],
          queryResult: result.data?['onePage']['entries']);
    }
  }
}
