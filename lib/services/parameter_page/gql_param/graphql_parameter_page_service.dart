import 'package:graphql_flutter/graphql_flutter.dart';
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
  Future<void> createPage(
      {required String withTitle,
      required Function(String errorMessage) onFailure,
      required Function() onSuccess}) async {
    final QueryOptions options = QueryOptions(
      document: gql(addpagetitle),
      variables: <String, dynamic>{
        'title': withTitle.trim(),
      },
    );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
      onFailure.call("${result.exception}");
    } else {
      onSuccess.call();
    }
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
}