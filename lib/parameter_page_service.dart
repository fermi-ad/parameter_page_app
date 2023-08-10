abstract class ParameterPageService {
  Future<void> fetchPages(
      {required Function(String errorMessage) onFailure,
      required Function(List<dynamic> pageTitles) onSuccess});

  Future<void> fetchEntries(
      {required String forPageId,
      required Function(String errorMessage) onFailure,
      required Function(List<dynamic> entries) onSuccess});

  Future<void> createPage(
      {required String withTitle,
      required Function(String errorMessage) onFailure,
      required Function() onSuccess});
}
