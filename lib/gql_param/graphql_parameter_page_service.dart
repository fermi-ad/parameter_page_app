import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parameter_page/parameter_page_service.dart';

import '../gqlconnect.dart';
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
}
