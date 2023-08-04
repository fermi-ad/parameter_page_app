abstract class ParameterPageService {
  Future<void> fetchPages(
      {required Function(String errorMessage) onFailure,
      required Function(List<dynamic> pageTitles) onSuccess});
}
