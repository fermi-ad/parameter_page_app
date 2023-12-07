import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parameter_page/services/parameter_page/gql_param/graphql_parameter_page_service.dart';
import 'package:test/test.dart';

void main() {
  group('fetchAllPages', () {
    test("fetchAllPages, returns a non-empty list of parameter page titles",
        () async {
      // Given a GraphQLParameterPageService
      await dotenv.load(fileName: ".env");
      final service = GraphQLParameterPageService();

      // When I request a list of parameter pages
      List<dynamic> pageTitles = [];
      await service.fetchPages(
          onFailure: (String message) =>
              throw Exception("fetchPages failure: $message"),
          onSuccess: (List<dynamic> titles) => pageTitles = titles);

      // Then at least 1 title has been returned
      expect(pageTitles.length, greaterThan(0));
    });
  });
}
