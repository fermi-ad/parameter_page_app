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
      document: gql(titlequery),
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      onFailure.call("${result.exception}");
    } else {
      List<dynamic> titles = [];
      titles = result.data?['allTitles'];
      onSuccess.call(titles);
    }
  }

  @override
  Future<void> fetchEntries(
      {required String forPageId,
      required Function(String errorMessage) onFailure,
      required Function(List entries) onSuccess}) async {
    final QueryOptions options = QueryOptions(
      document: gql(pageentryquery),
      variables: <String, dynamic>{'pageid': forPageId},
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      onFailure.call("${result.exception}");
    } else {
      onSuccess.call(result.data?['entriesInPageX']);
    }
  }

  @override
  Future<String> createPage({required String withTitle}) async {
    throw UnimplementedError("GraphQLParameterPageService createPage");
  }

  @override
  Future<void> deletePage(
      {required String withPageId,
      required Function(String errorMessage) onFailure,
      required Function() onSuccess}) async {
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
  }

  @override
  Future<void> savePage(
      {required String id,
      required ParameterPage page,
      required Function() onSuccess}) {
    throw UnimplementedError("GraphQLParameterPageService savePage");
  }

  @override
  Future<String> renamePage(
      {required String id, required String newTitle}) async {
    final QueryOptions options = QueryOptions(
      document: gql(updatepagetitle),
      variables: <String, dynamic>{'pageid': id, 'title': newTitle},
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      print(result);
      throw UnimplementedError("renamePage exception");
    } else {
      return newTitle;
    }
  }

  @override
  Future<ParameterPage> fetchPage({required String id}) async {
    final QueryOptions options = QueryOptions(
      document: gql(pagequery),
      variables: <String, dynamic>{'pageid': id},
      fetchPolicy: FetchPolicy.noCache,
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      throw UnimplementedError("fetchPage exception");
    } else {
      return ParameterPage.fromQueryResult(
          id: result.data?['onePage']['pageid'],
          title: result.data?['onePage']['title'],
          queryResult: result.data?['onePage']['entries']);
    }
  }
}
